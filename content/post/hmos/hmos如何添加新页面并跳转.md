---
title: "HMOS如何添加新页面并跳转"
date: 2024-05-16T18:22:21+08:00
lastmod: 2024-05-16T18:22:21+08:00
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

### 1.新页面创建

```arkts
@Entry
@Component
struct UIContainerPage {
	private list = [
		"组件-常用组件",
		"组件-气泡和菜单",
		"页面路由",
		"组件导航",
		"页面路由",
		"显示图片",
		"绘制几何形状",
		"使用动画",
		"下拉刷新组件",
	]
	
	build() {
		Column() {
			Column() {
				Text("鸿蒙学习大纲").fontSize(16).align(Alignment.Center)
					.margin({ top: 10, bottom: 10 })
			}.height(40)

			List() {

				ForEach(this.list, (item: string) => {
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

### 2.json配置新页面

main_pages.json

```dart
{
  "src": [
    "pages/MainPage",
    "pages/Index",
    "pages/UIContainerPage"
  ]
}
```

### 3.路由跳转

```arkts
	handleButtonEvent(item: string) {
		let url: string = ''

		switch (item) {
			case "UI开发":
				url = 'pages/UIContainerPage'
				break;
			default:
				console.error(`No page found for item: ${item}`)
				return; 
		}

		if (null == url) {
			return
		}


		router.pushUrl({ url: url }, router.RouterMode.Standard, (err) => {
			if (err) {
				console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`)
				return
			}
			console.info('Invoke pushUrl succeeded.')
		});
	}
```

### 4.效果

![image](/images/hmos/hmos如何添加新页面并跳转/result.png)

### 5.其它

#### 5.1.问题

     0FEFE/JsApp: Invoke pushUrl failed, code is 100002, message is Uri error. The uri of router is not exist.

如果出现上述情况，去第三步检查下main_pages.json中，该页面是否配置？如果没有配置，添加即可。

