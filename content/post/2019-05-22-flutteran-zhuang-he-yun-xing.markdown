---
title: "flutter安装和运行"
date: 2019-05-22
lastmod: 2019-05-22
categories:
  - "iOS"
tags:
  - "flutter"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


### 1.创建flutter工程目录（各项目+flutter目录），在flutter 目录下载flutter SDK
	git init
	git clone -b dev https://github.com/flutter/flutter.git

### 2.进入flutter SDK目录即flutter禁用通过 Google Analytics 发送数据
	cd flutter
	./bin/flutter config --no-analytics
	
禁用通过 Google Analytics 发送相关数据，以免国内网络连接失败问题。

### 3.检查flutter安装情况：flutter doctor
	ksnowlvdeMacBook-Pro:flutter ksnowlv$ ./bin/flutter doctor
	Downloading Material fonts...                                       0.7s
	Downloading android-arm-profile/darwin-x64 tools...                 1.3s
	Downloading android-arm-release/darwin-x64 tools...                 1.2s
	Downloading android-arm64-profile/darwin-x64 tools...               1.4s
	Downloading android-arm64-release/darwin-x64 tools...               1.4s
	Downloading android-x86 tools...                                    6.6s
	Downloading android-x64 tools...                                    6.8s
	Downloading android-arm tools...                                    3.1s
	Downloading android-arm-profile tools...                            2.0s
	Downloading android-arm-release tools...                            1.5s
	Downloading android-arm64 tools...                                  3.2s
	Downloading android-arm64-profile tools...                          2.1s
	Downloading android-arm64-release tools...                          1.5s
	Downloading ios tools...                                           16.0s
	Downloading ios-profile tools...                                   11.7s
	Downloading ios-release tools...                                    8.9s
	Downloading Gradle Wrapper...                                       0.3s
	Downloading package sky_engine...                                   1.1s
	Downloading common tools...                                         4.2s
	Downloading common tools...                                         4.1s
	Downloading darwin-x64 tools...                                    14.0s
	Doctor summary (to see all details, run flutter doctor -v):
	[✓] Flutter (Channel dev, v1.6.0, on Mac OS X 10.14.4 18E226, locale zh-Hans-CN)
	[!] Android toolchain - develop for Android devices (Android SDK version 28.0.3)
	    ✗ Android license status unknown.
	      Try re-installing or updating your Android SDK Manager.
	      See https://developer.android.com/studio/#downloads or visit https://flutter.dev/setup/#android-setup for detailed instructions.
	[!] iOS toolchain - develop for iOS devices
	    ✗ Xcode installation is incomplete; a full installation is necessary for iOS development.
	      Download at: https://developer.apple.com/xcode/download/
	      Or install Xcode via the App Store.
	      Once installed, run:
	        sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
	    ✗ libimobiledevice and ideviceinstaller are not installed. To install with Brew, run:
	        brew update
	        brew install --HEAD usbmuxd
	        brew link usbmuxd
	        brew install --HEAD libimobiledevice
	        brew install ideviceinstaller
	    ✗ ios-deploy not installed. To install:
	        brew install ios-deploy
	[!] Android Studio (version 3.4)
	    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
	    ✗ Dart plugin not installed; this adds Dart specific functionality.
	[!] Connected device
	    ! No devices available
	
	! Doctor found issues in 4 categories.

### 4.安装XCode和打开iOS模拟器* 安装XCode
	* 我机器安装的XCode版本是10.2.1，比较新了。如果安装的版本较老，可以更新下


			ksnowlvdeMacBook-Pro:flutter ksnowlv$ sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
					Password:

* 打开模拟器
	* 在Mac机器上，可以通过	`open -a Simulator`	

### 5.创建工程使用`flutter create 项目名称`创建项目

	在使用 flutter create命令创建flutter工程时，如果报Cannot create a project within the Flutter SDK. Target directory '/Users/ksnowlv/Music/flutter/flutter/my_app' is within the Flutter SDK at '/Users/ksnowlv/Music/flutter/flutter'的错误，注意不要在flutter SDK目录及子目录下创建工程，可考虑在其它目录下创建工程。例如平级目录


### 6.运行工程
 使用flutter run运行app，
 
 	../flutter/bin/flutter run
 	
 	
![image](/images/post/2019-05-22-flutteran-zhuang-he-yun-xing/flutter-run_cmd.png) 

	
![image](/images/post/2019-05-22-flutteran-zhuang-he-yun-xing/flutter-run_iOS.png) 
	
