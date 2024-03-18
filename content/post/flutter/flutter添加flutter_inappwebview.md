---
title: "Flutter添加flutter_inappwebview"
date: 2024-03-18T09:46:10+08:00
lastmod: 2024-03-18T09:46:10+08:00
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

## flutter_inappwebview的使用

### 1.flutter_inappwebview

官方链接见[https://www.dhiwise.com/post/exploring-the-flutter-inappwebview-package](https://www.dhiwise.com/post/exploring-the-flutter-inappwebview-package)

支持iOS/Android/MacOS/Web

### 2.pubspec.yaml添加依赖

```yaml
    flutter_inappwebview: ^6.0.0
```

### 3.示例

```dart
 

  import 'package:flutter/material.dart';
  import 'package:flutter_inappwebview/flutter_inappwebview.dart';

  class FlutterInAppWebViewWidget extends StatefulWidget {
    final String url;

    const FlutterInAppWebViewWidget({super.key, required this.url});

    @override
    FlutterInAppWebViewWidgetState createState() =>
        FlutterInAppWebViewWidgetState();
  }

  class FlutterInAppWebViewWidgetState extends State<FlutterInAppWebViewWidget> {
    late InAppWebViewController _webViewController;
    String pageTitle = '';

    @override
    Widget build(BuildContext context) {
      return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) {
              return;
            }

            if (await _webViewController.canGoBack()) {
              await _webViewController.goBack();
              updatePageTitle();
            } else {
              if (!context.mounted) {
                return;
              }
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(pageTitle),
              actions: [
                IconButton(
                    onPressed: () async {
                      if (await _webViewController.canGoBack()) {
                        await _webViewController.goBack();
                        updatePageTitle();
                      }
                    },
                    icon: const Icon(Icons.arrow_back)),
                IconButton(
                    onPressed: () async {
                      if (await _webViewController.canGoForward()) {
                        await _webViewController.goForward();
                      }
                    },
                    icon: const Icon(Icons.arrow_forward)),
                IconButton(
                    onPressed: () {
                      _webViewController.reload();
                      updatePageTitle();
                    },
                    icon: const Icon(Icons.refresh)),
              ],
            ),
            body: InAppWebView(
              initialUrlRequest:
              URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  debugPrint('Page started loading: $url');
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  debugPrint('Page onLoadStop loading: $url');
                });
              },
              onProgressChanged: (controller, progress) {
                debugPrint('Page onProgressChanged loading progress: $progress');
              },
              onPageCommitVisible: (controller, url) {
                debugPrint('Page onPageCommitVisible url: $url');
              },
              onTitleChanged: (controller, title) {
                debugPrint('Page onTitleChanged title: $title');
                setState(() {
                  if (title != null) {
                    pageTitle = title;
                  }
                });
              },
            ),
          ));
    }

    void updatePageTitle() {
      _webViewController.getTitle().then((value) {
        setState(() {
          if (value != null) {
            pageTitle = value;
          }
        });
      });
    }
  }

```

### 4.其它

* 关于PopScope
  * 当 canPop 为 true，则系统返回手势将导致封闭的 Navigator 照常接收弹出。会调用 onPopInvoked，此时didPop为true。
  * 当 canPop 为 false，则系统返回手势不会将路由从封闭的 Navigator 中弹出，但仍然会调用 onPopInvoked 方法,此时 didPop 为 false，此时进行逻辑判断或者插入其他需要执行的代码，如果需要返回则再执行 Navigator.of(context).pop();
  * 注意此时 onPopInvoked 又会被再次调用，但此时 didPop 为 true。
  因此，在onPopInvoked中，需要判断一下 didPop，如果为 true, 则 return。
