---
title: "Flutter如何添加弹出菜单-PopupMenuButton"
date: 2024-04-22T10:43:01+08:00
lastmod: 2024-04-22T10:43:01+08:00
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


### 1.PopupMenuButton简介
它是Flutter中的一个组件，用户通过点击按钮，打开一个弹出菜单。这个菜单通常包含一系列的选项

它有以下主要属性

* onSelected: 当用户选择一个菜单项时，会触发这个回调函数。
* itemBuilder: 返回一个列表，每个列表项都是一个 PopupMenuItem。

* offset: 弹出菜单的偏移量。
* elevation: 弹出菜单的阴影深度。
* color: 弹出菜单的背景颜色。
* shape: 弹出菜单的形状。
* actions: 一个包含 PopupMenuAction 对象的列表，可以用来添加自定义的菜单项。



### 2.示例

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

```dart
  List<PopupMenuEntry<String>> _buildPopupMenuItems(BuildContext context) {
      return menuItems.map((ItemModel item) {
        return PopupMenuItem<String>(
          value: item.title,
          child: Row(
            children: <Widget>[
              Icon(
                item.icon,
                size: 20,
                color: Colors.white,
              ),
              Container(
                margin: const EdgeInsets.only(top: 2, left: 10),
                child: Text(
                  item.title,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList();
    }
```

#### 3.3 自定义菜单小部件

通过menuBuilder构建菜单，通过pressType指定触发菜单显示的方式，通过padding，constraints，decoration控制UI展示

```dart

  PopupMenuButton(
    shadowColor: const Color(0xff98e165),
    color: const Color(0xFF4C4C4C),
    onSelected: (value) {
      debugPrint('PopupMenuButton selected:$value');
    },
    itemBuilder: (context) => _buildPopupMenuItems(context),
    onOpened: () {
      debugPrint('PopupMenuButton onOpened');
    },
    child: const Text('测试PopupMenuButton'),
  )

```

### 4.效果

![image](/images/flutter/flutter如何添加弹出菜单-PopupMenuButton/result.png)

### 5.小结

上述菜单属于很常见的一种自定义菜单,停在PopupMenuButton上，会有提示;如下图

![image](/images/flutter/flutter如何添加弹出菜单-PopupMenuButton/result1.png)
