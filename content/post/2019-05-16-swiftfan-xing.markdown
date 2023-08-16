---
title: "swift泛型"
date: 2019-05-16
lastmod: 2019-05-16
categories:
  - "swift"
tags:
  - "泛型"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---






```swift

/// 交换两个对象的值
///
/// - Parameters:
///   - aValue: 对象a
///   - bValue: 对象b
func swapValues<T>(_ aValue: inout T, _ bValue: inout T) {
    let temp = aValue
    aValue = bValue
    bValue = temp
}

/// 栈模板
struct QStack<T> {
    
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T {
        return self.items.removeLast()
    }
    
    func isEmpty() -> Bool {
       return (0 == self.items.count)
    }
    
    var count: Int {
        return self.items.count
    }
    
    subscript(i: Int) -> T {
        return self.items[i]
    }
}

```



