#!/bin/bash
#文件名:newDraft.sh
read -p "文件名(无需后缀)：" fileName
read -p "科目：" categories
read -p "标签：" tag
command="touch ${fileName}.md"

echo $command
echo  >> $fileName.md
echo  "---">> $fileName.md
echo  "title: ${fileName}">> $fileName.md
echo  "categories: ${categories}">> $fileName.md
time1=$(date "+%Y-%m-%d %H:%M:%S")
echo  "date: ${time1}">> $fileName.md
echo  "tags: ${tag}">> $fileName.md
echo  "mathjax: false">> $fileName.md
echo  "toc: true">> $fileName.md
echo  >> $fileName.md
echo  "---">> $fileName.md
echo '创建成功！按任意键退出'
read any
