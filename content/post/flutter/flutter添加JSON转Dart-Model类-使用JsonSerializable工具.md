---
title: "Flutter添加JSON转Dart Model类使用JsonSerializable工具"
date: 2024-04-19T14:06:37+08:00
lastmod: 2024-04-19T14:06:37+08:00
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


### 1.JSON转Dart-Model类使用JsonSerializable

我们使用官方推荐的json_serializable。 它是一个自动化的源代码生成器，可以在开发阶段为我们生成JSON序列化模板，不需我们手动维护，将运行时产生JSON序列化异常的风险降至最低。


### 2.pubspec.yaml引入插件依赖

```yaml

dependencies:
  flutter:
  sdk: flutter
    
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  build_runner: ^2.4.9
  
flutter:
  assets:
    - assets/images/
    - assets/lottie/
    - assets/audio/
    - assets/txt/
    - assets/json/

```

### 3.JSON转Dart-Model类示例

article_info.json内容如下
```json
{
  "article": {
    "id": 1234,
    "title": "Flutter JSON数据处理示例",
    "content": "在Flutter中处理JSON数据的详细示例",
    "author": {
      "id": 1234,
      "name": "ksnow"
    },
    "tags": [
      "Flutter",
      "JSON",
      "Dart"
    ],
    "comments": [
      {
        "id": 1,
        "text": "非常详细，谢谢分享！",
        "author": {
          "id": 1235,
          "name": "lucy"
        }
      },
      {
        "id": 2,
        "text": "JSON数据处理，非常好用",
        "author": {
          "id": 1236,
          "name": "jack"
        }
      }
    ]
  }
}

```


通过[https://caijinglong.github.io/json2dart/index.html](https://caijinglong.github.io/json2dart/index.html)转换为Dart-Model类。


ArticleInfo.dart

```dart
import 'package:json_annotation/json_annotation.dart';

part 'article_info.g.dart';


@JsonSerializable(explicitToJson: true)
class ArticleInfo extends Object {

  @JsonKey(name: 'article')
  Article article;

  ArticleInfo(this.article,);

  factory ArticleInfo.fromJson(Map<String, dynamic> srcJson) => _$ArticleInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ArticleInfoToJson(this);

}


@JsonSerializable(explicitToJson: true)
class Article extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'author')
  Author author;

  @JsonKey(name: 'tags')
  List<String> tags;

  @JsonKey(name: 'comments')
  List<Comments> comments;

  Article(this.id,this.title,this.content,this.author,this.tags,this.comments,);

  factory Article.fromJson(Map<String, dynamic> srcJson) => _$ArticleFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

}


@JsonSerializable(explicitToJson: true)
class Author extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  Author(this.id,this.name,);

  factory Author.fromJson(Map<String, dynamic> srcJson) => _$AuthorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);

}


@JsonSerializable(explicitToJson: true)
class Comments extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'text')
  String text;

  @JsonKey(name: 'author')
  Author author;

  Comments(this.id,this.text,this.author,);

  factory Comments.fromJson(Map<String, dynamic> srcJson) => _$CommentsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentsToJson(this);

}





```

看转换后的Author有两个，明显的BUG，去掉一个即可。

那为什么JsonSerializable要添加explicitToJson: true呢？请思考下为什么？


### 4.根据ArticleInfo自动生成article_info.g.dart文件

使用**dart run build_runner build**命令生成**article_info.g.dart**文件


```shell
(base) ksnowlv@MacBook-Pro-3 base_demo % dart  run build_runner build
Building package executable... (11.5s)
Built build_runner:build_runner.
[INFO] Generating build script completed, took 601ms
[INFO] Precompiling build script... completed, took 6.4s
[INFO] Building new asset graph completed, took 2.1s
[INFO] Found 1 declared outputs which already exist on disk. This is likely because the`.dart_tool/build` folder was deleted, or you are submitting generated files to your source repository.
Delete these files?
1 - Delete
2 - Cancel build
3 - List conflicts
1
[INFO] Checking for unexpected pre-existing outputs. completed, took 5m 54s
[INFO] Generating SDK summary completed, took 7.6s
[WARNING] source_gen:combining_builder on lib/models/article_info.dart:
article_info.g.dart must be included as a part directive in the input library with:
    part 'article_info.g.dart';
[INFO] Running build completed, took 34.3s
[INFO] Caching finalized dependency graph completed, took 454ms
[INFO] Succeeded after 34.8s with 152 output

```

### 5.调用

```dart
void _jsonWithJsonSerializable() async {
  try {
    // 加载本地 JSON 文件
    String data =
    await rootBundle.loadString('assets/json/article_info.json');
    Map<String, dynamic> jsonMap = json.decode(data);
    ArticleInfo articleInfo = ArticleInfo.fromJson(jsonMap);
    debugPrint('---jsonWithJsonSerializable:反序列化JSON---');
    debugPrint(
        '反序列化后articleInfo对象  { id :${articleInfo.article.id} title: ${articleInfo.article.title}}, content: ${articleInfo.article.content}  }');

    for (var comment in articleInfo.article.comments) {
      debugPrint(
          '反序列化后comment对象  { id :${comment.id} text: ${comment.text}}, author: ${comment.author.name}  }');
    }

    for (var tag in articleInfo.article.tags) {
      debugPrint('反序列化后tag对象  :$tag');
    }

    debugPrint('---jsonWithJsonSerializable:序列化对象articleInfo---');
    Map<String, dynamic> userJson = articleInfo.toJson();
    debugPrint('序列化后Json数据: ${json.encode(userJson)}');
  } catch (e) {
    debugPrint('JSON deserialization error:$e');
  }
}
```

### 6.效果

```shell
flutter: ---jsonWithJsonSerializable:反序列化JSON---
flutter: 反序列化后articleInfo对象  { id :1234 title: Flutter JSON数据处理示例}, content: 在Flutter中处理JSON数据的详细示例  }
flutter: 反序列化后comment对象  { id :1 text: 非常详细，谢谢分享！}, author: lucy  }
flutter: 反序列化后comment对象  { id :2 text: JSON数据处理，非常好用}, author: jack  }
flutter: 反序列化后tag对象  :Flutter
flutter: 反序列化后tag对象  :JSON
flutter: 反序列化后tag对象  :Dart
flutter: ---jsonWithJsonSerializable:序列化对象articleInfo---
flutter: 序列化后Json数据: {"article":{"id":1234,"title":"Flutter JSON数据处理示例","content":"在Flutter中处理JSON数据的详细示例","author":{"id":1234,"name":"ksnow"},"tags":["Flutter","JSON","Dart"],"comments":[{"id":1,"text":"非常详细，谢谢分享！","author":{"id":1235,"name":"lucy"}},{"id":2,"text":"JSON数据处理，非常好用","author":{"id":1236,"name":"jack"}}]}}
```

### 6.其它

为什么各个数据类添加@JsonSerializable(explicitToJson: true)？可以思考下
