# Function callback for when the current directory changes
# Check for pre-commit config file
if test ! -f .pre-commit-config.yaml
    return
end

# Check if git pre-commit is installed
if test -f .git/hooks/pre-commit
    return
end

set -l git_root (git root)
if test "$PWD" != "$git_root"
    return
end

# There is a pre-commit-config but no pre-commit hook installed
pre-commit install
