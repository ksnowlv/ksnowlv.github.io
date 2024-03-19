---
title: "Flutter添加相册选图image_picker"
date: 2024-03-19T16:16:30+08:00
lastmod: 2024-03-19T16:16:30+08:00
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

## image_picker的使用

### 1.image_picker

官方链接见[https://pub-web.flutter-io.cn/packages/image_picker](https://pub-web.flutter-io.cn/packages/image_picker)

### 2.permission_handler

官方链接见[https://pub-web.flutter-io.cn/packages/permission_handler](https://pub-web.flutter-io.cn/packages/permission_handler)
支持Android/iOS/Web/Windows

### 3.pubspec.yaml添加依赖

```yaml
     image_picker: ^1.0.7

     permission_handler: ^11.3.0
```

### 4.示例

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  ImagePickerWidgetState createState() => ImagePickerWidgetState();
}

class ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  void _pickImage() async {
    PermissionStatus status = await Permission.photos.status;

    if (status.isGranted) {
      // 权限已经被授予
      // 在这里可以执行相关操作
      debugPrint('用户已授权相册访问权限');
    } else {
      // 权限尚未被授予，需要请求权限
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
      ].request();

      // 处理权限请求的结果
      if (statuses[Permission.photos] == PermissionStatus.granted) {
        // 用户已授予相册访问权限

      } else {
        // 用户拒绝了相册访问权限
        debugPrint('用户拒绝了相册访问权限');
        return;
      }
    }

    final XFile? imageFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _imageFile == null
            ? const Text('no image selected!')
            : Image.file(
          File(_imageFile!.path),
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
        ElevatedButton(
            onPressed: () {
              _pickImage();
            },
            child: const Text("please pick image"))
      ],
    );
  }
}


```

从相册中选择图片，需要访问权限；故添加permission_handler支持。

在iOS模拟器或设备上，还需要以下支持。

* Podfile中添加相册权限支持

```text

# Uncomment this line to define a global platform for your project
# platform :ios, '12.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    # 添加权限处理，其它权限需要的话，也可以开启。
    # Start of the permission_handler configuration
    target.build_configurations.each do |config|


      # You can enable the permissions needed here. For example to enable camera
      # permission, just remove the `#` character in front so it looks like this:
      #
      # ## dart: PermissionGroup.camera
      # 'PERMISSION_CAMERA=1'
      #
      #  Preprocessor definitions can be found in: https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler_apple/ios/Classes/PermissionHandlerEnums.h
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',

        ## dart: PermissionGroup.calendar
        # 'PERMISSION_EVENTS=1',

        ## dart: PermissionGroup.reminders
        # 'PERMISSION_REMINDERS=1',

        ## dart: PermissionGroup.contacts
        # 'PERMISSION_CONTACTS=1',

        ## dart: PermissionGroup.camera
         #'PERMISSION_CAMERA=1',

        ## dart: PermissionGroup.microphone
        # 'PERMISSION_MICROPHONE=1',

        ## dart: PermissionGroup.speech
        # 'PERMISSION_SPEECH_RECOGNIZER=1',

        ## dart: PermissionGroup.photos
         'PERMISSION_PHOTOS=1',

        ## dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
        # 'PERMISSION_LOCATION=1',

        ## dart: PermissionGroup.notification
        # 'PERMISSION_NOTIFICATIONS=1',

        ## dart: PermissionGroup.mediaLibrary
        # 'PERMISSION_MEDIA_LIBRARY=1',

        ## dart: PermissionGroup.sensors
        # 'PERMISSION_SENSORS=1',   

        ## dart: PermissionGroup.bluetooth
        # 'PERMISSION_BLUETOOTH=1',

        ## dart: PermissionGroup.appTrackingTransparency
        # 'PERMISSION_APP_TRACKING_TRANSPARENCY=1',

        ## dart: PermissionGroup.criticalAlerts
        # 'PERMISSION_CRITICAL_ALERTS=1'
      ]

    end 
    # End of the permission_handler configuration

  end


end

```

* Info.list中添加相册权限支持

```text
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Used to demonstrate image picker plugin</string>
    <!-- <key>NSCameraUsageDescription</key>
    <string>Used to demonstrate image picker plugin</string> -->
    <!-- <key>NSMicrophoneUsageDescription</key>
    <string>Used to demonstrate image picker plugin</string> -->

```


### 5.效果

![image](/images/flutter/flutter添加相册选图image_picker/result_1.png)

![image](/images/flutter/flutter添加相册选图image_picker/result_2.png)

![image](/images/flutter/flutter添加相册选图image_picker/result_3.png)
