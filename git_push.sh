#!/bin/bash
#git提交
read -p "Please input your directory: " name
cd $name
git add -A
git status
read -p "Please input your commit: " name2
git commit -m "$name2"   
git push origin master
