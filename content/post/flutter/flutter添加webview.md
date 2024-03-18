---
title: "Flutter添加webview"
date: 2024-03-17T22:40:54+08:00
lastmod: 2024-03-17T22:40:54+08:00
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

## webview_flutter的使用

### 1.webview_flutter

官方链接见[https://pub-web.flutter-io.cn/packages/webview_flutter](https://pub-web.flutter-io.cn/packages/webview_flutter)

On iOS the WebView widget is backed by a WKWebView. On Android the WebView widget is backed by a WebView.
### 2.pubspec.yaml添加依赖

```yaml
  webview_flutter: ^4.7.0
```

### 3.示例

```dart
 import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewWidget extends StatefulWidget {
  final String url;

  const WebviewWidget({super.key, required this.url});

  @override
  WebviewWidgetState createState() => WebviewWidgetState();
}

class WebviewWidgetState extends State<WebviewWidget> {
  late WebViewController _webViewController;
  late String pageTitle = '';

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {},
        onProgress: (progress) {},
        onPageFinished: (url) {
          updatePageTitle();
        },
        onHttpAuthRequest: (request) {},
        onWebResourceError: (error) {
          debugPrint('''
                Page resource error:
                  code: ${error.errorCode}
                  description: ${error.description}
                  errorType: ${error.errorType}
                  isForMainFrame: ${error.isForMainFrame}
                          ''');
        },
        onNavigationRequest: (request) {
          debugPrint('allowing navigation to ${request.url}');

          return NavigationDecision.navigate;
        },
        onUrlChange: (change) {
          debugPrint('url change to ${change.url}');
        },
      ))
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (p0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(p0.message)),
          );
        },
      );
    
    loadHttpRequest(widget.url);
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

  //当 canPop 为 true，则系统返回手势将导致封闭的 Navigator 照常接收弹出。会调用 onPopInvoked，此时didPop为true。
  //当 canPop 为 false，则系统返回手势不会将路由从封闭的 Navigator 中弹出，但仍然会调用 onPopInvoked 方法,此时 didPop 为 false，此时进行逻辑判断或者插入其他需要执行的代码，如果需要返回则再执行 Navigator.of(context).pop();
  //注意此时 onPopInvoked 又会被再次调用，但此时 didPop 为 true。
  //因此，在onPopInvoked中，需要判断一下 didPop，如果为 true, 则 return。

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
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: WebViewWidget(controller: _webViewController),
        floatingActionButton: favoriteButton(),
      ),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      onPressed: () async {
        final String? url = await _webViewController.currentUrl();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('收藏 $url')),
          );
        }
      },
      child: const Icon(Icons.favorite),
    );
  }

  Future<void> loadHttpRequest(String url) async {
    await _webViewController.loadRequest(Uri.parse(url));
  }
}

```
