---
title: "Flutter添加网络库dio及示例"
date: 2024-03-18T18:24:15+08:00
lastmod: 2024-03-18T18:24:15+08:00
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


## dio的使用

### 1.dio

官方链接见[https://pub.dev/packages/dio](https://pub.dev/packages/dio)

支持iOS/Android/MacOS/Web/Linux/Windows

### 2.pubspec.yaml添加依赖

```yaml
  dio: ^5.4.1
```

### 3.示例

* network_service.dart
```dart

import 'package:base_demo/models/user/regist_request.dart';
import 'package:base_demo/models/user/regist_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class NetworkService {
  static final NetworkService _singleton = NetworkService._internal();

  factory NetworkService() {
    return _singleton;
  }

  NetworkService._internal();

  final Dio _dio = Dio();
  //     // 设置请求头
  // Map<String, String> headers = {
  //   "Content-Type": "multipart/form-data", // 设置Content-Type为application/json
  // };

  Map<String, String> jsonHeaders = {
    "Content-Type": "application/json",
    "Accept-Encoding": "gzip, deflate, br", // 设置Content-Type为application/json
  };

  void testGet() async {
    final response = await _dio.get('https://baidu.com');
    debugPrint("testGet:${response.toString()}");
  }

  void testHome() async {
    try {
      // 发起 GET 请求
      Response response = await _dio.get('http://127.0.0.1:8081/user/home');

      debugPrint(response.data.toString());
    } catch (e) {
      debugPrint('发生其他错误：$e');
    }
  }

  Future<RegistResponse?> testRegist() async {
    // 创建注册请求对象
    RegistRequest registRequest = RegistRequest(
      name: "ksnowlv",
      age: 10,
      phone: "15210795183",
      verificationCode: "123456",
    );

    try {
      Response response = await _dio.post(
        "http://127.0.0.1:8081/user/regist",
        data: registRequest.toJson(),
        options: Options(headers: jsonHeaders),
      );

      debugPrint("response data: ${response.data.toString()}");

      RegistResponse registResponse = RegistResponse.fromJson(response.data);
      return registResponse;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    }
  }
}

```

* regist_request.dart

```dart
  class RegistRequest {
    final String name;
    final int age;
    final String phone;
    final String verificationCode;

    RegistRequest({required this.name, required this.age, required this.phone, required this.verificationCode});

    Map<String, dynamic> toJson() {
      return {
        'name': name,
        'age': age,
        'phone': phone,
        'verification_code': verificationCode,
      };
    }
  }
```

* regist_response.dart

```dart
  import 'package:base_demo/models/base_response.dart';

// 定义注册数据的 model 类
class RegistData {
  final int registResult;
  final String userid;
  final String token;

  RegistData({required this.registResult, required this.userid, required this.token});

  factory RegistData.fromJson(Map<String, dynamic> json) {
    return RegistData(
      registResult: json['registResult'],
      userid: json['userid'],
      token: json['token'],
    );
  }
}

class RegistResponse extends BaseResponse {
  final RegistData data;

  RegistResponse({required int code, required String message, required this.data})
      : super(code: code, message: message);

  factory RegistResponse.fromJson(Map<String, dynamic> json) {
    return RegistResponse(
      code: json['code'],
      message: json['message'],
      data: RegistData.fromJson(json['data']),
    );
  }
}

```


### 4.调用

```dart

  void handleLoginEvent() async {
    //NetworkService().testGet();
    NetworkService().testHome();
    RegistResponse? response = await NetworkService().testRegist();

    if (response != null) {
      debugPrint("注册成功，返回信息：${response.message}");
    } else {
      debugPrint("注册失败");
    }
  }
```

### 5.效果

```shell
Reloaded 1 of 1712 libraries in 792ms (compile: 63 ms, reload: 231 ms, reassemble: 403 ms).
flutter: {message: hello fastapitest}
flutter: response data: {code: 200, message: 请求成功, data: {registResult: 1, userid: eea37a05-68ca-46a5-8deb-9265df6cb9b6, token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJlZWEzN2EwNS02OGNhLTQ2YTUtOGRlYi05MjY1ZGY2Y2I5YjYiLCJleHAiOjE3MTMzNDkxOTd9.bEBT2eA2KrP59MMmg68iGpO8StxI4CklZ7eSR0VtVe8}}
flutter: 注册成功，返回信息：请求成功
```
