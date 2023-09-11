---
title: "Python腾讯COS SDK上传文件"
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

### 2.上传文件

```python
    
    def start_upload(self):
        asyncio.run(self.coroutine__upload_task())

    # 上传文件的任务    
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

            dest_urls.reverse()
            data_item.dest_image_urls = dest_urls
            self.thread_pool_executor.submit(self.task_write_log, data_item)

```

