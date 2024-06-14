---
title: "Flutter关于ObjectKey的使用场景"
date: 2024-05-18T20:10:38+08:00
lastmod: 2024-05-18T20:10:38+08:00
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


### 1.ObjectKey的使用


Flutter中的`ObjectKey` 标识`Widget`树中各个节点的对象，它是`Key `类的一种特殊实现。与 `UniqueKey` 和 `ValueKey` 不同，`ObjectKey` 在创建时需要指定一个对象作为标识符，而不是依赖于随机生成的唯一标识符或特定的值。

`ObjectKey` 的主要应用场景,是在需要根据不同对象的特定属性来确保 `Widget` 的状态正确性时。

使用 `ObjectKey` 的应用场景：

* 1.在动态列表中保留状态
* 当你需要在动态列表中保留每个节点的状态，并且节点的状态是根据节点所包含的对象属性来确定的时候，可以使用 `ObjectKey` 来确保每个节点都能正确地保留其状态。

2.管理具有唯一对象的 Widget
需要在页面切换或数据更新时,管理一组唯一对象对应的 `Widget`，使用`ObjectKey` ,确保在切换页面或更新数据时,能正确定位到对应的`Widget`。


### 2.示例

```dart

class _ObjectkeyPageState extends State<ObjectkeyPage> {
  List<ObjectItem> objectItemList = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 100; i++) {
      objectItemList.add(ObjectItem(id: i, name: 'list Item $i'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: ListView.builder(
        itemCount: objectItemList.length,
        itemBuilder: (context, index) {
          final object = objectItemList[index];
          return Card(
            key: ObjectKey(object), // 使用对象的属性作为ObjectKey
            child: ListTile(
              title: Text(object.name),
              trailing:IconButton(
                icon:const Icon(Icons.edit),
                onPressed:() {
                  _updateObject(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateObject(int index) {

    setState(() {
      objectItemList[index] = ObjectItem(id: index, name: 'updated Item $index');
    });
  }
}

class ObjectItem {
  final int id;
  final String name;

  ObjectItem({required this.id, required this.name});
}

```



### 3.总结

#### 3.1. ObjectKey的主要优点

它能够根据指定的对象作为标识符来确保 `Widget` 在动态列表中的正确性和一致性。

* 1.保持对象的一致性
  * `ObjectKey` 根据对象来创建的，当对象保持不变时，`ObjectKey` 保持不变。如果对象没有改变，`Flutter`将正确地识别和定位到对象对应的列表项，从而确保列表项的状态和位置保持一致。

* 2.适用于复杂对象
  * 对于包含复杂属性和关联数据的对象，使用 `ObjectKey` 可以确保在更新或删除列表项时能够正确地根据对象属性来识别和定位到相应的列表项，而不需要额外的手动管理。

* 3.内存优化
  * 当使用 `ObjectKey` 时，`Flutter`可以通过比较对象的标识符,确定是否对应的`Widget`需要更新，从而提高处理性能,并减少不必要的重建.

#### 3.2. _updateObject 刷新的是单个对象，还是一组对象？如果想刷新某个列表项呢？如何做呢？
