#!/bin/bash


read -p "Enter a file path: " file_path

if [ -e "$file_path" ]
then
  stat -f "File name: %n\nFile size: %s bytes\nFile type: %F\nFile permissions: %A" $file_path
  ls -l $file_path
else
  
  echo "The file does not exist"
fi
