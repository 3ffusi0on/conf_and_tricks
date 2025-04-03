# Random

- Copy text to the clipboard

  > `xclip -sel clip < TextToCopy`

- Create and play a random MP3 playlist
  > `find -type f -iname \*.mp3 > playlist.txt && mplayer -shuffle -playlist playlist.txt`

# Git

- Remove already merged branches with preview and editing

  > `git branch --merged >/tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches`

- Restore a deleted local branch

  1. Find the SHA1 of the deleted branch

     > `git reflog`

  2. Recreate the branch at that commit
     > `git branch <BranchName> <sha1>`

- Pull remote changes, preferring their version without merge conflicts

  > `git pull -s recursive -X theirs --rebase origin <BranchName>`

- View diff against a stash

  > `git diff stash@{<number>} master` > `git stash show -p stash@{<number>}`

- Ignore changes to tracked files

  1. Set file to be ignored

     > `git update-index --assume-unchanged <file>`

  2. Revert to tracking changes
     > `git update-index --no-assume-unchanged <file>`

- Find the parent branch of a Git branch
  > `git show-branch | grep '\*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'`

# Vim

- Delete all trailing whitespace at the end of each line

  > `:%s/\s\+$//`

- Paste from clipboard in normal mode
  > `"+p`
