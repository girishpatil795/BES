#!/usr/bin/env bash
set -e

# Determine what git branch we're on, we only want to deploy master
export CODEBUILD_GIT_BRANCH=`git symbolic-ref HEAD --short 2>/dev/null`
if [ "$CODEBUILD_GIT_BRANCH" == "" ] ; then
    CODEBUILD_GIT_BRANCH=`git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }'`
    export CODEBUILD_GIT_BRANCH=${CODEBUILD_GIT_BRANCH#remotes/origin/}
fi

echo "On branch $CODEBUILD_GIT_BRANCH"
if  [ "$CODEBUILD_GIT_BRANCH" != 'master' ]; then
    echo "On branch $CODEBUILD_GIT_BRANCH ; not deploying as not master"
    exit 0
fi

# Install SSH client so we can deploy
yum install -y openssh-client rsync
echo "before ssh"
# Setup the SSH key
#mkdir ~/.ssh
chmod 700 ~/.ssh
echo "After 700 PERMISSION"
echo $SSH_USERNAME
echo $SSH_KEY
echo "COPYING SSH KEYS"
#echo $SSH_KEY | base64 --decode > ~/.ssh/id_rsa
echo $SSH_KEY > ~/.ssh/id_rsa
echo "COPIED SSH KEYS SUCCESSFULLY"
chmod 600 ~/.ssh/*
pwd
echo "before resync"
# Upload Files
#rsync --delete-after -arvce  "ssh -o StrictHostKeyChecking=no -p ${SFTP_PORT}"  . ${SSH_USERNAME}@${SSH_SERVER}:~/public_html/
rsync -a ./girish-git.txt ${SSH_USERNAME}@${SSH_SERVER}:/home/ec2-user/

# Run any necessary remote commands
#ssh -o "StrictHostKeyChecking=no"  ${SSH_USERNAME}@${SSH_SERVER} -p ${SSH_PORT} 'cd public_html ; composer install --optimize-autoloader; php artisan migrate'
