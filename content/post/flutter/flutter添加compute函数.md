---
title: "Flutter添加compute函数"
date: 2024-03-21T14:26:49+08:00
lastmod: 2024-03-21T14:26:49+08:00
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


### 1.Flutter compute函数

compute函数是一个用于在后台Isolate中执行计算密集型任务的便捷方式。

Flutter中，UI操作都在主Isolate中执行，为了避免在主线程中执行耗时的计算或处理大量数据，可以使用compute函数将计算任务移交给后台Isolate执行，以保持应用程序的响应性。

* compute函数的语法如下：

        Future<R> compute<Q, R>(R Function(Q message) function, Q message)

* 其中：

  * function: 在后台Isolate中执行的计算密集型任务的函数。
  * message: 传递给function函数的参数。

### 2.compute基本用法

```Dart
//
int sumResult(final int n) {
  int sum = 0;
  for (int i = 0; i < n; ++i) {
    sum += i;
  }
  return sum;
}


//调用
int res = await compute(sumResult, 100000);


```


### 3.compute使用闭包形式传递参数

```Dart
    int res = await compute((final int n) {
    int sum = 0;
    for (int i = 0; i < n; ++i) {
      sum += i;
    }
    return sum;
  }, 100000);


```

### 4.compute并行计算


```Dart
  Future<int> parallelCompute() async {
  final results = await Future.wait([
    compute(sumResult, 30000),
    compute(sumResult, 30000),
    compute(sumResult, 30000),
    compute(sumResult, 10000),
  ]);

  int sum = 0;
  for (var result in results) {
    sum += result;
  }

  return sum;
}
```

### 5.完整示例代码

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComputeWidget extends StatefulWidget {
  const ComputeWidget({super.key});

  @override
  ComputeWidgetState createState() => ComputeWidgetState();
}

class ComputeWidgetState extends State<ComputeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            
            onPressed: () async {
               DateTime startTime = DateTime.now();
               int res = await compute(sumResult, 100000);
              Duration timeDifference = DateTime.now().difference(startTime);
              debugPrint('使用单个计算函数 1~100000 total:$res, timecost:$timeDifference');
            },
            child: const Text('compute函数:使用单个计算函数')),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () async {
              DateTime startTime = DateTime.now();
              int res = await compute((final int n) {
                int sum = 0;
                for (int i = 0; i < n; ++i) {
                  sum += i;
                }
                return sum;
              }, 100000);
              Duration timeDifference = DateTime.now().difference(startTime);

              debugPrint('使用闭包形式传递参数 1~100000 total:$res  timecost:$timeDifference');
            },
            child: const Text('compute函数:使用闭包形式传递参数')),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () async {
              DateTime startTime = DateTime.now();
              int res = await parallelCompute();
              Duration timeDifference = DateTime.now().difference(startTime);
              debugPrint('使用compute进行并行计算 1~100000 total:$res timecost:$timeDifference');
            },
            child: const Text('compute函数:使用compute进行并行计算')),
      ],
    );
  }

  Future<int> parallelCompute() async {
    final results = await Future.wait([
      compute(sumResult, 30000),
      compute(sumResult, 30000),
      compute(sumResult, 30000),
      compute(sumResult, 10000),
    ]);

    int sum = 0;
    for (var result in results) {
      sum += result;
    }

    return sum;
  }
}

int sumResult(final int n) {
  int sum = 0;
  for (int i = 0; i < n; ++i) {
    sum += i;
  }
  return sum;
}

```


### 6.效果

```shell
flutter: 使用单个计算函数 1~100000 total:4999950000, timecost:0:00:00.185042
flutter: 使用闭包形式传递参数 1~100000 total:4999950000  timecost:0:00:00.162817
flutter: 使用compute进行并行计算 1~100000 total:1399950000 timecost:0:00:00.526195
flutter: 使用单个计算函数 1~100000 total:4999950000, timecost:0:00:00.178511
flutter: 使用闭包形式传递参数 1~100000 total:4999950000  timecost:0:00:00.168732
flutter: 使用compute进行并行计算 1~100000 total:1399950000 timecost:0:00:00.546384
```
从以上可以看出，并行计算耗时较长；并非是比直接运行较快，可以思考下原因。

### 7.小结

* compute适用场景
  * 适用于计算密集型任务，对于I/O密集型任务，使用 async 和 await 通常更合适。
* compute和UI线程通信‘
  * 该函数在isolate中执行，因此不能直接访问UI线程中的变量或调用UI相关的函数。如果需要更新UI，必须使用 setState。
* compute使用限制
  * 由于isolate的创建和销毁有一定的开销，对于非常短的计算任务，使用compute可能不是最佳选择。
  * 确保你的应用是支持 isolate 的（例如，不是在 Web 或 macOS 上运行）。




