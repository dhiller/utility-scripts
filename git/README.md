git utility scripts
===================

add-*-hook.sh
-------------

Utility scripts to add a commit hook to the git repo. Each of these scripts creates or updates a file `.git/hooks/...` with a link to one of the scripts in the [hooks](hooks) subdirectory.

Example: 

```bash
# Requirement: utility-scripts/git/add-pre-commit-shellcheck-hook.sh needs to be in path
$ add-pre-commit-shellcheck-hook.sh
$ ls .git/hooks
... pre-commit ...
$ cat .git/hooks/pre-commit
sh -c <path-to-utility-scripts>/git/hooks/pre-commit-shellcheck.sh
```

**CAVEAT: it's unsafe to use these with pre-existing hooks! This script does not check whether the target hook has been created with this script!**

