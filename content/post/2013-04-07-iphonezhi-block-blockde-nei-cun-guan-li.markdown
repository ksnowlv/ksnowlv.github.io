---
title: "iPhone之block_block的内存管理"
date: 2013-04-07
lastmod: 2013-04-07
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


   除了上文提到的C语言中块的`Block_copy`，`Block_release`和`Objective-c`的块`copy`，`release`，`autorelease`等简单内存管理，还有一些更为复杂的规则。
     
   如果一个块引用 了一个对象，那么会保存一个对象的变量，当复制该块时，会保留该对；而释放该块时，也会释放该对象。
`   （注意：当复制引用了__block变量的一个块时，__block变量中保存的对象是不会保留的。同样注意静态变量）`
 
 
 注意以下规则，

* 1.要复制的块中对于self的直接引用，会导致self被保留。
* 2.要复制的块中对一个对象的实例变量的引用（直接的或通过一个访问器方法），会导致self被保留。
* 3.方法中对本地变量中保存的一个对象的引用，会导致该 对象而不是self被保留。
    
    当复制一个块时，应该小心。如果复制该块的代码位于一个方法内部，并且该块引用对象的任何实例变量，则复制该块时会导致self被保留。很容易建立一个保留循环，阻止对象被正常销毁。

