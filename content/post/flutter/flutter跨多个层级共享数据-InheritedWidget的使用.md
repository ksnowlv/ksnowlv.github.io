---
title: "Flutter跨多个层级共享数据 InheritedWidget的使用"
date: 2024-04-02T16:57:43+08:00
lastmod: 2024-04-02T16:57:43+08:00
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

### InheritedWidget的使用

**InheritedWidget**是**Flutter**中非常重要的一个功能型组件，它提供了一种在widget树中从上到下共享数据的方式。

比如，在应用的根**widget**中通过**InheritedWidget**共享了数据，那么我们便可以在任意子widget中来获取该共享的数据！

像Flutter SDK中正是通过**InheritedWidget**来共享应用主题**Theme**和 **Locale** (当前语言环境)信息的。


### 示例

```dart
import 'package:flutter/material.dart';

class SharedDataWidget extends InheritedWidget {
  final String data;

  const SharedDataWidget(this.data, {super.key, required super.child});

  static SharedDataWidget of(BuildContext context) {
    // return context.dependOnInheritedWidgetOfExactType<SharedDataWidget>();
    final element =
        context.getElementForInheritedWidgetOfExactType<SharedDataWidget>()!;
    return element.widget as SharedDataWidget;
  }

  @override
  bool updateShouldNotify(SharedDataWidget oldWidget) {
    debugPrint('SharedDataWidget data: $data, old data: ${oldWidget.data}');
    return data != oldWidget.data;
  }
}

class InheritedDemoWidget extends StatelessWidget {
  const InheritedDemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedDataWidget =
        context.dependOnInheritedWidgetOfExactType<SharedDataWidget>();
    final data = sharedDataWidget?.data;

    debugPrint('InheritedDemoWidget data:$data');
    return Text('data:$data');
  }
}

class MyInheritedWidgetProvider extends StatefulWidget {
  final Widget child;

  const MyInheritedWidgetProvider({super.key, required this.child});

  static MyInheritedWidgetProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<MyInheritedWidgetProviderState>()!;
  }

  @override
  MyInheritedWidgetProviderState createState() =>
      MyInheritedWidgetProviderState();
}

class MyInheritedWidgetProviderState extends State<MyInheritedWidgetProvider> {
  String data = 'hello';
  int count = 0;

  void updateData(String newData) {
    setState(() {
      ++count;
      data = 'newData $count';
      debugPrint('MyInheritedWidgetProvider updateData data:$data');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SharedDataWidget(data, child: widget.child);
  }
}

class InheritedContainerWidget extends StatelessWidget {
  const InheritedContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidgetProvider(child: Builder(
      builder: (context) {
        return Column(
          children: [
            const InheritedDemoWidget(),
            ElevatedButton(
                onPressed: () {
                  MyInheritedWidgetProvider.of(context)
                      .updateData('I am a new data');
                },
                child: const Text('更新SharedDataWidget中的数据')),
          ],
        );
      },
    ));
  }
}

```

### 效果

![image](/images/flutter/flutter跨多个层级共享数据-InheritedWidget的使用/result.png)

### 小结

上述代码展示了如何在**Flutter**中使用**InheritedWidge**t来实现跨多个Widget层级的数据共享和响应式更新。

具体来说，它通过创建一个自定义的SharedDataWidget来传递和更新数据，同时使用MyInheritedWidgetProvider作为数据提供者，以及InheritedDemoWidget作为数据消费者。

#### 组件说明

* SharedDataWidget
  * 这是一个自定义的InheritedWidget，它保存了一个字符串类型的数据。它提供了一个静态方法of，允许任何依赖于它的Widget获取当前的数据。
* InheritedDemoWidget
  * 这个无状态的Widget用于展示从SharedDataWidget获取的数据。它通过context.dependOnInheritedWidgetOfExactType监听SharedDataWidget的变化，并在数据更新时重建自身。
  * 请注意，dependOnInheritedWidgetOfExactType方法需要在Widget的build方法中被调用，这样才能确保在依赖的数据变化时触发重建。如果使用final data = SharedDataWidget.of(context).data;是收不到SharedDataWidget数据变化的通知的
  * 此外，我们使用了非空断言!来确保data不为null，因为在SharedDataWidget中data是初始化为非null的。

现在，当MyInheritedWidgetProvider中的数据被更新时，InheritedDemoWidget将会收到通知并重建

* MyInheritedWidgetProvider
  * 这是一个StatefulWidget，它创建了一个SharedDataWidget实例，并将数据传递给它。它的updateData方法允许外部代码更新共享的数据，同时通过setState触发重建。

* InheritedContainerWidget
  * 这个无状态的Widget使用MyInheritedWidgetProvider来包裹它的子Widget，并提供了一个ElevatedButton，当按下时，会调用MyInheritedWidgetProvider.of(context).updateData来更新共享的数据。

#### 工作原理

* 数据提供: MyInheritedWidgetProvider作为数据提供者，它创建了一个SharedDataWidget实例，并将自身的data属性传递给它。
* 数据传递: SharedDataWidget作为InheritedWidget，会将它的数据沿着Widget树向下传递给所有的后代Widget。
* 数据监听: InheritedDemoWidget通过dependOnInheritedWidgetOfExactType监听SharedDataWidget的变化。当SharedDataWidget的数据发生变化时，InheritedDemoWidget会收到通知并重建，从而展示新的数据。
* 数据更新: 用户通过点击InheritedContainerWidget中的ElevatedButton来触发数据更新。MyInheritedWidgetProvider的updateData方法会被调用，并更新其内部的data属性。这会通过setState触发MyInheritedWidgetProvider和所有依赖于它的SharedDataWidget（以及进一步传递给依赖于SharedDataWidget的Widget）的重建。

#### 使用场景

这种模式适用于需要在多个Widget之间共享数据，而这些Widget不在同一个StatefulWidget的直接子级中的情况。例如，你可能有一个主题颜色或者用户数据，像登陆状态，需要在应用的多个部分中使用，但又不想把这些数据作为参数在Widget之间手动传递。使用InheritedWidget可以简化这个过程，并保持Widget树的清晰和可维护性。