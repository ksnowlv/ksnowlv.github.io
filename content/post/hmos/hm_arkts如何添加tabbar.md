---
title: "鸿蒙arkts如何添加tabbar"
date: 2024-05-10T20:39:42+08:00
lastmod: 2024-05-10T20:39:42+08:00
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


### 1.tabbar组件

tabbar组件是移动端开发经常使用的一个组件，底部固定工具栏，顶部tab工具栏等。

### 2.示例

```arkts


  @Entry
  @Component
  struct MainPage {
    @State private selectedIndex: number = 0;
    private controller: TabsController = new TabsController()

    build() {

      Column() {

        Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
          TabContent() {
            Column().width('100%').height('100%').backgroundColor(Color.White)
          }
          .tabBar({
            icon:$r('app.media.home'),
            text: '首页'
          })

          TabContent() {
            Column().width('100%').height('100%').backgroundColor(Color.White)
          }
          .tabBar({
            icon: $r('app.media.plugin'),
            text: '插件'
          })

          TabContent() {
            Column().width('100%').height('100%').backgroundColor(Color.White)
          }
          .tabBar( {
            icon: $r('app.media.mine'),
            text: '我的'
          })
        }
        .barWidth('100%') // 设置TabBar宽度
        .barHeight(60) // 设置TabBar高度
        .width('100%') // 设置Tabs组件宽度
        .height('100%') // 设置Tabs组件高度
        .backgroundColor(0xffADD8E6) // 设置Tabs组件背景颜色
        .onChange( (index: number) => {
          this.selectedIndex = index;
        }
        )
      }
      .width('100%')
      .height('100%')

    }

    switchTab(type: number) {
      this.controller.changeIndex(3);
    }
  }

```

### 3.效果

![image](/images/hmos/hm_arkts如何添加tabbar/result.png)

