---
title: "Qt中QWebEngineView下C++与JS互调"
date: 2023-12-25T11:42:15+08:00
lastmod: 2023-12-25T11:42:15+08:00
keywords: ["Qt", "C++", "WebView"]
tags: ["Qt", "C++", "WebView"]
categories: ["Qt", "C++", "WebView"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Qt6.6版本中webview的使用：QWebEngineView

C++与JS互调，在Qt中，通过QWebChannel的实现的。

QWebChannel是Qt WebChannel模块提供的一个功能，它允许在Qt WebEngineView中实现Qt和JavaScript之间的双向通信。通过使用QWebChannel，您可以在C++代码和JavaScript代码之间进行方法调用和信号传递。


### 1.WebEngineWidgets组件和qwebchannel.js文件

#### WebEngineView组件

![image](/images/post/Qt中QWebEngineView下C++与JS互调/WebEngineWidgets_dir.jpg)
检查WebEngineWidgets库，是否存在？如果不存在，重新安装Qt相关组件。选择自定义安装，在附加库上选择QtWebEngineView组件
![image](/images/post/Qt中QWebEngineView下C++与JS互调/Qt_Additional_Libraries.png)

建议所有附加库都选择安装，以便后续使用。

#### qwebchannel.js文件
![image](/images/post/Qt中QWebEngineView下C++与JS互调/qwebchannel_js_dir.jpg)

检查上 qwebchannel.js文件，并拷贝到Qt工程目录下，添加到qrc文件中。

### 2.Qt工程配置文件CMakeLists.txt

```c++
cmake_minimum_required(VERSION 3.5)

project(QtWebViewTest VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS WebEngineWidgets)#WebEngineWidgets组件

set(PROJECT_SOURCES
        main.cpp
        mainwindow.cpp
        mainwindow.h
        mainwindow.ui
        #添加MyObject，注册到QWebChannel对象上
        myobject.h
        myobject.cpp
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(QtWebViewTest
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
        image.qrc #image.qrc添加图片，html，txt，js等资源文件
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET QtWebViewTest APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(QtWebViewTest SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(QtWebViewTest
            ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(QtWebViewTest PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)
target_link_libraries(QtWebViewTest PRIVATE Qt${QT_VERSION_MAJOR}::WebEngineWidgets)#WebEngineWidgets库


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
if(${QT_VERSION} VERSION_LESS 6.1.0)
  set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER com.example.QtWebViewTest)
endif()
set_target_properties(QtWebViewTest PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS QtWebViewTest
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(QtWebViewTest)
endif()

```


### 3.html文件及qwebchannel.js文件的添加

![image](/images/post/Qt中QWebEngineView下C++与JS互调/Qt_resource_dir.png)

![image](/images/post/Qt中QWebEngineView下C++与JS互调/QtFileDirOverview.png)

index.html文件内容

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>WebChannel Test</title>
    <script src="qrc:///resource/qwebchannel.js"></script>
    <script>
        var myObject = null;

        new QWebChannel(qt.webChannelTransport, function (channel) {
            myObject = channel.objects.myObject;
            myObject.nativeMethodCalled.connect(function (message) {
                 console.log("******Received message from native: " + message);
                 alert("Received message from native: " + message);
            });
            myObject.callNativeMethod("Message from JavaScript");
        });

        function sendMessageToNative() {
            if (myObject) {
                myObject.showMessage("Hello from WebView!"); // 发送消息给原生代码
            }
        }

    </script>

</head>
<body>
    <h1>WebChannel Test</h1>
    <button onclick="sendMessageToNative()">Send Message to Native</button> <!-- 点击按钮发送消息给原生代码 -->
</body>
</html>

```

### 4.QWebEngineView对象&QWebChannel对象&MyObject对象

#### MainWindow.h

```c++
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class QWebEngineView;
class QWebChannel;
class MyObject;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void handleNativeCallWebPushButtonClicked();

    void handleWebCallNativePushButtonClicked();

private:
    Ui::MainWindow *ui;
    QWebEngineView *webEngineView;
    std::unique_ptr<QWebChannel> webChannel;
    std::unique_ptr<MyObject> myObject;
};
#endif // MAINWINDOW_H

```


#### MainWindow.cpp

```c++
#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include "myobject.h"
#include <QFile>
#include <QDir>
#include <QTextStream>

#include <QWebEngineView>
#include <QWebChannel>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // 加载图片并设置为按钮的图标
    // QPixmap pixmap(":/images/main.png");
    QPixmap pixmap(":/images/overview.jpg");
    ui->label->setPixmap(pixmap);


    webEngineView = new QWebEngineView(this);
    webEngineView->setGeometry(QRect(10, 20, 300, 250));

    // 创建一个QWebChannel对象，并将其绑定到QWebEngineView页面
    webChannel = std::make_unique<QWebChannel>();
    myObject =  std::make_unique<MyObject>();
    webChannel->registerObject(QStringLiteral("myObject"), myObject.get());
    webEngineView->page()->setWebChannel(webChannel.get());
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::handleNativeCallWebPushButtonClicked()
{
    qDebug()<<"handlNativeCallWebPushButtonClicked";


    QString htmlPath =  ":/resource/index.html";

    QFile file(htmlPath);
    if (file.exists()) {
        qDebug() << htmlPath<<",this file exists";
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << "Failed to open file";
            return;
        }

        // 创建文本流，并设置编码为UTF-8
        QTextStream in(&file);
        in.setLocale(QLocale(QLocale::C)); // 设置为"C"语言环境来确保编码为UTF-8

        // 读取并输出文件内容
        QString fileContent = in.readAll();
        qDebug() << fileContent;
        // 关闭文件
        file.close();

        const QUrl& url = QUrl(htmlPath);// QUrl::fromLocalFile(htmlPath);
        webEngineView->load(QUrl("qrc" + htmlPath));
        webEngineView->resize(300, 250);
        webEngineView->show();
    } else {
        qDebug() << "File does not exist";
    }
}


void MainWindow::handleWebCallNativePushButtonClicked()
{
    qDebug()<<"handleWebCallNativePushButtonClicked";
}


```

#### MyObject.h

```c++
#ifndef MYOBJECT_H
#define MYOBJECT_H

#include <QObject>
#include <QDebug>

class MyObject : public QObject
{
    Q_OBJECT
public:
    explicit MyObject(QObject *parent = nullptr);

public slots:
    void showMessage(const QString &message);

 public slots:
    void callNativeMethod(const QString &message);
signals:
    void nativeMethodCalled(const QString &message);
};

#endif // MYOBJECT_H

```
#### MyObject.cpp

```c++
#include "myobject.h"

MyObject::MyObject(QObject *parent)
    : QObject{parent}
{

}

void MyObject::showMessage(const QString &message) {
    // 在原生代码中处理来自WebView的消息
    qDebug() << "Message from WebView:" << message;
}

void MyObject::callNativeMethod(const QString &message)
{   //JS Call NativeMethod
    qDebug() << "Native method called from JavaScript:" << message;
    emit nativeMethodCalled("Message from native method");
}

```

### 5.效果

![image](/images/post/Qt中QWebEngineView下C++与JS互调/qt_result.png)

```shell

15:46:54: Starting /Users/lvwei/Documents/qtprojects/build-QtWebViewTest-Qt_6_6_1_for_macOS-Debug/QtWebViewTest.app/Contents/MacOS/QtWebViewTest...
doh set to ""  --  SystemOnly
handlNativeCallWebPushButtonClicked
":/resource/index.html" ,this file exists
"<!-- index.html -->\n<!DOCTYPE html>\n<html>\n<head>\n    <meta charset=\"UTF-8\">\n    <title>WebChannel Test</title>\n    <script src=\"qrc:///resource/qwebchannel.js\"></script>\n    <script>\n        var myObject = null;\n\n        new QWebChannel(qt.webChannelTransport, function (channel) {\n            myObject = channel.objects.myObject;\n            myObject.nativeMethodCalled.connect(function (message) {\n                 console.log(\"******Received message from native: \" + message);\n                 alert(\"Received message from native: \" + message);\n            });\n            myObject.callNativeMethod(\"Message from JavaScript\");\n        });\n\n        function sendMessageToNative() {\n            if (myObject) {\n                myObject.showMessage(\"Hello from WebView!\"); // 发送消息给原生代码\n            }\n        }\n\n    </script>\n\n</head>\n<body>\n    <h1>WebChannel Test</h1>\n    <button onclick=\"sendMessageToNative()\">Send Message to Native</button> <!-- 点击按钮发送消息给原生代码 -->\n</body>\n</html>\n"
-----------------------
Native method called from JavaScript: "Message from JavaScript"
Message from WebView: "Hello from WebView!"
Message from WebView: "Hello from WebView!"
Message from WebView: "Hello from WebView!"
15:46:54: Starting /Users/lvwei/Documents/qtprojects/build-QtWebViewTest-Qt_6_6_1_for_macOS-Debug/QtWebViewTest.app/Contents/MacOS/QtWebViewTest...
doh set to ""  --  SystemOnly
handlNativeCallWebPushButtonClicked
":/resource/index.html" ,this file exists
"<!-- index.html -->\n<!DOCTYPE html>\n<html>\n<head>\n    <meta charset=\"UTF-8\">\n    <title>WebChannel Test</title>\n    <script src=\"qrc:///resource/qwebchannel.js\"></script>\n    <script>\n        var myObject = null;\n\n        new QWebChannel(qt.webChannelTransport, function (channel) {\n            myObject = channel.objects.myObject;\n            myObject.nativeMethodCalled.connect(function (message) {\n                 console.log(\"******Received message from native: \" + message);\n                 alert(\"Received message from native: \" + message);\n            });\n            myObject.callNativeMethod(\"Message from JavaScript\");\n        });\n\n        function sendMessageToNative() {\n            if (myObject) {\n                myObject.showMessage(\"Hello from WebView!\"); // 发送消息给原生代码\n            }\n        }\n\n    </script>\n\n</head>\n<body>\n    <h1>WebChannel Test</h1>\n    <button onclick=\"sendMessageToNative()\">Send Message to Native</button> <!-- 点击按钮发送消息给原生代码 -->\n</body>\n</html>\n"
-----------------------
Native method called from JavaScript: "Message from JavaScript"
Message from WebView: "Hello from WebView!"
Message from WebView: "Hello from WebView!"
Message from WebView: "Hello from WebView!"
```
