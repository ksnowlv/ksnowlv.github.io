---
title: "鸿蒙arkts如何使用单次iO异步"
date: 2024-05-25T16:16:21+08:00
lastmod: 2024-05-25T16:16:21+08:00
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

### 单次iO异步

鸿蒙系统中，Promise和async/await提供异步并发能力，适用于单次I/O任务的场景开发，避免了对主线程的占用，减少了对主线程的阻塞

### 示例代码

#### 3.1 单次向文件写入字符串的文件IO任务

```js
	private async write(data: string, file: fs.File): Promise<void> {
		fs.write(file.fd, data).then((writeLen: number) => {
			console.info('write data length is: ' + writeLen)
		}).catch((err) => {
			console.error(`Failed to write data. err is ${err}`);
		})
	}

```

#### 3.2 async/await异步能力调用单次I/O任务

```js

async writeTextToFile(): Promise<void> {
    let context = getContext() as common.UIAbilityContext;
    let filePath: string = context.filesDir + "/test.txt";
    let file: fs.File = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    this.write('Hello World!', file).then(() => {
        console.info('Succeeded in writing data.');
    }).catch((err) => {
        console.error(`Failed to write data. Code is ${err}`);
        throw err
    }).finally(() => {
        if (file) {
            fs.close(file);
        }
    })
}


```

#### 3.3 调用

```js
    try {
        await this.writeTextToFile()
    } catch (error) {
        console.error('writeTextToFile 执行出错:', error);
    }
    
```

### 3.效果

```shell
05-25 16:26:50.081  10589-5947   0FEFE/JsApp                                        com.example.base_demo                          I  Succeeded in writing data.
05-25 16:26:50.082  10589-5947   04388/file_api                                     com.example.base_demo                          I  [file_entity.h:46->~FileEntity] Unlock succeeded inode = 123271
05-25 16:26:50.084  10589-5947   0FEFE/JsApp                                        com.example.base_demo                          I  write data length is: 12

```



