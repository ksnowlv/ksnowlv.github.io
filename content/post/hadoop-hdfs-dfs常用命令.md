---
title: "Hadoop Hdfs Dfs常用命令"
date: 2023-12-05T16:29:59+08:00
lastmod: 2023-12-05T16:29:59+08:00
keywords: ["Hadoop", "大数据"]
tags: ["Hadoop",  "大数据"]
categories: ["Hadoop", "大数据"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## hdfs dfs常用命令

当使用HDFS的命令行工具时，hdfs dfs是常用的命令。
下面是一些常用的hdfs dfs命令的示例及说明：

### 查看文件列表

示例：hdfs dfs -ls /path/to/directory
说明：用于列出指定目录下的文件和子目录。

### 创建目录

示例：hdfs dfs -mkdir /path/to/new/directory
说明：在指定路径下创建新的目录。

```terminal
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -mkdir /user/lvwei   
2023-12-04 17:54:04,591 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
mkdir: `hdfs://127.0.0.1:9000/user': No such file or directory
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -mkdir /user      
2023-12-04 17:54:51,374 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -mkdir /user/lvwei
2023-12-04 17:55:01,161 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -ls /user/lvwei
2023-12-04 18:57:59,493 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
```

### 上传文件

示例：hdfs dfs -put localfile.txt /path/in/hdfs/
说明：将本地文件上传到HDFS指定目录。也可以用-copyFromLocal参数。

```terminal
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -put /Users/lvwei/Documents/123.png /user/lvwei    
2023-12-05 10:23:03,958 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -ls /user/lvwei                                
2023-12-05 10:23:18,833 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Found 1 items
-rw-r--r--   1 lvwei supergroup     188414 2023-12-05 10:23 /user/lvwei/123.png
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -put /Users/lvwei/Documents/点位经营简报V1.0.0(1).zip /user/lvwei
zsh: no matches found: /Users/lvwei/Documents/点位经营简报V1.0.0(1).zip
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -put /Users/lvwei/Documents/1.zip /user/lvwei 
2023-12-05 10:25:34,269 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -ls /user/lvwei                                                  
2023-12-05 10:25:39,709 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Found 2 items
-rw-r--r--   1 lvwei supergroup    1242039 2023-12-05 10:25 /user/lvwei/1.zip
-rw-r--r--   1 lvwei supergroup     188414 2023-12-05 10:23 /user/lvwei/123.png
```

### 下载文件

示例：hdfs dfs -get /path/in/hdfs/file.txt localfile.txt
说明：将HDFS中的文件下载到本地文件系统。也可以用-copyToLocal参数。

```terminal
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -get /user/lvwei/123.png  /Users/lvwei/Pictures/123.png
2023-12-05 16:25:41,871 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable

```

### 复制文件

示例：hdfs dfs -cp /path/in/hdfs/sourcefile.txt /path/in/hdfs/destination/
说明：将HDFS中的文件复制到另一个目录。
移动文件：

示例：hdfs dfs -mv /path/in/hdfs/sourcefile.txt /path/in/hdfs/destination/
说明：将HDFS中的文件移动到指定目录。

```terminal
base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -cp /user/lvwei/1.zip /user/lvwei/uploadfile/1.zip
2023-12-05 16:27:03,496 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
```

### 删除文件或目录：

示例：hdfs dfs -rm /path/in/hdfs/file.txt 或 hdfs dfs -rm -r /path/in/hdfs/directory
说明：用于删除HDFS中的文件或目录。-r选项用于递归删除整个目录。

```terminal
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -ls /user/lvwei/uploadfile
2023-12-05 16:46:46,388 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Found 1 items
-rw-r--r--   1 lvwei supergroup    1242039 2023-12-05 16:27 /user/lvwei/uploadfile/1.zip
(base) lvwei@lvweideMacBook-Pro sbin % hdfs dfs -rm /user/lvwei/uploadfile/1.zip
2023-12-05 16:47:08,814 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Deleted /user/lvwei/uploadfile/1.zip
(base) lvwei@lvweideMacBook-Pro sbin % 
```

### 查看文件内容：

示例：hdfs dfs -cat /path/in/hdfs/file.txt
说明：用于查看HDFS中文件的内容。

```terminal
base) lvwei@lvweideMacBook-Pro sbin % % hdfs dfs -cat /user/lvwei/uploadfile/1.zip 
2023-12-05 16:27:03,496 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
```
