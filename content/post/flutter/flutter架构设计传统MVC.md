---
title: "Flutter架构设计传统MVC"
date: 2024-04-06T08:51:46+08:00
lastmod: 2024-04-06T08:51:46+08:00
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

## Flutter架构设计MVC

尽管官方推荐使用 Model-View-Model (MVVM) 或provide设计等，因为它们提供了更好的状态管理和响应式更新。这些模式更适合 Flutter 的设计哲学和框架特性。
但是经典MVC，在Flutter中，如何实现呢？

### 1.Flutter MVC架构设计的基本示例：

* Model: 数据模型，记录用户数据或状态。
* View: 用户界面，View负责显示Model的状态，通常会包含逻辑来响应用户的输入。
* Controller:控件器，作为Model与View交互的中介，处理用户输入，并更新模型，并显示在视图中。

### 2.Model

```dart
class PersonInfo {
   String name = '';
   int age = 0;

  PersonInfo(this.name, this.age);
}
```

### 3.Controller

```dart

import 'package:base_demo/pages/mine/person/person_info.dart';

class PersonInfoController {
  late PersonInfo _model;

  PersonInfo get model => _model;

  PersonInfoController() {
    _model = PersonInfo('', 0);
  }

  void updateName(String name) {
    _model.name = name;
  }

  void decrement() {
    _model.age -= 1;
  }

  void increment() {
    _model.age += 1;
  }

  String personInfo () {
    return 'name: ${_model.name}, age: ${_model.age}';
  }

}

```

### 4.View

```dart
import 'package:base_demo/pages/mine/person/person_info_controller.dart';
import 'package:base_demo/pages/mine/person/person_info.dart';
import 'package:flutter/material.dart';

class PersonInfoView extends StatefulWidget {
  final PersonInfoController controller;

  const PersonInfoView({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() => _PersonInfoViewState();
}

class _PersonInfoViewState extends State<PersonInfoView> {
  late PersonInfoController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MVC'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('personInfo = ${_controller.personInfo()}'),
              ElevatedButton(
                onPressed: () => setState(() {
                  _controller.updateName('ksnowlv');
                }),
                child: const Text('name ksnowlv'),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _controller.increment();
                }),
                child: const Text('age Increment'),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _controller.decrement();
                }),
                child: const Text('age decrement'),
              ),
            ],
          ),
        ));
  }
}

```

### 5.效果

![image](/images/flutter/flutter架构设计传统MVC/result.png)


### 6.小结

#### 1.示例设计

* PersonInfo：作为模型，比较简单，提供的姓名，年龄，仅仅作演示。
* PersonInfoController：负责处理用户输入，并更新PersonInfo模型数据。
* PersonInfoView：作为视图，因需要能够响应用户的输入，并更新显示，所以是一个StatefulWidget；直接与UserController交互，以便数据变化时，更新视图状态；当视图有输入时，通过更新模型，进而更新视图显示。如果仅仅是展示数据，视图可以是StatelessWidget。

#### 2.推荐设计

Flutter社区更倾向于使用**MVVM**或**Provider**模式，因为它们提供了更好的状态管理和响应式更新。






