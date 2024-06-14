---
title: "鸿蒙 arkts如何使用属性动画"
date: 2024-05-29T20:08:59+08:00
lastmod: 2024-05-29T20:08:59+08:00
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

### 1.属性动画
通过可动画属性改变引起UI上产生的连续视觉效果，即为属性动画。属性动画是最基础易懂的动画，

ArkUI提供两种属性动画接口`animateTo`和`animation`驱动组件属性按照动画曲线等动画参数进行连续的变化，产生属性动画。

|  属性动画接口 | 作用域  | 原理	  | 使用场景  |
|---|---|---|---|
| animateTo  |闭包内改变属性引起的界面变化。作用于出现消失转场。   | 通用函数，对闭包前界面和闭包中的状态变量引起的界面之间的差异做动画。支持多次调用，支持嵌套。  |  适用对多个可动画属性配置相同动画参数的动画。需要嵌套使用动画的场景。 |
|  animation | 组件通过属性接口绑定的属性变化引起的界面变化。  |  识别组件的可动画属性变化，自动添加动画。组件的接口调用是从下往上执行，animation只会作用于在其之上的属性调用。 组件可以根据调用顺序对多个属性设置不同的animation。 | 适用于对多个可动画属性配置不同参数动画的场景。  |

使用animateTo产生属性动画

`    animateTo(value: AnimateParam, event: () => void): void
`
animateTo接口参数中
* value指定动画参数（包括时长、曲线等）
* event为动画的闭包函数，闭包内变量改变产生的属性动画将遵循相同的动画参数。

### 2.示例

三个小动画示例：旋转，平稳，放缩

```js
	@Builder
	buildPage() {
		List() {
			ListItem() {

				Column({ space: 10 }) {


					Text('通过可动画属性改变引起UI上产生的连续视觉效果，即为属性动画。属性动画是最基础易懂的动画，ArkUI提供两种属性动画接口animateTo和animation驱动组件属性按照动画曲线等动画参数进行连续的变化，产生属性动画')
						.width('80%')
					Column() {
						Text('ArkUI')
							.fontSize(25)
							.fontColor(Color.White)
					}
					.justifyContent(FlexAlign.Center)
					.width(100)
					.height(100)
					.borderRadius(10)
					.rotate({ angle: this.rotateValue })
					.backgroundColor(Color.Green)

					Column() {
						Text('ArkUI')
							.fontSize(25)
							.fontColor(Color.White)

					}
					.justifyContent(FlexAlign.Center)
					.width(100)
					.height(100)
					.backgroundColor(Color.Red)
					.borderRadius(10)
					.opacity(this.opacityValue)
					.translate({ x: this.translateX })

					Column() {
						Text('ArkUI')
							.fontSize(25)
							.fontColor(Color.White)

					}
					.justifyContent(FlexAlign.Center)
					.width(100)
					.height(100)
					.backgroundColor(Color.Blue)
					.borderRadius(10)
					.scale({ x: this.scaleX, y: this.scaleY })

					Button('测试属性动画')
						.margin({ top: 50 })
						.onClick(() => {
							this.handleStartAimationEvent()
						})

				}.width('100%')
				.alignItems(HorizontalAlign.Center)
				.justifyContent(FlexAlign.Center)
			}

		}.width('100%')
		.height('100%')
	}
    
```

### 3.效果

#### 3.1.初始状态
![image](/images/hmos/hmos-arkts如何使用属性动画/reuslt1.png)

#### 3.2.动画状态
![image](/images/hmos/hmos-arkts如何使用属性动画/reuslt2.png)

#### 3.3.动画状态

![image](/images/hmos/hmos-arkts如何使用属性动画/reuslt3.png)


