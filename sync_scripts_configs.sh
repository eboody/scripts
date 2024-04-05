#!/bin/bash

cd $HOME/scripts

git pull origin main

sh $HOME/scripts/merge_dotfiles.sh
