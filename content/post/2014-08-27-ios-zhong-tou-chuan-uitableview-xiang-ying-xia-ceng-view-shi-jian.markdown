---
title: "iOS中透穿UITableView响应下层view事件"
date: 2014-08-27
lastmod: 2014-08-27
categories:
  - "iOS"
tags:
  - "UI"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

![image](/images/post/2014-08-27-ios-zhong-tou-chuan-uitableview-xiang-ying-xia-ceng-view-shi-jian/homepage_1.png)


<!--**图2**

![image](/images/post/2014-08-27-ios-zhong-tou-chuan-uitableview-xiang-ying-xia-ceng-view-shi-jian/homepage_2.png)
-->
#### 1.具体场景：淘宝iPad首页改版时,在拖动首页**UITableview**列表(见2区)时，banner页面保持不动（1区黑色透明层下面）,banner页面可以响应左右滑动，点击事件，
>* 如果拖动到banner页面下半部时，此时，松手首页**UITableview**列表，自动回到原来位置;
 * 如果拖动到banner页面上半部时，此时，松手首页**UITableview**列表，自动回到banner页面顶部;
 * 其它:实际上1区黑色透明层应该是全透明的,为了大家更好地了解下面的实现方案。

#### 2.实现方案* 如果把bannerview,首页**UITableview**列表放到一个**UIScrollView**中，需要每次都重置bannerview的纵向坐标，还需要把首页**UITableview**列表作为一个普通的view嵌入到**UIScrollView**中，它的拖动等事件由**UIScrollView**操控，比较麻烦。
* 如果把bannerview,首页**UITableview**列表放到一个普通的**UIView**中，更麻烦。
 
 综合考虑下，这种场景可以使用**UITableView的透穿方案**比较好。
   
    1.首页UITableview与banner页面放到同一个父View中，首页tableview在banner页面上面。
    2.首页UITableview添加一个和banner页面大小完全一样，完全透明的tableHeaderView
    3.穿透首页UITableview的处理。

#### 3.实现细节和关键点。
继承**UITableview**,添加穿透**UITableview**的处理。

``` objective-c

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView* tmpView = [super hitTest:point withEvent:event];
    
    if (tmpView.superview == self) {
        return nil;
    }
    return tmpView;
    
}

```

**debug时的截图**
![image](/images/post/2014-08-27-ios-zhong-tou-chuan-uitableview-xiang-ying-xia-ceng-view-shi-jian/tableview_debug.png)

处理的关键点在于**判断条件**

**tmpView.superview == self**!

如果需要穿透**UIView**，则变更为**tmpView == self**

