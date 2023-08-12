---
title: "AFNetworking-2.0主项目"
date: 2014-09-02
categories:
  - "iOS-网络"
tags:
  - "iOS-网络"
---
<!--more-->


#### AFNetworking-2.0主项目源代码文件组成：<!--more-->

![image](/images/post/2014-09-02-afnetworking-2-dot-0/afnetworking_code_overview.png)

#### AFNetworking-2.0主项目类组成：![image](/images/post/2014-09-02-afnetworking-2-dot-0/AFNetworking_class_overview.png)


### [AFNetworking 2.0](https://github.com/AFNetworking/AFNetworking)相比2.0做了优化调整。>* 兼容NSURLSession，适配iOS7.
* 模块化，可以自由挑选你需要的模块。
* 实时推送。AFNetworking主项目并没有这个特性，而是放到子项目[AFRocketClient](https://github.com/AFNetworking/AFRocketClient)

中文译文为[http://nshipster.cn/afnetworking-2/](http://nshipster.cn/afnetworking-2/)

#### 版本支持情况
|  AFNetworking 版本 &nbsp;&nbsp;&nbsp;&nbsp;|   最低支持 iOS Target  &nbsp;&nbsp;&nbsp;&nbsp;|     最低支持 OS X Target      &nbsp;&nbsp;&nbsp;&nbsp;|     注意事项          &nbsp;&nbsp;&nbsp;&nbsp; |
|:-----------------:|:---------------------:|:----------------------------:|:--------------------:|
|          2.x      |      iOS 6            |           OS X 10.8          | Xcode 5 is required  
|          [1.x](https://github.com/AFNetworking/AFNetworking/tree/1.x)      |      iOS 5            |         Mac OS X 10.7        |                      
|         [0.10.x](https://github.com/AFNetworking/AFNetworking/tree/0.10.x)    |      iOS 4            |         Mac OS X 10.6        |                      


### <br>结构：<br>
#### NSURLConnection
  - **AFURLConnectionOperation**
  
      `NSOperation`的子类，实现`NSURLConnectionDelegate`,
`NSURLConnectionDataDelegate`,控制`NSURLConnection`的创建，取消，
进行中，完成，并对外回调执行状态。

  - **AFHTTPRequestOperation**
  
       `AFURLConnectionOperation` 的子类，用于生成 `HTTP` 请求，可以区别可接受的和不可接受的状态码及内容类型。

  - **AFHTTPRequestOperationManager**:
  
      继承 NSObject类，遵循`NSSecureCoding`, `NSCopying`协议，包装常见 HTTP web 服务操作的类，包括请求的创建，响应的序列化，网络状态监控，安全性。通过`NSOperationQueue`对象来调度`AFHTTPRequestOperation`对象。
      
  
#### 小结：  
   1.AFURLConnectionOperation/AFHTTPRequestOperation及其子类共用享线程networkRequestThread的runloop,网络请求回调处理完后，准备好数据向上层调用者回调。
   
   2.使用状态机来控制NSOperation的状态切换，状态的改变通过在`setState`中通过KVO触发。
      
   * AFOperationPausedState
   * AFOperationReadyState
   * AFOperationExecutingState 
   * AFOperationFinishedState
   默认为`AFOperationReadyState` 
      
      
#### NSURLSession支持 _(iOS 7 / Mac OS X 10.9)_
- **AFURLSessionManager**：

   创建、管理基于 `NSURLSessionConfiguration` 对象的 `NSURLSession` 对象的类，也可以管理 session 的数据、下载/上传任务，实现 session 和其相关联的任务的 delegate 方法
- **AFHTTPSessionManager**：- `AFURLSessionManager` 的子类，包装常见的 HTTP web 服务操作，通过 `AFURLSessionManager`由`NSURLSession` 支持

#### 小结：
   目前还没有明确拒绝`NSURLConnection`,`iOS7`的`NSURLSession`是不是以后会逐步取代`NSURLConnection`？
   

#### 序列化(Serialization)
* **\<AFURLRequestSerialization>** 
    
    符合这个协议的对象用于处理请求，它将请求参数转换为 query string 或是 entity body 的形式，并设置必要的 header。

  - `AFHTTPRequestSerializer`:http标准格式
  - `AFJSONRequestSerializer`:json格式
  - `AFPropertyListRequestSerializer`:属性列表格式
  
* **\<AFURLResponseSerialization>**

    符合这个协议的对象用于验证、序列化响应及相关数据，转换为有用的形式，比如 JSON 对象、图像、甚至基于 Mantle 的模型对象

  - `AFHTTPResponseSerializer`：http标准格式
  - `AFJSONResponseSerializer`:json格式
  - `AFXMLParserResponseSerializer`:xml格式
  - `AFXMLDocumentResponseSerializer` _(Mac OS X)_
  - `AFPropertyListResponseSerializer`:属性列表格式
  - `AFImageResponseSerializer`:图片格式
  - `AFCompoundResponseSerializer`:网络失败时的数据填充。
  
#### 小结:
  主要是针对请求数据和响应数据格式的增强，提高易用性。
     

#### Additional Functionality
- `AFSecurityPolicy`:https安全策略。
- `AFNetworkReachabilityManager`:网络状态监听。

#### UIKit 扩展支持(UIKit expansion)
* `AFNetworkActivityIndicatorManager`:新增自动开始或结束状态栏上的网络指示器。
* `UIImageView+AFNetworking`: 新增显示图片前剪裁或者加滤镜的功能。
* `UIButton+AFNetworking` (新增): 类似 UIImageView+AFNetworking，按钮的背景图从线上下载。
* `UIActivityIndicatorView+AFNetworking` (新增): 根据网络请求的状态自动开始或结束。
* `UIProgressView+AFNetworking` (新增): 自动跟踪某个请求的上传下载的进度。
* `UIWebView+AFNetworking` (新增): 支持网络请求的进度和内容转换。

#### 小结:
   提供一些和网络相关UI的扩展的支持,提高使用便捷性。





