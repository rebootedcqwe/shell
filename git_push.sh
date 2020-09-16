#!/bin/bash
#git提交
git config --global user.name "rebootedcqwe"
git config --global user.email "2633062020@qq.com"
git add -A
git status
read -p "Please input your commit: " name2
git commit -m "$name2"   
git push origin master
