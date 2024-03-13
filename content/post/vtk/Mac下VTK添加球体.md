---
title: "Mac下VTK添加球体"
date: 2024-03-13T19:52:26+08:00
lastmod: 2024-03-13T19:52:26+08:00
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


### 1.VTK绘制紫色球体

```c++

//
#include <vtkSphereSource.h>

void ShapeRender::SphereRender() {
// 创建球体对象
    vtkSmartPointer<vtkSphereSource> sphere = vtkSmartPointer<vtkSphereSource>::New();
    sphere->SetThetaResolution(40);
    sphere->SetPhiResolution(40);
    
    // 创建 Mapper
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(sphere->GetOutputPort());
    
    // 创建 Actor
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    actor->GetProperty()->SetColor(1.0, 0.0, 1.0);  // 设置颜色为紫色
    
    VTKRender(actor);

}
```

### 2.效果


![image](/images/vtk/Mac下VTK添加球体/result.png)

