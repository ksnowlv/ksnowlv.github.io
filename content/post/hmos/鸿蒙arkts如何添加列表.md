---
title: "HMOS Arkts如何添加列表"
date: 2024-05-13T15:31:31+08:00
lastmod: 2024-05-13T15:31:31+08:00
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


### 1.List组件

list组件是移动端开发经常使用的一个组件，本文是在首页添加了一个列表，按照官方文档，记录下后续鸿蒙学习内容，不分先后

* UI开发
* ARKTS语言基础类库
* 通知
* 媒体
* 安全
* 网络与连接
* 电话服务
* 数据管理
* 文件管理
* 后台任务
* 设备管理
* DFX
* 国际化和本地化
* 应用服务
* 一次开发，多端部署
* Native API(NDK)
* 性能
* 工具




### 2.示例

### 2.1.HomePage.ets

```arkts
@Component
export default struct HomePage {
	private itemList = [
		"UI开发",
		"ARKTS语言基础类库",
		"通知",
		"媒体",
		"安全",
		"网络与连接",
		"电话服务",
		"数据管理",
		"文件管理",
		"后台任务",
		"设备管理",
		"DFX",
		"国际化和本地化",
		"应用服务",
		"一次开发，多端部署",
		"Native API(NDK)",
		"性能",
		"工具",
	]

	build() {
		Column() {
			Column() {
				Text("鸿蒙学习大纲").fontSize(16).align(Alignment.Center)
					.margin({ top: 10, bottom: 10 })
			}.height(40)

			List() {

				ForEach(this.itemList, (item: string) => {
					ListItem() {

						Button(item, { type: ButtonType.Normal, stateEffect: true })
							.borderRadius(10)
							.backgroundColor(0xff31abff)
							.width('70%')
							.height(30)
							.align(Alignment.Center)
							.onClick(() => {
								console.info("您进入{}部分学习", item)
							})
					}
					.width('100%')
					.height(40)
				})
			}
			.alignListItem(ListItemAlign.Start)
		}.backgroundColor(Color.White)
	}
}


```

### 2.2.MainPage.ets

```arkts
    TabContent() {
       HomePage().width('100%').height('100%').backgroundColor(Color.White)
    }.tabBar({
        icon: $r('app.media.home'),
        text: '首页'
    })
```

### 3.效果

![image](/images/hmos/鸿蒙arkts如何添加列表/result.png)

### 4.其它

为什么不使用兼容JS的类Web开发？可以先了解下ARKTS与它的区别；后续鸿蒙开发关于类Web开发内容会很少涉及。
