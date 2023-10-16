---
title: "Python爬虫关于静态验证码识别"
date: 2023-10-12T19:33:30+08:00
lastmod: 2023-10-12T19:33:30+08:00
keywords: ["Python", "爬虫", "静态验证码", "识别"]
tags: ["Python", "爬虫"]
categories: ["Python", "爬虫"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一.静态验证码识别

### 1.静态验证码

![image](/images/post/python爬虫关于静态验证码识别/verification_code.png)

如果点击验证码或请求该验证码链接，会重新请求新的验证码。在这种情况下，如何识别该验证码？

思路： 需要截屏整个网页，计算该验证码UI元素在网页中的位置及大小；并从整个网页截图中扣除该验证码图片，然后使用ocr识别

此处识别验证码使用ddddocr识别库，识别准确率挺高的。


### 2.示例代码

```python
 self.driver.get(WebPageAutoClick.URL)
        wait = WebDriverWait(self.driver, WebPageAutoClick.TIME_OUT)
        login_element = wait.until(EC.visibility_of_element_located((By.XPATH, "//div[@class='login-main-box']")))

        # login_element = self.driver.find_element(By.XPATH, "//div[@class='login-main-box']")
        # 使用 XPath 定位手机号码输入框
        phone_input = login_element.find_element(By.XPATH, "//input[@placeholder='手机号码']")
        # 使用 XPath 定位密码输入框
        password_input = login_element.find_element(By.XPATH, "//input[@placeholder='密码']")
        # 使用 XPath 定位验证码输入框
        code_input = login_element.find_element(By.XPATH, "//input[@placeholder='验证码']")
        # 查找登录按钮
        login_button = login_element.find_element(By.XPATH,"//div[@class='common-btn-auto mt40']")
        # 使用 XPath 定位验证码图片，
        captcha_image = login_element.find_element(By.XPATH, "//img[@id='kapimg']")

        # 获取验证码图片，采用直接截屏整个网页，然后，获取验证码图片显示的位置及大小，从整个大图上扣出验证码图片进行识别。
        # 为什么不采用网络请求验证码图片呢？通过图片链接再次请求时，验证码会改变。

        #截屏网页，并保存图片
        self.driver.save_screenshot(WebPageAutoClick.WEBPAGE_SCREENSHOT_IMAGE)
        screenshot_image = Image.open(WebPageAutoClick.WEBPAGE_SCREENSHOT_IMAGE)
        # 获取网页的宽与高，用来计算图片的分辨率
        self.window_width = self.driver.execute_script("return window.innerWidth")
        self.window_height = self.driver.execute_script("return window.innerHeight")
        # 计算图片分辨率
        scale = screenshot_image.size[0] / self.window_width

        # 获取验证码x,y轴坐标
        location = captcha_image.location
        # 获取验证码的长宽
        size = captcha_image.size
        # 写成我们需要截取的位置坐标
        rangle = (scale * int(location['x']),
                  scale * int(location['y']),
                  scale * int(location['x'] + size['width']),
                  scale * int(location['y'] + size['height']))

        verification_image = screenshot_image.crop(rangle)
        verification_image = verification_image.convert('RGB')
        # 保存我们截取的验证码图片，并读取验证码内容
        verification_image.save(WebPageAutoClick.VERIFICATION_CODE_IMAGE)

        with open(WebPageAutoClick.VERIFICATION_CODE_IMAGE, 'rb') as image_file:
            image_bytes = image_file.read()

        #使用ocr识别验证码图片，图片识别率挺高的。
        ocr = ddddocr.DdddOcr()
        text = ocr.classification(image_bytes)

        print("识别到的验证码：", text)

        if len(text) != 4:
            print("验证码位数不对")
            return

        # 填充手机号码和密码,验证码
        phone_input.send_keys("15210795183")
        password_input.send_keys("gc2053GCO")
        code_input.send_keys(text)
        # 点击登录按钮
        login_button.click()
        # 等待最多5秒
        self.driver.implicitly_wait(WebPageAutoClick.TIME_OUT)
        # 不再做如何验证码不对，重新刷新重试逻辑。

```
