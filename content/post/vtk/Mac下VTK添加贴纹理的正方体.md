---
title: "Mac下VTK添加贴纹理的正方体"
date: 2024-03-13T13:11:24+08:00
lastmod: 2024-03-13T13:11:24+08:00
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

### 1.添加图片资源

工程中添加Resource目录，并添加flutter.jpg,flutter.png，作为正方体的纹理

### 2.渲染正方体核心示例

```c++
const std::string jpgImagePath = "Resource/flutter.jpg";
const std::string pngimagePath = "Resource/flutter.png";


void ShapeRender::CubeRender() {
    // 创建正方体
    vtkSmartPointer<vtkCubeSource> cubeSource = vtkSmartPointer<vtkCubeSource>::New();
    
    // 创建正方体映射
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(cubeSource->GetOutputPort());
    
    // 创建jpg图片纹理
    vtkSmartPointer<vtkJPEGReader> jpegReader = vtkSmartPointer<vtkJPEGReader>::New();
    jpegReader->SetFileName(jpgImagePath.c_str());
    
    // 创建png图片纹理
    vtkSmartPointer<vtkPNGReader> pngReader = vtkSmartPointer<vtkPNGReader>::New();
    pngReader->SetFileName(pngimagePath.c_str());

    vtkSmartPointer<vtkTexture> texture = vtkSmartPointer<vtkTexture>::New();
    texture->SetInputConnection(jpegReader->GetOutputPort());

    // 创建包含纹理映射的角色
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    actor->SetTexture(texture);
    
    VTKRender(actor);
}
```

### 3.问题及解决方案

#### 1.图片无法加载报错问题

```shell
2024-03-13 13:19:52.196 (   0.908s) [           68DA2]      vtkJPEGReader.cxx:133    ERR| vtkJPEGReader (0x7fd437807010): Unable to open file flutter.jpg
2024-03-13 13:19:52.197 (   0.908s) [           68DA2]      vtkJPEGReader.cxx:350    ERR| vtkJPEGReader (0x7fd437807010): libjpeg could not read file: flutter.jpg
2024-03-13 13:19:52.197 (   0.908s) [           68DA2]       vtkExecutive.cxx:730    ERR| vtkCompositeDataPipeline (0x6000031f8600): Algorithm vtkJPEGReader (0x7fd437807010) returned failure for request: vtkInformation (0x6000029ea3a0)
  Debug: Off
  Modified Time: 735
  Reference Count: 1
  Registered Events: (none)
  Request: REQUEST_DATA
  FROM_OUTPUT_PORT: 0
  ALGORITHM_AFTER_FORWARD: 1
  FORWARD_DIRECTION: 0

```

如何解决呢？

* 方案1 
  * 把Resource图片文件夹拷贝到和应用程序同级的目录。因Mac程序是命令行程序，资源文件并不会打包到应用中。

* 方案2
  * 把图片转换为图片字节数组；使用xxd -i image.jpg > image_data.h。将图片文件转换为头文件。适应小图片，否则会导致应用程序较大。
    * extern unsigned char image_jpg[];
    * extern unsigned int image_jpg_len;

此次采用方案1即可。

![image](/images/vtk/Mac下VTK添加贴纹理的正方体/app_dir.png)


#### 2.vtkJPEGReader与vtkPNGReader支持库问题

需要添加**libvtkIOImage-9.3.dylib**支持库，文档不好查。

### 4.效果

![image](/images/vtk/Mac下VTK添加贴纹理的正方体/vtk_result.png)

### 5.完整示例代码

* ShapRender.hpp

```c++
//
//  ShapRender.hpp
//  HelloVTK
//
//  Created by ksnowlv on 2024/3/13.
//

#ifndef ShapRender_hpp
#define ShapRender_hpp

#include <stdio.h>

class vtkProp;

class ShapeRender {
public:
  ShapeRender();
  ~ShapeRender();

public:
  void CylinderRender();
  void CubeRender();

private:
  void VTKRender(vtkProp* actor);

};


#endif /* ShapRender_hpp */

```

* ShapRender.cpp

```c++
//
//  ShapRender.cpp
//  HelloVTK
//
//  Created by ksnowlv on 2024/3/13.
//

#include "ShapRender.hpp"

#include <vtkSmartPointer.h>
#include <vtkCylinderSource.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkRenderer.h>
#include <vtkRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkProperty.h>

//cubeRender
#include <vtkCubeSource.h>
#include <vtkJPEGReader.h>
#include <vtkTexture.h>
#include <vtkPNGReader.h>


ShapeRender::ShapeRender() {
    
}

ShapeRender::~ShapeRender() {
    
}

void ShapeRender::CylinderRender() {
    // 创建一个圆柱体数据源
    vtkSmartPointer<vtkCylinderSource> cylinderSource = vtkSmartPointer<vtkCylinderSource>::New();
    cylinderSource->SetHeight(6.0);
    cylinderSource->SetRadius(3.0);
    cylinderSource->SetResolution(8);

    // 创建一个映射器
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(cylinderSource->GetOutputPort());

    // 创建一个Actor
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    // 设置颜色
    actor->GetProperty()->SetColor(0.6, 0.0, 0.6);
    
    VTKRender(actor);

}

const std::string jpgImagePath = "Resource/flutter.jpg";
const std::string pngimagePath = "Resource/flutter.png";


void ShapeRender::CubeRender() {
    // 创建正方体
    vtkSmartPointer<vtkCubeSource> cubeSource = vtkSmartPointer<vtkCubeSource>::New();
    
    // 创建正方体映射
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    mapper->SetInputConnection(cubeSource->GetOutputPort());
    
    // 创建jpg图片纹理
    vtkSmartPointer<vtkJPEGReader> jpegReader = vtkSmartPointer<vtkJPEGReader>::New();
    jpegReader->SetFileName(jpgImagePath.c_str());
    
    // 创建png图片纹理
    vtkSmartPointer<vtkPNGReader> pngReader = vtkSmartPointer<vtkPNGReader>::New();
    pngReader->SetFileName(pngimagePath.c_str());

    vtkSmartPointer<vtkTexture> texture = vtkSmartPointer<vtkTexture>::New();
    texture->SetInputConnection(jpegReader->GetOutputPort());

    // 创建包含纹理映射的角色
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    actor->SetTexture(texture);
    
    VTKRender(actor);
}

void ShapeRender::VTKRender(vtkProp* actor) {
    // 创建渲染器
    vtkSmartPointer<vtkRenderer> renderer = vtkSmartPointer<vtkRenderer>::New();
    renderer->AddActor(actor);
    renderer->SetBackground(0.6, 0.2, 0.4);

    // 创建渲染窗口
    vtkSmartPointer<vtkRenderWindow> renderWindow = vtkSmartPointer<vtkRenderWindow>::New();
    renderWindow->AddRenderer(renderer);
    renderWindow->SetSize(1200, 800);
    renderWindow->SetPosition(100, 300);
    // 开始渲染
    renderWindow->Render();
    //必须放在Render之后，不然，可能显示不出来窗口标题
    renderWindow->SetWindowName("My VTK Window");
  

    // 创建交互器
    vtkSmartPointer<vtkRenderWindowInteractor> renderWindowInteractor = vtkSmartPointer<vtkRenderWindowInteractor>::New();
    renderWindowInteractor->SetRenderWindow(renderWindow);
    
    // 开始交互
    renderWindowInteractor->Start();
}

```

* main.cpp

```c++
//
//  main.cpp
//  HelloVTK
//
//  Created by ksnowlv on 2024/3/12.
//

#include <iostream>
#include "ShapRender.hpp"


int main() {
    
    std::unique_ptr<ShapeRender> render(std::make_unique<ShapeRender>());

    //render->CylinderRender();
    render->CubeRender();

    
    return 0;
}



```
