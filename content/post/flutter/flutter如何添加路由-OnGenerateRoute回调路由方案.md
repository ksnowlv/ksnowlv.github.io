---
title: "Flutter如何添加路由-OnGenerateRoute回调路由方案"
date: 2024-04-24T15:19:03+08:00
lastmod: 2024-04-24T15:19:03+08:00
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

flutter项目中，可以在 `MaterialApp` 的构造函数中直接定义路由映射表。每个路由由一个字符串标识符和一个对应的页面组件构成；但是，随着应用的扩展，路由表可能会变得庞大和难以管理。

因此，该方案不再赘述，接下来我们体验下大家最常见的**onGenerateRoute回调路由方案**

### 1.onGenerateRoute回调路由方案

#### 1.1.优点
    
* 允许你动态生成路由，可以根据需要加载模块。
* 适合中小型应用，它可以将路由逻辑分离到不同的文件或模块中。

#### 1.2.缺点

* 如果应用过大，可能会导致 `onGenerateRoute` 回调特别臃肿，变得特别复杂。

### 2.创建RouteGenerator路由表


```dart
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    
    final arguments = settings.arguments as Map<String,dynamic>?;

    debugPrint('---RouteGenerator RouteSettings: ${settings.name} ， arguments $arguments');

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage(title: "Home"));
      case '/home/basecontainerpage':
        return MaterialPageRoute(
            builder: (_) =>
                BaseContainerPage(title: arguments?['title']?? ""));
  
      default:
        debugPrint('---RouteGenerator RouteSettings:2 ${settings.name}');debugPrint('---RouteGenerator RouteSettings: ${settings.name}');
        return onUnknownRoute(RouteSettings(name: '${settings.name}'));
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('UnknownRoute'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('找不到${settings.name}页面， 404,稍候再试'),
        ),
      ),
    );
  }
}

```

### 3.创建页面组件BaseContainerPage

```dart

class BaseContainerPage extends StatefulWidget {
  final String title;
  const BaseContainerPage({super.key, required this.title});

  @override
  State<BaseContainerPage> createState() => _BaseContainerPageState();
}

class _BaseContainerPageState extends State<BaseContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemExtent: 60,
        itemCount: WidgetPageType.values.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          final pageType = WidgetPageType.values[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Text(_getPageTypeText(pageType)),
                  onPressed: () {
                    _showWidgetPage(context, pageType);
                  }
                  ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }
}

```

### 4.onGenerateRoute调用

```dart

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Router',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      onGenerateRoute: RouteGenerator().generateRoute,
    );
  }
}

```

### 5.router调用

```dart
void _onShowPage(
    BuildContext context, HomePageRouteType pageRouteType) async {

    final routerName = _routerFromPageType(pageRouteType);
    final title = _titleFromPageType(pageRouteType);
  
    if (routerName.isEmpty|| title.isEmpty) {
      return;
    }

    if (!context.mounted) {
      return;
    }
    
    await Navigator.pushNamed(context, routerName, arguments: {"title": title, "pageType": pageRouteType.name,});
  }
```

### 6.小结

#### 6.1.路由及页面管理 
* 可以将路由逻辑分离到不同的文件或模块中，保持代码的可维护性和可扩展性。
* 如果页面组件不在相应的文件夹，需要将组件名称和文件路径匹配起来，以免出错。

#### 6.2.关于路由参数传递

我们使用的是Map<String,dynamic>进行传递，仅作示例；也可以直接传递自定义对象，页面直接接收自定义对象即可；







