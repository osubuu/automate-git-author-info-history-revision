#!/bin/sh

GIT_CLONE_URL=$1
REPO_NAME=$(echo ${GIT_CLONE_URL} | awk -F"/" '{print $NF}')

# 1. Clone repository temporarily
git clone --bare ${GIT_CLONE_URL}

# 2. Go into cloned repository
cd $REPO

# 3. Go through commit history and correct
git filter-branch --env-filter '

OLD_EMAIL="old-email@example.com"
CORRECT_NAME="correct-name"
CORRECT_EMAIL="correct-email@example.com"

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

# 4. Push updated commit history to remote repository
git push --force --tags origin 'refs/heads/*'

# 5. Jump back out of repository and remove its content
cd ..
rm -rf $REPO
