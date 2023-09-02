---
title: "iOS视频播放-AVPlayerViewController"
date: 2019-12-25T20:37:53+08:00
lastmod: 2019-12-25T20:37:53+08:00
keywords: ["iOS", "swift", "音视频"]
tags: ["iOS", "swift", "音视频"]
categories: ["iOS", "swift", "音视频"]

comment: true
toc: true
autoCollapseToc: true
reward: true

---

<!--more-->

## 一.AVPlayerViewController播放视频

分两种形式

* 内嵌视图的形式显示
* 模态视图的形式显示

### 1.初始化AVPlayerViewController

```swift

 func loadPlayer() -> Void {
        guard let movieUrl = Bundle.main.path(forResource: "zh-zhfanti-en", ofType: "m4v") else {
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: movieUrl))
        playerViewController = AVPlayerViewController()
        playerViewController!.player = player
    }
    
```
### 2.内嵌视图的形式显示

```swift

 @IBAction func handlePlayInViewEvent(sender: AnyObject) {
        loadPlayer()
        
        guard (playerViewController != nil) else {
            return
        }
        
        containerView?.addSubview(playerViewController!.view)
        playerViewController?.view.frame = containerView!.bounds
        self.addChild(playerViewController!)
        playerViewController?.player?.play()
   }
   
```

效果图

![image](/images/post/iOS视频播-AVPlayerViewController/1.png)

点击`AVPlayerViewController`可以全屏播放

### 3.模态视图的形式显示

```swift
	@IBAction func handlePlayWithModelViewEvent(sender: AnyObject) {
        
        loadPlayer()
        
        guard (playerViewController != nil) else {
            return
        }
        
        
        self.present(playerViewController!, animated: true) { [weak self] () -> Void in
            guard let self = self else {
                return
            }
            self.playerViewController?.player?.play()
        }
    }


```

效果图

### 二.停止视频播放

```swift

 @IBAction func handleStopPlayEvent(sender: AnyObject? ){
        
        guard playerViewController != nil else {
            return
        }
        
        if ((playerViewController?.parent) != nil) {
            playerViewController?.view.removeFromSuperview()
            playerViewController?.removeFromParent()
        } else if playerViewController != nil && playerViewController!.isModalInPresentation {
            playerViewController?.dismiss(animated: (sender != nil ? true:false), completion: nil)
        }
        
        playerViewController?.player?.pause()
        playerViewController = nil
  }
    
```
