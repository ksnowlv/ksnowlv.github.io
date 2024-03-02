---
title: "Fastapi关于kafka消息组件的使用"
date: 2023-11-27T19:47:36+08:00
lastmod: 2023-11-27T19:47:36+08:00
keywords: ["Fastapi", "kafka", "消息组件", "后端开发"]
tags: ["Fastapi", "后端开发"]
categories: ["Fastapi", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## FastApi中kafka的使用


### 1.confluent-kafka的安装

```shell
 pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --upgrade confluent-kafka 
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple/
Collecting confluent-kafka
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/25/7d/d8ef2b94cf076a1f5427de51389d710550290e62b385abdd983cc57b3691/confluent_kafka-2.3.0-cp311-cp311-macosx_10_9_x86_64.whl (3.4 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 3.4/3.4 MB 704.4 kB/s eta 0:00:00
Installing collected packages: confluent-kafka
Successfully installed confluent-kafka-2.3.0

```

### 2.Kafka生产者及消费者创建


CONSUMER_GROUP_ID = "my_consumer_group"  # 自定义消费者组 ID

#### Kafka 服务器配置
kafka_conf = {
'bootstrap.servers': 'localhost:9092',
'group.id': CONSUMER_GROUP_ID  # 添加消费者组 ID
}
#### 创建 Kafka 生产者
producer = Producer(kafka_conf)

#### 创建 Kafka 消费者
consumer = Consumer(kafka_conf)


### 3.Kafka生产者发送消息

```python
def send_message(topic: str, message: str):
    producer.produce(topic, value=message)
    producer.flush()
    return {"message": "Message sent to Kafka topic"}

```

### 4.Kafka消费者消费消息
```python
def consume_messages(topic: str):
    consumer.subscribe([topic])

    while True:
        msg = consumer.poll(1.0)
        print(f"msg = {msg}")
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                print(f"KafkaError._PARTITION_EOF")
                continue
            else:
                raise KafkaException(msg.error())
        value = msg.value().decode("utf-8")
        consumer.commit()
        return {"consume_messages message": value}

```

### 5.完整示例代码

```python

from fastapi import APIRouter
from confluent_kafka import Producer, Consumer, KafkaError, KafkaException

router = APIRouter(
    prefix="/kafka",
    tags=["kafka测试接口"],
    responses={404: {"description": "Not found"}},
)

CONSUMER_GROUP_ID = "my_consumer_group"  # 自定义消费者组 ID

# Kafka 服务器配置
kafka_conf = {
    'bootstrap.servers': 'localhost:9092',
    'group.id': CONSUMER_GROUP_ID  # 添加消费者组 ID
}
# 创建 Kafka 生产者
producer = Producer(kafka_conf)

# 创建 Kafka 消费者
consumer = Consumer(kafka_conf)

@router.post("/send_message/{topic}")
def send_message(topic: str, message: str):
    producer.produce(topic, value=message)
    producer.flush()
    return {"message": "Message sent to Kafka topic"}

@router.get("/consume_messages/{topic}")
def consume_messages(topic: str):
    consumer.subscribe([topic])

    while True:
        msg = consumer.poll(1.0)
        print(f"msg = {msg}")
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                print(f"KafkaError._PARTITION_EOF")
                continue
            else:
                raise KafkaException(msg.error())
        value = msg.value().decode("utf-8")
        consumer.commit()
        return {"consume_messages message": value}

```

### 6.执行效果
```shell
2023-11-27 19:59:15.499 | INFO     | app.core.xlogger:dispatch:30 - Request: GET http://127.0.0.1:8081/kafka/consume_messages/age Headers({'host': '127.0.0.1:8081', 'sec-fetch-site': 'same-origin', 'accept-encoding': 'gzip, deflate', 'connection': 'keep-alive', 'sec-fetch-mode': 'cors', 'accept': 'application/json', 'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15', 'referer': 'http://127.0.0.1:8081/docs', 'sec-fetch-dest': 'empty', 'accept-language': 'zh-CN,zh-Hans;q=0.9'})
2023-11-27 19:59:15.502 | DEBUG    | app.core.xlogger:dispatch:33 - Request query_params: {}
msg = None
msg = None
msg = None
msg = None
msg = None
msg = None
2023-11-27 19:59:22.315 | INFO     | app.core.xlogger:dispatch:30 - Request: POST http://127.0.0.1:8081/kafka/send_message/age?message=10 Headers({'host': '127.0.0.1:8081', 'sec-fetch-site': 'same-origin', 'accept-encoding': 'gzip, deflate', 'accept-language': 'zh-CN,zh-Hans;q=0.9', 'sec-fetch-mode': 'cors', 'accept': 'application/json', 'origin': 'http://127.0.0.1:8081', 'content-length': '0', 'connection': 'keep-alive', 'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15', 'referer': 'http://127.0.0.1:8081/docs', 'sec-fetch-dest': 'empty'})
2023-11-27 19:59:22.319 | DEBUG    | app.core.xlogger:dispatch:33 - Request query_params: {'message': '10'}
msg = None
msg = <cimpl.Message object at 0x10fdb1140>
2023-11-27 19:59:22.804 | ERROR    | app.core.xlogger:dispatch:46 - total time cost: 0.48857784271240234
2023-11-27 19:59:22.805 | INFO     | app.core.xlogger:dispatch:50 - Response status code: 200 Response headers: MutableHeaders({'content-length': '47', 'content-type': 'application/json'})
2023-11-27 19:59:22.806 | ERROR    | app.core.xlogger:dispatch:46 - total time cost: 7.306714057922363
2023-11-27 19:59:22.807 | INFO     | app.core.xlogger:dispatch:50 - Response status code: 200 Response headers: MutableHeaders({'content-length': '35', 'content-type': 'application/json'})
2023-11-27 19:59:22.813 | INFO     | app.core.xlogger:dispatch:55 - Response Body: b'{"message":"Message sent to Kafka topic\xef\xbc\x9aage"}'
2023-11-27 19:59:22.816 | INFO     | app.core.xlogger:dispatch:55 - Response Body: b'{"consume topic: age message":"10"}'
2023-11-27 19:59:37.587 | INFO     | app.core.xlogger:dispatch:30 - Request: GET http://127.0.0.1:8081/kafka/consume_messages/phone Headers({'host': '127.0.0.1:8081', 'sec-fetch-site': 'same-origin', 'accept-encoding': 'gzip, deflate', 'connection': 'keep-alive', 'sec-fetch-mode': 'cors', 'accept': 'application/json', 'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15', 'referer': 'http://127.0.0.1:8081/docs', 'sec-fetch-dest': 'empty', 'accept-language': 'zh-CN,zh-Hans;q=0.9'})
2023-11-27 19:59:37.591 | DEBUG    | app.core.xlogger:dispatch:33 - Request query_params: {}
msg = None
msg = None
msg = None
msg = None
msg = None
msg = None
msg = None
msg = None
2023-11-27 19:59:46.464 | INFO     | app.core.xlogger:dispatch:30 - Request: POST http://127.0.0.1:8081/kafka/send_message/phone?message=152 Headers({'host': '127.0.0.1:8081', 'sec-fetch-site': 'same-origin', 'accept-encoding': 'gzip, deflate', 'accept-language': 'zh-CN,zh-Hans;q=0.9', 'sec-fetch-mode': 'cors', 'accept': 'application/json', 'origin': 'http://127.0.0.1:8081', 'content-length': '0', 'connection': 'keep-alive', 'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15', 'referer': 'http://127.0.0.1:8081/docs', 'sec-fetch-dest': 'empty'})
2023-11-27 19:59:46.465 | DEBUG    | app.core.xlogger:dispatch:33 - Request query_params: {'message': '152'}
msg = None
msg = <cimpl.Message object at 0x10fe69c40>
2023-11-27 19:59:46.874 | ERROR    | app.core.xlogger:dispatch:46 - total time cost: 0.4104759693145752
2023-11-27 19:59:46.876 | INFO     | app.core.xlogger:dispatch:50 - Response status code: 200 Response headers: MutableHeaders({'content-length': '49', 'content-type': 'application/json'})
2023-11-27 19:59:46.877 | ERROR    | app.core.xlogger:dispatch:46 - total time cost: 9.290580987930298
2023-11-27 19:59:46.877 | INFO     | app.core.xlogger:dispatch:50 - Response status code: 200 Response headers: MutableHeaders({'content-length': '38', 'content-type': 'application/json'})
2023-11-27 19:59:46.878 | INFO     | app.core.xlogger:dispatch:55 - Response Body: b'{"message":"Message sent to Kafka topic\xef\xbc\x9aphone"}'
2023-11-27 19:59:46.879 | INFO     | app.core.xlogger:dispatch:55 - Response Body: b'{"consume topic: phone message":"152"}'
2023-11-27 19:59:54.660 | INFO     | app.core.xlogger:dispatch:30 - Request: GET http://127.0.0.1:8081/kafka/consume_messages/name Headers({'host': '127.0.0.1:8081', 'sec-fetch-site': 'same-origin', 'accept-encoding': 'gzip, deflate', 'connection': 'keep-alive', 'sec-fetch-mode': 'cors', 'accept': 'application/json', 'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15', 'referer': 'http://127.0.0.1:8081/docs', 'sec-fetch-dest': 'empty', 'accept-language': 'zh-CN,zh-Hans;q=0.9'})
2023-11-27 19:59:54.660 | DEBUG    | app.core.xlogger:dispatch:33 - Request query_params: {}
msg = <cimpl.Message object at 0x10fe6a4c0>
2023-11-27 19:59:54.933 | WARNING  | app.core.xlogger:dispatch:48 - total time cost: 0.2732861042022705
2023-11-27 19:59:54.933 | INFO     | app.core.xlogger:dispatch:50 - Response status code: 200 Response headers: MutableHeaders({'content-length': '41', 'content-type': 'application/json'})
2023-11-27 19:59:54.934 | INFO     | app.core.xlogger:dispatch:55 - Response Body: b'{"consume topic: name message":"ksnowlv"}'


```
