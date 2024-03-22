---
title: "Flutter作为模块嵌入iOS项目"
date: 2024-03-22T13:33:37+08:00
lastmod: 2024-03-22T13:33:37+08:00
keywords: ["flutter"]
tags: ["flutter"]
categories: ["flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## iOS项目嵌入Flutter模块

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

### 2.创建iOS项目

使用XCode创建iOS项目,我使用的XCode 15.3需要修改下项目配置ENABLE_USER_SCRIPT_SANDBOXING为NO，见[链接](https://ksnowlv.github.io/post/flutter/flutter添加模块到ios项目中报错ios-xcode-15.3sandbox-rsync-deny-file-write-create/)


```shell
ksnowlv@MacBook-Pro-3 FlutterProjects % ls
FlutterModuleTest	README.md		base_demo		flutter_module		hello_world
ksnowlv@MacBook-Pro-3 FlutterProjects % 

```

注意FlutterModuleTest与flutter_module在同级目录。


### 3.创建iOS项目Podfile

```text
# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

# 指定flutter模块路径
flutter_application_path = '/Users/ksnowlv/Documents/FlutterProjects/FlutterProjects/flutter_module'
load File.join(flutter_application_path, '.ios', 'flutter', 'podhelper.rb') 



target 'FlutterModuleTest' do
  # Comment the next line if you don't want to use dynamic frameworks
   use_frameworks!
    # 加载flutter模块
  install_all_flutter_pods(flutter_application_path)

  # Pods for UseFlutterModule
  pod 'Masonry', '~> 1.0'

end

# 新增的配置
post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end


```

### 4.显示flutter页面

* AppDelegate.swift
```swift
import UIKit
import Flutter
import FlutterPluginRegistrant

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    lazy var flutterEngine = FlutterEngine(name: "My Flutter engine!")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
        
        return true
    }
 }
```

* AppDelegate.swift

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

![image](/images/flutter/flutter作为模块嵌入iOS项目/result_1.png)

![image](/images/flutter/flutter作为模块嵌入iOS项目/result_2.png)