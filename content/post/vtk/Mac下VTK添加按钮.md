---
title: "Mac下VTK添加按钮"
date: 2024-03-13T20:32:00+08:00
lastmod: 2024-03-13T20:32:00+08:00
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



### 1.VTK绘制按钮

```c++

#include <vtkTextProperty.h>
#include <vtkTextActor.h>
//
#include <vtkCallbackCommand.h>
// 回调函数
void ButtonCallbackFunction(vtkObject* caller, long unsigned int eventId, void* clientData, void* callData)
{
    std::cout << "Button clicked!" << std::endl;
}


void ShapeRender::ButtonRender() {
    //VTK 中，没有直接的按钮控件，但是你可以创建一个类似按钮的交互式控件；
    //像vtkTextActor，然后在交互器通过vtkCallbackCommand接收事件
    
    // 创建文字属性
    vtkSmartPointer<vtkTextProperty> textProperty = vtkSmartPointer<vtkTextProperty>::New();
    textProperty->SetColor(1.0, 1.0, 1.0);  // 设置文字颜色为白色
    textProperty->SetFontSize(24);  // 设置字号大小
    textProperty->SetJustificationToCentered();  // 设置文字居中显示
    
    // 创建按钮文字对象
    vtkSmartPointer<vtkTextActor> buttonActor = vtkSmartPointer<vtkTextActor>::New();
    buttonActor->SetInput("Click Me! Test Button Event");  // 设置按钮文字
    buttonActor->SetTextProperty(textProperty);
    // 设置按钮位置
    buttonActor->GetPositionCoordinate()->SetCoordinateSystemToNormalizedDisplay();
    buttonActor->GetPositionCoordinate()->SetValue(0.5, 0.5);
    // 设置按钮颜色
    //buttonActor->GetTextProperty()->SetColor(.0, 0.0, 0.0);  // 设置文字颜色为黑色
    
    
    vtkSmartPointer<vtkRenderer> renderer = vtkSmartPointer<vtkRenderer>::New();
    // 将按钮文字对象添加到渲染器中
    renderer->AddActor(buttonActor);
    renderer->SetBackground(0.6, 0.2, 0.4);
    
    // 创建渲染窗口
    vtkSmartPointer<vtkRenderWindow> renderWindow = vtkSmartPointer<vtkRenderWindow>::New();
    renderWindow->AddRenderer(renderer);
    renderWindow->SetSize(1200, 800);
    renderWindow->SetPosition(100, 300);
    
    // 创建交互器
    vtkSmartPointer<vtkRenderWindowInteractor> renderWindowInteractor = vtkSmartPointer<vtkRenderWindowInteractor>::New();
    renderWindowInteractor->SetRenderWindow(renderWindow);
    
    // 创建回调命令并绑定到交互器上
    vtkSmartPointer<vtkCallbackCommand> buttonCallback = vtkSmartPointer<vtkCallbackCommand>::New();
    buttonCallback->SetCallback(ButtonCallbackFunction);
    renderWindowInteractor->AddObserver(vtkCommand::LeftButtonPressEvent, buttonCallback);
    
    // 开始渲染
    renderWindow->Render();
    renderWindowInteractor->Start();
}

```

### 2.效果


![image](/images/vtk/Mac下VTK添加按钮/result.png)

