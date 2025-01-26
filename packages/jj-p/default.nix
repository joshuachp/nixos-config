{
  writeShellApplication,
}:
writeShellApplication {
  name = "jj-p";
  text = builtins.readFile ./jj-p.sh;
}
