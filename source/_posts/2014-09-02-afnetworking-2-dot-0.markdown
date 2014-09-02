---
layout: post
title: "AFNetworking-2.0"
date: 2014-09-02 19:18
comments: true
categories: iOS-网络
---


###[AFNetworking 2.0](https://github.com/AFNetworking/AFNetworking)相比2.0做了优化调整。
>* 兼容NSURLSession，适配iOS7.
* 模块化，可以挑选你需要的模块。
* 实时推送。AFNetworking主项目并没有这个特性，而是放到子项目[AFRocketClient](https://github.com/AFNetworking/AFRocketClient)

中文译文为[http://nshipster.cn/afnetworking-2/](http://nshipster.cn/afnetworking-2/)

其版本支持情况

|  AFNetworking 版本 &nbsp;&nbsp;&nbsp;&nbsp;|   最低支持 iOS Target  &nbsp;&nbsp;&nbsp;&nbsp;|     最低支持 OS X Target      &nbsp;&nbsp;&nbsp;&nbsp;|     注意事项          &nbsp;&nbsp;&nbsp;&nbsp; |
|:-----------------:|:---------------------:|:----------------------------:|:--------------------:|
|          2.x      |      iOS 6            |           OS X 10.8          | Xcode 5 is required  
|          [1.x](https://github.com/AFNetworking/AFNetworking/tree/1.x)      |      iOS 5            |         Mac OS X 10.7        |                      
|         [0.10.x](https://github.com/AFNetworking/AFNetworking/tree/0.10.x)    |      iOS 4            |         Mac OS X 10.6        |                      

 


###其结构：

#### NSURLConnection

- `AFURLConnectionOperation`:`NSOperation`的子类，负责管理`NSURLConnection` 并且实现其 `NSURLConnectionDelegate`,`NSURLConnectionDataDelegate`,`NSSecureCoding`, `NSCopying` 方法

- `AFHTTPRequestOperation`:`AFURLConnectionOperation` 的子类，用于生成 `HTTP` 请求，可以区别可接受的和不可接受的状态码及内容类型。

- `AFHTTPRequestOperationManager`: 继承 NSObject类，遵循`NSSecureCoding`, `NSCopying`协议，包装常见 HTTP web 服务操作的类，包括请求的创建，响应的序列化，网络状态监控，安全性。通过`NSOperationQueue`对象来调度`AFHTTPRequestOperation`对象。

#### NSURLSession支持 _(iOS 7 / Mac OS X 10.9)_

- `AFURLSessionManager`：创建、管理基于 `NSURLSessionConfiguration` 对象的 `NSURLSession` 对象的类，也可以管理 session 的数据、下载/上传任务，实现 session 和其相关联的任务的 delegate 方法
- `AFHTTPSessionManager`：`AFURLSessionManager` 的子类，包装常见的 HTTP web 服务操作，通过 `AFURLSessionManager`由`NSURLSession` 支持

#### 序列化(Serialization)

* `<AFURLRequestSerialization>`符合这个协议的对象用于处理请求，它将请求参数转换为 query string 或是 entity body 的形式，并设置必要的 header。

  - `AFHTTPRequestSerializer`:http
  - `AFJSONRequestSerializer`:json
  - `AFPropertyListRequestSerializer`:属性列表
  
* `<AFURLResponseSerialization>`符合这个协议的对象用于验证、序列化响应及相关数据，转换为有用的形式，比如 JSON 对象、图像、甚至基于 Mantle 的模型对象

  - `AFHTTPResponseSerializer`：http
  - `AFJSONResponseSerializer`:json
  - `AFXMLParserResponseSerializer`:xml
  - `AFXMLDocumentResponseSerializer` _(Mac OS X)_
  - `AFPropertyListResponseSerializer`:属性列表
  - `AFImageResponseSerializer`:图片
  - `AFCompoundResponseSerializer`

#### Additional Functionality

- `AFSecurityPolicy`
- `AFNetworkReachabilityManager`

#### UIKit 扩展支持(UIKit expansion) 

* `AFNetworkActivityIndicatorManager`: 新增自动开始或结束状态栏上的网络指示器。
* `UIImageView+AFNetworking`: 新增显示图片前剪裁或者加滤镜的功能。
* `UIButton+AFNetworking` (新增): 类似 UIImageView+AFNetworking，按钮的背景图从线上下载。
* `UIActivityIndicatorView+AFNetworking` (新增): 根据网络请求的状态自动开始或结束。
* `UIProgressView+AFNetworking` (新增): 自动跟踪某个请求的上传下载的进度。
* `UIWebView+AFNetworking` (新增): 支持网络请求的进度和内容转换。


####AFNetworking子项目地址：[https://github.com/AFNetworking](https://github.com/AFNetworking)
其它子项目
>* 1.[AFNetworkActivityLogger](https://github.com/AFNetworking/AFNetworkActivityLogger)
* 2.[AFAmazonS3Client](https://github.com/AFNetworking/AFAmazonS3Client)
* 3.[AFJSONRPCClient](https://github.com/AFNetworking/AFJSONRPCClient)
* 4.[Xcode-Project-Templates](https://github.com/AFNetworking/Xcode-Project-Templates)
* 5.[AFOnoResponseSerializer](https://github.com/AFNetworking/AFOnoResponseSerializer)
* 6.[WebKit-AFNetworking](https://github.com/AFNetworking/WebKit-AFNetworking)
* 7.[AFMsgPackSerialization](https://github.com/AFNetworking/AFMsgPackSerialization)
* 8.[AFCoreImageResponseSerializer](https://github.com/AFNetworking/AFCoreImageResponseSerializer)
* 9.[AFKissXMLRequestOperation](https://github.com/AFNetworking/AFKissXMLRequestOperation)
* 10.[afnetworking.com](https://github.com/AFNetworking/afnetworking.com)
* 11.[AFWebDAVManager](https://github.com/AFNetworking/AFWebDAVManager)
* 12.[AFOAuth2Client](https://github.com/AFNetworking/AFOAuth2Client)
* 13.[AFgzipRequestSerializer](https://github.com/AFNetworking/AFgzipRequestSerializer)
* 14.[AFOAuth1Client](https://github.com/AFNetworking/AFOAuth1Client)
* 15.[AFHTTPRequestOperationLogger](https://github.com/AFNetworking/AFHTTPRequestOperationLogger)
* 16.[AFRocketClient](https://github.com/AFNetworking/AFRocketClient)
* 17.[AFContentRequestOperations](https://github.com/AFNetworking/AFContentRequestOperations)
* 18.[AFIncrementalStore](https://github.com/AFNetworking/AFIncrementalStore)
* 19.[AFNetworking-ASIHTTPRequest](https://github.com/AFNetworking/AFNetworking-ASIHTTPRequest)
* 20.[AFCollectionJSONRequestOperation](https://github.com/AFNetworking/AFCollectionJSONRequestOperation)
