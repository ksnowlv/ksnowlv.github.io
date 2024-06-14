---
title: "Flutter如何添加路由 Bloc和Cubit路由方案"
date: 2024-04-25T10:07:03+08:00
lastmod: 2024-04-25T10:07:03+08:00
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


flutter项目中，除了OnGenerateRoute回调路由方案，基于flutter_bloc和bloc库不仅可以用于实现基于Bloc模式的状态管理，也可以用于实现导航路由方案。

bloc库提供了Bloc和Cubit类，用于管理业务逻辑和应用程序状态，而flutter_bloc库则提供了BlocProvider和BlocConsumer等Widget，用于与Bloc和Cubit进行集成。

接下来介绍下基于Bloc和Cubit路由方案的路由方案。


### 1.创建路由状态管理器

**router_cubit.dart**

```dart
/*
 * RouterInfo 类用于存储路由信息。
 * 
 * @param route 可选参数，表示路由的路径。
 * @param params 可选参数，表示路由中携带的参数，以键值对形式存储。
 */
class RouterInfo {
  // 路由路径
  String? route;
  // 路由参数
  Map<String, String>? params;

  /*
   * RouterInfo 类的构造函数。
   * 
   * @param route 路由路径，可以为空。
   * @param params 路由参数，以键值对形式存储，可以为空。
   */
  RouterInfo(this.route, this.params);
}


/*
 * 路由器状态管理器类，继承自Cubit，用于管理应用程序的路由信息。
 */
class RouterCubit extends Cubit<RouterInfo> {
  /*
   * 构造函数：初始化RouterCubit状态。
   */
  RouterCubit() : super(RouterInfo(null, null));

  /*
   * 导航到指定的路由页面，并带上参数。
   * 
   * @param route 要导航到的路由名称。
   * @param params 路由参数，以键值对形式提供。
   */
  void navigateTo(String route, Map<String, String> params) {

    debugPrint('HomeCubit :$route, params:$params');
    RouterInfo routerInfo = RouterInfo(route, params);
    emit(routerInfo);
  }
}

```

### 2.BlocConsumer监听状态变化

使用**BlocConsumer**来监听状态变化，并执行页面导航。

```dart

import 'package:bloc_router_demo/router_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RouterCubit, RouterInfo>(
      listener: (context, state) {
        if (state.route != null) {
          Navigator.of(context)
              .pushNamed(state.route!, arguments: state.params);
        }
      },
      builder: (context, state) {
        return _buildHomePage(context);
      },
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<RouterCubit>().navigateTo('/details', {'title': '详情', 'content': '我是详情页'});
                },
                child: const Text('跳转详情'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    context.read<RouterCubit>().navigateTo('/view', {'title': '查看', 'content': '我是查看页'});
                  },
                  child: const Text('跳转查看')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    context.read<RouterCubit>().navigateTo('/favorite', {
                      'title': '收藏',
                    });
                  },
                  child: const Text('跳转收藏')),
            ],
          ),
        ));
  }
}


```

### 3.跳转页面处理

**details_page.dart**

```dart
// 首页模块的详情页面
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final Map<dynamic,dynamic>?arguments = ModalRoute.of(context)?.settings.arguments as Map<dynamic,dynamic>?;

    return Scaffold(
      appBar: AppBar(title: Text(arguments?['title']??'')),
      body: Center(child: Text(arguments?['content']??'')),
    );
  }
}

```

其它页面类似.

### 4.RouterCubit注入应用

创建提供RouterCubit的MultiBlocProvider，将RouterCubit注入整个应用程序，以便在整个应用中，可以使用RouterCubit来管理路由信息。


```dart

void main() {

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create:(context) => RouterCubit()),

  ], child: const MyApp()));
}

```

### 5.小结

基于Bloc的路由方案与基于onGenerateRoute回调路由方案相比

#### 5.1 优点
  * 1.状态管理：基于Bloc的路由方案，将导航信息存储在状态中，实现强大的状态管理和逻辑封装，减少页面之间的耦合性。
  * 2.业务逻辑分离解耦：使用Bloc，将导航逻辑与界面分离，将导航信息放在状态中，减少页面之间的耦合，使得页面之间的通信更加清晰和灵活；将导航逻辑封装在Cubit中，可以更加专注于界面渲染和用户交互，而不需要处理导航逻辑。
  * 3.代码复用：通过Bloc和Cubit，实现路由的共享和重用，提高代码的可维护性和可重用性。
  * 4.更灵活的跳转：基于Bloc的路由方案可以更灵活地处理导航逻辑，根据不同的状态决定是否跳转到特定的页面。

#### 5.2 不足
  * 1.复杂性：与onGenerateRoute回调相比，使用Bloc的路由方案，会增加一些复杂性，需要一定的学习成本。
  * 2.性能开销：Bloc的状态管理，可能带来一定的性能开销，相对于简单的路由回调，对性能可能有一定影响。
  * 3.额外代码：使用Bloc的路由方案，需要编写更多的代码，处理状态管理和监听状态变化；相对于简单回调，会增加一些冗余代码。

#### 5.3 路由方案选择
* 根据应用的复杂度、团队经验、性能要求等因素进行权衡。
* 基于Bloc的路由方案适合大型复杂应用，对简单应用，显得繁琐。

#### 5.4 关于路由表

像前文OnGenerateRoute回调路由方案，提到的路由表，可以参考下。


