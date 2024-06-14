---
title: "MacOS下Python中Tkinter按钮无法修改背景的解决方案"
date: 2024-06-07T09:45:54+08:00
lastmod: 2024-06-07T09:45:54+08:00
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

### 1.MacOS下Python中Tkinter按钮无法修改背景的解决方案


```python


    WIDGETWIDTH = 30
    WIDGETHEIGHT = 2
    BUTTON_FONT_SIZE = 20 
    BUTTON_BKCOLOR = "#5B70CF"
    BUTTON_BKCOLOR_SELECTED = "#5B70FF"
    BUTTON_FONT_COLOR = "white"

     for item in self.item_list:
         
            button = Button(self.root, text=item,
                            width=App.WIDGETWIDTH,
                            height=App.WIDGETHEIGHT,
                            font=("Arial", App.BUTTON_FONT_SIZE),
                            bg=App.BUTTON_BKCOLOR,
                            fg=App.BUTTON_FONT_COLOR,
                            activebackground=App.BUTTON_BKCOLOR_SELECTED
                            )
            button["command"] = lambda item=item: self.on_button_click(item)
            button.pack(pady=20)
            self.button_list.append(button)

```


![image](/images/python/MacOS下Python中Tkinter按钮无法修改背景的解决方案/result1.png)

遗憾的是，通过`bg`属性设置按钮背景色发现，不生效。

按钮的背景色是MacOS系统默认颜色风格。需引用tkmacosx库。

### 2.解决方案

安装`tkmacosx`并使用新`Button`

```shell
pip3 install tkmacosx
```

#### 2.1. 按钮引用库更换

由`from tkinter import Button`更换为`from tkmacosx import Button`

#### 2.2.按钮宽高设定更换

tkmacosx下需要重新设置了button宽度与高度

```python
    WIDGETWIDTH = 500
    WIDGETHEIGHT = 50

```

最终效果

![image](/images/python/MacOS下Python中Tkinter按钮无法修改背景的解决方案/result2.png)




