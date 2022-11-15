#!/bin/bash
echo 
cd F:\hexo个人博客\Hexo
npm start

git add .
git commit -m "feat: add new blog"
git pull origin main
git push origin HEAD:main