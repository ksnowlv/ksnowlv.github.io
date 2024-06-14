---
title: "Hmos Arkts如何使用系统布局构建登陆页面"
date: 2024-05-26T13:59:21+08:00
lastmod: 2024-05-26T13:59:21+08:00
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


### 1.UI布局的核心

任何UI布局核心在于计算子控件的大小和位置,本质是指定子控件的上、下、左、右，这直接决定了子控件的位置和大小。

### 2.鸿蒙系统布局

鸿蒙提供了多种容器与布局，像线性布局(Row/Column)，层叠布局(Stack)，弹性布局(Flex)，相对布局(RelativeContainer)，列表，网格(Grid/GridItem)，栅格布局(GridRow/GridCol)等等


### 3.使用示例

#### 3.1 使用示例

```js
@Entry
@Component
struct LoginPage {
    TAG = 'LoginPage'
@State userAccount: string = ''
@State password: string = ''

@Builder
    navigationTitle() {
        Column() {
            Text('登陆')

                .fontColor('#182431')
                .fontSize(25)
                .lineHeight(41)
                .fontWeight(700)
        }
    }

    build() {
        Column() {
            Navigation() {
                this.buildPage()
            }.title(this.navigationTitle())
                .titleMode(NavigationTitleMode.Mini)

        }.width('100%')
            .height('100%')
    }

@Builder
    buildPage() {
        Column() {
            Image($rawfile('login/app_logo.png'))
                .width(100)
                .height(100)
                .margin({ top: 20, bottom: 20 })
            Text('测试APP')
                .fontSize(24)
                .fontColor('#FFBECEFA')

            Row() {
                Image($rawfile('login/account.png'))
                    .width(30)
                    .height(30)
                TextInput({ placeholder: '请输入账户名', })//
                    .width('100%')
                    .height('100%')
                    .backgroundColor(Color.Transparent)
                    .placeholderColor('#ffA0ACD4')
                    .fontColor('#ffA0ACD4')
                    .fontSize(20)
                    .borderColor(Color.Transparent)
                    .onFocus(() => {
                        console.info(this.TAG + '-账号输入框获取焦点')
                    })
                    .onChange((value: string) => {
                        this.userAccount = value
                        console.info(this.TAG + '-账号:' + this.userAccount)
                    })
                    .onSubmit((enterKey: EnterKeyType) => {
                        console.info(this.TAG + '-输入法回车键的类型值:' + enterKey)
                    })

            }
        .height(50)
                .width('90%')
                .padding({ left: 10, right: 40 })
                .margin({ top: 40 })
                .backgroundColor('#FFF0F5FD')

            Row() {
                Image($rawfile('login/password.png'))
                    .width(30)
                    .height(30)
                TextInput({ placeholder: '请输入密码', })//
                    .type(InputType.Password)
                    .width('100%')
                    .height('100%')
                    .backgroundColor(Color.Transparent)
                    .placeholderColor('#ffA0ACD4')
                    .fontColor('#ffA0ACD4')
                    .fontSize(20)
                    .onFocus(() => {
                        console.info(this.TAG + '-密码输入框获取焦点')
                    })
                    .onChange((value: string) => {
                        this.password = value
                        console.info(this.TAG + '-密码:' + this.password)
                    })
                    .onSubmit((enterKey: EnterKeyType) => {
                        console.info(this.TAG + '-输入法回车键的类型值:' + enterKey)
                    })
            }
        .height(50)
                .width('90%')
                .padding({ left: 10, right: 40 })
                .margin({ top: 10 })
                .backgroundColor('#FFF0F5FD')

            Button('登陆')
                .width('70%')
                .height(40)
                .margin({ top: 40 })
                .backgroundColor('#ff5B70CF')
                .fontColor(Color.White)
                .onClick(() => {
                    console.info(this.TAG + '-触发登陆事件')
                })

            Button('注册')
                .width('70%')
                .height(40)
                .margin({ top: 15 })
                .backgroundColor('#ffF8644E')
                .fontColor(Color.White)
                .onClick(() => {
                    console.info(this.TAG + '-触发注册事件')
                })

            Text('其他方式登录')
                .fontColor('#FFD5DFF2')
                .fontSize(13)
                .margin({ top: 30 })

            Row({ space: 10 }) {
                Image($rawfile('login/wechat.png'))
                    .width(30)
                    .height(30)
                    .onClick(() => {
                        console.info(this.TAG + '-触发微信分享事件')
                    })
                Image($rawfile('login/qq.png'))
                    .width(30)
                    .height(30)
                    .onClick(() => {
                        console.info(this.TAG + '-触发QQ分享事件')
                    })
                Image($rawfile('login/weibo.png'))
                    .width(30)
                    .height(30)
                    .onClick(() => {
                        console.info(this.TAG + '-触发微博分享事件')
                    })
            }
        .margin({ top: 20 })

        }
    .width('100%')
            .height('100%')

    }
}


```

### 4.效果

![image](/images/hmos/hmos-arkts如何使用系统布局构建登陆页面/result1.png)

![image](/images/hmos/hmos-arkts如何使用系统布局构建登陆页面/result1.png)

账号和密码输入后，日志如下
```shell
05-26 12:43:19.954  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号输入框获取焦点
05-26 12:43:24.832  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:1
05-26 12:43:25.745  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:15
05-26 12:43:27.229  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:151
05-26 12:43:28.361  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:1510
05-26 12:43:29.011  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:15109
05-26 12:43:29.646  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:151098
05-26 12:43:30.761  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:1510988
05-26 12:43:33.195  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:15109883
05-26 12:43:33.861  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:151098834
05-26 12:43:35.496  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:1510988341
05-26 12:43:35.651  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:15109883411
05-26 12:43:35.777  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:151098834111
05-26 12:43:44.667  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-账号:15109883411
05-26 12:43:46.883  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-密码输入框获取焦点
05-26 12:43:52.265  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-密码:1
05-26 12:43:52.946  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-密码:12
05-26 12:43:54.377  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-密码:123
05-26 12:43:55.214  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-密码:1234
05-26 12:43:55.836  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-密码:12345
05-26 12:43:56.511  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-密码:123456
05-26 12:44:10.276  15409-208    0FEFE/JsApp                                        com.example.base_demo                          I  LoginPage-输入法回车键的类型值:6

```


### 5.其它

#### 5.1.UI布局

UI布局是前端技术基础技能，给入门的演示下一些基本用法，提供个简单示例，上述示例主要是UI控件(图片，文本，按钮，输入框)，和Row/Column布局的组合使用。

#### 5.2.和其它平台对比

使用鸿蒙系统自带UI容器和布局，构建页面，是不是很自然？

是不是比Flutter简洁一些，比iOS/Android传统的UI布局也简洁高效，类似Android Compose和iOS swiftUI。


