---
title: "Flutter如何添加弹出菜单-popup_menu"
date: 2024-04-22T17:30:13+08:00
lastmod: 2024-04-22T17:30:13+08:00
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




### 1.popup_menu

官方链接见[https://pub-web.flutter-io.cn/packages/popup_menu](https://pub-web.flutter-io.cn/packages/popup_menu)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
  popup_menu: ^2.0.0
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

#### 3.2 构造并显示PopupMenu菜单

通过menuItems构造菜单项，调用PopupMenu构造方法，然后，通过PopupMenu的show方法显示菜单。

```dart
   void _showPopupMenu(BuildContext context) {
    
      List<MenuItem> popupMenuItems = menuItems.map((item) {
        return MenuItem(
            title: item.title,
            image: Icon(
              item.icon,
              size: 20,
              color: Colors.white,
            ),
            textStyle: const TextStyle(color: Colors.white, fontSize: 12));
      }).toList();
    
      final popupMenu = PopupMenu(
        items: popupMenuItems,
        onClickMenu: (MenuItemProvider item) {
          debugPrint('Selected:${item.menuTitle}');
        },
        onDismiss: () {
          debugPrint('Menu is dismissed');
        },
        context: context,
      );
      popupMenu.show(widgetKey: btnKey);
    }
```

其中为按钮的btnKey，声明如下

```dart
final GlobalKey btnKey = GlobalKey();

```

调用如下
```dart
   ElevatedButton(
        key: btnKey,
        onPressed: () => _showPopupMenu(context),
        child: const Text('显示popup_menu')
  )

```


### 4.效果

![image](/images/flutter/flutter如何添加弹出菜单-popup_menu/result.png)

选中菜单时，onClickMenu先触发，然后，调用onDismiss

```shell

flutter: Selected:粘贴
flutter: Menu is dismissed
flutter: Selected:转发
flutter: Menu is dismissed

```

### 5.其它

#### 5.1. 小结
    上述菜单,属于很常见的一种自定义菜单，效果通常可以满足一般使用，样式可简单定义。

#### 5.2 MenuConfig

关于PopupMenu菜单构造时，可以传递MenuConfig，可以调整菜单样式。其属性如下

```dart

  const MenuConfig({
    this.type = MenuType.grid,
    this.itemWidth = 72.0,
    this.itemHeight = 65.0,
    this.arrowHeight = 10.0,
    this.maxColumn = 4,
    this.backgroundColor = const Color(0xff232323),
    this.highlightColor = const Color(0xff353535),
    this.lineColor = const Color(0x55000000),
  });

```

* type： 默认格子（grid），还支持单列 （list）
* itemWidth、itemHeight: 菜单项宽度与高度
* arrowHeight：箭头的高度
* maxColumn：格子类型菜单最大列数
* backgroundColor：背景色
* highlightColor：点击的高亮色
* lineColor：分隔线的颜色



