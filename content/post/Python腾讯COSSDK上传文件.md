---
title: "Python腾讯COS-SDK上传文件"
date: 2023-09-09T15:58:46+08:00
lastmod: 2023-09-09T15:58:46+08:00
keywords: ["Python", "COS SDK", "上传文件"]
tags: ["Python"]
categories: ["Python"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Python腾讯COSSDK上传文件

### 1.初始化腾讯COS SDK
```python
    config = CosConfig(Region=CosFileUpload.COS_BUCKET_REGION, SecretId=CosFileUpload.COS_SECRET_ID,
                           SecretKey=CosFileUpload.COS_SECRET_KEY, Token=token, Scheme=scheme)
    self.client = CosS3Client(config)
    self.ks_ids = self.load_upload_res_file()
    self.upload_data_items = self.load_ks_res_file()

```

### 2.使用协程上传文件

因为视频文件有两个，所以上传任务两个一组进行上传；

```python

    # 使用协程上传文件
    def start_upload(self):
        asyncio.run(self.coroutine__upload_task())
    
    # 上传单个文件的任务
    async def task_upload_file(self, ks_id, file_path):
    
        file_name = os.path.basename(file_path)
    
        key = ks_id + '/' + file_name
    
        # 上传文件
        response = self.client.upload_file(
            Bucket=CosFileUpload.COS_BUCKET_NAME,
            Key=key,
            LocalFilePath=file_path,
            EnableMD5=False,
            progress_callback=None
        )
    
        print(f"response = {response}")
    
        if response.get("ETag") is None:
            return None
    
        tag = response["ETag"]
        print(f"response ETag = {tag}")
    
        # 获取上传文件的下载地址
        url = self.client.get_object_url(
            Bucket=CosFileUpload.COS_BUCKET_NAME,
            Key=key
        )
    
        return url

    async def  coroutine__upload_task(self):

        for data_item in self.upload_data_items:
            # 两个文件上传
            uploadload_files = (os.path.join(CosFileUpload.UPLOAD_FILE_DIR, data_item.ks_id + "_1001.mp4"),
                                os.path.join(CosFileUpload.UPLOAD_FILE_DIR, data_item.ks_id + "_2001.mp4"))

            tasks =[asyncio.create_task(self.task_upload_file(data_item.ks_id, item)) for item in uploadload_files]

            (dones, pending) = await asyncio.wait(tasks)

            dest_urls = []
            for done in dones:
                print(f"task result = {done.result()}")
                if done.result() is None:
                    continue
                else:
                    dest_urls.append(done.result())

            if len(dest_urls) != 2:
                return
            dest_urls.sort()
            data_item.dest_image_urls = dest_urls
            self.thread_pool_executor.submit(self.task_write_log, data_item)

```

### 3.上传任务过滤-本地已上传文件记录

如果上传任务已完成，会在本地生成一个记录文件;该记录文件每条记录有7个属性，选择第3个属性为惟一key，并添加到集合中

```python
    def load_upload_res_file(self):

        ks_ids = set()
        with open(CosFileUpload.UPLOAD_TXT_FILE, "r") as txt_file:

            for line in txt_file:
                data = line.strip().split(',')

                if len(data) == 7:
                    ks_ids.add(data[2])

        return ks_ids
```

### 4.上传任务过滤-本地视频文件

下载目录下和上传目录下文件都同时存在的视频文件才会上传。

```python
    def load_ks_res_file(self):

    data_items = []
    count_exist_file = 0
    count_file_not_all_exist = 0
    duplicate_items = set()
    count_duplicate_item = 0

    with open(CosFileUpload.INPUT_TXT_FILE, "r") as txt_file:

        for line in txt_file:
            data = line.strip().split(',')

            if len(data) == 5:

                allfiles = [os.path.join(CosFileUpload.DOWNLOAD_FILE_DIR, data[2] + "_1001.mp4"),
                            os.path.join(CosFileUpload.DOWNLOAD_FILE_DIR, data[2] + "_2001.mp4"),
                            os.path.join(CosFileUpload.UPLOAD_FILE_DIR, data[2] + "_1001.mp4"),
                            os.path.join(CosFileUpload.UPLOAD_FILE_DIR, data[2] + "_2001.mp4"),]
                all_exist = all(os.path.exists(file) for file in allfiles)

                if all_exist:

                    if data[2] not in self.ks_ids:
                        data_item = DataItem()
                        data_item.data = data
                        data_item.set_data_item(data[0], data[1], data[2], [data[3], data[4]])
                        data_items.append(data_item)
                    else:
                        count_exist_file += 1
                        #print(f"第{count_exist_file}条数据已经存在：{data}不需要上传")

                        if data[2] in duplicate_items:
                            count_duplicate_item += 1
                            print(f"第{count_duplicate_item}条重复数据项:{data}")
                        else:
                            duplicate_items.add(data[2])
                else:
                    count_file_not_all_exist += 1
                    #print(f"第{count_file_not_all_exist}条数据：{data}文件不全")

    return data_items
```

