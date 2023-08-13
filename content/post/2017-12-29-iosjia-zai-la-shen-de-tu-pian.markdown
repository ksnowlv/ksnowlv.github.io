---
title: "iOS加载拉伸的图片"
date: 2017-12-29
lastmod: 2017-12-29
categories:
  - "iOS"
tags:
  - "UI"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

iOS如何加载拉伸的图片呢？

1.通过代码指定拉伸区域加载图片。如下所示。

```objective-c

+ (UIImage*)stretchImage:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    if ([image respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        CGSize imageSize = image.size;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageSize.height/2,
                                                                    imageSize.width/2,
                                                                    imageSize.height/2,
                                                                    imageSize.width/2)];
    }
    else{
        image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    }
    
    return image;
}

```

2.通过Asset Catalog指定拉伸区域加载图片。

通过Xcode中Asset Catalog的slice指定拉伸区域及属性。如图所示。

![image](/images/post/2017-12-29-iosjia-zai-la-shen-de-tu-pian/asset-catalog-slice.png) 
	
点击右下角的*show slicing*开始编辑图片，如图所示。

![image](/images/post/2017-12-29-iosjia-zai-la-shen-de-tu-pian/asset-catalog-slice-setting.png) 

直接在控件中引用该图片即可。