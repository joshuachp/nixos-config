{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
{
  options =
    let
      inherit (lib) mkEnableOption;
    in
    {
      homeConfig.desktop.hyprland.enable = mkEnableOption "hyprland window manager" // {
        default = if osConfig == null then false else osConfig.nixosConfig.desktop.hyprland.enable;
      };
    };
  config =
    let
      cfg = config.homeConfig.desktop.hyprland;
      enable = config.systemConfig.desktop.enable && cfg.enable;
    in
    lib.mkIf enable {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd = {
          enable = true;
          variables = [ "-all" ];
        };
        settings = {
          # See https://wiki.hyprland.org/Configuring/Monitors/
          monitor = ",preferred,auto,1";

          # Some default env vars.
          env = [
            "XCURSOR_SIZE,24"
            "WLR_NO_HARDWARE_CURSORS,1"
          ];

          # Execute your favorite apps at launch
          exec-once = [
            "systemctl --user import-environment XDG_CURRENT_DESKTOP WAYLAND_DISPLAY DISPLAY"
            "dbus-update-activation-environment --systemd XDG_CURRENT_DESKTOP=Hyprland WAYLAND_DISPLAY DISPLAY"
            "systemd-cat waybar"
            "systemd-cat mako"
            "systemd-cat swaybg -m fit -i ~/Pictures/wallpaper.png"
            "~/.config/hypr/scripts/sleep.sh"
            # XWayland settings
            "systemd-cat xsettingsd"
            # Polkit
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          ];
          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
          input = {
            kb_layout = "us,it";
            kb_variant = "nodeadkeys";

            follow_mouse = 1;

            touchpad = {
              natural_scroll = false;
            };

            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          };

          general = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            gaps_in = 1;
            gaps_out = 1;
            border_size = 1;
            "col.active_border" = "rgba(bdae93aa)";
            "col.inactive_border" = "rgba(928374aa)";

            layout = "dwindle"; # master
          };

          decoration = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            rounding = 0;

            blur = {
              enabled = true;
              size = 3;
              passes = 1;
            };

            drop_shadow = true;
            shadow_range = 4;
            shadow_render_power = 3;
            "col.shadow" = "rgba(1a1a1aee)";
          };

          animations = {
            enabled = false;

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          misc = {
            disable_hyprland_logo = true;
            background_color = "rgba(282828aa)";
          };

          dwindle = {
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true; # you probably want this
          };

          master = {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_is_master = true;
          };

          gestures = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = false;
          };

          # Example per-device config
          # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
          device = {
            name = "epic-mouse-v1";
            sensitivity = -0.5;
          };

          # See https://wiki.hyprland.org/Configuring/Keywords/ for more
          "$mainMod" = "SUPER";

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          bind = [
            "$mainMod, Return, exec, alacritty"
            "$mainMod SHIFT, Q, killactive,"
            "$mainMod SHIFT, E, exit,"
            "$mainMod, E, exec, nautilus"
            "$mainMod, D, exec, wofi --show drun"

            # Lock
            "$mainMod ALT, L, exec, swaylock -f -e"

            # Keyboard
            "$mainMod ALT, K, exec, ~/.config/hypr/scripts/keyboard.sh"

            # Audio
            ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

            # Luminosity
            ",XF86MonBrightnessDown, exec, light -U 5"
            ",XF86MonBrightnessUp, exec, light -A 5"

            # Music
            ",XF86AudioNext, exec, playerctl next"
            ",XF86AudioPrev, exec, playerctl previous"
            ",XF86AudioPlay, exec, playerctl play-pause"
            ",XF86AudioStop, exec, playerctl stop"

            # Screenshot
            "$mainMod, S, exec, ~/.config/hypr/scripts/screen-shot.sh"

            # Window bindings
            "$mainMod, F, fullscreen"
            "$mainMod SHIFT, F, togglefloating"
            "$mainMod, T, togglegroup"

            # Move focus
            "$mainMod, h, movefocus, l"
            "$mainMod, l, movefocus, r"
            "$mainMod, k, movefocus, u"
            "$mainMod, j, movefocus, d"

            # Move window
            "$mainMod SHIFT, h, movewindow, l"
            "$mainMod SHIFT, l, movewindow, r"
            "$mainMod SHIFT, k, movewindow, u"
            "$mainMod SHIFT, j, movewindow, d"

            # Switch workspaces with mainMod + [0-9]
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          windowrulev2 = [
            # Window rules
            "workspace 5,class:(thunderbird)"
            "workspace 5,class:(Mattermost)"
            "workspace 4,class:(Spotify)"
          ];
        };
      };
    };
}
