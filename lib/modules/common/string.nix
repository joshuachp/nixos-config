_: {
  config = {
    lib.config = {
      string = {
        /*
          chunks :: string -> int -> [string]

          Divides the list in substring of the given length.
        */
        chunks =
          len: str:
          let
            strLen = builtins.stringLength str;
            chunks = builtins.ceil ((strLen + 0.0) / len);
          in
          if strLen == 0 then
            [ ]
          else if strLen < len then
            [ str ]
          else
            builtins.genList (i: builtins.substring (i * len) len str) chunks;
      };
    };
  };
}
