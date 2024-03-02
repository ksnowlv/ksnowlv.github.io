---
title: "Xcode之ObjC/all_load/force_load"
date: 2014-08-12
lastmod: 2014-08-12
categories:
  - "iOS"
tags:
  - "Xcode"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

## 一.应用场景
   在项目中，可能会使用多个第三方的库。
    
   如果使用-all_load选项，这会导致所有的类的方法都会被载入.
   <!--more-->
    
   不管“你的程序”有没有用到，所有的，包括系统的，方法会被载入,
    
   这不仅导致目标程序大小增大，而且容易引起一些冲突;
   而这些冲突往往你无法解决(常常出现在你链接的各种库中）。
## 二.如何解决这种问题呢？你可以使用-force_load.    
    指定要载入所有方法的库,但是仅在Xcode3.2之后才支持.
    然后，在other linker flags 中配置-force_load（第一项为-force_load 第二项为.a路径）

### 三.注意事项
   * Xcode5之前的版本重启Xcode!!!（注意一定要重启）
   * Xcode5及以后的不需要重启Xcode
   
### 四.最终设置
#### 静态库的设置

![image](/images/post/2014-08-12-xcode-zhi-forceload/library_path.png)

#### `other linker flags`设置![image](/images/post/2014-08-12-xcode-zhi-forceload/other_link_flag.png)

### 五.总结

### 1. -ObjC与-force_load,-all_load的区别. 
   * -ObjC加载所有类和有本类的分类，对于系统本类的分类是不加载的。
   * -force_load,-all_load,加载类所有的方法，包括系统本类的分类方法。  

### 2.`-force-load`,`-all_load`,所做的事情是相同的,但是，是有区别的
   * -all_load是加载所有静态库中所有的类,分类,可能导致冲突。 
   * -force_load是指定加载某个静态库中所有的类,分类,不影响其它类按需加载。

