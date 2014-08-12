---
layout: post
title: "Xcode之forceload"
date: 2014-08-12 23:51
comments: true
categories: Xcode
---

####1.应用场景:

    在项目中，可能会使用多个第三方的库。
    如果使用-all_load选项，这会导致所有的类的方法都会被载入.
    不管“你的程序”有没有用到，所有的，包括系统的，方法会被载入,
    这不仅导致目标程序大小增大，而且容易引起一些冲突;
    而这些冲突往往你无法解决(常常出现在你链接的各种库中）。
####2.如何解决这种问题呢？你可以使用-force_load.
    
    指定要载入所有方法的库,但是仅在Xcode3.2之后才支持.
    然后，在other linker flags 中配置-force_load（第一项为-force_load 第二项为.a路径）

####3.注意事项:
    Xcode5之前的版本重启Xcode!!!（注意一定要重启）
    Xcode5及以后的不需要重启Xcode
####4.最终设置:

####静态库的设置
![image](/images/post/2014-08-12-xcode-zhi-forceload/library_path.png)

####`other linker flags`设置
![image](/images/post/2014-08-12-xcode-zhi-forceload/other_link_flag.png)

