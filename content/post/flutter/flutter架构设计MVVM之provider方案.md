---
title: "flutter架构设计MVVM之provider方案"
date: 2024-03-30T22:55:14+08:00
lastmod: 2024-03-30T22:55:14+08:00
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

## Flutter架构设计MVVM-Provider


Flutter中，MVVM架构的实现，可以通过使用ChangeNotifierProvider或者Consumer、Selector等其他与Provider包相关的Widget来实现。

这些Widget可以帮助你在页面级别管理状态，而不需要将状态提升到整个应用级别。

下面一个简单的例子，展示如何在一个普通的页面中使用MVVM架构;
目录结构如下

user \
--model \
-----user.dart \
--page_route \
-----user_page_route.dart \
--view \
-----user_page.dart \
--view_models \
-----user_view_model.dart 

### 1.Model

* user.dart

```dart
class User {
  String name = '';
  int age = 0;

  User(this.name, this.age);
}


```

### 2.ViewModel

* user_view_model.dart

```dart
import 'package:base_demo/pages/mine/user/model/user.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {

  User? _user;
  User? get user => _user;

  void loadUser() {
    _user = User('ksnowlv', 10);
    notifyListeners();
  }

  void increaseUserAge() {
    _user?.age++;
    // 通知视图(user interface)更新
    notifyListeners();
  }

   void decreaseUserAge() {
    _user?.age--;
    // 通知视图(user interface)更新
    notifyListeners();
  }

  void updateUserName(String name) {
    _user?.name = name;
    // 通知视图(user interface)更新
    notifyListeners();
  }
}
```

### 3.View

* user_page.dart

我们创建user_page页面视图，它的主要操作如下

* 当用户点击加载用户数据按钮时，它会通过UserViewModel加载User中的姓名和年龄的数据，并通知视图更新显示。
* 当点击**年龄增加1岁**的按钮时，它会通过UserViewModel将User中的年龄加1，并通知视图更新显示。
* 当点击**年龄减小1岁**的按钮时，它会通过UserViewModel将User中的年龄减1，并通知视图更新显示。


```dart
import 'package:base_demo/pages/mine/user/view_models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mvvm'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: <Widget>[
              ElevatedButton(onPressed: () {
                var userViewModel = Provider.of<UserViewModel>(context, listen: false);
                userViewModel.loadUser();
              }, child: const Text('加载用户数据'), 
              ),

              Consumer<UserViewModel>(builder: (context, userViewModel, child) {

                return userViewModel.user != null ? 
                Column(
                  children: [
                    Text('name: ${userViewModel.user?.name}, age: ${userViewModel.user?.age}'),

                    const SizedBox(height: 20,), 
                    ElevatedButton(
                      onPressed: () => userViewModel.increaseUserAge(), 
                    child: const Text('年龄增加1岁')
                    ),
                       const SizedBox(height: 20,), 
                    ElevatedButton(onPressed: () => userViewModel.decreaseUserAge(), 
                    child: const Text('年龄减小1岁')
                    ),
                  ],
                  
                 ): const Text('用户数据为空，没有加载成功');
                
              },),
            ]
            ),
      ),
    );
  }
}

```

### 4.页面中绑定 ViewModel

* user_page_route.dart

使用ChangeNotifierProvider来在页面级别提供UserViewModel的实例，这样页面的View就可以直接访问和修改ViewModel中的数据了

```dart
import 'package:base_demo/pages/mine/user/view/user_page.dart';
import 'package:base_demo/pages/mine/user/view_models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
    
class UserPageRoute extends StatelessWidget {

  const UserPageRoute({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: const UserPage(),
      );
  }
}

```

这样UserPageRoute可以在任意合适的时间进行展示，可以实现状态管理在单个页面内部就可以完成；保持代码模块化，清晰性。

### 5.效果
![image](/images/flutter/flutter架构设计MVVM之provider方案/result.png)