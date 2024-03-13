---
title: "Mac下VTK添加三角形"
date: 2024-03-13T18:57:56+08:00
lastmod: 2024-03-13T18:57:56+08:00
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


### 1.VTK绘制三角形

```c++

//vtkPolygon
#include <vtkPolygon.h>
#include <vtkNamedColors.h>


void ShapeRender::TriangleRender() {
    // 创建三角形的点
    vtkSmartPointer<vtkPoints> points = vtkSmartPointer<vtkPoints>::New();
    points->InsertNextPoint(0, 0, 0);  // 第一个点
    points->InsertNextPoint(1, 0, 0);  // 第二个点
    points->InsertNextPoint(0.5, 1, 0);  // 第三个点
    
    // 创建三角形的单元
    vtkSmartPointer<vtkCellArray> polygons = vtkSmartPointer<vtkCellArray>::New();
    vtkSmartPointer<vtkPolygon> polygon = vtkSmartPointer<vtkPolygon>::New();
    polygon->GetPointIds()->SetNumberOfIds(3);  // 三个顶点
    polygon->GetPointIds()->SetId(0, 0);
    polygon->GetPointIds()->SetId(1, 1);
    polygon->GetPointIds()->SetId(2, 2);
    polygons->InsertNextCell(polygon);
    
    // 创建三角形的颜色
    vtkSmartPointer<vtkUnsignedCharArray> colors = vtkSmartPointer<vtkUnsignedCharArray>::New();
    colors->SetNumberOfComponents(3);
    colors->SetNumberOfTuples(1);
    unsigned char color[3] = {255, 0, 0};
    colors->SetTypedTuple(0, color);

    // 创建PolyData并将点、单元和颜色数据设置进去
    vtkSmartPointer<vtkPolyData> polyData = vtkSmartPointer<vtkPolyData>::New();
    polyData->SetPoints(points);
    polyData->SetPolys(polygons);
    polyData->GetCellData()->SetScalars(colors);
    
    // 创建Mapper
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputData(polyData);
    
    // 创建Actor
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    
    // 设置颜色和阴影,会覆盖上面设置 polyData->GetCellData()->SetScalars(colors);设置的颜色；
    //如果要观察上面设置颜色的效果，可以把下面代码注释掉
    actor->GetProperty()->SetColor(1.0, 0.0, 1.0);  // 设置填充颜色为品红色
    actor->GetProperty()->SetAmbient(0.3);  // 环境光系数
    actor->GetProperty()->SetDiffuse(0.0);  // 散射光系数
    actor->GetProperty()->SetSpecular(1.0);  // 镜面反射
    
    VTKRender(actor);
}


```

### 2.效果

![image](/images/vtk/Mac下VTK添加三角形/result.png)
