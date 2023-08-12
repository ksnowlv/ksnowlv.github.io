---
title: "Mac下安装Django"
date: 2014-08-10
categories:
  - "python"
tags:
  - "python"
---
<!--more-->

Mac下如何安装Django呢？
<!--more-->

安装步骤如下

#### 1.Django安装前，先安装python,再安装pip
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$sudo easy_install pip
    Password:
    Searching for pip
    Reading http://pypi.python.org/simple/pip/
    Best match: pip 1.5.6
    Downloading https://pypi.python.org/packages/source/p/pip/        pip-1.5.6.tar.gz#md5=01026f87978932060cc86c1dc527903e
    Processing pip-1.5.6.tar.gz
    Running pip-1.5.6/setup.py -q bdist_egg --dist-dir /tmp/easy_install-8B1wUW/pip-1.5.6/egg-dist-tmp-7Tfgxf
    warning: no files found matching 'pip/cacert.pem'
    warning: no files found matching '*.html' under directory 'docs'
    warning: no previously-included files matching '*.rst' found under     directory 'docs/_build'
    no previously-included directories found matching 'docs/_build/_sources'
    Adding pip 1.5.6 to easy-install.pth file
    Installing pip script to /usr/local/bin
    Installing pip2.7 script to /usr/local/bin
    Installing pip2 script to /usr/local/bin

    Installed /Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg
    Processing dependencies for pip
    Finished processing dependencies for pip
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$
    
#### 2.然后安装Django：
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$sudo pip install Django
    Password:
    Downloading/unpacking Django
      Downloading Django-1.6.5-py2.py3-none-any.whl (6.7MB): 6.1MB downloaded
    Cleaning up...
    Exception:
    Traceback (most recent call last):
      File "/Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg/pip/basecommand.py", line 122, in main
    status = self.run(options, args)
      File "/Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg/pip/commands/install.py", line 278, in run
    requirement_set.prepare_files(finder, force_root_egg_info=self.bundle, bundle=self.bundle)
      File "/Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg/pip/req.py", line 1197, in prepare_files
    do_download,
      File "/Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg/pip/req.py", line 1375, in unpack_url
    self.session,
      File "/Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg/pip/download.py", line 572, in unpack_http_url
    download_hash = _download_url(resp, link, temp_location)
      File "/Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg/pip/download.py", line 433, in _download_url
    for chunk in resp_read(4096):
      File "/Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg/pip/download.py", line 421, in resp_read
    chunk_size, decode_content=False):
      File "/Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg/pip/_vendor/requests/packages/urllib3/response.py", line 240, in stream
    data = self.read(amt=amt, decode_content=decode_content)
      File "/Library/Python/2.7/site-packages/pip-1.5.6-py2.7.egg/pip/_vendor/requests/packages/urllib3/response.py", line 187, in read
    data = self._fp.read(amt)
      File "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/httplib.py", line 567, in read
    s = self.fp.read(amt)
      File "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/socket.py", line 380, in read
    data = self._sock.recv(left)
      File "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/ssl.py", line 241, in recv
    return self.read(buflen)
      File "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/ssl.py", line 160, in read
    return self._sslobj.read(len)
    SSLError: The read operation timed out

    Storing debug log for failure in /Users/ksnowlv/Library/Logs/pip.log
    ksnowlv@ksnowlvdeMa
    
#### 3.安装出错，如何解决呢？方案是添加两个环境变量:
    export CFLAGS=-Qunused-arguments
    export CPPFLAGS=-Qunused-arguments
示例如下:

    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$export CFLAGS=-Qunused-arguments
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$export CPPFLAGS=-Qunused-arguments
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$sudo pip install Django
    Password:
    Downloading/unpacking Django
      Downloading Django-1.6.5-py2.py3-none-any.whl (6.7MB): 6.7MB downloaded
    Installing collected packages: Django
    Successfully installed Django
    Cleaning up...
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$  
    

`这个过程好折腾，找半天解决方案。希望大家多注意!!!`

#### 4.验证下是否安装成功
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$python
    Python 2.7.5 (default, Mar  9 2014, 22:15:05) 
    [GCC 4.2.1 Compatible Apple LLVM 5.0 (clang-500.0.68)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import django
    >>> print django.get_version()
    1.6.5
    #输出1.6.5 表示当前最新版本为1.6.5，表示已经安装成功
    >>> ^D
    #退出python control + D
    ksnowlv@ksnowlvdeMacBook-Pro~/Movies/python server$  

终于安装成功,大功告成!