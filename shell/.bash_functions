# git post-push hook call
git() {
  ROOT="$(/usr/bin/git rev-parse --show-toplevel)"
  LOCATION="/.git/hooks/post-push"
  if [ "$1" == "push" ] && [ -f "$ROOT$LOCATION" ]; then
    /usr/bin/git $* && eval $ROOT$LOCATION
  else
    /usr/bin/git $*
  fi
}

# fixup past commit
fixup () {
  if [ -n "$(git status --porcelain)" ]; then
    git commit --fixup $1 && git stash && git rebase --autosquash $1~ && git stash pop;
  else
    git commit --fixup $1 && git rebase --autosquash $1~;
  fi
}