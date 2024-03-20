---
title: "Flutter添加状态管理库get"
date: 2024-03-20T10:22:07+08:00
lastmod: 2024-03-20T10:22:07+08:00
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

## get 的使用

### 1.get

官方链接见[https://pub-web.flutter-io.cn/packages/photo_view](https://pub-web.flutter-io.cn/packages/photo_view)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
  get: ^4.6.6
```

### 3.示例

* main.dart

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return const GetMaterialApp(
      title: 'GetX demo',
      home: HomePage(title: 'home page'),
    );
  }
}
```

* GetxWidget.dart

```dart
import 'package:base_demo/widgets/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetxWidget extends StatefulWidget {
  const GetxWidget({Key? key}) : super(key: key);

  @override
  GetxWidgetState createState() => GetxWidgetState();
}

class GetxWidgetState extends State<GetxWidget> {
  final CounterController counterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => Text('点击了${counterController.counter.value}次')),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              counterController.increment();
            },
            child: const Text('+')),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              counterController.decrement();
            },
            child: const Text('+')
            ),

            ElevatedButton(onPressed: () {

              Get.to(() => const DetailPage(data: 'getx widget'), arguments: '参数传递');

            }, child: const Text('跳转详情页面'))
      ],
    );
  }
}

// 控制器类，用于管理计数器状态
class CounterController extends GetxController {
  var counter = 0.obs; // 通过obs将变量变为响应式变量

  void increment() {
    counter.value++; // 使用.value来访问obs变量的值
  }

  void decrement() {
    counter.value--; // 使用.value来访问obs变量的值
  }
}

```

* DetailPage.dart

```dart
import 'package:flutter/material.dart';
    
class DetailPage extends StatelessWidget {

 final String data;

const DetailPage({ super.key, required this.data});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pages'),
      ),
      body: Center(
        child: Column(

         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          const Text('received data'),
          Text(data),
          ElevatedButton(
            onPressed: () {

              Navigator.pop(context, 'Hello from DetailsPage');

            } , 
            child: const Text('go back'))
         ],   
        ),
      ),
    );
  }
}
```

### 4.效果

```shell
[GETX] Instance "GetMaterialController" has been created
[GETX] Instance "GetMaterialController" has been initialized
[GETX] Instance "CounterController" has been created
[GETX] Instance "CounterController" has been initialized
[GETX] CLOSE TO ROUTE /DetailPage
[GETX] GOING TO ROUTE /DetailPage
[GETX] CLOSE TO ROUTE /DetailPage
[GETX] GOING TO ROUTE /DetailPage
[GETX] CLOSE TO ROUTE /DetailPage
```