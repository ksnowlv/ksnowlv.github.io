---
title: "Flutter如何添加轮播组件 Flutter_card_swiper"
date: 2024-05-03T20:32:55+08:00
lastmod: 2024-05-03T20:32:55+08:00
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



### 1.flutter_card_swiper

官方链接见[https://pub-web.flutter-io.cn/packages/flutter_card_swiper](https://pub-web.flutter-io.cn/packages/flutter_card_swiper)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
  flutter_card_swiper: ^7.0.0
```

### 3.使用示例

#### 3.1 定义轮播卡片

```dart

/*
 * CardView类定义了一个 StatelessWidget，用于构建一个带有卡片名称和图片的卡片视图。
 *
 * 参数:
 * - cardName: 卡片的名称，类型为 String，必需。
 * - imageUrl: 卡片图片的URL，类型为 String，必需。
 */
class CardView extends StatelessWidget {
  final String cardName;
  final String imageUrl;

  const CardView({super.key, required this.cardName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    //构建函数返回一个SingleChildScrollView，其中包含卡片的名称和图片。
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            cardName,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
          ),
          const SizedBox(height: 20),
          // 使用CachedNetworkImage展示网络图片，提供占位符和错误图标。
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}

```

#### 3.2 构造轮播视图

目标实现了一个卡片轮播视图，用户可以通过水平滑动来浏览不同的卡片。每张卡片包含文本和图片，图片和文本信息通过cardList这个列表构造而成。
```dart

class CardSwiperPage extends StatefulWidget {
  const CardSwiperPage({super.key});

  @override
  State<CardSwiperPage> createState() => _CardSwiperPageState();
}

class _CardSwiperPageState extends State<CardSwiperPage> {
  static const List<List<String>> cardList = [
    ['卡片 1', 'https://t7.baidu.com/it/u=2581522032,2615939966&fm=193&f=GIF'],
    ['卡片 2', 'https://t7.baidu.com/it/u=245883932,1750720125&fm=193&f=GIF'],
    ['卡片 3', 'https://t7.baidu.com/it/u=3241434606,2550606435&fm=193&f=GIF'],
    ['卡片 4', 'https://t7.baidu.com/it/u=826329656,2212580321&fm=193&f=GIF'],
    ['卡片 5', 'https://t7.baidu.com/it/u=1416385889,2308474651&fm=193&f=GIF']
  ];

  final CardSwiperController controller = CardSwiperController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CardSwiper(
                controller: controller,
                cardsCount: cardList.length,
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 4,
                backCardOffset: const Offset(20, 20),
                padding: const EdgeInsets.all(20.0),
                cardBuilder: (context, index, horizontalOffsetPercentage,
                    verticalOffsetPercentage) =>
                    CardView(
                        cardName: cardList[index][0],
                        imageUrl: cardList[index][1]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.right),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.top),
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.bottom),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) {
    debugPrint(
      '_onSwipe The card: previousIndex:$previousIndex, currentIndex: $currentIndex, direction${direction.name}',
    );
    return true;
  }

  bool _onUndo(
      int? previousIndex,
      int currentIndex,
      CardSwiperDirection direction,
      ) {
    debugPrint(
      '_onUndo The card: previousIndex:$previousIndex, currentIndex: $currentIndex, direction${direction.name}',
    );
    return true;
  }
}

```

主要代码介绍

* controller：是一个 CardSwiperController 对象，用于控制卡片滑动器的行为，如撤销滑动、执行滑动等。
* dispose 方法：当 CardSwiperPage 从小部件树中移除时，会调用此方法。它负责清理资源，如调用 controller.dispose() 来释放控制器资源。

* CardSwiper：是卡片滑动器的核心小部件，它接收以下参数：
  * controller：用于控制卡片滑动的控制器。
  * cardsCount：卡片的总数。
  * onSwipe：当卡片被滑动时调用的回调函数。
  * onUndo：当执行撤销操作时调用的回调函数。
  * numberOfCardsDisplayed：同时显示的卡片数量。
  * backCardOffset：背面卡片的偏移量。
  * padding：卡片的内边距。
  * cardBuilder：一个构建器回调，用于为每个卡片位置生成 Widget。

* _onSwipe 和 _onUndo 方法：这两个方法分别在卡片被滑动和撤销时调用。它们使用 debugPrint 来输出滑动和撤销操作的调试信息。
* 按钮区：包含四个FloatingActionButton，用于执行撤销操作和控制轮播视图向不同方向滑动。

### 4.效果

![image](/images/flutter/flutter如何添加轮播组件-flutter_card_swiper/result1.png)

![image](/images/flutter/flutter如何添加轮播组件-flutter_card_swiper/result2.png)

可以控制下方按钮区，观察下四个不同方向的轮播效果。

### 5.其它

如果要实现自动轮播效果呢？该组件自身虽然不支持，但是，我们可以启动Timer来实现。

