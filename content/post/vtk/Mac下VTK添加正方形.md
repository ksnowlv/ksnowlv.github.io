---
title: "Mac下VTK添加正方形"
date: 2024-03-13T19:08:55+08:00
lastmod: 2024-03-13T19:08:55+08:00
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


### 1.VTK绘制正方形

```c++
void ShapeRender::SquareRender() {
    // 创建正方形的顶点坐标
    vtkSmartPointer<vtkPoints> points = vtkSmartPointer<vtkPoints>::New();
    points->InsertNextPoint(0, 0, 0);
    points->InsertNextPoint(1, 0, 0);
    points->InsertNextPoint(1, 1, 0);
    points->InsertNextPoint(0, 1, 0);
    
    // 创建单元，并添加顶点索引
    vtkSmartPointer<vtkCellArray> polys = vtkSmartPointer<vtkCellArray>::New();
    constexpr int KPointNum = 4;
    vtkIdType quad[KPointNum] = {0, 1, 2, 3};
    polys->InsertNextCell(4, quad);
    
    // 创建 PolyData，并设置顶点与单元
    vtkSmartPointer<vtkPolyData> square = vtkSmartPointer<vtkPolyData>::New();
    square->SetPoints(points);
    square->SetPolys(polys);
    
    // 创建Mapper
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputData(square);

    // 创建Actor
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    actor->GetProperty()->SetColor(1.0, 0.0, 1.0);  // 设置颜色为紫色
    
    VTKRender(actor);
}

```

### 2.效果

![image](/images/vtk/Mac下VTK添加正方形/result.png)
