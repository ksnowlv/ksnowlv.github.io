---
title: "Mac下VTK添加圆锥体"
date: 2024-03-13T19:20:59+08:00
lastmod: 2024-03-13T19:20:59+08:00
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

### 1.VTK绘制圆锥体

```c++

//
#include <vtkConeSource.h>

void ShapeRender::ConeRender() {
    // 创建圆锥对象
    vtkSmartPointer<vtkConeSource> cone = vtkSmartPointer<vtkConeSource>::New();
    //设置圆锥面，越大越接近圆锥面；可以对比下，设置10与100的区别
    cone->SetResolution(100);
    
    // 创建 Mapper
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(cone->GetOutputPort());
    
    // 创建 Actor
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    actor->GetProperty()->SetColor(1.0, 0.0, 1.0);  // 设置颜色为紫色
    VTKRender(actor);
}
```

### 2.效果

* cone->SetResolution(10)时

![image](/images/vtk/Mac下VTK添加圆锥体/result_10.png)

* cone->SetResolution(100)时

![image](/images/vtk/Mac下VTK添加圆锥体/result_100.png)

