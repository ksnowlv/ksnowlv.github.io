---
title: "swift-https的支持"
date: 2018-07-18
lastmod: 2018-07-18
categories:
  - "swift"
tags:
  - "安全"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

swift中，如何支持https呢？

https分为单向（客户端校验服务端）的和双向（客户端/服务端相互校验）具体可查阅相关资料。

实现`URLSessionDelegate`协议中

`urlSession(_ session: didReceive challenge: completionHandler: )`

具体实现

```swift

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        var disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        
        var credential:URLCredential? = nil
        /*disposition：如何处理证书
         performDefaultHandling:默认方式处理
         useCredential：使用指定的证书
         cancelAuthenticationChallenge：取消请求
         */
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        
            if credential != nil {
                disposition = URLSession.AuthChallengeDisposition.useCredential
            }
        }else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
            //单向验证，客户端不需要服务端验证，此处与默认处理一致即可
            disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
        }
        else {
            disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
        }
        
        completionHandler(disposition, credential)
    }
}
```
