#!/bin/bash
echo 
cd F:\hexo-blog\Hexo
npm start

git add .
git commit -m "feat: add new blog"
git pull origin main
git push origin HEAD:main