
#           Random

* copy to the clic board
> xclip -sel clip < TextToCopy

* Random playlist mplayer
> find -type f -iname \*.mp3 > playlist.txt && mplayer -shuffle -playlist playlist.txt

#           GIT

* Github Markdowns
> https://guides.github.com/features/mastering-markdown/

* How to undo the last git add?
> git reset

* How to edit an incorrect commit message in Git?
> git commit --amend -m "New commit message"
  * OR
> git reset --soft HEAD^
> git commit -c ORIG_HEAD

* How to Undo 'git add' before commit
> git reset <file>

* How to squash my last X commits together using git?
> git rebase -i <after-this-commit>

* How to cancel a local git commit?
> git reset HEAD^

* How to remove local commited branches ?
> git remote prune origin

* Undo local branch delete
  * find the <sha1> of the branch with:
   > git reflog
  * then
   > git branch <BranchName> <sha1>

* Pull their version without merge conflicts
> git pull -s recursive -X theirs --rebase origin <BranchName>

* Git diff against a stash
> git diff stash@{<number>} master
> git stash show -p stash@{<number>}

* How to clone into a non-empty directory
> git init && git remote add origin <path of the repo> && git fetch

* How to delete a branch
 * local
   > git branch -D <BranchName>
 * server
   > git push origin --delete <BranchName>

* How to ignore changed files (tracked)
> git update-index --assume-unchanged <file>
 * revert
> git update-index --no-assume-unchanged <file>

* How to Find the parent branch of a Git branch 
> git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'

#           ZSH / BASH

* clear the entire line
> [Ctrl][u]

* delete the word IN FRONT of the cursor
> [Ctrl][w]

* Undo the last change
> [Ctrl][_]

* Stop search
> [Ctrl][j]

* Delete the word AFTER the cursor
> [Alt][d]

* Move one word
> [Alt][b]
> [Alt][f]

* Complete and search in history
> [Alt][n]
> [Alt][p]

* Completing history word
> [Alt][,]

* Move to next space
> [Alt][l]

* Add '' around all the current text
> [Alt][']

* Swap two word
> [Alt][t]

* Capitalize the next word
> [Alt][u]

* Open man for 1st word
> [Alt][h]

#           Pacman

* Installed as dependencies for packages that are no longer installed
> pacman -Qdt

* Remove all of those
> pacman -Rsn $(pacman -Qqdt)

#           Vim

* Delete all trailing whitespace (at the end of each line)
> :%s/\s\+$//

* Paste from clipboard (normal mode)
> "+p

#           ArchLinux

* Change default applications
> -Edit /usr/share/applications/mimeinfo.cache
