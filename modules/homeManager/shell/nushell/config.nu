$env.config = {
  show_banner: false,
  edit_mode: vi,
}

def ll [
--all (-a) # Show hidden files
...pattern
] -> table {
  if ($pattern | is-empty) {
    ls -l
  } else {
    ls -l ...$pattern
  } | sort-by type name --ignore-case;
}

alias la = ll -a
