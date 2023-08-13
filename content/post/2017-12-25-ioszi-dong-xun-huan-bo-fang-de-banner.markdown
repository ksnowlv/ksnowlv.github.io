---
title: "iOS自动循环播放的banner"
date: 2017-12-25
lastmod: 2017-12-25
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

自动循环播放的banner是很常见的UI组件。如何实现呢？

## 一.实现思路
### 1.横向滚动的banner。
* UIScrollViw+UIImageView.
* UICollectionView+UICollectionViewCell.
* 前者需要自己做重用UIImageView，后者可以直接重用UICollectionViewCell。如果前者没有做重用，多占用内存。
### 2.自动循环播放banner。
* 可以使用计时器触发循环播放.
* 拖动或手动滑动banner时，停止自动循环播放banner。手势停止后，开启自动循环播放banner。

### 3.特殊banner位的处理。
* 处于第1个或最后1个时，为保证横向自动滑动效果流畅性，不跳动，需要特殊处理下。
* 在生成banner时，第1个前面插入最后1个banner。最后1个banner后面插入第1个banner。当滑动到最后1个banner时，重置于第2个banner位。
	  

## 二.本文采用第二种

**UICollectionView+UICollectionViewCell**
关键代码实现

### 2.1生成banner的特殊处理

```objective-c

- (void)setBannerList:(NSArray<KBannerItem *> *)bannerList {
    
    if (bannerList.count > 1) {
        NSMutableArray *itemList = [NSMutableArray arrayWithArray:bannerList];
        [itemList insertObject:bannerList.lastObject atIndex:0];
        [itemList addObject:bannerList.firstObject];
        _bannerList = itemList;
    }else{
        _bannerList = bannerList;
    }
    
    if (self.bannerList.count > 1) {
        self.bannerPageControl.numberOfPages = self.bannerList.count - 2;
    }else{
        self.bannerPageControl.numberOfPages = 0;
    }
    
    self.noBannerImageView.hidden = self.bannerList.count > 0;
    self.bannerPageControl.currentPage = 0;
    [self.collectionView reloadData];
    self.collectionView.contentOffset = CGPointMake(CGRectGetWidth(self.collectionView.frame), 0);
}
```

### 2.2 banner自动循环播放触发的事件

```objective-c

- (void)handleBannerChangeEvent:(id)sender {
    
    if (_bannerPageControl.numberOfPages <= 1) {
        return;
    }
    
    NSInteger page = _bannerPageControl.currentPage + 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:page + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

```

### 2.3开启自动播放或关闭自动播放bannner

```objective-c
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.countTimer.isOpen = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    self.countTimer.isOpen = YES;
}

```	  

### 2.4.滑动时的特殊处理

```objective-c

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_bannerList.count <=1) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(scrollView.frame);
    NSInteger currentPage = scrollView.contentOffset.x / width;
    
    if (currentPage == 0) {
        if (scrollView.contentOffset.x < 0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_bannerList.count - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
            self.bannerPageControl.currentPage = _bannerList.count - 2;
        }else{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
            self.bannerPageControl.currentPage = 0;
            
        }
        
    }else if (currentPage == _bannerList.count - 1) {
        self.bannerPageControl.currentPage = 0;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }else{
        self.bannerPageControl.currentPage = currentPage - 1;
    }
}


```