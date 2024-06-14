---
title: "Hmos Arkts如何添加下拉刷新组件 PullToRefresh"
date: 2024-05-25T14:54:52+08:00
lastmod: 2024-05-25T14:54:52+08:00
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





### 1.PullToRefresh

官方链接见[https://gitee.com/openharmony-sig/PullToRefresh](https://gitee.com/openharmony-sig/PullToRefresh)


### 2.添加依赖

```shell
  ohpm install @ohos/pulltorefresh
```

`oh-package.json5`版本修改为2.0.1

```json
{
  "name": "base_demo",
  "version": "1.0.0",
  "description": "Please describe the basic information.",
  "main": "",
  "author": "",
  "license": "",
  "dependencies": {
    "@ohos/pulltorefresh": "2.0.1"
  },
  "devDependencies": {
    "@ohos/hypium": "1.0.6"
  }
}
```

### 3.示例代码

#### 3.1 PullToRefreshPage测试页面

```js

import { PullToRefresh } from '@ohos/pulltorefresh'

@Entry
@Component
struct PullToRefreshPage {
    TAG = 'PullToRefreshPage'
@State itemList: string[] = ['北京', '天津', '上海', '深圳', '珠海', '厦门', '青岛', '大连', '威海', '烟台', '旅顺', '长春', '哈尔滨', '沈阳']
    private scroller: Scroller = new Scroller();

@Builder
    navigationTitle() {
        Column() {
            Text('城市')
                .fontColor('#182431')
                .fontSize(30)
                .lineHeight(41)
                .fontWeight(700)
        }.alignItems(HorizontalAlign.Start)
    }

@Builder
    buildList() {
        List({ space: 3, scroller: this.scroller }) {
            ForEach(this.itemList, (item, index) => {
                ListItem() {

                    Row() {
                        Image($r('app.media.icon'))
                            .width(40)
                            .height(40)
                            .margin({ left: 10, right: 20 })
                        Text(`${index}.${item}`).fontSize(20)

                    }.width('100%')
                        .height('100%')
                }
            .width('100%')
                    .height(60)
            })
        }
    .divider({ strokeWidth: 0.5, color: Color.Green, startMargin: 10, endMargin: 10 })
            .width('100%')
            // 特别注意：必须设置列表为滑动到边缘无效果，否则无法触发pullToRefresh组件的上滑下拉方法。
            .edgeEffect(EdgeEffect.None)

    }

    build() {
        Navigation() {

            PullToRefresh({
                // 必传项，列表组件所绑定的数据
                data: this.itemList,
                // 必传项，需绑定传入主体布局内的列表或宫格组件
                scroller: this.scroller,
                // 必传项，自定义主体布局，内部有列表或宫格组件
                customList: () => {
                    this.buildList()
                },
                // 可选项，下拉刷新回调
                onRefresh: () => {
                    console.info(`${this.TAG} onRefresh`)
                    return new Promise<string>((resolve, reject) => {
                        // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
                        console.info(`${this.TAG} Promise`)
                        setTimeout(() => {
                            resolve('刷新成功');
                            console.info(`${this.TAG} resolve`)
                            //this.itemList = this.dataNumbers;
                            const citys: string[] = ['上拉刷新出来的郑州', '上拉刷新出来的济南', '上拉刷新出来的沈阳']
                            this.itemList = this.itemList.concat(citys)
                            console.info(`${this.TAG} itemList:${this.itemList} `)
                        }, 1000);
                    });
                },
                // 可选项，上拉加载更多回调
                onLoadMore: () => {
                    return new Promise<string>((resolve, reject) => {
                        console.info(`${this.TAG} onLoadMore Promise`)
                        // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
                        setTimeout(() => {
                            console.info(`${this.TAG}  onLoadMore resolve`)
                            resolve('');
                            this.itemList.push('上拉加载出来的武汉')
                            console.info(`${this.TAG} onLoadMore itemList:${this.itemList} `)
                        }, 1000);
                    });
                },
                customLoad: null,
                customRefresh: null,
            })

        }
    .title(this.navigationTitle())
            .titleMode(NavigationTitleMode.Mini)
    }
}
```

### 3.2.注意事项

List必须设置滑动到边缘没有效果

```js
edgeEffect(EdgeEffect.None)
```

否则无法触发pullToRefresh组件的上滑下拉方法。

### 4.效果

![image](/images/hmos/Hmos_arkts如何添加下拉刷新组件_PullToRefresh/result.png)

菜单也可由长按触发，属于很常见的一种自定义菜单。