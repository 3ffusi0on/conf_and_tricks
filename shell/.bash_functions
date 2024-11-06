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