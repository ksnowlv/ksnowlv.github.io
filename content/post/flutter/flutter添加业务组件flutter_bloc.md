---
title: "Flutter添加业务组件flutter_bloc"
date: 2024-03-19T19:10:49+08:00
lastmod: 2024-03-19T19:10:49+08:00
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




## flutter_bloc的使用

### 1.flutter_bloc

官方链接见[https://pub-web.flutter-io.cn/packages/flutter_bloc](https://pub-web.flutter-io.cn/packages/flutter_bloc)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
  flutter_bloc: ^8.1.4 
```

### 3.示例

* counter_cubit.dart

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(super.initialState);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);

}
```

* counter_widget.dart

```dart
import 'package:base_demo/bloc/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  CounterWidgetState createState() => CounterWidgetState();
}

class CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<CounterCubit>().increment();
          },
          child: const Text("点击+增加计数"),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<CounterCubit>().decrement();
          },
          child: const Text("点击-减少计数"),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Counter Value:',
            ),
            BlocBuilder<CounterCubit, int>(
              builder: (context, state) {
                return Text('$state');
              },
            ),
          ],
        ),
      ],
    );
  }
}

```


* counter_cubit.dart

```dart

class PageMine extends StatelessWidget {
  const PageMine({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(create:(context) => CounterCubit(0),
      child: const Center(child:  CounterWidget()),);
  }
}

```
### 4.小结

#### flutter_bloc核心组件：

* Bloc/ Cubit
  * Bloc 和 Cubit 是用于管理业务逻辑和状态的核心组件。它们负责处理业务逻辑，并将状态输出给 Flutter 组件进行显示。

* BlocProvider
  * BlocProvider 是用于在组件树中提供 Bloc 或 Cubit 实例的组件，可以让子组件通过 BlocProvider.of(context) 来获取所需的 Bloc 或 Cubit 实例。

* BlocBuilder和BlocListener
  * BlocBuilder 用于根据 Bloc 或 Cubit 的状态构建界面，而 BlocListener 则用于监听状态变化并执行一些副作用操作。

#### flutter_bloc使用步骤

* 创建业务逻辑组件(**Bloc或Cubit**）来管理应用程序的状态和业务逻辑。

* 界面组件中使用**BlocProvider**来提供业务逻辑组件的实例，并使用**BlocBuilder**或**BlocListener**来根据状态更新界面或执行副作用操作。

* 通过与界面组件的交互来触发事件，进而让业务逻辑组件更新状态，并通知界面组件进行相应的更新。


