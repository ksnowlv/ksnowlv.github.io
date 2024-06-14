---
title: "Hmos如何播放视频-使用Video组件"
date: 2024-05-24T15:50:55+08:00
lastmod: 2024-05-24T15:50:55+08:00
keywords: ["HMOS"]
tags: ["HMOS"]
categories: ["HMOS"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.视频播放

鸿蒙系统中，关于视频播放，可以使用上层视频组件Video。

参数如下

* src
  *  视频播放源的路径，支持本地视频路径和网络路径。
     支持在resources下面的video或rawfile文件夹里放置媒体资源。
     支持dataability://的路径前缀，用于访问通过Data Ability提供的视频路径，具体路径信息详见 DataAbility说明。
    - 支持file:///data/storage路径前缀的字符串，用于读取应用沙箱路径内的资源。需要保证目录包路径下的文件有可读权限。
      说明：视频支持的格式是：mp4、mkv、webm、TS。
  
* currentProgressRate
  * 视频播放倍速。
    说明： number取值仅支持：0.75，1.0，1.25，1.75，2.0。
    默认值：1.0 | PlaybackSpeed.Speed_Forward_1_00_X
* previewUri
  * 视频未播放时的预览图片路径，默认不显示图片。

* controller
  * 设置视频控制器，可以控制视频的播放状态。

 ### 2.视频资源

* 本地视频资源
  * 存放在resources/rawfile目录下，例如：本文使用test.mp4文件，那本地视频文件路径可指定为`localVideo: Resource = $rawfile('test.mp4')`

* 网络视频资源 
  * 提供url视频文件地址即可，本文不提供，读者自行选择即可 

### 3.示例代码

```arkts
import router from '@ohos.router';

@Entry
@Component
struct VideoPage {
	TAG = 'VideoPage'
	localVideoController: VideoController = new VideoController()
	netVideoController: VideoController = new VideoController()
	localVideo: Resource = $rawfile('test.mp4')
	videoUrl = 'https://cmsvideo4.pg0.cn/group4/M00/13/0B/CgoN4mDdkX6AUcEYAESOlJKkmcM401.mp4'
	@State currentTime: number = 0;
	@State durationTime: number = 0;

	@Builder
	navigationTitle() {
		Column() {
			Text('视频播放')
				.fontColor('#182431')
				.fontSize(30)
				.lineHeight(41)
				.fontWeight(700)
		}.alignItems(HorizontalAlign.Start)
	}

	@Builder
	buildPage() {

		List() {
			ListItem() {
				Column({ space: 10 }) {
					Video({
						src: this.localVideo,
						controller: this.localVideoController
					}).autoPlay(true)
						.width('90%')
						.height(200)

					Button('开始播放')
						.onClick((event) => {
							console.info(`${this.TAG}  onClick `)
							this.localVideoController.start();
						})
						.width('80%')

					Video({
						src: this.videoUrl,
						controller: this.netVideoController
					})
						.muted(false)//设置是否静音
						.controls(true)//设置是否显示默认控制条
						.autoPlay(false)//设置是否自动播放
						.loop(false)//设置是否循环播放
						.objectFit(ImageFit.Contain)//设置视频适配模式
						.width('90%')
						.height(200)
						.onPrepared((event) => {
							if (event) {
								console.info(`${this.TAG} onSeeked duration:${event.duration}`)
								this.durationTime = event.duration
							}
						})
						.onStart(() => {
							console.info(`${this.TAG} onStart `)
						})
						.onSeeked((event) => {
							if (event) {
								console.info(`${this.TAG}  onSeeked time:${event.time}`)
							}
						})
						.onUpdate((event) => {
							if (event) {
								console.info(`${this.TAG}  onUpdate time:${event.time}`)
								this.currentTime = event.time
							}
						})
						.onPause(() => {
							console.info(`${this.TAG}  onPause `)
						})
						.onFinish(() => {
							console.info(`${this.TAG}  onFinish `)
						})
						.onError(() => {
							console.info(`${this.TAG}  onError `)
						})

					Row() {
						Text(JSON.stringify(this.currentTime) + 's')
						Slider({
							value: this.currentTime,
							min: 0,
							max: this.durationTime
						})
							.onChange((value: number, mode: SliderChangeMode) => {
								this.netVideoController.setCurrentTime(value);
							}).width("80%")
						Text(JSON.stringify(this.durationTime) + 's')
					}.alignItems(VerticalAlign.Center)
					.justifyContent(FlexAlign.Center)
					.opacity(0.8)
					.width("90%")

					Button('开始播放')
						.onClick((event) => {
							console.info(`${this.TAG}  onClick `)
							this.netVideoController.start();
						})
						.width('80%')

					Button('播放视频')
						.onClick((event) => {
							router.pushUrl({
								url: 'pages/CommonWidget/FullPage',
								params: { videoSrc: this.videoUrl, videoTime: this.currentTime }
							})
						})
						.width('80%')

				}.width('100%')
				.alignItems(HorizontalAlign.Center)
				.justifyContent(FlexAlign.Center)
			}
		}
	}

	build() {
		Column() {
			Navigation() {
				this.buildPage()
			}.title(this.navigationTitle())
			.titleMode(NavigationTitleMode.Full)

		}.width('100%')
		.height('100%')
	}
}
```

### 4.效果

![image](/images/hmos/hmos如何播放视频-使用Video组件/result.png)

### 5.其它

#### 5.1.应用权限问题

遗憾的是上述示例并不能播放视频，问题出现在哪里呢？

本地视频播放，需要`ohos.permission.MODIFY_AUDIO_SETTINGS`和`ohos.permission.READ_MEDIA`两个权限

网络视频播放，需要`ohos.permission.INTERNET`网络权限

在module.json5文件添加即可

```json
 "requestPermissions": [
      {
        "name": "ohos.permission.INTERNET",
        "usedScene": {
          "when": "always"
        },

      },
      {
        "name": "ohos.permission.MODIFY_AUDIO_SETTINGS",
        "usedScene": {
          "when": "always"
        }
      },
      {
        "name": "ohos.permission.READ_MEDIA",
        "usedScene": {
          "when": "always"
        }
      }
    ]
```