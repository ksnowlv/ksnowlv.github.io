---
title: "iOS视频播放-AVPlayer和AVPlayerLayer"
date: 2019-11-26
lastmod: 2019-11-26
categories:
  - "swift"
tags:
  - "视频"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---



本文计划使用`AVPlayer`和`AVPlayerLayer`播放视频，视频格式如下：

* m4v:MP4的特殊类型，MP4格式的高清；可包含字幕
* mp4：音频、视频信息的压缩编码标准。
* srt：字幕文件格式

### 一.m4v格式视频播放

 播放m4v格式可通过MP4格式的文件+字幕文件合成m4v格式，可用[Subler](https://www.macupdate.com/app/mac/31647/subler)工具合成
	
![image](/images/post/2019-11-26-iosshi-pin-bo-fang-avplayer/Subler.jpg) 

#### 从本地获取视频文件并播放视频。

```swift

   func playMovieFromLocalFile(fileFullName: String) -> Bool {
        
        guard FileManager.default.fileExists(atPath: fileFullName) else {
            debugPrint("\(fileFullName) not Found")
            return false
        }
        
        let asset = AVAsset(url: URL(fileURLWithPath: fileFullName))
        let playerItem = AVPlayerItem(asset: asset)
        
        for characteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
            
            debugPrint("\(characteristic)\n")
            
            if let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) {
                for option in group.options {
                    debugPrint("  Option: \(option.displayName)\n")
                }
            }
        }
        
        // Create a group of the legible AVMediaCharacteristics (Subtitles)
        if let group = asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible) {
            
            let locale = Locale(identifier: "zh")
            // Create an option group to hold the options in the group that match the locale
            let options =
                AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
            // Assign the first option from options to the variable option
            if let option = options.first {
                // Select the option for the selected locale
                playerItem.select(option, in: group)
            }
        }
        
        player = AVPlayer(playerItem: playerItem)
        player?.appliesMediaSelectionCriteriaAutomatically = false
        
        if playerLayer == nil && player != nil  {
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerContainerView?.layer.addSublayer(playerLayer!)
        }
        
        return true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        playerLayer?.frame = playerContainerView!.bounds
    }
    
```

效果图如下：

![image](/images/post/2019-11-26-iosshi-pin-bo-fang-avplayer/overview_1.png) 

### 二.播放mp4格式带srt字幕
`mp4`文件和字幕`srt`文件通过时间軕实现当前播放进度展示相应文本。
srt格式解析可参考[AVPlayerViewController-Subtitles](https://github.com/mhergon/AVPlayerViewController-Subtitles)


  ```swift
  
  func playMovie(movieFile: String, captionFile: String) -> Bool {
        
        let fileManage = FileManager.default
        guard fileManage.fileExists(atPath: movieFile) && fileManage.fileExists(atPath: captionFile) else {
            debugPrint("movie:\(movieFile)/ or captionFile:\(captionFile)not found")
            return false
        }
        
        
        player =  AVPlayer(url: URL(fileURLWithPath: movieFile))
        
        let asset = AVAsset(url: URL(fileURLWithPath: captionFile))
        
        for characteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
            print("\(characteristic)")
            
            // Retrieve the AVMediaSelectionGroup for the specified characteristic.
            if let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) {
                // Print its options.
                for option in group.options {
                    print("  Option: \(option.displayName)")
                }
            }
        }
        
        if let group = asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible) {
            let locale = Locale(identifier: "en")
            let options =
                AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
            if let option = options.first {
                // Select Spanish-language subtitle option
                player?.currentItem!.select(option, in: group)
                print("\(player?.currentItem!.select(option, in: group))")
            }
        }
        
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerContainerView?.layer.addSublayer(playerLayer!)
        
        
        player?.currentItem?.addObserver(self, forKeyPath:ViewController.observerKeyStatus, options:[NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
        player?.currentItem?.addObserver(self, forKeyPath: ViewController.observerKeyLoadedTimeRanges, options: NSKeyValueObservingOptions.new, context: nil)
        
        // Subtitle file
        let subtitleFile = Bundle.main.path(forResource: "test", ofType: "srt")
        let subtitleURL = URL(fileURLWithPath: subtitleFile!)
        
        // Subtitle parser
        parser = Subtitles(file: subtitleURL, encoding: .utf8)
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] (time: CMTime) in
            
            let currentTime = CMTimeGetSeconds(time)
            
            guard let self = self else {
                return
            }
            
            
            self.movieTextLabel?.text = self.parser?.searchSubtitles(at: currentTime)
            
            let totolCTTime =  self.player?.currentItem?.duration ?? CMTimeMake(value: 0, timescale: 0)
            
            let totalTime  = CMTimeGetSeconds(totolCTTime)
            
            if totalTime > 0 {
                self.slider?.value = Float(currentTime/totalTime)
            }
        })
        
        return true
    }

  ```
  
  
  效果图如下：

![image](/images/post/2019-11-26-iosshi-pin-bo-fang-avplayer/overview_2.png) 

  
### 三.两种方式需要手动播放或暂停  
  ```swift
  
      @IBAction func handleStartPlayerEvent(sender: AnyObject) {
        isPlaying = true
        player?.play()
    }
    
    @IBAction func handlePausePlayerEvent(sender: AnyObject) {
        
        if isPlaying {
            player?.pause()
        }
    }
    
  ```



