---
title: "Flutter作为CocoaPods的podspec文件分发嵌入iOS项目"
date: 2024-04-17T16:39:03+08:00
lastmod: 2024-04-17T16:39:03+08:00
keywords: ["flutter", "iOS"]
tags: ["flutter", "iOS"]
categories: ["flutter", "iOS"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### iOS项目使用CocoaPods内嵌应用和插件框架的混合工程

##### 直接嵌入Flutter模块的framework：
优势：
* 1.集成简单：直接将Flutter模块编译为framework，iOS项目引入即可。
* 2.独立发布：Flutter framework在iOS项目中作为独立的模块，可以独立更新和发布，无需flutter环境，有利于维护和迭代。

缺点：
* 1.集成复杂性：需要通过Flutter工具链来构建并更新 framework，不够灵活。
* 2.依赖管理：如果与原生iOS项目共享依赖，可能会导致依赖管理复杂。

#### CocoaPods内嵌应用和插件框架的混合工程：
优势：
* 1.依赖管理：可以利用CocoaPods来管理混合工程中Flutter模块的依赖，简化了依赖管理流程。
* 2.灵活性：可以更灵活地使用原生 iOS 功能，并与 Flutter 模块进行混合开发。

缺点：
* 1.集成复杂性：需要在原生工程中配置相关的插件、依赖和编译设置，可能稍显复杂。

### 1.创建Flutter模块

```shell
ksnowlv@MacBook-Pro-3 FlutterProjects % flutter create -t module flutter_module
Creating project flutter_module...
Resolving dependencies in flutter_module... 
Got dependencies in flutter_module.
Wrote 12 files.

All done!
Your module code is in flutter_module/lib/main.dart.
ksnowlv@MacBook-Pro-3 FlutterProjects % ls
README.md	base_demo	flutter_module	hello_world

```

### 2.生成frameworks

在flutter_module模块目录下，生成库命令如下，

    flutter build ios-framework  --cocoapods --output=目录

使用**flutter build ios-framework --cocoapods** 生成库文件

    flutter build ios-framework --cocoapods  --output=../FlutterCocoaFrameworkTest/FlutterLib

FlutterCocoaFrameworkTest与flutterModule为同级目录，因此，**--output**指定为**../FlutterCocoaFrameworkTest/FlutterLib**，生成的库在FlutterCocoaFrameworkTest目录下


```shell
(base) ksnowlv@MacBook-Pro-3 flutter_module %  flutter build ios-framework --cocoapods  --output=../FlutterCocoaFrameworkTest/FlutterLib

Building frameworks for com.example.flutterModule in debug mode...
Flutter assets will be downloaded from https://storage.flutter-io.cn. Make sure you trust this source!
 ├─Creating Flutter.podspec...                                       6ms
 ├─Building App.xcframework...                                     16.8s
 └─Moving to ../FlutterCocoaFrameworkTest/FlutterLib/Debug          45ms
Building frameworks for com.example.flutterModule in profile mode...
 ├─Creating Flutter.podspec...                                       1ms
Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 1384 bytes (99.9% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons
flag when building your app.
Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 1384 bytes (99.9% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons
flag when building your app.
 ├─Building App.xcframework...                                     32.1s
 └─Moving to ../FlutterCocoaFrameworkTest/FlutterLib/Profile         29ms
Building frameworks for com.example.flutterModule in release mode...
 ├─Creating Flutter.podspec...                                       4ms
Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 1384 bytes (99.9% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons
flag when building your app.
Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 1384 bytes (99.9% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons
flag when building your app.
 ├─Building App.xcframework...                                     28.9s
 └─Moving to ../FlutterCocoaFrameworkTest/FlutterLib/Release         57ms
Frameworks written to /Users/ksnowlv/Documents/FlutterProjects/FlutterProjects/flutter_module/../FlutterCocoaFrameworkTest/FlutterLib.
Bitcode support has been deprecated. Turn off the "Enable Bitcode" build setting in your Xcode project or you may encounter compilation errors.
See https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes for details.
(base) ksnowlv@MacBook-Pro-3 flutter_module % 
```

![image](/images/flutter/flutter作为CocoaPods的podspec文件分发嵌入iOS项目/iOS_framework.png)


### 3.创建iOS项目和Podfile

使用XCode创建iOS项目,我使用的XCode 15.3，直接创建*FlutterCocoaFrameworkTest*项目即可。

创建Podfile，内容如下

```text

platform :ios, '13.0'

target 'FlutterCocoaFrameworkTest' do
  # Comment the next line if you don't want to use dynamic frameworks
   use_frameworks!


  # Pods for UseFlutterModule

  pod 'Flutter', :podspec => 'FlutterLib/Release/Flutter.podspec'
#  pod 'Flutter', :podspec => 'FlutterLib/Debug/Flutter.podspec'

end
```

使用**pod install**安装依赖

```shell
(base) ksnowlv@MacBook-Pro-3 FlutterCocoaFrameworkTest % pod install
Analyzing dependencies
Fetching podspec for `Flutter` from `FlutterLib/Debug/Flutter.podspec`
Downloading dependencies
Installing Flutter (3.19.500)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `FlutterCocoaFrameworkTest.xcworkspace` for this project from now on.
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod installed.

[!] Your project does not explicitly specify the CocoaPods master specs repo. Since CDN is now used as the default, you may safely remove it from your repos directory via `pod repo remove master`. To suppress this warning please add `warn_for_unused_master_specs_repo => false` to your Podfile.
(base) ksnowlv@MacBook-Pro-3 FlutterCocoaFrameworkTest % pod update 

```

至此，Flutter库已经引入，然后，再引入**App.xcframework**，操作步骤如下


* 选中**TARGETS**中**FlutterCocoaFrameworkTest**，
* 选择**Build Phases**选项卡，
* 点击Link Binary With Libraries选项卡； 选择+，并在Add Other下拉列表中选择Add Files，选中FlutterLib下Debug目录下**App.xcframework**

* 然后，在**Embed Frameworks**选项卡中，添加**App.xcframework**


![image](/images/flutter/flutter作为CocoaPods的podspec文件分发嵌入iOS项目/xcode_framework.jpg)

### 4.显示flutter页面

* AppDelegate.swift
```swift
import UIKit
import Flutter

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    lazy var flutterEngine = FlutterEngine(name: "My Flutter engine!")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        flutterEngine.run()
        return true
    }
 }
```

* ViewController.swift

```swift
import UIKit

import Flutter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showFlutterView()  {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController: flutterViewController)
        navigationController.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissFlutterViewController))
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func dismissFlutterViewController() {
           dismiss(animated: true, completion: nil)

   }
}

```

### 5.效果

![image](/images/flutter/flutter作为CocoaPods的podspec文件分发嵌入iOS项目/result1.png)

![image](/images/flutter/flutter作为CocoaPods的podspec文件分发嵌入iOS项目/result2.png)


### 6.可能遇见的问题

#### 问题1

    SDK does not contain 'libarclite' at the path '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc/libarclite_iphonesimulator.a'; try increasing the minimum deployment target

解决方案

    从https://github.com/diyxiaoshitou/Libarclite-Files-main下载文件后，把libarclite_iphoneos.a，libarclite_ip...simulator.a添加到创建的arc目录下即可。路径如下：

![image](/images/flutter/flutter作为CocoaPods的podspec文件分发嵌入iOS项目/xcode_lib1.png)

![image](/images/flutter/flutter作为CocoaPods的podspec文件分发嵌入iOS项目/xcode_lib2.png)


#### 问题2

    [ERROR:flutter/shell/common/engine.cc(213)] Engine run configuration was invalid.

解决方案
    
    按上述第三部分介绍的添加App.xcframework步骤，添加后，清除工程，重新运行即可。

