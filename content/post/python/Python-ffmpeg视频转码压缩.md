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

## ffmpeg视频转码压缩
视频文件如何压缩减少大小呢？

其中，可以通过视频转码来实现,将视频文件从H.264编码转换为H.265(HEVC）

### 1.python ffmpeg视频转码

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

#### 视频转码参数说明
   我们使用 subprocess 模块来调用FFmpeg命令将视频文件从H.264编码转换为 H.265（HEVC）编码。
* -i 参数指定输入文件，
* -c:v 参数指定输出视频的编解码器为 H.265（HEVC），
* -preset 参数指定编码速度和质量的平衡点（可选参数包括 ultrafast、superfast、veryfast、faster、fast、medium、slow、slower 和 veryslow），
* -x265-params 参数是 H.265 编码器的附加参数。在这里，我们设置 -x265-params crf=28，以设置恒定质量模式（CQP）下的视频质量，
* 28 是质量的值，可供自己选择。输出文件将保存在指定的输出路径中。

请注意，视频文件的大小和质量受多种因素影响，包括分辨率、比特率、FPS 等。在使用 H.265 编码器进行编码转换时，请根据你的需求进行设置。


### 2.视频转码后文件压缩效果

#### main.py文件中统计目录下文件大小

```python
    folder_path = 'python_fps/high'
    fps_high_file_size = FileMgr.get_directory_size(folder_path)
    print(f"python_fps/high 目录下所有文件大小:{fps_high_file_size}, 共{fps_high_file_size/(1024.0 *1024.0 * 1024.0)}G")

    folder_path = 'python_fps/high_codec'
    fps_high_codec_file_size = FileMgr.get_directory_size(folder_path)
    print(f"python_fps/high_codec目录下所有文件大小:{fps_high_codec_file_size},共{fps_high_codec_file_size/(1024.0 * 1024.0 * 1024.0)}G")

    result = '%.2f' % ((fps_high_file_size - fps_high_codec_file_size) * 100.0 / fps_high_file_size)
    print(f"---所有视频文件采用H264转H265压缩方式的压缩率 = {result}%")
```

#### H264转H265视频文件压缩效果
```shell

python_fps/high 目录下所有文件大小:4367638719, 共4.0676805367693305G
python_fps/high_codec目录下所有文件大小:1686972766,共1.5711158197373152G
---所有视频文件采用H264转H265压缩方式的压缩率 = 61.38%
```

