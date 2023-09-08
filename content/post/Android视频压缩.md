---
title: "Android视频压缩"
date: 2023-09-05T15:15:41+08:00
lastmod: 2023-09-05T15:15:41+08:00
keywords: ["Android", "Python", "音视频"]
tags: ["Android","Python", "音视频"]
categories: ["Android", "Python", "音视频"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Android视频压缩

## 一.业务场景

Android设备使用相机进行视频录像后，生成视频文件；视频文件上传云端服务后，进行业务方面的处理；
如何减少视频文件大小呢？

## 二.解决方案

考虑到安装包大小，视频压缩速度，采用了[VideoProcessor](https://github.com/yellowcath/VideoProcessor)进行压缩。

视频压缩方式
* fps压缩：fps大于25的，控制在20
* 720P压缩：720P以上的视频进行720P压缩
* H264转码H265(HEIF): 在相机视频取景时，配置支持HEIF格式或针对所有视频文件转码为H265编码

## 三.fps压缩

```android

 void fpsCompressVidio(File file) {

        String sourcePath = file.getPath();
        String fileName = file.getName();
        long fileSize =  file.length()/1000;
        String resFilePath = fpsFilePath + fileName;
        Uri uri = Uri.parse(sourcePath);

        long duration = 0;
        int width = 0;
        int height = 0;
        float aveFrameRate = 0.0f;
        int frameRate = 0;
        try {
            MediaMetadataRetriever retriever = new MediaMetadataRetriever();
            retriever.setDataSource(this,uri);
            int bitrate = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_BITRATE));
            retriever.release();
            MediaExtractor extractor = new MediaExtractor();
            extractor.setDataSource(this,uri,null);
            MediaFormat format = extractor.getTrackFormat(VideoUtil.selectTrack(extractor, false));
            frameRate = format.containsKey(MediaFormat.KEY_FRAME_RATE) ? format.getInteger(MediaFormat.KEY_FRAME_RATE) : -1;
            aveFrameRate = VideoUtil.getAveFrameRate(new VideoProcessor.MediaSource(this,uri));
            width = format.getInteger(MediaFormat.KEY_WIDTH);
            height = format.getInteger(MediaFormat.KEY_HEIGHT);
            int rotation = format.containsKey(MediaFormat.KEY_ROTATION) ? format.getInteger(MediaFormat.KEY_ROTATION) : -1;
            duration = format.containsKey(MediaFormat.KEY_DURATION) ? format.getLong(MediaFormat.KEY_DURATION) : -1;
            String KEY_MIME= format.containsKey(MediaFormat.KEY_MIME) ? format.getString(MediaFormat.KEY_MIME) : "";
            String  videoInfo = String.format(Locale.ENGLISH,"size:%dX%d,framerate:%d,aveFrameRate:%f,rotation:%d,bitrate:%d,duration:%.1fs", width, height, frameRate,aveFrameRate, rotation, bitrate,
                    duration / 1000f / 1000f);

            extractor.release();

            Log.e("--testVidio",videoInfo);
        } catch (Exception e) {
            e.printStackTrace();
        }

        long startTimestamp = System.currentTimeMillis();

        if (frameRate > 25) {
            frameRate = 20;
        }

        final int tempFrameRate = frameRate;

        sharedExecutor.execute(new Runnable() {
            @Override
            public void run() {
                try {

                    VideoProcessor.processor(getApplicationContext())
                            .input(sourcePath)
                            .output(resFilePath)
                            .frameRate(tempFrameRate)
                            .progressListener(new VideoProgressListener() {
                                @Override
                                public void onProgress(float progress) {
                                    int intProgress = (int) (progress * 100);
                                    Log.e("-VideoProcessor:", String.valueOf(intProgress));

                                    uiAction(new Runnable() {
                                        @Override
                                        public void run() {
                                            tv_count.setText(fileName + "压缩进度:"+ intProgress + "%" );
                                        }
                                    });

                                    if (intProgress >=100) {

                                        long curTime = System.currentTimeMillis();
                                        long deltaTime = curTime - startTimestamp;

                                        String res = fileName + "压缩耗时为:" + deltaTime + "ms";
                                        Log.e("-VideoProcessor:", res);

                                    }
                                }
                            }).process();

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

```

## 四.720P压缩

```android

    void compressVideo(File file) {

        String sourcePath = file.getPath();
        String fileName = file.getName();
        String resFilePath = w_h_FilePath + fileName;
        
        long startTimestamp = System.currentTimeMillis();
        
        sharedExecutor.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    VideoProcessor.processor(getApplicationContext())
                            .input(sourcePath)
                            .output(resFilePath)
                            .outWidth(1280).outHeight(720)
                            .progressListener(new VideoProgressListener() {
                                @Override
                                public void onProgress(float progress) {
                                    int intProgress = (int) (progress * 100);
                                    Log.e("-VideoProcessor:", String.valueOf(intProgress));
                                    
                                    if (intProgress >=100) {

                                        long curTime = System.currentTimeMillis();
                                        long deltaTime = curTime - startTimestamp;

                                        String res = fileName + "压缩耗时为:" + deltaTime + "ms";
                                        Log.e("-VideoProcessor:", res);
                                    }
                                }
                            }).process();

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

```

## 五.视频文件转码为H265

```python
    def start_codec_compressed(self):

        if len(self.fps_list) == 0:
            return

        for file_path in self.fps_list:
            file_name = os.path.basename(file_path)
            dest_file_path = FfmpegManager.CODEC_DEST_FILE_PATH + file_name

            subprocess.run(["ffmpeg", "-i", file_path, "-c:v", "libx265", "-preset", "medium", "-x265-params", "crf=28", dest_file_path], check=True)
```
使用ffmpeg进行265转码验证下压缩效果

```terminal
python_fps/high 目录下所有文件大小:4367638719, 共4.0676805367693305G
python_fps/high_codec目录下所有文件大小:1686972766,共1.5711158197373152G
---所有视频文件采用H264转H265压缩方式的压缩率 = 61.38%
```

在Android设备中，在使用相机录制时，检查设备是否支持H.265编码？如果支持，对相机录制进行配置。如果不支持，使用H264编码。


#### 1.检查设备支持
检查设备是否支持 H.265 编码器,通过检查**CamcorderProfile**类中的**QUALITY_HEVC**属性来判断，例如：

```android
boolean isHEVCSupported = CamcorderProfile.hasProfile(CamcorderProfile.QUALITY_HEVC);
```

#### 2.配置 MediaRecorder

使用 MediaRecorder 对象进行录制时，你需要将视频编码器属性设置为 VideoEncoder.HEVC，例如：
```android
mediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.HEVC);
```

#### 3.配置CamcorderProfile类

如果你想使用 CamcorderProfile 类来设置摄像机参数，你可以将 videoCodec 属性设置为 MediaRecorder.VideoEncoder.HEVC，例如：
```android
CamcorderProfile camcorderProfile = CamcorderProfile.get(cameCamcorderProfile.QUALITY_HIGH);
camcorderProfile.videoCodec = MediaRecorder.VideoEncoder.HEVC;
```

## 六.结论

* fps压缩，效果不佳
* 720P压缩：效果有限
* 转码H265：如果设备支持，则相机录制视频时进行H265配置
