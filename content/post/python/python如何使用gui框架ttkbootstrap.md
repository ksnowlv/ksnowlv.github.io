---
title: "Python如何使用gui框架ttkbootstrap"
date: 2024-06-11T15:30:01+08:00
lastmod: 2024-06-11T15:30:01+08:00
keywords: ["Python"]
tags: ["Python"]
categories: ["Python"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1.ttkbootstrap

官网链接：https://ttkbootstrap.readthedocs.io/en/latest/

* 提供多种预设的样式，可以直接使用。
* API简单，与Tkinter的使用方法类似，容易上手。
* 支持自定义主题和样式，可以创建独特的界面。
* 兼容标准Tkinter组件，可以无缝集成到现有的Tkinter应用中。

可以看作`tkinter`的升级版本，较为美观易用。

### 2.示例代码

```python

import ttkbootstrap as ttk
from ttkbootstrap.constants import *

class App(object):

    BUTTON_FONT_SIZE = 20
    def __init__(self):
        self.init_widgets()

    def init_widgets(self):
        #深色主题：  solar superhero cyborg darkly vapor
        #浅色主题：cosmo flatly journal litera lumen minty sandstone  yeti

        self.root = ttk.Window(themename="solar")
        self.root.geometry('600x800')
        self.work_state_label = ttk.Label(self.root,
                                      text="所有支持的颜色风格",
                                      font=("Arial", App.BUTTON_FONT_SIZE),
                                          bootstyle= SUCCESS)

        self.work_state_label.pack(pady=10)

        for color in self.root.style.colors:
            b = ttk.Button(self.root, text=color, bootstyle=color)
            b.pack(side=TOP, padx=5, pady=5)

        b1 = ttk.Button(self.root, text="Solid Button", bootstyle=SUCCESS)
        b1.pack(side=TOP, padx=5, pady=10)

        b2 = ttk.Button(self.root, text="Outline Button", bootstyle=(SUCCESS, OUTLINE))
        b2.pack(side=TOP, padx=5, pady=10)

        b3 = ttk.Button(self.root, text="Outline Button", bootstyle=(SUCCESS, OUTLINE))
        b3.pack(side=TOP, padx=5, pady=10)


        self.root.mainloop()


```

### 3.效果

![image](/images/python/python如何使用gui框架ttkbootstrap/result1.png)

![image](/images/python/python如何使用gui框架ttkbootstrap/result2.png)

