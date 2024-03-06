---
title: "Flutter本地图片管理"
date: 2024-03-05T10:51:25+08:00
lastmod: 2024-03-05T10:51:25+08:00
keywords: ["flutter"]
tags: ["flutter"]
categories: ["flutter"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## Flutter本地图片管理

### 1.支持1x，2x，3x图片时

图片目录如下

images \
--1.png \
--x.png \
--2x\
----1.png \
----x.png \
--3x \
----1.png \
----x.png 


images目录下默认为1倍图，2x目录下为2倍图，3x目录下为3倍图

pubspec.yaml添加配置

```yaml
flutter:

  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  assets:
    - images/
```

### 2.支持2x，3x图片时

图片目录如下

images \
--1.png \
--x.png \
--3x \
----1.png \
----x.png

images目录下默认为2倍图，3x目录下为3倍图
pubspec.yaml添加配置

```yaml
flutter:

  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  assets:
    - images/
```


### 3.图片加载

```dart
Image.asset('images/home.png')

```

### 4.注意事项

* 没有1倍图时，无需创建2x图片目录，只需把2x图放置相应目录即可。
* images目录下，无论默认是加载2x图片，3x图片，需要有相应图片；2x，3x，3.5x目录可以没有。不然，会出现如下错误

      Image provider: AssetImage(bundle: null, name: "images/home.png")
      Image key: AssetBundleImageKey(bundle: PlatformAssetBundle#2a2d6(), name: "images/home.png", scale: 1.0)
      ════════════════════════════════════════════════════════════════════════════════
    
      ════════ Exception caught by image resource service ════════════════════════════
      Unable to load asset: "images/study.png".

