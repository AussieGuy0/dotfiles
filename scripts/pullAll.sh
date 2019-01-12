#!/bin/bash
# Enters each directory located in current path and
# runs a 'git pull' if it is a git directory. 

for d in */ ; do
    cd "$d" || exit
    if [[ -d ".git" ]]; then
        echo "Updating project: $d"
        git pull 
    fi
    cd .. || exit
done
