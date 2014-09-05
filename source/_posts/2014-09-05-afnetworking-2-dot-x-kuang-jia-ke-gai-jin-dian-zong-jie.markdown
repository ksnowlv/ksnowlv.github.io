---
layout: post
title: "AFNetworking-2.x框架可改进点总结"
date: 2014-09-05 14:10
comments: true
categories: iOS-网络
---

**AFNetworking**网络框架**2.x**是很优秀的，许多关键的技术细节处理的是很到位的。

###AFNetworking 2.x可能改进点小结

####1.可以根据需求，选用其中部分模块，并裁剪其中一些类。
####2.目前网络模块不支持长连接。
####3.**NSCache**的不当使用，可以调整优化。

   见`UIKit扩展`中`UIImageView (AFNetworking)`中
        
  * 1.如果没有对图片个数或占用内存大小作限制，如果使用过多，会造成内存占用过多引发crash;
  * 2.如果做了图片个数或内存大小的限制，因为**NSCache**的淘汰策略是基于引用计数的，则通常不是我们所需求的，这也是系统提供的**NSCache**的尴尬之处。

####4.**UIKit扩展**中**UIButton (AFNetworking)**图片不支持cache.
####5.图片下载队列的优化调整。
    
   * 1.**UIImageView (AFNetworking)**和**UIButton (AFNetworking)**各使用一个**NSOperationQueue**,如果同时使用这两个控件，可以考虑使用同一个**NSOperationQueue**。
   * 2.鉴于我们应用当中图片使用量较大，不建议直接使用网络模块中的队列进行下载。
    
####6.网络请求取消，可以完善下。
####7.最好屏蔽网络请求暂停的接口.

    网络请求暂停后，始终会停留在NSOperationQueue中，占用线程资源，影响其它线程的调度。




    

