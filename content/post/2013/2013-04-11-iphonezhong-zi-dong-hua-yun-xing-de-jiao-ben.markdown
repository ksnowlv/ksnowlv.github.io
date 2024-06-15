---
title: "iPhone中自动化运行的脚本"
date: 2013-04-11
lastmod: 2013-04-11
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

支持点击，拖拽。

```objective-c
 var target = UIATarget.localTarget();

for (j=0; j<1000; j++)
{
for (i=0;i<=1000;i++) {
    xPoint = Math.floor(Math.random()*268+1)
    yPoint = Math.floor(Math.random()*300+90)
    target.tap( { x:xPoint, y:yPoint } );
}

for (i=0;i<=1000;i++) {
    xPoint = Math.floor(Math.random()*268+1)
    yPoint = Math.floor(Math.random()*300+90)

    xPoint2 = Math.floor(Math.random()*268+1)
    yPoint2 = Math.floor(Math.random()*300+90)
    target.dragFromToForDuration({x:xPoint, y:yPoint},{x:xPoint2,y:yPoint2},1);
}
}
```