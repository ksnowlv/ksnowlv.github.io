---
title: "Flutter关于uniqueKey的使用"
date: 2024-05-17T18:41:39+08:00
lastmod: 2024-05-17T18:41:39+08:00
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


### 1.uniqueKey的使用

在 Flutter 中，UniqueKey是Key的一个特殊子类，它可以在创建时生成一个全局唯一的标识符。

它有哪些使用场景呢？

#### 1.动态列表中的元素标识
当你需要在ListView、GridView 或其他页面中添加、删除或更新元素时，使用 UniqueKey 可以确保每个元素都具有唯一的标识符。

#### 2.路由跳转时的页面标识
使用 UniqueKey 可以确保每次路由跳转都创建一个新的页面实例，而不是重复使用之前的页面，这样能够保持页面状态的独立性。


### 示例

```dart
class UniqueKeyPage extends StatefulWidget {
  const UniqueKeyPage({super.key});

  @override
  State<UniqueKeyPage> createState() => _UniqueKeyPageState();
}

class _UniqueKeyPageState extends State<UniqueKeyPage> {

  var  _uniqueKey = UniqueKey();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(child:  Column(
        children: [
          const Text('使用 UniqueKey 更新的 Widget'), 
          const SizedBox(height: 30,), 
          ElevatedButton(
            onPressed: () {
              setState(() {
                  _uniqueKey = UniqueKey();
              });
            
            }, 
            child: const Text('更新 Widget')),

            const SizedBox(height: 30,),  

            UniqueKeyDemoWidget(key: _uniqueKey),
        ],
      ),
    ));
  }
}

class UniqueKeyDemoWidget extends StatelessWidget {
  const UniqueKeyDemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('UniqueKeyDemoWidget build');
    return Container(
      width: 200,
      height: 200,
      color: Colors.blue,
      child: const Center(
        child: Text('UniqueKey 示例 Widget'),
      ),
    );
  }
}
```

在上述示例中，UniqueKey用于标识 Widget 的唯一性，它的主要作用是在动态添加、移除 Widget 时，确保每个 Widget 都有一个唯一的标识。

### 3.其它

UniqueKey在构建一些需要动态更新布局的场景中特别有用，
比如列表项的增删操作，并且也可以帮助避免一些因为 Widget 重复使用而导致的问题。
