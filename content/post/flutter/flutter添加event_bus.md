---
title: "Flutter添加event_bus"
date: 2024-03-15T22:33:29+08:00
lastmod: 2024-03-15T22:33:29+08:00
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

### 1.添加flutter event_bus

官方链接见[event_bus](https://pub-web.flutter-io.cn/packages/event_bus)

**pubspec.yaml**添加**event_bus**依赖

```yaml
  event_bus: ^2.0.0

```

### 2.示例

```dart
import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';

class CounterEvent {
  int count;

  CounterEvent(this.count);
}

class EventBusWidget extends StatefulWidget {
  const EventBusWidget({super.key});

  @override
  EventBusWidgetState createState() => EventBusWidgetState();
}

class EventBusWidgetState extends State<EventBusWidget> {
  int _counter = 0;
  final eventBus = EventBus();

  @override
  void initState() {
    super.initState();
    eventBus.on<CounterEvent>().listen((event) {
      setState(() {
        _counter = event.count;
      });
    });
  }

  @override
  void dispose() {
    eventBus.destroy();
    super.dispose();
  }

  void _incrementCounter() {
    _counter++;
    eventBus.fire(CounterEvent(_counter));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('the counter value is'),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        ElevatedButton(
            onPressed: () {
              _incrementCounter();
            },
            child: const Text('增加计数counter'))
      ],
    );
  }
}

```

