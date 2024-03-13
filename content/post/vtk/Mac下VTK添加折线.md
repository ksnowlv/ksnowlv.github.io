---
title: "Mac下VTK添加折线"
date: 2024-03-13T18:26:10+08:00
lastmod: 2024-03-13T18:26:10+08:00
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

### 1.VTK绘制折线

```c++

#include <vtkPoints.h>
#include <vtkCellArray.h>
#include <vtkPolyData.h>
#include <vtkUnsignedCharArray.h>
#include <vtkCellData.h>

void ShapeRender::PolyLineRender() {
    // 创建所有折线的点
    vtkSmartPointer<vtkPoints> points = vtkSmartPointer<vtkPoints>::New();
    //用来表示点的X、Y、Z坐标。具体来说，参数范围可以是任意的浮点数
    points->InsertNextPoint(0, 0, 0);  // 起点
    points->InsertNextPoint(1, 1, 1);  // 段1终点
    points->InsertNextPoint(2, 1, 1);  // 段2终点
    points->InsertNextPoint(3, 1, 0);  // 段3终点
    
    // 创建折线的单元
    vtkSmartPointer<vtkCellArray> lines = vtkSmartPointer<vtkCellArray>::New();
    vtkIdType line[2];
    line[0] = 0; line[1] = 1;
    lines->InsertNextCell(2, line);  // 线段1
    line[0] = 1; line[1] = 2;
    lines->InsertNextCell(2, line);  // 线段2
    line[0] = 2; line[1] = 3;
    lines->InsertNextCell(2, line);  // 线段3
    
    // 创建颜色数组
    vtkSmartPointer<vtkUnsignedCharArray> colors = vtkSmartPointer<vtkUnsignedCharArray>::New();
    colors->SetNumberOfComponents(3);
    colors->SetNumberOfTuples(3);
    
    // 设置每段直线的颜色
    unsigned char colorSegment1[3] = {255, 0, 0};  // 红色
    unsigned char colorSegment2[3] = {0, 255, 0};  // 绿色
    unsigned char colorSegment3[3] = {0, 0, 255};  // 蓝色
    colors->SetTypedTuple(0, colorSegment1);
    colors->SetTypedTuple(1, colorSegment2);
    colors->SetTypedTuple(2, colorSegment3);
    
    // 创建PolyData并将点和线数据设置进去
    vtkSmartPointer<vtkPolyData> polyData = vtkSmartPointer<vtkPolyData>::New();
    polyData->SetPoints(points);
    polyData->SetLines(lines);
    polyData->GetCellData()->SetScalars(colors);
    
    // 创建Mapper
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputData(polyData);
    
    // 创建Actor
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    actor->GetProperty()->SetLineWidth(3);
    
    VTKRender(actor);
}
```

### 2.效果

![image](/images/vtk/Mac下VTK添加折线/poly_line_result.png)