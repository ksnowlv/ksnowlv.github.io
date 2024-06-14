---
title: "React如何添加登陆页面"
date: 2024-06-11T21:37:14+08:00
lastmod: 2024-06-11T21:37:14+08:00
keywords: ["Web"]
tags: ["Web"]
categories: ["Web"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.UI布局的核心

任何UI布局核心在于计算子控件的大小和位置,本质是指定子控件的上、下、左、右，这直接决定了子控件的位置和大小。

### 2.web前端

主要通过css文件配置页面布局及样式

### 3.使用示例

#### 3.1 使用示例

* 2.1.`LoginPage.tsx`页面

```react
import React from "react"
import "./LoginPage.css"


const handleLoginPageOnClick = (eventName: string) => {
  console.log(eventName + " click");
};

const LoginPage: React.FC = () => {

  const handleLoginClick = () => handleLoginPageOnClick("login");

  const handleRegisterClick = () => handleLoginPageOnClick("register");

  const handleWechatClick = () => handleLoginPageOnClick("wechat")
  const handleQQClick = () => handleLoginPageOnClick("qq");
  const handleWeiboClick = () => handleLoginPageOnClick("weibo");

  return (
    <div className="login-container">
      <div className="logo-container">
        <img src="login_page/app_logo.png" alt="LoginPage AppLogo" className="logo" />
      </div>
      <p className="app">测试App</p>
      <div className="input-container">
        <div className="input-wrapper">
          <img src="login_page/account.png" alt="Username Icon" />
          <input type="text" placeholder="请输入账号" />
        </div>
      </div>
      <div className="input-container">
        <div className="input-wrapper">
          <img src="login_page/password.png" alt="Password Icon" />
          <input type="password" placeholder="请输入密码"  />
        </div>
      </div>
      <button className="login-button" onClick={handleLoginClick}>登陆</button>
      <button className="register-button" onClick={handleRegisterClick}>注册</button>
      <p className="other-login-text">其它登陆方式</p>
      <div className="social-icons">
        <img src="login_page/wechat.png" alt="WeChat" onClick={handleWechatClick} />
        <img src="login_page/qq.png" alt="QQ" onClick={handleQQClick} />
        <img src="login_page/weibo.png" alt="Weibo" onClick={handleWeiboClick} />
      </div>

    </div>
  )
};

export default LoginPage;
```

* 2.2.`LoginPage.css`

```css
:root {
    --primary-color: #5B70CF;
    --secondary-color: #F8644E;
    --input-color: #A0ACD4;
    --background-color: #F0F5FD;
    --text-color: #D5DFF2;
    --font-size: 20px;
}

.login-container {
    text-align: center;
}

.logo-container {
    margin-top: 8vh;
}

/* 如果需要更细致的控制，例如在小屏幕设备上调整边距，可以使用媒体查询 */
/* 以下是一个示例，可以根据实际需要进行调整 */
@media (max-width: 600px) {
    .logo-container {
        margin-top: 15%; /* 在小屏幕设备上，可能需要更大的边距 */
    }
}


.logo {
    width: 150px;
    height: 150px;
}

.app {
    margin-top: 20px;
    margin-bottom: 50px;
    font-size: var(--font-size);
    color: var(--text-color);
    font-weight: bold;
}

.input-container {
    background-color: var(--background-color);
    margin: 0 40px;
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
    /* 使用gap代替margin进行元素间距设置，需要浏览器支持 */
    /* gap: 20px; */
}

.input-wrapper {
    display: flex;
    align-items: center;
    flex-grow: 1;
}

.input-wrapper img {
    margin-left: 20px; /* 考虑使用gap代替margin-left */
    margin-right: 10px;
}

input {
    flex: 1;
    border: none; /* 保留一个透明边框以提供视觉反馈 */
    background: none;
    outline: none;
    font-size: var(--font-size);
    color: var(--input-color);
}

input:focus {
    border-color: none
}

/* 合并重复的placeholder样式 */
.placeholder-text {
    color: var(--input-color);
}

.login-button, .register-button {
    height: 60px;
    width: 80%;
    margin-bottom: 10px;
    background-color: var(--primary-color);
    font-size: var(--font-size);
    color: white;
    border: none;
}

.login-button {
    margin-top: 60px;
}

.register-button {
    margin-top: 20px;
    background-color: var(--secondary-color);
}

.other-login-text {
    margin-top: 60px;
    margin-bottom: 20px;
    text-align: center;
    font-size: 16px;
    color: var(--text-color);
}

.social-icons {
    display: flex;
    align-items: center;
    justify-content: center;
}

.social-icons img {
    margin: 0 10px;
    width: 40px;
    height: 40px;
}
```

### 4.效果

![image](/images/web/React如何添加登陆页面/result.png)

### 5.其它

#### 5.1.UI布局和其它平台对比
相比较`iOS`，`Android`,`Flutter`,`鸿蒙`，使用`React`写页面，真是太方便快捷了.
回头抽时间写个`VUE`版本的,估计都比原生的方便快捷。

