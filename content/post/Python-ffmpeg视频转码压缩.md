---
title: "Python ffmpeg视频转码压缩"
date: 2023-09-04T20:04:05+08:00
lastmod: 2023-09-04T20:04:05+08:00
keywords: ["Python", "ffmpeg", "视频转码", "视频压缩"]
tags: ["Python", "音视频"]
categories: ["Python", "音视频"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

视频文件如何压缩减少大小呢？

其中，可以通过视频转码来实现,将视频文件从 H.264 编码转换为 H.265（HEVC）


```python

import subprocess
import os

from filemgr import FileMgr


class FfmpegManager(object):

    SOURCE_FILE_PATH = "python_fps/high/"
    DEST_FILE_PATH = "python_fps/high_ffmpeg/"
    CODEC_DEST_FILE_PATH = "python_fps/high_codec/"

    def __init__(self):
        self.fps = 20
        self.fps_list = FileMgr.all_video_files(FfmpegManager.SOURCE_FILE_PATH)


    def start_codec_compressed(self):

        if len(self.fps_list) == 0:
            return

        for file_path in self.fps_list:
            file_name = os.path.basename(file_path)
            dest_file_path = FfmpegManager.CODEC_DEST_FILE_PATH + file_name

            subprocess.run(["ffmpeg", "-i", file_path, "-c:v", "libx265", "-preset", "medium", "-x265-params", "crf=28", dest_file_path], check=True)



```

我们使用 subprocess 模块来调用FFmpeg命令将视频文件从 H.264 编码转换为 H.265（HEVC）编码。
* -i 参数指定输入文件，
* -c:v 参数指定输出视频的编解码器为 H.265（HEVC），
* -preset 参数指定编码速度和质量的平衡点（可选参数包括 ultrafast、superfast、veryfast、faster、fast、medium、slow、slower 和 veryslow），
* -x265-params 参数是 H.265 编码器的附加参数。在这里，我们设置 -x265-params crf=28，以设置恒定质量模式（CQP）下的视频质量，
* 28 是质量的值，可供自己选择。输出文件将保存在指定的输出路径中。

请注意，视频文件的大小和质量受多种因素影响，包括分辨率、比特率、FPS 等。在使用 H.265 编码器进行编码转换时，请根据你的需求进行设置。
