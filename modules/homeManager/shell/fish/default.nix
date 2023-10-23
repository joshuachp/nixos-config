# Fish configuration
{ config
, lib
, ...
}:
let
  inherit (config.systemConfig) minimal;
in
{
  config = {
    programs.fish = {
      enable = true;

      interactiveShellInit = builtins.readFile ./config/config.fish;

      functions = lib.mkMerge [
        (lib.mkIf (!minimal) {
          # Function callback for when the current directory changes
          __cwd_callback_hook = {
            description = "Function callback for CWD change";
            onVariable = "PWD";
            body = builtins.readFile ./functions/__cwd_callback_hook.fish;
          };
          # Jump function to change directory
          j = {
            description = "Jumps to a directory using jump";
            body = "cd (jump print $argv)";
          };
        })
      ];
    };
  };
}
