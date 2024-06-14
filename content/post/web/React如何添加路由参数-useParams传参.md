---
title: "React如何添加路由参数-UseParams传参"
date: 2024-06-14T18:06:17+08:00
lastmod: 2024-06-14T18:06:17+08:00
keywords: ["前端开发","React"]
tags: ["前端开发","React"]
categories: ["前端开发","React"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.react-router-dom路由框架

`create-react-app`框架下，页面之间的中转可以使用`react-router-dom`

官方链接：https://reactrouter.com/en/main/start/overview


### 2.UseParams传参页面跳转

### 2.1.UseParams传参

动态传参数格式：`页面/参数1/参数2/...`

我们以为例：

`/aboutpage/10/ksnowlv`


### 2.3.完整跳转代码

```js

import { Button } from "antd";
import React from "react";
import { Link, useNavigate } from "react-router-dom";

const HomePage = () => {

    const navigate = useNavigate();

    function handleButtonClick() {
        console.log("click");
        // navigate(`/button_page?name=ksnow&address=beijing&age=10`);

        const queryParams = new URLSearchParams({
            name: "张三",
            age: "18",
            address: "北京",
        });

        navigate(`/button_page?${queryParams.toString()}`);

    }
    return (
        <div>
            <h1>Home Page</h1>
            <Button type="primary" onClick={handleButtonClick}>第一种跳转按钮页面</Button>
            <br />
            <br />
            <Link to={`/button_page?name=ksnow&address=beijing&age=10`}> 第二种跳转按钮页面</Link>
            <br />
            <br />
            <Link to="/aboutpage/10/ksnowlv">useParams传参跳转关于页面</Link>

        </div>
    );
};

export default HomePage;


```

### 2.4.接收跳转参数

动态参数应该通过` useParams` 来获取


```js
import React from "react";
import { useParams } from "react-router-dom";


const AboutPage = () => {

    const params = useParams()

    const id = params.id
    const name = params.name

    console.log(`useParams id=${id}, name=${name}`);

    return (
        <div>
            <h1>About</h1>
            <p>
                The id is {id} and the name is {name}
            </p>
            <p>
                This is an example project to demonstrate how to use React and
                TypeScript together.
            </p>
        </div>
    );
};

export default AboutPage;
```

### 3.路由配置

添加`AboutPage`路由配置

```js
import React from 'react';
import { Routes as ReactRoutes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import PluginsPage from './pages/PluginsPage';
import MinePage from './pages/MinePage';
import ButtonPage from './pages/ButtonPage';
import AboutPage from './pages/AboutPage';

const Routes = () => (
    <ReactRoutes>
        <Route path="/" element={<HomePage />} />
        <Route path="/plugins" element={<PluginsPage />} />
        <Route path="/mine" element={<MinePage />} />
        <Route path="/button_page" element={<ButtonPage />} />
        <Route path="/aboutpage/:id/:name" element={<AboutPage />} />
    </ReactRoutes>
);

export default Routes;

```


### 4.效果

![image](/images/web/React如何添加路由参数-useParams传参/result1.png)

![image](/images/web/React如何添加路由参数-useParams传参/result2.png)
