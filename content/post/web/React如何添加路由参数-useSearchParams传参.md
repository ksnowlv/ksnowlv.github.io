---
title: "React如何添加路由参数-useSearchParams传参"
date: 2024-06-14T15:45:35+08:00
lastmod: 2024-06-14T15:45:35+08:00
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


### 1.react-router-dom路由框架

`create-react-app`框架下，页面之间的中转可以使用`react-router-dom`

官方链接：https://reactrouter.com/en/main/start/overview


### 2.useSearchParams传参页面跳转

可以使用`useNavigate`和`Link`跳转


### 2.1.`useNavigate`跳转
* 可以直接在页面？后拼接参数
  * 类似`/button_page?name=ksnow&address=beijing&age=18`
* 可以使用URLSearchParams拼接在页面后面，类似以下这种
```js
      const queryParams = new URLSearchParams({
        name: "张三",
        age: "18",
        address: "北京",
      });

      navigate(`/button_page?${queryParams.toString()}`);
```

#### 2.2.`Link`跳转

```js
    <Link to={`/button_page?name=ksnow&address=beijing&age=10`}> 第二种跳转页面</Link>
```


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
            <Link to={`/button_page?name=ksnow&address=beijing&age=10`}> 第二种跳转按钮页面</Link>

          </div>
  );
};

export default HomePage;


```

### 2.4.接收跳转参数

查询参数应该通过` useSearchParams` 钩子来获取,因此，通过`useSearchParams`获取参数


```js
import React, { useState } from 'react';
import './ButtonPage.css';
import { useParams, useSearchParams } from 'react-router-dom';

interface ButtonPageProps {

}
    
const ButtonPage: React.FC<ButtonPageProps> = () => {
    ;
    const [size, setSize] = useState('large')
    const [searchParams, setSearchParams] = useSearchParams(); // 获取查询参数

  // 从 searchParams 中读取查询参数
  const name = searchParams.get('name') || '';
  const age = searchParams.get('age') || '0';
  const address = searchParams.get('address') || '';
  console.log(`接收到的参数：name=${name}, age=${age}, address=${address}`);

    const handleSizeChange = (e: any) => {
        setSize(e.target.value);
    };
    return (
        <div>
       
            <p>姓名: {name}</p>
            <p>年龄: {age}</p>
            <p>地址: {address}</p>

        </div>
    )
};

export default ButtonPage

```

### 3.路由配置

```js
import React from 'react';
import { Routes as ReactRoutes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import PluginsPage from './pages/PluginsPage';
import MinePage from './pages/MinePage';
import ButtonPage from './pages/ButtonPage';

const Routes = () => (
  <ReactRoutes>
    <Route path="/" element={<HomePage />} />
    <Route path="/plugins" element={<PluginsPage />} />
    <Route path="/mine" element={<MinePage />} />
    <Route path="/button_page" element={<ButtonPage />} />
  </ReactRoutes>
);

export default Routes;
```

### 4.其它

接下来看看我们试试`useParams`传参