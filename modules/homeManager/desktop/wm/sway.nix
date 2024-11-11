{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
{
  options = {
    homeConfig.desktop.sway.enable = lib.mkEnableOption "sway window manager" // {
      default = osConfig.nixosConfig.desktop.sway.enable or false;
    };
  };
  config =
    let
      cfg = config.homeConfig.desktop.sway;
      swayPkg = config.wayland.windowManager.sway.package;
      swaymsg = lib.getExe' swayPkg "swaymsg";
      swaylock = lib.getExe config.programs.swaylock.package;
    in
    lib.mkIf cfg.enable {
      wayland.windowManager.sway =
        let
          rofi = lib.getExe pkgs.rofi;
          pactl = lib.getExe' pkgs.pulseaudio "pactl";
          light = lib.getExe pkgs.light;
          playerctl = lib.getExe pkgs.playerctl;

          wofiLaunch = lib.getExe (
            pkgs.writeShellApplication {
              name = "wofi-launch";
              runtimeInputs = [
                pkgs.wofi
                pkgs.killall
              ];
              text = ''
                set -eEuo pipefail

                killall -q wofi || true

                wofi "$@"
              '';
            }
          );
          screenshotScreen = lib.getExe (
            pkgs.writeShellApplication {
              name = "screenshot-screen";
              runtimeInputs = [
                pkgs.xdg-user-dirs
                pkgs.grim
                pkgs.libnotify
              ];
              text = ''
                set -eEuo pipefail

                mkdir -p "$(xdg-user-dir PICTURES)/Screenshots"
                grim "$(xdg-user-dir PICTURES)/Screenshots/$(date +'%Y-%m-%d-%H%M%S.png')"
                notify-send "Screenshot Captured" "Saved in Picture/Sreenshots directory."
              '';
            }
          );
          screenshotSelection = lib.getExe (
            pkgs.writeShellApplication {
              name = "screenshot-selection";
              runtimeInputs = [
                pkgs.xdg-user-dirs
                pkgs.grim
                pkgs.slurp
                pkgs.libnotify
              ];
              text = ''
                set -eEuo pipefail

                mkdir -p "$(xdg-user-dir PICTURES)/Screenshots"
                grim -g "$(slurp)" "$(xdg-user-dir PICTURES)/Screenshots/$(date +'%Y-%m-%d-%H%M%S.png')"
                notify-send "Screenshot Captured" "Saved in Picture/Sreenshots directory."
              '';
            }
          );

          term = lib.getExe pkgs.alacritty;
          inherit (config.wayland.windowManager.sway.config) modifier;

          menu = "${wofiLaunch} --show drun | xargs ${swaymsg} exec --";
          dmenu = "${wofiLaunch} --show run | xargs ${swaymsg} exec --";
          wmenu = "${rofi} -show window | xargs ${swaymsg} exec --";

          nofify-send = lib.getExe pkgs.libnotify;
        in
        {
          enable = true;
          wrapperFeatures.gtk = true;

          config = {
            input = {
              "type:touchpad" = {
                dwt = "enabled";
                tap = "enabled";
                middle_emulation = "enabled";
              };
              "1:1:AT_Translated_Set_2_keyboard" = {
                xkb_layout = "it";
                xkb_variant = "nodeadkeys";
                xkb_numlock = "enabled";
              };
              "type:keyboard" = {
                xkb_layout = "it";
              };
            };
            bars = [ { command = lib.getExe pkgs.waybar; } ];
            modifier = "Mod4";
            keybindings = {
              # Start a terminal
              "${modifier}+Return" = "exec ${term}";

              # Kill focused window
              "${modifier}+Shift+q" = "kill";

              # Start your launcher
              "${modifier}+d" = "exec ${menu}";
              "${modifier}+Shift+d" = "exec ${dmenu}";
              "${modifier}+Tab" = "exec ${wmenu}";

              # Reload the configuration
              "${modifier}+Shift+c" = ''
                exec ${nofify-send} -u "low" -i "distributor-logo-nixos" -a "sway" "sway" "Restarting window manager"; reload
              '';

              # Exit sway
              "${modifier}+Shift+e" = ''
                exec ${swaymsg} -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
              '';

              # Move your focus around
              "${modifier}+h" = "focus left";
              "${modifier}+j" = "focus down";
              "${modifier}+k" = "focus up";
              "${modifier}+l" = "focus right";

              # Or use $mod+[up|down|left|right]
              "${modifier}+Left" = "focus left";
              "${modifier}+Down" = "focus down";
              "${modifier}+Up" = "focus up";
              "${modifier}+Right" = "focus right";

              # Move the focused window with the same, but add Shift
              "${modifier}+Shift+h" = "move left";
              "${modifier}+Shift+j" = "move down";
              "${modifier}+Shift+k" = "move up";
              "${modifier}+Shift+l" = "move right";
              # Ditto, with arrow keys
              "${modifier}+Shift+Left" = "move left";
              "${modifier}+Shift+Down" = "move down";
              "${modifier}+Shift+Up" = "move up";
              "${modifier}+Shift+Right" = "move right";

              # Switch to workspace
              "${modifier}+1" = "workspace number 1";
              "${modifier}+2" = "workspace number 2";
              "${modifier}+3" = "workspace number 3";
              "${modifier}+4" = "workspace number 4";
              "${modifier}+5" = "workspace number 5";
              "${modifier}+6" = "workspace number 6";
              "${modifier}+7" = "workspace number 7";
              "${modifier}+8" = "workspace number 8";
              "${modifier}+9" = "workspace number 9";
              "${modifier}+0" = "workspace number 10";
              # Move focused container to workspace
              "${modifier}+Shift+1" = "move container to workspace number 1";
              "${modifier}+Shift+2" = "move container to workspace number 2";
              "${modifier}+Shift+3" = "move container to workspace number 3";
              "${modifier}+Shift+4" = "move container to workspace number 4";
              "${modifier}+Shift+5" = "move container to workspace number 5";
              "${modifier}+Shift+6" = "move container to workspace number 6";
              "${modifier}+Shift+7" = "move container to workspace number 7";
              "${modifier}+Shift+8" = "move container to workspace number 8";
              "${modifier}+Shift+9" = "move container to workspace number 9";
              "${modifier}+Shift+0" = "move container to workspace number 10";

              # Layout, split horizontal or vertical
              "${modifier}+b" = "splith";
              "${modifier}+v" = "splitv";

              # Switch the current container between different layout styles
              "${modifier}+s" = "layout stacking";
              "${modifier}+w" = "layout tabbed";
              "${modifier}+e" = "layout toggle split";

              # Make the current focus fullscreen
              "${modifier}+f" = "fullscreen";

              # Toggle the current focus between tiling and floating mode
              "${modifier}+Shift+space" = "floating toggle";

              # Swap focus between the tiling area and the floating area
              "${modifier}+space" = "focus mode_toggle";

              # Move focus to the parent container
              "${modifier}+a" = "focus parent";

              ##
              # Scratchpad:
              #
              # Sway has a "scratchpad", which is a bag of holding for windows.
              # You can send windows there and get them back later.

              # Move the currently focused window to the scratchpad
              "${modifier}+Shift+minus" = "move scratchpad";

              # Show the next scratchpad window or hide the focused scratchpad window.
              # If there are multiple scratchpad windows, this command cycles through them.
              "${modifier}+minus" = "scratchpad show";

              # Resize mode
              "${modifier}+r" = ''
                mode "resize"
              '';

              # Special keys
              XF86AudioRaiseVolume = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ 0 && ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
              XF86AudioLowerVolume = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
              XF86AudioMute = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
              # Microphone
              XF86AudioMicMute = "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
              # Luminosity
              XF86MonBrightnessDown = "exec ${light} -U 5";
              XF86MonBrightnessUp = "exec ${light} -A 5";
              # Music
              XF86AudioNext = "exec ${playerctl} next";
              XF86AudioPrev = "exec ${playerctl} previous";
              XF86AudioPlay = "exec ${playerctl} play-pause";
              XF86AudioStop = "exec ${playerctl} stop";

              # Lock
              "Alt+${modifier}+l" = "exec --no-startup-id ${swaylock} -f -e";
            };
            modes = {
              resize = {
                # left will shrink the containers width
                # right will grow the containers width
                # up will shrink the containers height
                # down will grow the containers height
                h = "resize shrink width 10px";
                j = "resize grow height 10px";
                k = "resize shrink height 10px";
                l = "resize grow width 10px";

                # Ditto, with arrow keys
                Left = "resize shrink width 10px";
                Down = "resize grow height 10px";
                Up = "resize shrink height 10px";
                Right = "resize grow width 10px";

                # Return to default mode
                Return = ''
                  mode "default"
                '';
                Escape = ''
                  mode "default"
                '';
              };
            };
            window = {
              border = 2;
              titlebar = false;
            };
            floating = {
              border = 2;
              titlebar = false;
            };
            colors = {
              focused = {
                border = "#a89984";
                background = "#928374";
                text = "#ebdbb2";
                indicator = "#928374";
                childBorder = "#a89984";
              };
            };
            gaps = {
              smartBorders = "off";
            };
            fonts = {
              names = [ "Noto Sans" ];
              style = "Regular";
              size = 11.0;
            };
          };
          extraConfig = ''
            bindsym --release Print exec ${screenshotScreen}
            bindsym --release Shift+Print exec ${screenshotSelection}

            include ~/.config/sway/config.d/*
          '';
        };

      programs.swaylock = {
        enable = true;
        settings = {
          image = "~/Pictures/wallpaper.png";
        };
      };

      services.swayidle = {
        enable = true;
        systemdTarget = "sway-session.target";
        events = [
          {
            event = "before-sleep";
            command = "${swaylock} -f -e";
          }
          {
            event = "after-resume";
            command = ''
              ${swaymsg} 'output * dpms on'
            '';
          }
        ];
        timeouts = [
          {
            timeout = 300;
            command = "${swaylock} -f -e";
          }
          {
            timeout = 360;
            command = ''
              ${swaymsg} 'output * dpms off'
            '';
          }
          {
            timeout = 600;
            command = "systemctl suspend";
          }
        ];
      };
    };
}
