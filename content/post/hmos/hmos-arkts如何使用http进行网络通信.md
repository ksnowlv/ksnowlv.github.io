---
title: "鸿蒙arkts如何使用http进行网络通信"
date: 2024-05-27T14:37:45+08:00
lastmod: 2024-05-27T14:37:45+08:00
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

### 1.鸿蒙http模块

鸿蒙官方提供'@ohos.net.http'模块，它支持应用通过HTTP发起一个数据请求，支持常见的`GET`、`POST`、`OPTIONS`、`HEAD`、`PUT`、`DELETE`、`TRACE`、`CONNECT`方法。

在实际应用场景中，`GET`、`POST`使用较多，因此，基于这两种请求方式，封装简单的`http`工具库



### 2.http工具库示例

```js
xport class HttpInterface {
	static readonly TAG = 'HttpInterface'
	static readonly HTTP_READ_TIMEOUT = 90 * 1000; //90ms
	static readonly HTTP_CONNECT_TIMEOUT = HttpInterface.HTTP_READ_TIMEOUT;
	static readonly CONTENT_TYPE_HEADER = {
		'Content-Type': 'application/json'
	}

	static httpRequest(
		url: string,
		params?: string | Object | ArrayBuffer,
		header?: Object
	): Promise<HttpResponseResult> {
		// 每一个httpRequest对应一个HTTP请求任务，不可复用
		const request = http.createHttp();

		let method = http.RequestMethod.POST

		if (params == null || params == undefined) {
			method = http.RequestMethod.GET
			console.info(`${HttpInterface.TAG} http get request url  :${url}, httpHeader:${JSON.stringify(header)}`)
		} else {
			console.info(`${HttpInterface.TAG} http post request url  :${url}, httpHeader:${JSON.stringify(header)} params:${JSON.stringify(params)}`)
		}

		const responseResult = request.request(url, {
			// 超时时间
			readTimeout: HttpInterface.HTTP_READ_TIMEOUT,
			connectTimeout: HttpInterface.HTTP_CONNECT_TIMEOUT,
			method,
			extraData: params,
			header: { ...HttpInterface.CONTENT_TYPE_HEADER, ...header },
		});

		let httpResponseResult: HttpResponseResult = new HttpResponseResult();

		return responseResult.then((data: http.HttpResponse) => {
			console.info(`${HttpInterface.TAG}  httpStatus code :${data.responseCode}, response httpheader:${JSON.stringify(data.header)} `)
			const responseCode = data.responseCode
			httpResponseResult.data = data.result

			if (responseCode === http.ResponseCode.OK) {
				httpResponseResult.resultType = HttpResponseResultType.SUCCESS

			} else if (responseCode >= http.ResponseCode.INTERNAL_ERROR) {
				httpResponseResult.resultType = HttpResponseResultType.SERVICE_ERROR

			} else if (responseCode >= http.ResponseCode.BAD_REQUEST) {
				httpResponseResult.resultType = HttpResponseResultType.CLIENT_ERROR
			} else {
				httpResponseResult.resultType = HttpResponseResultType.OTHER_ERROR
			}

			return httpResponseResult;

		}).catch((err) => {
			//
			console.error(`${HttpInterface.TAG} response error: ${JSON.stringify(err)}`)
			httpResponseResult.resultType = HttpResponseResultType.EXCEPTION
			httpResponseResult.data = JSON.stringify(err)
			return httpResponseResult

		}).finally(() => {
			console.info(`${HttpInterface.TAG} response finish httpResponseResult ---resultType: ${httpResponseResult.resultType},data:${httpResponseResult.data} }`)
			// 当该请求使用完毕时，调用destroy方法主动销毁
			request.destroy();
		})
	}
}

```

### 3.http工具库调用

#### 3.1.鸿蒙前端`http get`调用

```js
httpGet() {

		//const url = 'http://127.0.0.1:8081/user/home'
		const url = 'http://10.0.2.2:8081/user/home'
		HttpInterface.httpRequest(url).then(response => {
			if (response.resultType === HttpResponseResultType.SUCCESS) {
				console.info(`${this.TAG} httpRequest 请求成功数据: ${JSON.stringify(response.data)}`)
				this.getResponseData = JSON.stringify(response.data)
			} else {
				console.info(`${this.TAG} httpRequest 请求失败数据: ${response.resultType} error:${JSON.stringify(response.data)}`)
			}
		}).catch(err => {
			console.info(`${this.TAG} httpRequest 请求失败 error:${JSON.stringify(err)}`)
		})
	}

```

#### 3.2.后端`http get`测试接口

```python
@router.get('/home')
async def home():
    return  {"code":200,'message': "hello fastapitest", "data": {"name":"ksnowlv","age":"20"}}

```

#### 3.3.鸿蒙前端`http post`调用

```js

	httpPost() {
		// const url = 'http://127.0.0.1:8081/user/test'
		const url = 'http://10.0.2.2:8081/user/test'
		const pageInfo = {
			"pageIndex": 0,
			"pageNumber": 10
		}

		HttpInterface.httpRequest(url, pageInfo).then(response => {
			if (response.resultType === HttpResponseResultType.SUCCESS) {
				console.log(`${this.TAG} httpRequest 请求成功数据: ${JSON.stringify(response.data)}`)
				this.postResponseData = JSON.stringify(response.data)
			} else {
				console.log(`${this.TAG} httpRequest 请求失败数据: ${response.resultType} error:${JSON.stringify(response.data)}`)
			}
		}).catch(err => {
			console.info(`${this.TAG} httpRequest 请求失败 error:${JSON.stringify(err)}`)

		})
	}

```

#### 3.4.后端`http post`调用

```python
class PageInfo(BaseModel):
    pageIndex: int
    pageNumber: int


@router.post('/test')
async def home(info:PageInfo):

    # return {'message': "Hello user"}
    xlogger.info(f"test pageIndex :{info.pageIndex},pageNumber {info.pageNumber}")

    return  {"code":200,'message': "hello fastapitest", "data": {"totolNum":1000,"pageNum":info.pageNumber, "pageIndex":info.pageIndex,"newsList":[{"title":"热门新闻", "subTitle":"北京新闻，新能源车","descption":"这是北京新闻"}]}}

```

### 4.效果

#### 4.1.鸿蒙前端


控制台关于HttpInterface日志情况

```shell
05-27 14:28:24.667  17156-153    0FEFE/JsApp                    com.example.base_demo           I  HttpInterface http get request url  :http://10.0.2.2:8081/user/home, httpHeader:undefined
05-27 14:28:25.003  17156-153    0FEFE/JsApp                    com.example.base_demo           I  HttpInterface  httpStatus code :200, response httpheader:{"content-length":"79","content-type":"application/json","date":"Mon, 27 May 2024 06:28:25 GMT","server":"uvicorn"}
05-27 14:28:25.004  17156-153    0FEFE/JsApp                    com.example.base_demo           I  HttpInterface response finish httpResponseResult ---resultType: 1,data:{"code":200,"message":"hello fastapitest","data":{"name":"ksnowlv","age":"20"}} }
05-27 14:29:39.440  17156-153    0FEFE/JsApp                    com.example.base_demo           I  HttpInterface http post request url  :http://10.0.2.2:8081/user/test, httpHeader:undefined params:{"pageIndex":0,"pageNumber":10}
05-27 14:29:39.708  17156-153    0FEFE/JsApp                    com.example.base_demo           I  HttpInterface  httpStatus code :200, response httpheader:{"content-encoding":"gzip","content-length":"187","content-type":"application/json","date":"Mon, 27 May 2024 06:29:39 GMT","server":"uvicorn","vary":"Accept-Encoding"}
05-27 14:29:39.708  17156-153    0FEFE/JsApp                    com.example.base_demo           I  HttpInterface response finish httpResponseResult ---resultType: 1,data:{"code":200,"message":"hello fastapitest","data":{"totolNum":1000,"pageNum":10,"pageIndex":0,"newsList":[{"title":"热门新闻","subTitle":"北京新闻，新能源车","descption":"这是北京新闻"}]}} }

```

页面显示效果

![image](/images/hmos/hmos-arkts如何使用http进行网络通信/result.png)

### 4.2 后端控制台

```shell

2024-05-27 14:28:25.642 | INFO     | app.core.xlogger:dispatch:30 - Request: GET http://10.0.2.2:8081/user/home Headers({'host': '10.0.2.2:8081', 'user-agent': 'libcurl-agent/1.0', 'accept': '*/*', 'accept-encoding': 'gzip', 'content-type': 'application/json'})
2024-05-27 14:28:25.644 | DEBUG    | app.core.xlogger:dispatch:33 - Request query_params: {}
2024-05-27 14:28:25.645 | WARNING  | app.core.xlogger:dispatch:48 - total time cost: 0.003578662872314453
2024-05-27 14:28:25.645 | INFO     | app.core.xlogger:dispatch:50 - Response status code: 200 Response headers: MutableHeaders({'content-length': '79', 'content-type': 'application/json'})
2024-05-27 14:28:25.646 | INFO     | app.core.xlogger:dispatch:55 - Response Body: b'{"code":200,"message":"hello fastapitest","data":{"name":"ksnowlv","age":"20"}}'
2024-05-27 14:29:40.318 | INFO     | app.core.xlogger:dispatch:30 - Request: POST http://10.0.2.2:8081/user/test Headers({'host': '10.0.2.2:8081', 'user-agent': 'libcurl-agent/1.0', 'accept': '*/*', 'accept-encoding': 'gzip', 'content-type': 'application/json', 'content-length': '31'})
2024-05-27 14:29:40.319 | DEBUG    | app.core.xlogger:dispatch:33 - Request query_params: {}
2024-05-27 14:29:40.321 | INFO     | app.api.users.userrouter:home:37 - test pageIndex :0,pageNumber 10
2024-05-27 14:29:40.322 | WARNING  | app.core.xlogger:dispatch:48 - total time cost: 0.0038661956787109375
2024-05-27 14:29:40.322 | INFO     | app.core.xlogger:dispatch:50 - Response status code: 200 Response headers: MutableHeaders({'content-length': '206', 'content-type': 'application/json'})
2024-05-27 14:29:40.323 | INFO     | app.core.xlogger:dispatch:55 - Response Body: b'{"code":200,"message":"hello fastapitest","data":{"totolNum":1000,"pageNum":10,"pageIndex":0,"newsList":[{"title":"\xe7\x83\xad\xe9\x97\xa8\xe6\x96\xb0\xe9\x97\xbb","subTitle":"\xe5\x8c\x97\xe4\xba\xac\xe6\x96\xb0\xe9\x97\xbb\xef\xbc\x8c\xe6\x96\xb0\xe8\x83\xbd\xe6\xba\x90\xe8\xbd\xa6","descption":"\xe8\xbf\x99\xe6\x98\xaf\xe5\x8c\x97\xe4\xba\xac\xe6\x96\xb0\xe9\x97\xbb"}]}}'
```

### 5.其它

#### 5.1.为什么json不直接做解析？
http重点是通信，不包含数据适配层，json不直接做解析可由数据适配层负责处理；如果是其它格式的数据，也是数据适配层处理。

#### 5.2. HTTP请求任务

HTTP请求任务，因不可复用，所以，没有做任务池复用及调度。可以自己做个任务池不复用，控制请求任务的调度；如果是等待中的重复任务，可以做些优化策略。


### 5.3.网络访问权限

项目中需要配置ohos.permission.INTERNET权限。

