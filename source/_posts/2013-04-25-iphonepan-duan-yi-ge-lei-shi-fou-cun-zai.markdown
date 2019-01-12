---
layout: post
title: "iPhone判断一个类是否存在"
date: 2013-04-25 17:16
comments: true
categories: 
---


如何在判断一个类是否在当前SDK版本中是否存在？

```objective-c
    Class JSONSerialization = NSClassFromString(@"NSJSONSerialization");
    
    if (JSONSerialization) {
        NSLog(@"NSJSONSerialization exist!");
    }
    else
    {
        NSLog(@"NSJSONSerialization not exist!");
    }
    
    JSONSerialization = NSClassFromString(@"JSONSerialization");
    
    if (JSONSerialization) {
        NSLog(@"JSONSerialization exist!");
    }
    else
    {
        NSLog(@"JSONSerialization not exist!");
    }

```