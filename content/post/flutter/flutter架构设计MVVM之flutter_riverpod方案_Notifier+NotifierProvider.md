---
title: "Flutter架构设计MVVM之flutter_riverpod方案_Notifier+NotifierProvider"
date: 2024-04-05T18:22:17+08:00
lastmod: 2024-04-05T18:22:17+08:00
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

前文[1](1)MVVM架构设计，我们使用的是ChangeNotifier+ChangeNotifierProvider组合，其实它们在flutter_riverpod 3.0.0版本中即将被移除；那Riverpod提供了哪些类型提供者呢？

Riverpod共提供了八种不同类型的提供者，都适用于不同的用例：

* Provider
* StateProvider:@Deprecated('Will be removed in 3.0.0'
* StateNotifierProvider：@Deprecated('Will be removed in 3.0.0')
* FutureProvider
* StreamProvider
* ChangeNotifierProvider：@Deprecated('Will be removed in 3.0.0')
* NotifierProvider:@Deprecated('Will be removed in 3.0.0')
* AsyncNotifierProvider

我们此次选用Notifier与NotifierProvider，大家体会下用法。

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
class UserViewModel extends Notifier<UserModel> {

  // ignore: empty_constructor_bodies
  void updateName(String newName) {
    state = state.copyWith(name:newName);
  }

  void updateAge(int newAge) {
    state = state.copyWith(age:newAge);
  }

  @override
  UserModel build() {
    return UserModel('', 0);
  }
}
//观察UserViewModel数据变化
final userViewModelProvider = NotifierProvider<UserViewModel,UserModel>( UserViewModel.new);

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
          Text('viewModel:${userViewModel}'),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                //ref.read(userViewModelProvider).updateName('kk');
                ref.read(userViewModelProvider.notifier).updateName('kksnow');
              },
              child: const Text('更新姓名')),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                //ref.read(userViewModelProvider).updateAge(userViewModel.userModel.age + 1);
                //userViewModel.updateAge(1+ userViewModel.userModel.age);
                ref.read(userViewModelProvider.notifier).updateAge(userViewModel.age + 1);
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
![image](/images/flutter/flutter架构设计MVVM之flutter_riverpod方案_Notifier+NotifierProvider/result.png)

### 6.分析与小结
#### 调整
* 实际上只有user_view_model.dart与user_model_page.dart略微有所调整，其实变化不大。
* 为什么Notifier与NotifierProvider将要过期被移除呢？新的方式做的升级，采用注解的方式，既能精简代码，又能提升性能；后面再作演示。

