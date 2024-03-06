---
title: "Flutter Do Not Use BuildContexts Across Async Gaps"
date: 2024-03-05T16:50:39+08:00
lastmod: 2024-03-05T16:50:39+08:00
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

### 1.问题

flutter在使用新版本时，遇见

    Don't use 'BuildContext's across async gaps.\nTry rewriting the code to not use the 'BuildContext', or guard the use with a 'mounted' check

的问题。

这意味着在异步操作之后不应该再使用 BuildContext

因为提供该上下文的widget可能已经不在widget树中。如果你尝试访问它的上下文或者在其中进行路由，可能会导致潜在的错误或者崩溃。

### 2.解决方案

检查mounted的属性

对于Widget而言

```dart

void _onButtonPressed(BuildContext context) async {
  final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const DetailPage(
            data: 'Hello from PageOne',
          )));

  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('receive result:$result')),
  );
}
```