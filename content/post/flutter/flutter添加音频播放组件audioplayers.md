---
title: "Flutter添加音频播放组件audioplayers"
date: 2024-03-29T18:43:21+08:00
lastmod: 2024-03-29T18:43:21+08:00
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

官方链接见[https://pub-web.flutter-io.cn/packages/audioplayers](https://pub-web.flutter-io.cn/packages/audioplayers)

支持Android/iOS/linux/MacOS/Web/Windows

### 2.pubspec.yaml添加依赖

```yaml
  audioplayers: ^6.0.0

  assets:
    - assets/images/
    - assets/lottie/
    - assets/audio/test.mp3
```

### 3.示例

* audio_players_page.dart

```dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class AudioPlayersPage extends StatefulWidget {
  const AudioPlayersPage({super.key});

  @override
  State<AudioPlayersPage> createState() => _AudioPlayersPageState();
}

class _AudioPlayersPageState extends State<AudioPlayersPage> {
  PlayerState? _playerState;
  static const String _audioPath = 'audio/test.mp3';
  late AudioPlayer _audioPlayer;
  Duration _position = Duration.zero;
  Duration? _duration;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    playAudio();
  }

  void playAudio() async {
    try {
      //请注意AssetSource构造函数中的路径是audio/test.mp3
      //而不是 assets/audio/test.mp3。这是因为AssetSource会自动将路径解析为assets/目录下的文件。
      //确保您的音频文件确实位于项目目录的assets/audio/文件夹中，并且文件名和扩展名都是正确的。
      //final source = AssetSource('assets/audio/test.mp3');
      //await _audioPlayer.setSourceAsset('audio/test.mp3');
      //为了与播放器播放时设置的AssetSource对象路径作对比。
      final ByteData data = await rootBundle.load('assets/audio/test.mp3');
      debugPrint('ByteData = ${data.lengthInBytes}');
      // 设置音频源并播放
      _audioPlayer.play(AssetSource(_audioPath));
      //监听播放器状态
      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          _playerState = state;
          debugPrint('_playerState: $_playerState');

          if(_playerState == PlayerState.completed) {
            debugPrint('重新播放');
            playAudio();
          }
        });
      });

      _audioPlayer.onPositionChanged.listen((position) {
        setState(() {
          _position = position;
        });
      });

      _audioPlayer.onDurationChanged.listen((duration) {
        _duration = duration;
      });

    } catch (e) {
      // 处理异常
      debugPrint('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _duration != null
                  ? SizedBox(
            child: Slider(
              value: (_duration != null &&
                      _position.inMilliseconds > 0 &&
                      _position.inMilliseconds <
                              _duration!.inMilliseconds)
                      ? _position.inMilliseconds / _duration!.inMilliseconds
                      : 0.0,
              onChanged: _onSliderChanged,
            ),
          )
                  : Container(),
          Text('音频播放当前位置: ${_position.toString().split('.').first}'),
          Text('音频播放总时长: ${_duration?.toString().split('.').first ?? ''}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: IconButton(
                  key: const Key('play_button'),
                  onPressed: () {
                    if (!_isPlaying) {
                      _play();
                    }
                  },
                  iconSize: 48.0,
                  icon: const Icon(Icons.play_arrow),
                ),
              ),
              Expanded(
                child: IconButton(
                  key: const Key('pause_button'),
                  onPressed: () {
                    if (_isPlaying) {
                      _pause();
                    }
                  },
                  iconSize: 48.0,
                  icon: const Icon(Icons.pause),
                ),
              ),
              Expanded(
                child: IconButton(
                  key: const Key('stop_button'),
                  onPressed: () {
                    if (_isPlaying || _isPaused) {
                      _stop();
                    }
                  },
                  iconSize: 48.0,
                  icon: const Icon(Icons.stop),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _onSliderChanged(double newValue) {
    if (_duration == null) {
      return;
    }
    final position = newValue * _duration!.inMilliseconds;
    _audioPlayer.seek(Duration(milliseconds: position.round()));
  }

  Future<void> _play() async {
    await _audioPlayer.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _playerState = PlayerState.stopped;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }
}

```
### 4.小结

#### 功能描述 
* _AudioPlayersPageState中，audioplayers插件里的AudioPlayer和AssetSource类来处理音频的播放。在initState方法中，我们初始化了_audioPlayer，并调用了playAudio方法开始播放音频。

* playAudio方法中，使用rootBundle.load方法来加载音频文件的字节数据，并通过_audioPlayer.play(AssetSource(_audioPath))来设置音频源并开始播放。我们还监听了音频播放器的状态变化、播放位置变化以及总时长变化，并根据状态的变化更新界面。

* build方法中，
  * 使用Column和Row来实现音频播放控制按钮和播放进度条的布局。
  * 使用Slider来展示和控制音频播放的进度，并在顶部显示当前播放位置和总时长。
  * 音频控制按钮部分，通过IconButton来实现播放、暂停和停止音频的功能，利用_play()、_pause()和_stop()方法来控制音频的播放状态，并根据播放状态更新界面。

* 最后，在dispose方法中，我们释放了_audioPlayer的资源，确保在页面销毁之前释放相关的资源，避免内存泄漏。

#### 注意事项

关于本地音频路径，AssetSource和rootBundle加载路径的区别

* AssetSource加载的路径是**audio/test.mp3**，而不是**assets/audio/test.mp3**；因为AssetSource会自动将路径解析为assets/目录下的文件
* rootBundle加载的资源路径为**assets/audio/test.mp3**

### 5.效果

![image](/images/flutter/flutter添加音频播放组件audioplayers/result.png)
