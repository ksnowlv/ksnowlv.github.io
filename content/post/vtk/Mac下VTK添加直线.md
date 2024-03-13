---
title: "Mac下VTK添加直线"
date: 2024-03-13T17:32:59+08:00
lastmod: 2024-03-13T17:32:59+08:00
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


### 1.VTK绘制直线

```c++
void ShapeRender::LineRender() {
    
    vtkSmartPointer<vtkLineSource> lineSource = vtkSmartPointer<vtkLineSource>::New();
    //起点和终点的范围大约在 (0, 0, 0) 到 (1, 1, 1) 之间
    lineSource->SetPoint1(0.0, 0.0, 0.0);  // 设置起点坐标
    lineSource->SetPoint2(0.0, 0.5, 0.0);  // 设置终点坐标


    // 创建一个映射
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(lineSource->GetOutputPort());

    // 创建一个角色
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    // 设置直线的宽度
    actor->GetProperty()->SetLineWidth(3);
    // 设置直线的颜色
    actor->GetProperty()->SetColor(1.0, 1.0, 1.0);
    
    VTKRender(actor);
}

```

### 2.效果

![image](/images/vtk/Mac下VTK添加直线/vtk_line.png)