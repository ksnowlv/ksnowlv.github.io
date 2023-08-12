---
title: "swift之url编解码"
date: 2018-06-22
categories:
  - "swift-基础框架"
tags:
  - "swift-基础框架"

---
<!--more-->


url的编码与解码，在工程中很常用，编解码针对特殊字符及中文，确保url可以正常访问

```objective-c

let KUrlCodingReservedCharacters = "!*'();:|@&=+$,/?%#[]{}"

extension NSString {
    
    /// url编码
    ///
    /// - Returns: NSString
    func urlEncode() -> NSString? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: KYKUrlCodingReservedCharacters).inverted)! as NSString
        
    }
    
    /// url解码
    ///
    /// - Returns: NSString
    func urlDecode() -> NSString? {
        return self.removingPercentEncoding as NSString?
    }
}

```