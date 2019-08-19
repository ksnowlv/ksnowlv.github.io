---
layout: post
title: "python筛选目录下非jpeg，png，bmp格式的图片"
date: 2019-05-15 20:01
comments: true
categories: Python小工具
---



 功能：筛选指定目录下非jpeg/png/bmp格式的文件，并把路径以日志形式输出。

关键有两点：

* 目录遍历，记录所有文件路径。
* 遍历路径，使用imghdr.what判断文件格式，非jpeg/png/bmp格式的文件路径输出。

`python3.0`实现如下：


```python

import os
import imghdr

##工具功能：筛选目录下非jpeg，png，bmp格式的图片，并输出其路径
##Python 3.0

#图片文件夹目录
IMAGEPATH = None

#初始化
def init():
    global IMAGEPATH
    IMAGEPATH  = "/Users/ksnowlv/Documents/image"


# 功能：读取指定目录下的所有文件绝对路径（包括该目录下所有子目录），并以列表形式返回

def readDir(dirPath):
    myDirPath = dirPath
    if dirPath.endswith('/'):# 要求传入的路径参数最后不能有斜杠,目的是为了递归时格式统一
        myDirPath = dirPath.rstrip('/')
        print('文件夹路径末尾删除/ = %s'%(myDirPath))

    allFiles = []

    if os.path.isdir(myDirPath):
        fileList = os.listdir(myDirPath)
        for f in fileList:
            f = myDirPath+'/'+f
            if os.path.isdir(f):
                subFiles = readDir(f)
                allFiles = subFiles + allFiles #合并当前目录与子目录的所有文件路径
            else:
                allFiles.append(f)
        return allFiles
    else:
        print('Error,not a dir')
    return allFiles

#根据路径筛选出非目标图片的路径
def filterPicture(fileList):
    for fileName in fileList:
        # data = open(fileName, 'rb').read(20)
        fileType = imghdr.what(fileName)
        # print("filename = %s fileType = %s" % (fileName,fileType))

        if fileType != "jpeg" and fileType != "png" and fileType != "bmp":
            print("filename = %s can not parse fileType = %s " % (fileName, fileType))

def main():
    init()
    fileList = readDir(IMAGEPATH)
    filterPicture(fileList)


if __name__ == '__main__':
    main()
```