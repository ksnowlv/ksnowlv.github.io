---
title: "Python Ffmpeg压缩mp4文件"
date: 2023-09-12T14:25:01+08:00
lastmod: 2023-09-12T14:25:01+08:00
keywords: ["Python", "音视频", "ffmpeg"]
tags: ["Python", "音视频"]
categories: ["Python", "音视频"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## mp4文件压缩

### 1.h265转码

```python

subprocess.run(["ffmpeg", "-i", file_path, "-c:v", "libx265", "-preset", "medium", "-x265-params", "crf=25", dest_file_path], check=True)
```

其中subprocess.run()函数是Python 3.5及更高版本的新特性，用于运行外部命令

ffmpeg是要执行的外部命令
* -i file_path指定输入文件的路径。
* -c:v libx265指定使用libx265编解码器进行视频压缩。
* -preset medium选项指定压缩速度和质量的预设级别为中等级别，根据需要可替换为其他预设。
  * ultrafast：快速编码，但文件大小较大。
  *  superfast：比ultrafast略慢，但压缩速度更快，可用于时间敏感性应用。
  *  veryfast：较快的编码速度，视频质量和文件大小之间的平衡。
  *  faster：中等的编码速度，较高的压缩质量，适合用于在线视频分发等应用。
  *  fast：默认的速度和压缩质量，适用于大多数情况。
  *  medium：略慢的编码速度，更高的视频质量和更小的文件大小，适用于高质量的视频编码。
  *  slow：更慢的编码速度，更高的视频质量和更小的文件大小，适用于高质量视频编码和存档。
  *  slower：慢的编码速度，最高的视频质量和最小的文件大小，适用于高质量视频编码和存档。 
* -x265-params crf=25指定压缩质量的设置，此处使用固定的25个CRF（Constant Rate Factor）值。CRF值越低，压缩质量越好，但文件大小更大。可根据需要调整此参数。
* dest_file_path指定输出文件的路径。
* check=True选项指示在外部命令返回非零退出代码时引发异常，以便在运行发生任何错误时提供错误处理机制。

压缩效果

```terminal
fpsdemo 目录下所有文件大小:122933532, 共0.11449077352881432G
sub_frame目录下所有文件大小:85824524,共0.07993031665682793G
---压缩率 = 30.19%
```

### 2.视频抽帧

比如每5帧抽取一帧

```python
    def sub_frames(self, input_file, output_file):
    # 构造FFmpeg命令
        ffmpeg.input(input_file).output(output_file, vf='select=not(mod(n\,5))', vsync='1').run()
```
* ffmpeg:是一个音视频处理工具。

* input(input_file):指定要转换的输入文件，input_file是要转换的文件路径。
* output(output_file):指定转换的输出文件和其路径，output_file是输出文件的路径。
* vf='select=not(mod(n\\,5))' 表示使用视频筛选器。vf指定视频筛选器选项，将每5个帧中的一帧选择出来。
* vsync='1' 表示输出视频中的音频与视频同步， '0' 意味着不同步

压缩效果

```terminal
fpsdemo 目录下所有文件大小:122933532, 共0.11449077352881432G
sub_frame目录下所有文件大小:66270482,共0.061719195917248726G
---压缩率 = 46.09%
```
### 3.分辨率压缩

算法模型对于大于720P的视频文件，实际是按720P尺寸处理，因此对视频文件可进行分辨率压缩

```python
    def resolution_720P(self, input_file, output_file):
        probe = ffmpeg.probe(input_file)
        video_stream = next((stream for stream in probe['streams'] if stream['codec_type'] == 'video'), None)
        if video_stream is None:
            raise Exception('没有找到视频流.')
        # 算法侧模型是按720P处理
        if video_stream['width'] > 1280 and video_stream['height'] > 720:
            resolution = "1280x720"  # 720P分辨率
            subprocess.run(["ffmpeg", "-i", input_file, "-vf", "scale={}".format(resolution), "-c:a", "copy", output_file], check=True)
        else:
            # subprocess.run(["ffmpeg", "-i", input_file, output_file], check=True)
            FileMgr.copy_file(input_file, "sub_frame")

```

执行ffmpeg命令操作的效果

```terminal
fpsdemo 目录下所有文件大小:122933532, 共0.11449077352881432G
sub_frame目录下所有文件大小:95149232,共0.08861462771892548G
---压缩率 = 22.60%
```

因FFmpeg转换处理的视频文件会进行压缩，因此文件大小通常会比原始视频文件的文件大小要小

大于720P的视频文件执行文件拷贝操作的效果

```terminal
fpsdemo 目录下所有文件大小:122933532, 共0.11449077352881432G
sub_frame目录下所有文件大小:112876595,共0.10512452106922865G
---压缩率 = 8.18%
```

### 4.fps压缩

fps控制在20不影响算法效果，因此，fps参数设定为20

```python

 subprocess.run(["ffmpeg", "-i", file_path, "-r", "20", "-vcodec", "libx264", dest_file_path], check=True)

```

压缩效果

```terminal

fps目录下所有文件大小:7538707398,共7.020968383178115G
fps_res目录下所有文件大小:7578761862, 共7.058272009715438G
---FPS超过25的视频采用20fps压缩方式的压缩率 = -0.53%

```

压缩效果较差