# Fish configuration
{ config, lib, ... }:
let
  cfg = config.systemConfig;
in
{
  config = {
    programs.fish = {
      enable = true;

      interactiveShellInit =
        lib.pipe ([ ./config/config.minimal.fish ] ++ (lib.optional (!cfg.minimal) ./config/config.fish))
          [
            (builtins.map builtins.readFile)
            builtins.toString
          ];

      functions = lib.mkMerge [
        (lib.mkIf (!cfg.minimal) {
          # Function callback for when the current directory changes
          __cwd_callback_hook = {
            description = "Function callback for CWD change";
            onVariable = "PWD";
            body = builtins.readFile ./functions/__cwd_callback_hook.fish;
          };
          # task-warrior wrapper
          tasks = {
            description = "A command line todo manager, customized.";
            wraps = "task";
            body = builtins.readFile ./functions/tasks.fish;
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
