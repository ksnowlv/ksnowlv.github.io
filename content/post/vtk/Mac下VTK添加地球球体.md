---
title: "Mac下VTK添加地球球体"
date: 2024-03-14T17:24:07+08:00
lastmod: 2024-03-14T17:24:07+08:00
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

### 1.VTK绘制地球球体

```c++

void ShapeRender::EarthRender() {

    vtkSmartPointer<vtkNamedColors> colors = vtkSmartPointer<vtkNamedColors>::New();
    //Earth source
    vtkSmartPointer<vtkEarthSource> earthSource = vtkSmartPointer<vtkEarthSource>::New();
    
    earthSource->OutlineOn();
    earthSource->Update();
    
    // Create a sphere
    vtkSmartPointer<vtkSphereSource> sphere = vtkSmartPointer<vtkSphereSource>::New();
    sphere->SetThetaResolution(100);
    sphere->SetPhiResolution(100);
    sphere->SetRadius(earthSource->GetRadius());
    
    // Create a mapper and actor
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(earthSource->GetOutputPort());
    
    //球页
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    actor->GetProperty()->SetColor(colors->GetColor3d("Black").GetData());
    
    
    vtkSmartPointer<vtkPolyDataMapper> sphereMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    sphereMapper->SetInputConnection(sphere->GetOutputPort());
    //球体
    vtkSmartPointer<vtkActor> sphereActor = vtkSmartPointer<vtkActor>::New();
    sphereActor->SetMapper(sphereMapper);
    sphereActor->GetProperty()->SetColor(
    colors->GetColor3d("PeachPuff").GetData());
    
    // 创建渲染器
    vtkSmartPointer<vtkRenderer> renderer =  vtkSmartPointer<vtkRenderer>::New();
    renderer->AddActor(actor);
    renderer->AddActor(sphereActor);
    renderer->SetBackground(0.6, 0.2, 0.4);
    
    // 创建渲染窗口
    vtkSmartPointer<vtkRenderWindow> renderWindow = vtkSmartPointer<vtkRenderWindow>::New();
    renderWindow->AddRenderer(renderer);
    renderWindow->SetSize(1200, 800);
    renderWindow->SetPosition(100, 300);
    renderWindow->Render();
    renderWindow->SetWindowName("EarthSource");
    
    
    // 创建交互器
    vtkSmartPointer<vtkRenderWindowInteractor> renderWindowInteractor =  vtkSmartPointer<vtkRenderWindowInteractor>::New();
    renderWindowInteractor->SetRenderWindow(renderWindow);
    renderWindowInteractor->Start();

}

```

另外：需要添加**libvtkFiltersHybrid-9.3.dylib**和**libvtkCommonColor-9.3.dylib**支持库

### 2.效果

![image](/images/vtk/Mac下VTK添加地球球体/result.png)