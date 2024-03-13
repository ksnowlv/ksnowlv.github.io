---
title: "Mac下VTK添加文字"
date: 2024-03-13T20:11:45+08:00
lastmod: 2024-03-13T20:11:45+08:00
keywords: ["Mac","VTK","C++"]
tags: ["Mac","VTK","C++"]
categories: ["Mac","VTK","C++"]


comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->



### 1.VTK绘制文字

```c++

#include <vtkTextProperty.h>
#include <vtkTextActor.h>

void ShapeRender::TextRender() {
    
    // 创建文字属性
    vtkSmartPointer<vtkTextProperty> textProperty = vtkSmartPointer<vtkTextProperty>::New();
    textProperty->SetColor(1.0, 0.0, 1.0);  // 设置文字颜色为紫色
    textProperty->SetFontSize(24);  // 设置字号大小
    textProperty->SetJustificationToCentered();  // 设置文字居中显示
    
    // 创建文字对象
    vtkSmartPointer<vtkTextActor> textActor = vtkSmartPointer<vtkTextActor>::New();
    textActor->SetInput("Hello, VTK!");  // 设置文字内容
    textActor->SetTextProperty(textProperty);
    
    textActor->SetPosition(600, 400);  // 设置文字位置屏幕居中
    
    VTKRender(textActor);
}

```

### 2.效果


![image](/images/vtk/Mac下VTK添加文字/result.png)

