---
title: "Hmos如何添加顶部tab页面"
date: 2024-05-21T19:23:45+08:00
lastmod: 2024-05-21T19:23:45+08:00
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


### 1.Tabs组件

Tabs组件的页面组成包含两个部分，分别是TabContent和TabBar。TabContent是内容页，TabBar是导航页签栏.

根据不同的导航类型，布局会有区别，可以分为底部导航、顶部导航、侧边导航，其导航栏分别位于底部、顶部和侧边


### 2.示例代码

```artts
 @Entry
@Component
struct TabsPage {
	@State private selectedIndex: number = 0;
	private controller: TabsController = new TabsController()
	private itemList = [
		"关注",
		"视频",
		"游戏",
		"数码",
		"科技",
		"影视",
		"体育",
	]

	build() {
		Column() {
			//BarPosition.Start
			//BarPosition.End
			Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {

				ForEach(this.itemList, (item) => {
					TabContent() {
						Column() {
							Text(item)
								.fontSize(24)
								.fontColor(Color.White)
						}
						.width('100%')
						.height('100%') // 如果需要垂直居中，确保高度设置正确
						.alignItems(HorizontalAlign.Center) // 水平居中子组件
						.justifyContent(FlexAlign.Center) // 垂直居中子组件
						.backgroundColor(Color.Green)
					}
					.tabBar({
						text: item
					})

				})
			}
			// .vertical(true) //开启侧边导航栏
			// .barWidth(100) //开启侧边导航栏，设置barWidth
			// .barHeight(300) //开启侧边导航栏，设置barHeight
			.barWidth('100%') // 开启顶部/底部导航栏，设置TabBar宽度
			.barHeight(60) // 开启顶部/底部导航栏，设置TabBar高度
			.width('100%') // 设置Tabs组件宽度
			.height('100%') // 设置Tabs组件高度
			.backgroundColor(0xffADD8E6) // 设置Tabs组件背景颜色
			.onChange((index: number) => {
				this.selectedIndex = index;
				console.info(`${this.selectedIndex} `);
			}
			)

		}
		.width('100%')
		.height('100%')

	}
}
 ```

### 3.效果

#### 开启顶部导航的情况

```artts
.barWidth('100%') // 开启顶部/底部导航栏，设置TabBar宽度
.barHeight(60) // 开启顶部/底部导航栏，设置TabBar高度
```
效果如下

![image](/images/hmos/hmos如何添加顶部tab页面/result1.png)

#### 开启侧边导航的情况

```artts
 .vertical(true) //开启侧边导航栏，默认是不开启侧边导航栏的
 .barWidth(100) //开启侧边导航栏，设置barWidth
 .barHeight(300) //开启侧边导航栏，设置barHeight
```
效果如下

![image](/images/hmos/hmos如何添加顶部tab页面/result1.png)

