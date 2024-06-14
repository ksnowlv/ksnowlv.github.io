---
title: "Flutter绘图优化-Build方法耗时方面"
date: 2024-04-06T20:35:53+08:00
lastmod: 2024-04-06T20:35:53+08:00
keywords: ["Flutter"]
tags: ["Flutter"]
categories: ["Flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->




## 一.避免在build方法中进行重复且耗时的工作

因为当父widget重建时,子Widget的build()方法会被频繁地调用。

例如：
* build方法中执行耗时较长的任务。
  * 同步文件IO；
  * 同步网络IO；
  * 计算密集型任务；
  * 过深的UI嵌套；
  * 复杂的动画效果；
  * 等等。

## 二.避免在build方法中返回一个或多个过于庞大的widget

把它们分拆成不同的widget，并进行封装，调用：注意以下规则

### 慎用页面整体刷新，建议局部刷新，提升绘图性能。
当在State对象上调用setState时，所有子widget都将重建；因此，将setState的调用，转移到实际需要更新的widget子树，使用局部刷新widget来提升性能；避免在widget树的更高层级中，调用setState进行全部更新。

局部刷新有哪些方式呢？

* 1.setState 方法

  使用方式：在有状态的widget中，可以调用setState方法来通知Flutter框架在该widget状态发生变化时进行更新。
```dart
      setState(() {
      // 更新状态
      });
```
* 2.ValueNotifier 和 ValueListenableBuilder

  使用方式：使用ValueNotifier包装需要监听的值，在需要更新的地方使用ValueListenableBuilder监听数值的变化并进行局部刷新。

```dart

ValueNotifier<int> myValueNotifier = ValueNotifier<int>(0);

ValueListenableBuilder(
  valueListenable:myValueNotifier,
  builder:(context,value,child) {
    return MyWidget(value);
  },
);

```

* 3.StreamBuilder

使用方式：使用StreamBuilder监听流的变化，在流中有数据传入时进行局部刷新;可以监听单个流，可以监听多个流；

```dart

  Stream<dynamic> combinedStream() {
    return Stream<dynamic>.fromFutures([
      fetchUserInfo(),
      fetchUserOrders(),
      fetchUserTicket(),
      fetchUserCount(),
      fetchUserIsInBlack(),
    ]);
  }

  StreamBuilder<dynamic>(
      stream: combinedStream(),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint('data waiting:${snapshot.data}');
            
              return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
          } else {
              if (snapshot.hasData) {
                debugPrint('Data:${snapshot.data}');
                  if (snapshot.data is String) {
                    result += '\n${snapshot.data as String}';
                  } else if (snapshot.data is num) {
                   result += '\n${snapshot.data as num}';
                  } else if (snapshot.data is bool) {
                    result += '\n 黑名单:${snapshot.data as bool}';
                  }
              }
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text('data:$result'),
                  ElevatedButton(
                      onPressed: () {
                      setState(() {});
                      },
                      child: const Text('StreamBuilder重新加载~')
                  ),
              ],
              );
          }
      },
  ),

```
* 4.FutureBuilder

  使用方式：根据Future对象的不同状态来构建widget，它允许在Future完成后，自动触发局部刷新。

```dart
 FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('data waiting:${snapshot.data}');
        
        } else if (snapshot.hasError) {
          return Text('Error:${snapshot.error}');
        } else {
          return Text('Data:${snapshot.data}');
        }
      },
    )
```

* 5.AnimatedBuilder

使用方式：将AnimatedBuilder包裹需要执行动画的widget，在动画值变化时进行局部刷新。

```dart
  AnimatedBuilder(
    animation:animationController,
    builder:(context,child) {
      // 执行动画的UI
    },
  );
```

* 6.InheritedWidget/InheritedModel

* 使用方式：可以在widget树中共享数据，依赖于这些数据的widget会自动更新。

```dart
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


```

在 InheritedWidget的子Widget 中，你可以使用 of 方法来获取 InheritedWidget 的状态。当 InheritedWidget 的状态发生变化时，子 Widget 也会重新构建。


* 7.CustomPainter
  使用方式：在自定义绘制中，使用CustomPainter 来局部刷新。当绘制参数发生变化时，CustomPainter也会重新构建。

```dart
class MyCustomPainter extends CustomPainter {
  final double radius;

  MyCustomPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('size:$size, radius:$radius');
    final paint = Paint();
    paint.color = Colors.green;
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

```

* 8.使用key

使用方式：通过为widget设置key，在需要时重建。

```dart
 final Key buttonKey = UniqueKey();
  ElevatedButton(onPressed: () {}, key: buttonKey, child: const Text('ElevatedButton'),),
```


* 9.第三方库的支持

使用方式：如 riverpod 或 provider，getx，它们提供了更好的状态管理和局部刷新功能，不再赘述。

### widget中使用const构造组件。
### widget UI层级尽可能的减少。
### widget 懒加载和分页。
### 构建可复用的UI时，最好使用StatelessWidget，而不是函数。
### 处理高消耗操作时用 isolates。
### 列表中的重用。
特别是长列表，注意itemExtent 或 prototypeItem使用。

