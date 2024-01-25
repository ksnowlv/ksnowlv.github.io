---
title: "Python OpenCV安装与简单使用"
date: 2023-08-30T16:14:48+08:00
lastmod: 2023-08-30T16:14:48+08:00
keywords: ["Python", "OpenCV"]
tags: ["Python", "OpenCV"]
categories: ["Python", "OpenCV"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Python OpenCV安装与简单使用

## 一. Python OpenCV安装

### 1.使用pip安装cmake及OpenCV

使用清华大学的镜像源

```shell
# 安装cmake
(venv) lvwei@lvweideMacBook-Pro opencvdemo % pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --upgrade cmake
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple/
Collecting cmake
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/6a/27/a1b63d753ccc1dbc72ac6749762428c4a56f3f76eaffbf69316735460bef/cmake-3.27.2-py2.py3-none-macosx_10_10_universal2.macosx_10_10_x86_64.macosx_11_0_arm64.macosx_11_0_universal2.whl (47.4 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 47.4/47.4 MB 909.0 kB/s eta 0:00:00
Installing collected packages: cmake
Successfully installed cmake-3.27.2

# opencv-python
(venv) lvwei@lvweideMacBook-Pro opencvdemo % pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --upgrade opencv-python
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple/
Collecting opencv-python
  Using cached https://pypi.tuna.tsinghua.edu.cn/packages/8a/6f/8aa049b66bcba8b5a4dc872ecfdbcd8603a96704b070fde22222e479c3d7/opencv_python-4.8.0.76-cp37-abi3-macosx_10_16_x86_64.whl (54.7 MB)
Collecting numpy>=1.21.2
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/c9/57/3cb8131a0e6d559501e088d3e685f4122e9ff9104c4b63e4dfd3a577b491/numpy-1.25.2-cp311-cp311-macosx_10_9_x86_64.whl (20.8 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 20.8/20.8 MB 884.6 kB/s eta 0:00:00
Installing collected packages: numpy, opencv-python
Successfully installed numpy-1.25.2 opencv-python-4.8.0.76


```

### 2.OpenCV测试与示例

```python

def main():
    # Use a breakpoint in the code line below to debug your script.
     print(cv2.__version__)

    image = cv2.imread('images/1.webp')

    # 缩放图片
    scale_percent = 50  # 缩放比例
    width = int(image.shape[1] * scale_percent / 100)
    height = int(image.shape[0] * scale_percent / 100)
    dim = (width, height)
    resized = cv2.resize(image, dim, interpolation=cv2.INTER_AREA)

    # 在窗口中显示图片
    cv2.imshow('Image', resized)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

```

![image](/images/post/Python-OpenCV安装与简单使用/1.png) 