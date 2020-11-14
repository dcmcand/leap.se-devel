#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

#if public exists remove it
if [ -d "public" ]
  then rm -rf public
fi

mkdir public

cd public

git init

git remote add origin git@github.com:dcmcand/leap.se.git

git pull origin master

cd ..

# Build the project.
hugo -t academic # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..

