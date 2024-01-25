---
title: "Swift预编译宏添加"
date: 2023-06-26T13:53:02+13:00
lastmod: 2023-06-26T13:53:02+13:00
keywords: ["Swift", "iOS"]
tags: ["Swift", "iOS"]
categories: ["Swift","iOS"]

comment: true
toc: true
autoCollapseToc: true
reward: true

---


### 1.swift预编译宏添加

在Xcode中，项目的build Settings，搜索 Swift Compiler，选择Other Swift Flags，添加环境变量。注意添加 -D参数.

<!--more-->
![image](/images/post/swift预编译宏添加/build-setting.png)

### 2.swift预编译宏示例代码

```swift

static func printFunctionSignature(functionName: String = #function, fileName: String = #file, line: Int = #line, column: Int = #column) {
#if DEBUGLOG
  print("---工程名---:函数签名: \(functionName) 在 \(fileName) 的第 \(line) 行第 \(column) 列")
#elseif RELEASE
  //
#endif
}
```
