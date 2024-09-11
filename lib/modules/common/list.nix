_: {
  config = {
    lib.config = {
      list = {
        /*
          sum :: [number] -> number

          Sum a list of numbers.

          > list.sum [ 1 2 3 4 ]
          10
        */
        sum = builtins.foldl' (x: y: builtins.add x y) 0;
      };
    };
  };
}
