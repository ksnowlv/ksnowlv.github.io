---
title: "Mac下使用Cython"
date: 2023-09-09T22:26:10+08:00
lastmod: 2023-09-09T22:26:10+08:00
keywords: ["Python", "Cython"]
tags: ["Python"]
categories: ["Python"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->
## Mac下Cython使用示例

### 1.安装Cython库

```python
ksnowlv@MacBook-Pro-3 hugoblog %  pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --upgrade cython

Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple/
Collecting cython
  Using cached https://pypi.tuna.tsinghua.edu.cn/packages/e2/18/ba1a01c0ed30b248878b98fcf0654141c1c0e476166b5dcb4d7c04214884/Cython-3.0.2-cp311-cp311-macosx_10_9_x86_64.whl (3.1 MB)
Installing collected packages: cython
Successfully installed cython-3.0.2
```
国内使用清华的镜像安装快

### 2.创建.pyx的Cython文件
例如，我们在person.pyx文件中创建Person类。

```python
# 使用 Cython 封装一个 Person 类

cdef class Person:
    cdef public str name
    cdef public int age
    cdef public str address
    cdef public str phone

    def __init__(self, name, age, address, phone):
        self.name = name
        self.age = age
        self.address = address
        self.phone = phone

    # 显示人员信息
    cpdef get_info(self):
        info = f"Name: {self.name}, Age: {self.age}, Address: {self.address}, Phone: {self.phone}"
        print(info)
```        
在上述代码中，我们使用 cdef class 和 cdef public 关键字来定义一个Cython的 Person 类。

* cdef class 
    
    声明了这个类是使用 C 扩展模块的形式来定义的，
* cdef

    public 指定了这些成员可以从 Python 代码中访问。

### 3.构建扩展模块的构建脚本setup.py

```python
from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize("person.pyx")
)
```

### 4.构建扩展模块的.so

在终端进入到setup.py脚本目录，执行**python setup.py build_ext --inplace**
命令，会生成person.so的扩展模块文件。
```python
(venv) ksnowlv@MacBook-Pro-3 hellocython % python setup.py build_ext --inplace 
Compiling person.pyx because it changed.
[1/1] Cythonizing person.pyx
/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/Cython/Compiler/Main.py:384: FutureWarning: Cython directive 'language_level' not set, using '3str' for now (Py3). This has changed from earlier releases! File: /Users/ksnowlv/Documents/python_projects/hellocython/person.pyx
  tree = Parsing.p_module(s, pxd, full_module_name)
running build_ext
building 'person' extension
creating build
creating build/temp.macosx-10.9-universal2-cpython-311
clang -Wsign-compare -Wunreachable-code -fno-common -dynamic -DNDEBUG -g -fwrapv -O3 -Wall -arch arm64 -arch x86_64 -g -I/usr/local/opt/ruby@3.0/include -I/Library/Frameworks/Python.framework/Versions/3.11/include/python3.11 -c person.cpp -o build/temp.macosx-10.9-universal2-cpython-311/person.o
person.cpp:2729:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:3063:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:3575:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:3904:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:4075:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:6078:76: warning: code will never be executed [-Wunreachable-code]
        if (__Pyx_PyTuple_SET_ITEM(argstuple, (Py_ssize_t)i, args[i]) < 0) goto bad;
                                                                           ^~~~~~~~
person.cpp:6078:73: note: silence by adding parentheses to mark code as explicitly dead
        if (__Pyx_PyTuple_SET_ITEM(argstuple, (Py_ssize_t)i, args[i]) < 0) goto bad;
                                                                        ^
                                                                        /* DISABLES CODE */ ( )
6 warnings generated.
person.cpp:2729:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:3063:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:3575:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:3904:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:4075:3: warning: code will never be executed [-Wunreachable-code]
  goto __pyx_L3_error;
  ^~~~~~~~~~~~~~~~~~~
person.cpp:6078:76: warning: code will never be executed [-Wunreachable-code]
        if (__Pyx_PyTuple_SET_ITEM(argstuple, (Py_ssize_t)i, args[i]) < 0) goto bad;
                                                                           ^~~~~~~~
person.cpp:6078:73: note: silence by adding parentheses to mark code as explicitly dead
        if (__Pyx_PyTuple_SET_ITEM(argstuple, (Py_ssize_t)i, args[i]) < 0) goto bad;
                                                                        ^
                                                                        /* DISABLES CODE */ ( )
6 warnings generated.
creating build/lib.macosx-10.9-universal2-cpython-311
clang++ -bundle -undefined dynamic_lookup -arch arm64 -arch x86_64 -g -L/usr/local/opt/ruby@3.0/lib -I/usr/local/opt/ruby@3.0/include build/temp.macosx-10.9-universal2-cpython-311/person.o -o build/lib.macosx-10.9-universal2-cpython-311/person.cpython-311-darwin.so
copying build/lib.macosx-10.9-universal2-cpython-311/person.cpython-311-darwin.so -> 

```
### 5.python模块引用Cython构建扩展模块

#### python文件

```python
# 导入 person 模块
import person

def main():
    # Use a breakpoint in the code line below to debug your script.
    p = person.Person("ksnowlv", 39, "北京海淀区", "15211111111")
    print(f"name = {p.name}, age = {p.age}")
    p.get_info()

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()
```

#### 执行情况
```python
name = ksnowlv, age = 39
Name: ksnowlv, Age: 39, Address: 北京海淀区, Phone: 15211111111
Process finished with exit code 0
```



