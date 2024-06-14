---
title: "Flutter关于ValueKey的使用场景"
date: 2024-05-18T18:17:32+08:00
lastmod: 2024-05-18T18:17:32+08:00
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


### 1.ValueKey的使用


在 Flutter 中，`ValueKey`用于标识`Widget`树中各个节点的对象，它是`Key`类的一种特殊实现。与`UniqueKey` 不同，`ValueKey `是根据给定的值来创建的，而不是根据随机生成的唯一标识符。

ValueKey有哪些使用场景呢？

* 1.保留列表项的状态
  * 一个动态列表中，其中的元素根据某个唯一标识来进行更新和定位时，可以使用 ValueKey来确保某个值对应的列表项保留其状态。

* 2.管理具有唯一标识的对象
  * 在涉及具有唯一标识的对象（如获取数据库中的数据、网络请求结果等）的应用中，可以使用 ValueKey 来标识这些对象，并在 UI 中进行正确的映射和更新。

* 3.动态路由场景下的页面标识
  * 在某些情况下，你可能希望使用特定的值来标识不同的路由页面，以确保在路由跳转和页面更新时能够保持正确的页面状态。



### 示例
使用 ValueKey 只需要创建一个对应的对象，然后将其作为 ValueKey 的参数传递进去。下面是一个示例，演示了如何在 Flutter 中使用 ValueKey：

```dart
class _ValuekeyPageState extends State<ValuekeyPage> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: ValueKey(item),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      setState(() {
                        _removeItem(index);
                      });
                    },
                    child: ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _insertItem(index+1),
                      ),
                    ),
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: _addItem,
              child: const Icon(Icons.add),
            ),
          ],
        ));
  }

  void _addItem() {
    setState(() {
      items.add('New Item ${items.length + 1}');
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _insertItem(int index) {
    setState(() {
      items.insert(index, 'Inserted Item  ${items.length + 1}');
    });
  }
}
```

ValueKey 用于为 Dismissible组件指定一个唯一的标识。在这个示例中，每个项目的值被用作唯一标识，以确保在项目被删除或插入时能够正确地识别和定位到对应的项目。



### 3.总结

上文ValueKey的作用体现在以下几个方面：

* 1.Dismissible组件中，我们为每个元素指定了一个 ValueKey，这样在项目被滑动移除时，Flutter 可以根据项目的唯一标识来识别要移除的项目。
* 2.通过在状态管理的 addItem、removeItem 和 insertItem 方法中使用 setState 来更新 items 状态列表，以触发 UI 的重新构建和更新。

