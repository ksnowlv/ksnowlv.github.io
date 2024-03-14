---
title: "Mac下VTK添加日志"
date: 2024-03-14T11:30:36+08:00
lastmod: 2024-03-14T11:30:36+08:00
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

### 1.添加Logger类

* Logger.hpp

```c++
//
//  Logger.hpp
//  HelloVTK
//
//  Created by ksnowlv on 2024/3/14.
//

#ifndef Logger_hpp
#define Logger_hpp

#include <stdio.h>

#include <vtkObject.h>
class vtkLogger;

class Logger: public vtkObject {
    
public:
    // 获取单例实例的方法
    static Logger* GetInstance()
    {
        if (!m_instance)
        {
            m_instance = new Logger();
        }
        return m_instance;
    }

    
    ~Logger();
    
public:

    // 输出debug级别的日志消息
    void LogDebugMessage(const char* message);

       // 输出warn级别的日志消息
    void LogWarningMessage(const char* message);

       // 输出error级别的日志消息
    void LogErrorMessage(const char* message);

       // 输出fatal级别的日志消息
    void LogFatalMessage(const char* message);
    
private:
    // 私有化构造函数和拷贝构造函数
    Logger();
    Logger(const Logger&);
    Logger& operator=(const Logger&);

private:
    static Logger* m_instance;

};

#endif /* Logger_hpp */

```


* Logger.cpp

```c++
//
//  Logger.cpp
//  HelloVTK
//
//  Created by ksnowlv on 2024/3/14.
//

#include "Logger.hpp"

#include <vtkSmartPointer.h>
#include <vtkOutputWindow.h>

Logger* Logger::m_instance = nullptr;

Logger::Logger() {

vtkSmartPointer<vtkOutputWindow> outputWindow = vtkSmartPointer<vtkOutputWindow>::New();
vtkOutputWindow::SetInstance(outputWindow);
}

Logger::Logger(const Logger&) {

}

Logger& Logger::operator=(const Logger&) {
return *m_instance;
}

Logger::~Logger() {

}

void Logger::LogDebugMessage(const char* message) {
//vtkDebugMacro(<<message);
vtkWarningMacro(<< "Debug: " << message);
}

void Logger::LogWarningMessage(const char* message) {
vtkWarningMacro(<<message);
}

void Logger::LogErrorMessage(const char* message) {
vtkErrorMacro(<<message);
}

void Logger::LogFatalMessage(const char* message) {
vtkWarningMacro(<<message);
}


```

* 调用

```c++

Logger* logger = Logger::GetInstance();
logger->LogDebugMessage("这是一个debug级别的日志消息。");
logger->LogWarningMessage("这是一个warn级别的日志消息。");
logger->LogErrorMessage("这是一个error级别的日志消息.");
logger->LogFatalMessage("这是一个fatal级别的日志消息.");
cout<<"---Macro USE----"<<endl;
vtkGenericWarningMacro("Warning message");
vtkErrorWithObjectMacro(logger, "error message");
vtkDebugWithObjectMacro(logger, "debug message");
vtkWarningWithObjectMacro(logger, "warning message");
```

!!!仅为日志使用效果展示，在实际项目中，不推荐使用。

### 2.效果

```shell
2024-03-14 11:51:04.435 (   0.008s) [          10E305]             Logger.cpp:35    WARN| vtkObject (0x6000008b2990): Debug: 这是一个debug级别的日志消息。
2024-03-14 11:51:04.435 (   0.008s) [          10E305]             Logger.cpp:39    WARN| vtkObject (0x6000008b2990): 这是一个warn级别的日志消息。
2024-03-14 11:51:04.435 (   0.008s) [          10E305]             Logger.cpp:43     ERR| vtkObject (0x6000008b2990): 这是一个error级别的日志消息.
2024-03-14 11:51:04.435 (   0.008s) [          10E305]             Logger.cpp:47    WARN| vtkObject (0x6000008b2990): 这是一个fatal级别的日志消息.
---Macro USE----
2024-03-14 11:51:04.435 (   0.008s) [          10E305]               main.cpp:23    WARN| Warning message
2024-03-14 11:51:04.435 (   0.008s) [          10E305]               main.cpp:24     ERR| vtkObject (0x6000008b2990): error message
2024-03-14 11:51:04.435 (   0.008s) [          10E305]               main.cpp:26    WARN| vtkObject (0x6000008b2990): warning message
```


