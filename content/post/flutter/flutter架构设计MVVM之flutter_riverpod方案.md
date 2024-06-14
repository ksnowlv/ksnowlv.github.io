---
title: "Flutter架构设计MVVM之flutter_riverpod方案"
date: 2024-04-04T16:18:41+08:00
lastmod: 2024-04-04T16:18:41+08:00
keywords: ["flutter", "架构设计"]
tags: ["flutter", "架构设计"]
categories: ["flutter", "架构设计"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## Flutter架构设计MVVM-flutter_riverpod

在 MVVM 架构中，我们有三种主要的组件：Model（模型）,View（视图）和 ViewModel（视图模型）。

flutter_riverpod是一个基于Provider的状态管理库，可以辅助我们在Flutter应用中实现MVVM架构。

flutter_riverpod 主要用于管理 Model 和 ViewModel，而 View 通常是由 Flutter 的 Widget 树来表示的。 

目录结构如下

user_model \
--model \
-----user_model.dart \
--view \
-----user_model_page.dart \
--view_models \
-----user_view_model.dart

### 1.Model

* user_model.dart

```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String name;
  int age;

  UserModel(
      this.name,
      this.age,
      );
}


```

### 2.ViewModel

* user_view_model.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_demo/pages/mine/user_model/model/user_model.dart';

class UserViewModel with ChangeNotifier {
  final UserModel _userModel;

  UserModel get userModel => _userModel;

  UserViewModel() : _userModel = UserModel('', 0);

  // ignore: empty_constructor_bodies
  void updateName(String newName) {
    _userModel.name = newName;
    notifyListeners();
  }

  void updateAge(int newAge) {
    _userModel.age = newAge;
    notifyListeners();
  }
}

//观察UserViewModel数据变化
final userViewModelProvider = ChangeNotifierProvider<UserViewModel>((ref) => UserViewModel());

```

### 3.View

* user_model_page.dart

我们扩展的是ConsumerWidget页面视图，在build方法中，通过ref.watch(userViewModelProvider)监控userViewModel数据变化。

```dart
import 'package:base_demo/pages/mine/user_model/view_models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserModelPage extends ConsumerWidget {
  const UserModelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userViewModel = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('viewModel:${userViewModel.userModel}'),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                //ref.read(userViewModelProvider.notifier).updateName('kk');
                userViewModel.updateName('kksnow');
              },
              child: const Text('更新姓名')),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                //ref.read(userViewModelProvider.notifier).updateAge(12);
                userViewModel.updateAge(1+ userViewModel.userModel.age);
              },
              child: const Text('更新年龄')),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

```

### 4.ProviderScope创建和管理Provider 的上下文
* main.dart

我们要确保使用 package:riverpod 中的Provider类， ProviderScope 提供了创建和管理 Provider 的上下文，这些 Provider 用于管理状态和数据
因flutter_riverpo库d与provider库都提供Provider类，我们对flutter_riverpo库重命名。


```dart
import 'package:base_demo/common/hive_manage.dart';
import 'package:base_demo/common/logger.dart';
import 'package:base_demo/common/theme_manager.dart';
import 'package:base_demo/pages/main/main_page.dart';
import 'package:base_demo/widgets/provider_widget.dart';
import 'package:base_demo/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as flutter_riverpod ;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() async {
  XLogger.getLogger().d("main init");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  await HiveManage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterModel()),
        ChangeNotifierProvider(create: (context) => ThemeManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    //ProviderScope 提供了创建和管理 Provider 的上下文，这些 Provider 用于管理状态和数据
    return flutter_riverpod.ProviderScope(
        child: MaterialApp(
          title: 'Flutter Base Demo',
          theme: themeManager.theme,
          home: const MainPage(title: "Main page"),
          initialRoute: '/',
          onGenerateRoute: XRouter.generateRoute,
          builder: FToastBuilder(),
        ));
  }
}

```


### 5.效果
![image](/images/flutter/flutter架构设计MVVM之flutter_riverpod方案/result.png)

### 6.分析与小结

#### 6.1分析

拆解上述MVVM示例
##### Model（模型）

Model是应用程序的数据层，负责处理数据和业务逻辑。在本例中，UserModel类是一个简单的数据模型，它包含了用户的姓名和年龄信息. 

##### ViewModel

ViewModel是Model和View之间的桥梁，它负责处理View的数据需求，并在数据变化时通知View更新。

UserViewModel类继承自ChangeNotifier，它持有一个UserModel实例，并通过notifyListeners方法来通知依赖于它的状态的Widget进行更新。ViewModel提供了修改Model数据的方法，如updateName和updateAge，并在每次数据变化后触发更新。

##### View（视图）

View是用户界面的表示，它通过ViewModel来获取数据并展示给用户。

UserModelPage是一个ConsumerWidget，它使用ref.watch来监听UserViewModel的状态变化。当用户通过按钮更新数据时，ViewModel会响应这些变化，并通知View进行相应的更新。

##### ProviderScope

ProviderScope是flutter_riverpod中的一个Widget，它用于创建和管理Provider的上下文。

Provider负责管理状态和数据流。flutter_riverpod.ProviderScope确保了Provider的生命周期与Widget树的生命周期相匹配，并在必要时正确地清理资源。


#### 6.2小结
  * flutter_riverpod提供了一套强大的状态管理工具功能，如状态监听、延迟加载、状态转换，自动更新和依赖注入，使得状态的管理和访问变得更加简洁和高效。
  * 通过使用flutter_riverpod，我们可以在Flutter应用中实现MVVM架构，从而清晰地分离应用程序的不同部分。
 