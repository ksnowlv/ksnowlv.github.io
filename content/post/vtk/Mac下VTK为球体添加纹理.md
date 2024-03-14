---
title: "Mac下VTK为球体添加纹理"
date: 2024-03-14T09:25:12+08:00
lastmod: 2024-03-14T09:25:12+08:00
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


### 1.VTK绘制带纹理的紫色球体

```c++

//
#include <vtkSphereSource.h>
#include <vtkPTextureMapToSphere.h>

void ShapeRender::SphereRender() {
    // 创建球体对象
    vtkSmartPointer<vtkSphereSource> sphereSource = vtkSmartPointer<vtkSphereSource>::New();
    sphereSource->SetThetaResolution(50);
    sphereSource->SetPhiResolution(50);
    sphereSource->SetRadius(10);
    
    //球面纹理
    vtkSmartPointer<vtkTextureMapToSphere> textureMapToSphere = vtkSmartPointer<vtkTextureMapToSphere>::New();
    textureMapToSphere->SetInputConnection(sphereSource->GetOutputPort());
    
    
    // 创建 Mapper
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(textureMapToSphere->GetOutputPort());
    
    // 创建 Actor
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    actor->SetTexture(m_texture);
    actor->GetProperty()->SetColor(1.0, 0.0, 1.0);  // 设置颜色为紫色
    
    VTKRender(actor);
}

```

另外需要添加**libvtkFiltersTexture-9.3.dylib**支持库;

* 关于纹理生成,声明为成员的形式复用。

```c++
void ShapeRender::init() {
    // 创建png图片纹理
    vtkSmartPointer<vtkPNGReader> pngReader = vtkSmartPointer<vtkPNGReader>::New();
    pngReader->SetFileName("flutter_dart.png");
    
    m_texture = vtkSmartPointer<vtkTexture>::New();
    m_texture->SetInputConnection(pngReader->GetOutputPort());
}

```
为什么该图片没有像前文添加图片目录？

因为刚发现一种方法，无需手动拷贝图片所在目录的文件夹，到应用的同级目录。下文再说。

### 2.效果


![image](/images/vtk/Mac下VTK为球体添加纹理/result.png)

