{ config, lib, ... }:
{
  config = {
    lib.config = {
      math = {
        /*
          Base raised to the power of the exponent.

          This function supports only integers.

            Type: pow :: int or float -> int -> int

            Args:
              base: The base.
              exponent: The exponent.

            Example:
              pow 0 1000
              => 0
              pow 1000 0
              => 1
              pow 2 30
              => 1073741824
              pow 3 3
              => 27
              pow (-5) 3
              => -125
        */
        powi =
          let
            pow = base: exp: if exp == 0 then 1 else base * (pow base (exp - 1));
          in
          base: exp: if exp < 0 then builtins.throw "powi supports only integer exponents" else pow base exp;
        /*
          hexToDec :: string -> int

          Converts an hexadecimal string to base 10 number.
        */
        hexToDec =
          hex:
          let
            hexMap = {
              "0" = 0;
              "1" = 1;
              "2" = 2;
              "3" = 3;
              "4" = 4;
              "5" = 5;
              "6" = 6;
              "7" = 7;
              "8" = 8;
              "9" = 9;
              "a" = 10;
              "b" = 11;
              "c" = 12;
              "d" = 13;
              "e" = 14;
              "f" = 15;
            };
          in
          if (builtins.match "^[a-fA-F0-9]+$" hex) != [ ] then
            builtins.throw "expected a hexadecimal string character"
          else
            lib.pipe hex [
              lib.toLower
              lib.stringToCharacters
              lib.lists.reverseList
              (lib.imap0 (i: v: hexMap.${v} * (config.lib.config.math.powi 16 i)))
              config.lib.config.list.sum
            ];
      };
    };
  };
}
