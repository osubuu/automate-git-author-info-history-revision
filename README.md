# git-author-history-fix
Small Shell script to automate the revision of author info in a repository's commit history via command line. The steps were taken from [GitHub's help page](https://help.github.com/en/github/using-git/changing-author-info).

## 1. Modify `history.sh` script with proper email information

Change `OLD_EMAIL`, `CORRECT_NAME` and `CORRECT_EMAIL` to the correct values

<pre><code>
git filter-branch --env-filter '

<b>OLD_EMAIL="bademail@example.com"</b>
<b>CORRECT_NAME="Eric"</b>
<b>CORRECT_EMAIL="goodemail@example.com"</b>

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
export GIT_COMMITTER_NAME="$CORRECT_NAME"
export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
export GIT_AUTHOR_NAME="$CORRECT_NAME"
export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
</code></pre>

## 2. Run the script via command line
```
. history.sh git@github.com:username/repository-name.git
```
