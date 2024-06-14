---
title: "Hmos如何添加页面内的导航"
date: 2024-05-21T17:40:05+08:00
lastmod: 2024-05-21T17:40:05+08:00
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


### 1.鸿蒙页面内的导航

Navigation组件一般作为页面的根容器，包括单页面、分栏和自适应三种显示模式。

Navigation组件适用于模块内页面切换，一次开发，多端部署场景。通过组件级路由能力实现更加自然流畅的转场体验，并提供多种标题栏样式来呈现更好的标题和内容联动效果。一次开发，多端部署场景下，Navigation组件能够自动适配窗口显示大小，在窗口较大的场景下自动切换分栏展示效果。


Navigation组件的页面包含主页和内容页。主页由标题栏、内容区和工具栏组成，可在内容区中使用NavRouter子组件实现导航栏功能。内容页主要显示NavDestination子组件中的内容。

NavRouter是配合Navigation使用的特殊子组件，默认提供点击响应处理，不需要开发者自定义点击事件逻辑。NavRouter有且仅有两个子组件，其中第二个子组件必须是NavDestination。NavDestination是配合NavRouter使用的特殊子组件，用于显示Navigation组件的内容页。当开发者点击NavRouter组件时，会跳转到对应的NavDestination内容区。


### 2.示例代码

```arkts 
@Entry
@Component
struct NavigationPage {
	private itemList: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

	build() {
		Column() {
			Navigation() {
				TextInput({ placeholder: 'search...' })
					.width("90%")
					.height(40)
					.backgroundColor('#FFFFFF')

				List({ space: 20 }) {
					ForEach(this.itemList, (item: string) => {
						ListItem() {
							NavRouter() {
								Text("NavRouter_" + item)
									.width("100%")
									.height(72)
									.backgroundColor('#FFFFFF')
									.borderRadius(20)
									.fontSize(16)
									.fontWeight(500)
									.textAlign(TextAlign.Center)
								NavDestination() {
									Text("Nav_Content_" + item).fontColor(Color.White).fontSize(16)
								}
								.title("Nav_title_" + item).backgroundColor(Color.Green)
							}
						}
					}, (item: string): string => item)
				}
				.width("90%")
				.margin({ top: 12 })
			}
			.title("主题")
			.mode(NavigationMode.Split)
			// .mode(NavigationMode.Stack)
			// .mode(NavigationMode.Auto)

		}
		.height('100%')
		.width('100%')
		.backgroundColor('#F1F3F5')
	}
}
```

注意mode的指定，分栏或栈式或自动，其效果不同。

### 3.效果

分栏的情况下

![image](/images/hmos/hmos如何添加页面内的导航/result1.png)

栈式或自动的情况下

![image](/images/hmos/hmos如何添加页面内的导航/result2.png)

![image](/images/hmos/hmos如何添加页面内的导航/result2.png)

