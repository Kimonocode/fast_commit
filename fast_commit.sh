#!/bin/bash

### Create Commits and Merge On Main Quickly ###

#Get git current_branch and stock i 
current_branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/');

# current_branch return : [ ( branch ) ]
# remove first and last character to remove parentheses
# | cut -c 2- -> Delete the first
# | rev | cut -c2- | rev -> Delete the last

branch=$(echo $current_branch | cut -c 2- | rev | cut -c2- | rev)

commit(){
  read -p "Name the commit : " commit
  echo -e "\n"
  git commit -m "$commit"
}

merge_branch(){
  echo -e "\033[33mWarning :\033[0m"
  read -p "You are on branch [$branch], merging [$branch] with [main]? [Y/n] : " response
  if [[ $response = "Y" ]]; then
    git add -A
    commit
    git checkout main
    echo -e "\n\033[32mMERGE [$branch -> main]\033[0m\n"
    git merge $branch
    echo -e "\n\033[32mPUSH [$branch -> main]\033[0m\n"
    git push
    echo -e "\n"
    reset_branch
    echo -e "\n"
    git status
    funny
  elif [[ $response = "n" ]]; then
    exit 0
  else
    merge_branch
  fi
}

reset_branch(){
  read -p "Go back to the branch [$branch] ? [Y\n] : " response
  if [[ $response = "Y" ]]; then
    git checkout $branch
  elif [[ $response = "n" ]]; then
    funny
    exit 0
  else
    reset_branch
  fi
}

funny(){
  echo -e "\nHapppy Hack !\n"
}

if [[ $branch == *"main"* || $branch == *"master"* ]]; then
  git add -A
  commit
  echo -e "\n\033[32mPUSH [main -> main]\033[0m\n"
  git push
  echo -e "\n"
  git status
  funny
else
  echo -e "\n"
  merge_branch
fi