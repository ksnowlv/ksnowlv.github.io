---
layout: post
title: "flutter创建工程报错:Cannot create a project within the Flutter SDK. Target directory 'x' is within the Flutter SDK at'/Users/x/Music/flutter/flutter'"
date: 2019-05-22 11:13
comments: true
categories: flutter
---


在使用 `flutter create`命令创建`flutter`工程时，如果报`Cannot create a project within the Flutter SDK. Target directory '/Users/ksnowlv/Music/flutter/flutter/my_app' is within the Flutter SDK at
'/Users/ksnowlv/Music/flutter/flutter'的错误，`注意不要在`flutter SDK`目录及子目录下创建工程，可考虑在其它目录下创建工程。例如平级目录

	ksnowlvdeMacBook-Pro:flutter ksnowlv$ ./flutter/bin/flutter create my_app
	Creating project my_app...
	  my_app/ios/Runner.xcworkspace/contents.xcworkspacedata (created)
	  my_app/ios/Runner/Info.plist (created)
	  my_app/ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png (created)
	  my_app/ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png (created)
	  my_app/ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md (created)
	  my_app/ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json (created)
	  my_app/ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png (created)
	  my_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png (created)
	  my_app/ios/Runner/Base.lproj/LaunchScreen.storyboard (created)
	  my_app/ios/Runner/Base.lproj/Main.storyboard (created)
	  my_app/ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata (created)
	  my_app/ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme (created)
	  my_app/ios/Flutter/Debug.xcconfig (created)
	  my_app/ios/Flutter/Release.xcconfig (created)
	  my_app/ios/Flutter/AppFrameworkInfo.plist (created)
	  my_app/test/widget_test.dart (created)
	  my_app/my_app.iml (created)
	  my_app/.gitignore (created)
	  my_app/.metadata (created)
	  my_app/ios/Runner/AppDelegate.h (created)
	  my_app/ios/Runner/main.m (created)
	  my_app/ios/Runner/AppDelegate.m (created)
	  my_app/ios/Runner.xcodeproj/project.pbxproj (created)
	  my_app/android/app/src/profile/AndroidManifest.xml (created)
	  my_app/android/app/src/main/res/mipmap-mdpi/ic_launcher.png (created)
	  my_app/android/app/src/main/res/mipmap-hdpi/ic_launcher.png (created)
	  my_app/android/app/src/main/res/drawable/launch_background.xml (created)
	  my_app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png (created)
	  my_app/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png (created)
	  my_app/android/app/src/main/res/values/styles.xml (created)
	  my_app/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png (created)
	  my_app/android/app/src/main/AndroidManifest.xml (created)
	  my_app/android/app/src/debug/AndroidManifest.xml (created)
	  my_app/android/gradle/wrapper/gradle-wrapper.properties (created)
	  my_app/android/gradle.properties (created)
	  my_app/android/settings.gradle (created)
	  my_app/pubspec.yaml (created)
	  my_app/README.md (created)
	  my_app/lib/main.dart (created)
	  my_app/android/app/build.gradle (created)
	  my_app/android/app/src/main/java/com/example/my_app/MainActivity.java (created)
	  my_app/android/build.gradle (created)
	  my_app/android/my_app_android.iml (created)
	  my_app/.idea/runConfigurations/main_dart.xml (created)
	  my_app/.idea/libraries/Flutter_for_Android.xml (created)
	  my_app/.idea/libraries/Dart_SDK.xml (created)
	  my_app/.idea/libraries/KotlinJavaRuntime.xml (created)
	  my_app/.idea/modules.xml (created)
	  my_app/.idea/workspace.xml (created)
	Running "flutter packages get" in my_app...                         5.7s
	Wrote 66 files.
	
	All done!
	[✓] Flutter is fully installed. (Channel dev, v1.6.0, on Mac OS X 10.14.4 18E226, locale zh-Hans-CN)
	[!] Android toolchain - develop for Android devices is partially installed; more components are available. (Android SDK version 28.0.3)
	[!] iOS toolchain - develop for iOS devices is partially installed; more components are available. (Xcode 10.2.1)
	[!] Android Studio is partially installed; more components are available. (version 3.4)
	[!] Connected device is not available.
	
	Run "flutter doctor" for information about installing additional components.
	
	In order to run your application, type:
	
	  $ cd my_app
	  $ flutter run
	
	Your application code is in my_app/lib/main.dart.
	
	ksnowlvdeMacBook-Pro:flutter ksnowlv$ 
