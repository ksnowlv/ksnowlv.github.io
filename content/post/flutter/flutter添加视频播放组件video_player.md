---
title: "Flutter添加视频播放组件video_player"
date: 2024-03-28T21:39:34+08:00
lastmod: 2024-03-28T21:39:34+08:00
keywords: ["Flutter"]
tags: ["Flutter"]
categories: ["Flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## video_player的使用

### 1.video_player

官方链接见[https://pub-web.flutter-io.cn/packages/video_player](https://pub-web.flutter-io.cn/packages/video_player)

支持Android/iOS/MacOS/Web

### 2.pubspec.yaml添加依赖

```yaml
  video_player: ^2.8.3 
```

### 3.示例

* video_player_page.dart

```dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String pageTitle;
  const VideoPlayerPage({super.key, required this.pageTitle});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _controller.value.isInitialized
                    ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                    : const CircularProgressIndicator(), // ,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('开始播放'),
                  onPressed: () {
                    setState(() {
                      _controller.play();
                    });
                  },
                ),
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  child: const Text('暂停播放'),
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      }
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

```
### 4.小结

我们使用Flutter中的video_player插件来播放网络视频。

* _VideoPlayerPageState中，使用video_player插件里的VideoPlayerController和VideoPlayer类来处理视频的播放。在initState方法中，初始化了_controller，并通过VideoPlayerController.networkUrl方法来设置视频的网络地址，并且在视频初始化完成后通过initialize().then来确保第一帧视频被显示，即使在按下播放按钮之前也可以看到视频的第一帧。
* dispose释放了_controller的资源，确保在页面销毁之前释放相关的资源，避免内存泄漏。
* build方法中，使用SingleChildScrollView和Column来实现视频播放器、视频进度条和控制按钮的布局。使用AspectRatio来展示视频播放器，同时使用VideoProgressIndicator来展示视频的播放进度，并添加了开始播放和暂停播放的按钮来控制视频的播放状态。

### 5.效果

![image](/images/flutter/flutter添加视频播放组件video_player/result.png)

