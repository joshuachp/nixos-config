# Theme configuration for nix
{ lib, ... }:
{
  options =
    let
      inherit (lib) mkOption types;
    in
    {
      systemConfig.theme.base16 = lib.mkOption {
        default = { };
        description = "Configuration for base16 theme";
        type = types.attrsOf (
          types.submodule {
            options = {
              base00 = mkOption {
                description = "Default Background";
                type = types.str;
              };
              base01 = mkOption {
                description = "Lighter Background (Used for status bars, line number and folding marks)";
                type = types.str;
              };
              base02 = mkOption {
                description = "Selection Background";
                type = types.str;
              };
              base03 = mkOption {
                description = "Comments, Invisibles, Line Highlighting";
                type = types.str;
              };
              base04 = mkOption {
                description = "Dark Foreground (Used for status bars)";
                type = types.str;
              };
              base05 = mkOption {
                description = "Default Foreground, Caret, Delimiters, Operators";
                type = types.str;
              };
              base06 = mkOption {
                description = "Light Foreground (Not often used)";
                type = types.str;
              };
              base07 = mkOption {
                description = "Light Background (Not often used)";
                type = types.str;
              };
              base08 = mkOption {
                description = "Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted";
                type = types.str;
              };
              base09 = mkOption {
                description = "Integers, Boolean, Constants, XML Attributes, Markup Link Url";
                type = types.str;
              };
              base0A = mkOption {
                description = "Classes, Markup Bold, Search Text Background";
                type = types.str;
              };
              base0B = mkOption {
                description = "Strings, Inherited Class, Markup Code, Diff Inserted";
                type = types.str;
              };
              base0C = mkOption {
                description = "Support, Regular Expressions, Escape Characters, Markup Quotes";
                type = types.str;
              };
              base0D = mkOption {
                description = "Functions, Methods, Attribute IDs, Headings";
                type = types.str;
              };
              base0E = mkOption {
                description = "Keywords, Storage, Selector, Markup Italic, Diff Changed";
                type = types.str;
              };
              base0F = mkOption {
                description = "Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>";
                type = types.str;
              };
            };
          }
        );
      };
    };
  config = {
    systemConfig.theme.base16.blackMetalBathory = {
      base00 = "000000";
      base01 = "121212";
      base02 = "222222";
      base03 = "333333";
      base04 = "999999";
      base05 = "c1c1c1";
      base06 = "999999";
      base07 = "c1c1c1";
      base08 = "5f8787";
      base09 = "aaaaaa";
      base0A = "e78a53";
      base0B = "fbcb97";
      base0C = "aaaaaa";
      base0D = "888888";
      base0E = "999999";
      base0F = "444444";
    };
  };
}
