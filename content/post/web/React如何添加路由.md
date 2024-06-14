---
title: "React如何添加路由"
date: 2024-06-13T18:32:40+08:00
lastmod: 2024-06-13T18:32:40+08:00
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


```shell
  npm install react-router-dom
```
安装成功后，配置文件中如下
```json
"react-router-dom": "^6.23.1",
```

### 2.页面示例

### 2.1 `HomePage.tsx`
```js
import { Button } from "antd";
import React from "react";
import { useNavigate } from "react-router-dom";

const HomePage = () => {

  const navigate = useNavigate();

  function handleButtonClick() {
    console.log("click");
    navigate("/button_page");

  }
  return (
    <div>
      <h1>Home Page</h1>
      <Button type="primary" onClick={handleButtonClick}>跳转按钮页面</Button>

    </div>
  );
};

export default HomePage;

```

### 2.1 `PluginsPage.tsx`

```js
import React from "react";

interface PluginsPageProps
{
}

const PluginsPage = (props: PluginsPageProps) => {
    return (
        <div>
            Plugins
        </div>
    );
}

export default PluginsPage;

```

### 2.3 `MinePage.tsx`

```js
import React from "react";

interface MinePageProps {
}

const MinePage = (props: MinePageProps) => {
    return (
        <div>
            <h1>MinePage</h1>
        </div>
    );
}

export default MinePage;

```

### 3.路由示例

 `Routes.js`

```js
import React from 'react';
import { Routes as ReactRoutes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import PluginsPage from './pages/PluginsPage';
import MinePage from './pages/MinePage';
import ButtonPages from './pages/ButtonPage';

const Routes = () => (
  <ReactRoutes>
    <Route path="/" element={<HomePage />} />
    <Route path="/plugins" element={<PluginsPage />} />
    <Route path="/mine" element={<MinePage />} />
    <Route path="/button_page" element={<ButtonPages />} />
  </ReactRoutes>
);

export default Routes;
```

### 4.调用


#### 4.1. `App.tsx` 
```js
import React from 'react';
import logo from './logo.svg';
import './App.css';
import { BrowserRouter as Router } from 'react-router-dom';
import Routes from './Routes';
import Navigation from './Navigation';

function App() {
  return (
    <div className="App">

      <Router>
        <div>
          <Navigation />
          <Routes /> {/* 使用 Routes 组件来渲染路由 */}
        </div>
      </Router>

    </div>
  );

  // App.js


}

export default App;

```

#### 4.2. `Navigation.tsx`


```js
import { Link } from 'react-router-dom';

function Navigation() {
    return (
        <nav>
            <Link to="/">HomePage</Link> |
            <Link to="/plugins">PluginsPage</Link> |
            <Link to="/mine">MinePage</Link>
        </nav>
    );
}

export default Navigation;
```

### 5.效果

![image](/images/web/React如何添加路由/result.png)

