---
title: "Flutter如何添加自定义弹出菜单 CustomPopupMenu"
date: 2024-04-22T09:46:19+08:00
lastmod: 2024-04-22T09:46:19+08:00
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



### 1.CustomPopupMenu

官方链接见[https://pub-web.flutter-io.cn/packages/CustomPopupMenu](https://pub-web.flutter-io.cn/packages/CustomPopupMenu)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
  custom_pop_up_menu: ^1.2.4
```

### 3.示例

#### 3.1 定义菜单项

```dart
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
List<ItemModel> menuItems = [
  ItemModel('复制', Icons.content_copy),
  ItemModel('粘贴', Icons.content_paste),
  ItemModel('转发', Icons.send),
  ItemModel('收藏', Icons.collections),
  ItemModel('删除', Icons.delete),
  ItemModel('分享', Icons.share),
  ItemModel('搜索', Icons.search),
];

```

#### 3.2 生成单击触发菜单
ClipRRect包裹的Container，它包含一个GridView，用来展示菜单项；菜单项通过GridView中menuItems列表构建的，每个菜单项都是Column包裹的Icon和Text；

```dart
 Widget _buildSingleClickMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 220,
        color: const Color(0xFF4C4C4C),
        child: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          crossAxisCount: 4,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: menuItems
              .map((item) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 20,
                        color: Colors.white,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: Text(
                          item.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
```

#### 3.3 自定义菜单小部件

通过menuBuilder构建菜单，通过pressType指定触发菜单显示的方式，通过padding，constraints，decoration控制UI展示

```dart

    CustomPopupMenu(
      menuBuilder: _buildSingleClickMenu,
      pressType: PressType.singleClick,
      child: Container(
        padding: const EdgeInsets.all(15),
        constraints: const BoxConstraints(
            minWidth: 50, maxWidth: 240, minHeight: 50),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 204, 101, 225),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: const Text('测试CustomPopupMenu'),
      ),
    ),
```



### 4.效果

![image](/images/flutter/flutter如何添加弹出菜单-CustomPopupMenu/result1.png)

### 5.小结

* 上述菜单也可由长按触发，属于很常见的一种自定义菜单。