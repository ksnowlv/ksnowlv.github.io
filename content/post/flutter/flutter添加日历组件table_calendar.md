---
title: "Flutter添加日历组件table_calendar"
date: 2024-03-09T22:50:54+08:00
lastmod: 2024-03-09T22:50:54+08:00
keywords: ["flutter", "table_calendar"]
tags: ["flutter"]
categories: ["flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1.添加table_calendar库

[table_calendar库](https://github.com/aleksanderwozniak/table_calendar)当前最新版本为3.1.0

pubspec.yaml添加依赖3.1.0

```yaml
dependencies:
  table_calendar: ^3.1.0
```

### 2.table_calendar简单使用

```dart
import 'package:base_demo/common/logger.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreenPage extends StatefulWidget {
  const CalendarScreenPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  CalendarScreenPageState createState() => CalendarScreenPageState();
}

class CalendarScreenPageState extends State<CalendarScreenPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Selector'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 1, 1),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,

        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
            XLogger.getLogger().d('您选择的日期:$_selectedDay, 当前焦点日期:$_focusedDay');
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
            XLogger.getLogger().d('当前日历格式:$_calendarFormat');
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          XLogger.getLogger().d('当前焦点日期:$_focusedDay');
        },
      ),
    );
  }
}


```

### 3.效果

![image](/images/flutter/flutter添加日历组件table_calendar/overview.png)