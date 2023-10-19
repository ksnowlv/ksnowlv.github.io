---
title: "Python爬虫关于滑块验证码自动操作"
date: 2023-10-18T17:22:23+08:00
lastmod: 2023-10-18T17:22:23+08:00
keywords: ["Python", "爬虫", "滑块验证码", "识别"]
tags: ["Python", "爬虫"]
categories: ["Python", "爬虫"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一.滑块验证码方案

### 1.背景

项目中有时验证码是滑块滑动拼图形式验证的，这种验证码该如何完成验证呢?
### 2.思路

* 1.获取完整验证码背景图片及缺口验证码图片
* 2.匹配缺口照片在完整照片的位置
* 3.机器模拟人工滑动轨迹
* 4 判断拼图是否成功,若成功，跳转其它页面；若失败，滑块拼图递归循环调用


## 二.豆瓣示例

### 1.完整验证码背景图片及缺口验证码图片

#### 完整验证码背景图片

![image](/images/post/python爬虫关于滑动验证码自动操作/douban_bk_full_image.png)

#### 缺口验证码图片

![image](/images/post/python爬虫关于滑动验证码自动操作/douban_slider_captcha_image.png)

其中缺口图片全图如下，需要把缺口图片扣出来。

缺口图片原图

![image](/images/post/python爬虫关于滑动验证码自动操作/douban_image1.png)


缺口图片扣图后的结果图片

![image](/images/post/python爬虫关于滑动验证码自动操作/douban_image2.png)

示例代码如下：

```python
    image = Image.open(io.BytesIO(response.content))
    image.save(SliderCaptchaDemo.FULL_SLIDER_IMAGE)

    # 获取验证码x,y轴坐标
    crop_point = (71, 248)

    # 获取验证码的长宽
    crop_size = (61, 61)
    # 设备分辨率为2
    scale = 2
    rangle = (crop_point[0] * scale,
              crop_point[1] * scale,
              crop_point[0] * scale + crop_size[0] * scale,
              crop_point[1] * scale + crop_size[1] * scale
              )

    verification_image = image.crop(rangle)
    # verification_image = verification_image.convert('RGB')
    # 保存我们截取的验证码图片，并读取验证码内容
    verification_image.save(SliderCaptchaDemo.SLIDER_IMAGE)
```

### 2.完整示例代码

```python

import numpy
from selenium import webdriver
from selenium.common import NoSuchElementException
from selenium.webdriver import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver import Chrome
from selenium.webdriver import ChromeOptions
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.safari.options import Options
import time
import requests
from PIL import Image
import io
import cv2


class SliderCaptchaDemo(object):
   URL = "https://accounts.douban.com/passport/login"
   BK_IMAGE = 'bk_image.png'
   FULL_SLIDER_IMAGE = "full_slider_image.png"
   SLIDER_IMAGE = "slider_image.png"
  
   TIME_OUT = 20
 
   def __init__(self):
     option = ChromeOptions()
     # 解决滑块无法滑动的问题
     option.add_experimental_option('excludeSwitches', ['enable-automation'])
     option.add_experimental_option('detach', True)
     # 创建一个对象，控制chrome浏览器
     self.driver = webdriver.Chrome(options=option)
   
     # 创建 SafariOptions 实例
     # option = Options()
     # # 添加选项
     # option.add_argument('-enableFullPageScreenshot')
     # option.add_argument('-allow-file-access-from-files')
     # self.driver = webdriver.Safari(options=option)
   
     self.driver.set_window_size(1000, 600)
     self.panel_element = None
     # self.driver.maximize_window()
   def loadLoginPage(self):
    self.driver.get(SliderCaptchaDemo.URL)
    script = 'Object.defineProperty(navigator, "webdriver", {get: () => false,});'
    self.driver.execute_script(script)

    wait = WebDriverWait(self.driver, SliderCaptchaDemo.TIME_OUT)
    login_element = wait.until(
     EC.visibility_of_element_located((By.XPATH, "//div[@class='account-tabcon-start']"))
    )

    # 使用 XPath 定位手机号码输入框
    phone_input = login_element.find_element(By.XPATH, "//input[@placeholder='手机号']")
    phone_input.send_keys("15210795183")
    # 使用 XPath 定位密码输入框
    code_input = login_element.find_element(By.XPATH,
                                            "//div[@class='account-form-field account-form-codes']/input[@id='code']")

    # 显式等待，直到获取验证码按钮可点击；
    # 有时候，如果页面中的元素尺寸或位置发生变化时，使用Selenium自动点击元素可能会失败。
    # 解决这种问题的一种方法是使用JavaScript的click()方法来触发元素的点击操作。
    get_code_button = WebDriverWait(self.driver, 10).until(
     EC.element_to_be_clickable((By.CLASS_NAME, "get-code"))
    )
    self.driver.execute_script("arguments[0].click();", get_code_button)
    time.sleep(5)
    self.loop()

   def get_images(self):

    if self.panel_element is None:
     # 在网页中，有时会使用 iframe 或 frame 元素嵌入其他网页或内容。如果要在 Selenium 中操作这些嵌入的网页或内容，就需要先切换到相应的 iframe 或 frame 中。
     # 使用 driver.switch_to.frame() 方法可以通过 iframe 或 frame 元素的索引、名称或 WebElement 对象来切换到相应的 iframe 或 frame 中
     # 使用 driver.switch_to.default_content() 方法可以切换回默认的上下文，即切回到主文档或最外层的窗口，以便继续操作其他元素。
     iframe = self.driver.find_element(By.ID, "tcaptcha_iframe_dy")
     self.driver.switch_to.frame(iframe)

     panel_element = WebDriverWait(self.driver, 12).until(
      EC.visibility_of_element_located((By.CLASS_NAME, "body-wrap"))
     )
     self.panel_element = panel_element
     print(f"元素已经加载完成：", self.panel_element)

    element = self.panel_element.find_element(By.XPATH, "//*[@id='slideBg']")
    # 获取元素的background-image属性值
    bg_image = element.get_attribute("style")
    # 从background-image属性值中提取图片链接
    start_index = bg_image.index("(") + 1
    end_index = bg_image.index(")")
    image_url = bg_image[start_index:end_index]
    image_url = image_url.replace('"', '')
    print(f"背景图片链接：{image_url}")
    response = requests.get(image_url, stream=True)
    bk_image = Image.open(io.BytesIO(response.content))
    bk_image.save(SliderCaptchaDemo.BK_IMAGE)

    # 找到指定的元素
    slider_element = self.panel_element.find_element(By.XPATH, "//*[@id='tcOperation']/div[@class='tc-fg-item']")
    # 获取元素的background-image属性值
    slider_image = slider_element.get_attribute("style")
    # 从background-image属性值中提取图片链接
    start_index = slider_image.index("(") + 1
    end_index = slider_image.index(")")
    image_url = slider_image[start_index:end_index]
    image_url = image_url.replace('"', '')
    print(f"图片链接：{image_url}")

    response = requests.get(image_url, stream=True)
    image = Image.open(io.BytesIO(response.content))
    image.save(SliderCaptchaDemo.FULL_SLIDER_IMAGE)

    # 获取验证码x,y轴坐标
    crop_point = (71, 248)

    # 获取验证码的长宽
    crop_size = (61, 61)

    # 设备分辨率为2
    scale = 2
    rangle = (crop_point[0] * scale,
              crop_point[1] * scale,
              crop_point[0] * scale + crop_size[0] * scale,
              crop_point[1] * scale + crop_size[1] * scale
              )

    verification_image = image.crop(rangle)
    # verification_image = verification_image.convert('RGB')
    # 保存我们截取的验证码图片，并读取验证码内容
    verification_image.save(SliderCaptchaDemo.SLIDER_IMAGE)
    # 返回路径
    return SliderCaptchaDemo.BK_IMAGE, SliderCaptchaDemo.SLIDER_IMAGE

   def loop(self):
    # 得到验证码图片
    full_image, slider_image = self.get_images()
    # 匹配缺口照片在完整照片的位置，因设备分辨率为2，所以图片匹配的像素距离除2；因滑块相比图片最左边缘已偏移23，所以减去23
    slider_offset = self.match_picture(full_image, slider_image) / 2 - 23
    print(f"match_picture 滑块移动：{slider_offset}")

    find_image_slider_offset = self.find_image(full_image, slider_image) / 2 - 23
    print(f"find_image 滑块移动：{find_image_slider_offset}")

    # 机器模拟人工滑动轨迹
    self.sliding_track(slider_offset)
    # 若失败，循环触发。
    if self.judge_show():
     self.loop()
    else:
     self.driver.switch_to.default_content()

   @staticmethod
   def find_image(full_image, slider_image):
    # 读取图片文件信息
    img_full = cv2.imread(full_image)
    # 以灰度模式加载图片
    template = cv2.imread(slider_image)
    # 方法
    methods = [cv2.TM_SQDIFF_NORMED, cv2.TM_CCORR_NORMED, cv2.TM_CCOEFF_NORMED]
    # 记录每个方法的距离
    left = []
    # 最接近值
    min_ = []
    for method in methods:
     # 匹配
     res = cv2.matchTemplate(img_full, template, method)
     # 获取相关内容
     min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)
     if method == cv2.TM_SQDIFF_NORMED:
      min_.append(min_val - 0.0)
      left.append(min_loc[0])
     else:
      min_.append(1.0 - max_val)
      left.append(max_loc[0])
    index = min_.index(numpy.min(min_))

    return left[index]

   @staticmethod
   def match_picture(full_image_path, slider_image_path):
    # 读取背景图片和缺口图片
    full_image = cv2.imread(full_image_path)
    slider_image = cv2.imread(slider_image_path)

    # 识别图片边缘
    full_image_edge = cv2.Canny(full_image, 100, 200)
    slider_image_edge = cv2.Canny(slider_image, 100, 200)

    # 转换图片格式,图片边缘的灰度图，进一步将其图片格式转为RGB格式
    # !!!很关键！否则缺口匹配将不准确
    full_image_grey = cv2.cvtColor(full_image_edge, cv2.COLOR_GRAY2RGB)
    slider_image_grey = cv2.cvtColor(slider_image_edge, cv2.COLOR_GRAY2RGB)

    # 缺口匹配
    res = cv2.matchTemplate(full_image_grey, slider_image_grey, cv2.TM_CCOEFF_NORMED)
    # 寻找最优匹配
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)
    return max_loc[0]

   # 判断是否完成操作
   def judge_show(self):
    time.sleep(2)
    show = 'return document.getElementsByClassName(\'tc-captcha tc-drag\')'
    show_is = self.driver.execute_script(show)
    return len(show_is) > 0

   def sliding_track(self, distance):

    # 获取轨迹
    track = self.get_tracks(distance)
    # 获取按钮
    slider = self.panel_element.find_element(By.XPATH,
                                             "//*[@id='tcOperation']/div[@class='tc-fg-item tc-slider-normal']")
    action_chains = ActionChains(self.driver)
    action_chains.click_and_hold(slider).perform()
    print(track)
    for t in track:
     action_chains.move_by_offset(xoffset=t, yoffset=0).perform()
    action_chains.release().perform()
    time.sleep(2)

   @staticmethod
   def get_tracks(distance, rate=0.4, t=0.2, v=0):

    tracks = []
    # 加速减速的临界值
    mid = rate * distance
    # 当前位移
    s = 0
    # 循环
    while s < distance:
     # 初始速度
     v0 = v
     if s < mid:
      a = 20
     else:
      a = -3
     # 计算当前t时间段走的距离
     s0 = v0 * t + 0.5 * a * t * t
     # 计算当前速度
     v = v0 + a * t
     # 四舍五入距离，因为像素没有小数
     tracks.append(round(s0))
     # 计算当前距离
     s += s0

    return tracks

```

### 3.执行情况

```terminal
元素已经加载完成： <selenium.webdriver.remote.webelement.WebElement (session="a5bcbf92885e54d4719716dd20dc0b9b", element="43CFBD8E7123211115CCF2AE31F09402_element_2")>
背景图片链接：https://turing.captcha.qcloud.com/cap_union_new_getcapbysig?img_index=1&image=02790500005c326000000009dcd3aa783e9a&sess=s0ctSKwsKqqdWpLwg3yzcnwXvZWYnjkcn94nDfoPcuWQxQH35pWAFscJZidcEhaCp2xpwMxZh2lRRJaGqeWpQtFV-j5TiOfwTlcTGFEZRSqtU6VCJsrrYHOi-sF9NGzNLMe8lbiXpf0CRLIVYpDnf8IJK5B9g8VlE3EgdoVVTjtLKLaOaKlt_gOs9PM4CodMbLAQE10j1zoZw4yyRZ1KfsrhAQqZHnyTu6mt-CCg90DjKFNrS8S184TNhSguSSnKK6Q7HD4u1OBM2f2zeGtbxX4WyVarqVHmQdsBEXkDWqfNXnI7EBm86lRfsYf-eA789b9luKpNBYSTJDaOwqJwJITBMz_0Gvc3DrW__M0i21dgepUD3U7AYYclIYAlkmdpwl
图片链接：https://turing.captcha.qcloud.com/cap_union_new_getcapbysig?img_index=0&image=02790500005c326000000009dcd3aa783e9a&sess=s0ctSKwsKqqdWpLwg3yzcnwXvZWYnjkcn94nDfoPcuWQxQH35pWAFscJZidcEhaCp2xpwMxZh2lRRJaGqeWpQtFV-j5TiOfwTlcTGFEZRSqtU6VCJsrrYHOi-sF9NGzNLMe8lbiXpf0CRLIVYpDnf8IJK5B9g8VlE3EgdoVVTjtLKLaOaKlt_gOs9PM4CodMbLAQE10j1zoZw4yyRZ1KfsrhAQqZHnyTu6mt-CCg90DjKFNrS8S184TNhSguSSnKK6Q7HD4u1OBM2f2zeGtbxX4WyVarqVHmQdsBEXkDWqfNXnI7EBm86lRfsYf-eA789b9luKpNBYSTJDaOwqJwJITBMz_0Gvc3DrW__M0i21dgepUD3U7AYYclIYAlkmdpwl
match_picture 滑块移动：185.0
find_image 滑块移动：117.0
[0, 1, 2, 3, 4, 4, 5, 6, 7, 8, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 10, 10, 10, 10, 10]

```

## 三.问题

### 1.滑块为什么不能正常滑动？

可能被反爬虫策略命中

实际上，我们使用默认的方式初始化 WebDriver 打开一个网站，下面这段 JS 代码永远为 true，而手动打开目标网站的话，则为：undefined
 #通过这段 JS 脚本区分是爬虫还是人工操作
window.navigator.webdriver
详细解释可参考[链接](https://www.cnblogs.com/zihkj/p/12583657.html)

### 2.验证码为什么通过率低

使用match_picture识别准确率较高，可以对比和find_image的区别
另外从执行情况来看，find_image偏差挺大的,例如
* match_picture 滑块移动：185.0
* find_image 滑块移动：117.0

### 3.验证码匹配成功后，为什么还在不停的识别？

本文重点在于滑动验证码的自动识别操作，提供解决问题的思路，具体业务逻辑以实际情况为准。
