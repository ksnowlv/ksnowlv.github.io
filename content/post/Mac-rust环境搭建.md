---
title: "Mac Rust环境搭建"
date: 2023-09-03T22:40:00+08:00
lastmod: 2023-09-03T22:40:00+08:00
keywords: ["Mac", "rust"]
tags: ["Mac", "rust"]
categories: ["Mac", "rust"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Mac安装rust

### 1.设置环境变量

RUSTUP_DIST_SERVER （用于更新 toolchain）：

```terminal
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static

```

RUSTUP_UPDATE_ROOT （用于更新 rustup）：

```terminal
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
```

### 2 下载安装脚本

```terminal
ksnowlv@MacBook-Pro-3 rustdemo % curl -O https://cdn.jsdelivr.net/gh/rust-lang-nursery/rustup.rs/rustup-init.sh
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 23159    0 23159    0     0  18002      0 --:--:--  0:00:01 --:--:-- 18092

ksnowlv@MacBook-Pro-3 rustdemo % ls
rustup-init.sh

```

rustup-init.sh安装脚本下载成功

```terminal
(base) lvwei@lvweideMacBook-Pro hello % curl -O https://cdn.jsdelivr.net/gh/rust-lang-nursery/rustup.rs/rustup-init.sh
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
curl: (35) Recv failure: Connection reset by peer

```

如果上述curl -O https://cdn.jsdelivr.net/gh/rust-lang-nursery/rustup.rs/rustup-init.sh报错，

#### 如果是x86_64架构，可以使用

```terminal
curl -O https://static.rust-lang.org/rustup/dist/x86_64-apple-darwin/rustup-init

```

#### 如果是ARM架构，可以使用

```terminal
curl -O https://static.rust-lang.org/rustup/dist/aarch64-apple-darwin/rustup-init

```


### 3.执行rustup-init.sh安装rust

#### 如果是x86_64架构下

```terminal
ksnowlv@MacBook-Pro-3 rustdemo % chmod 777 rustup-init.sh 
ksnowlv@MacBook-Pro-3 rustdemo % sh rustup-init.sh        
info: downloading installer

Welcome to Rust!

This will download and install the official compiler for the Rust
programming language, and its package manager, Cargo.

Rustup metadata and toolchains will be installed into the Rustup
home directory, located at:

  /Users/ksnowlv/.rustup

This can be modified with the RUSTUP_HOME environment variable.

The Cargo home directory is located at:

  /Users/ksnowlv/.cargo

This can be modified with the CARGO_HOME environment variable.

The cargo, rustc, rustup and other commands will be added to
Cargo's bin directory, located at:

  /Users/ksnowlv/.cargo/bin

This path will then be added to your PATH environment variable by
modifying the profile files located at:

  /Users/ksnowlv/.profile
  /Users/ksnowlv/.bash_profile
  /Users/ksnowlv/.bashrc
  /Users/ksnowlv/.zshenv

You can uninstall at any time with rustup self uninstall and
these changes will be reverted.

Current installation options:


   default host triple: x86_64-apple-darwin
     default toolchain: stable (default)
               profile: default
  modify PATH variable: yes

1) Proceed with installation (default)
2) Customize installation
3) Cancel installation
>1

info: profile set to 'default'
info: default host triple is x86_64-apple-darwin
info: syncing channel updates for 'stable-x86_64-apple-darwin'
info: latest update on 2023-08-24, rust version 1.72.0 (5680fa18f 2023-08-23)
info: downloading component 'cargo'
  6.2 MiB /   6.2 MiB (100 %)   1.1 MiB/s in  5s ETA:  0s
info: downloading component 'clippy'
  2.3 MiB /   2.3 MiB (100 %)   1.1 MiB/s in  2s ETA:  0s
info: downloading component 'rust-docs'
 13.7 MiB /  13.7 MiB (100 %)   1.1 MiB/s in 13s ETA:  0s 
info: downloading component 'rust-std'
 25.0 MiB /  25.0 MiB (100 %)   1.1 MiB/s in 24s ETA:  0s 
info: downloading component 'rustc'
 55.5 MiB /  55.5 MiB (100 %) 1001.6 KiB/s in  1m  1s ETA:  0s
info: downloading component 'rustfmt'
  1.7 MiB /   1.7 MiB (100 %)   1.1 MiB/s in  1s ETA:  0s
info: installing component 'cargo'
info: installing component 'clippy'
info: installing component 'rust-docs'
 13.7 MiB /  13.7 MiB (100 %)   4.0 MiB/s in  2s ETA:  0s
info: installing component 'rust-std'
 25.0 MiB /  25.0 MiB (100 %)  12.9 MiB/s in  1s ETA:  0s
info: installing component 'rustc'
 55.5 MiB /  55.5 MiB (100 %)  13.1 MiB/s in  4s ETA:  0s
info: installing component 'rustfmt'
info: default toolchain set to 'stable-x86_64-apple-darwin'

  stable-x86_64-apple-darwin installed - rustc 1.72.0 (5680fa18f 2023-08-23)


Rust is installed now. Great!

To get started you may need to restart your current shell.
This would reload your PATH environment variable to include
Cargo's bin directory ($HOME/.cargo/bin).

To configure your current shell, run:
source "$HOME/.cargo/env"
ksnowlv@MacBook-Pro-3 rustdemo % 

```

如果是arm64架构下
```terminal
(base) lvwei@lvweideMacBook-Pro hello % curl -O https://static.rust-lang.org/rustup/dist/aarch64-apple-darwin/rustup-init
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 7813k  100 7813k    0     0   877k      0  0:00:08  0:00:08 --:--:--  928k
(base) lvwei@lvweideMacBook-Pro hello % ls -l
total 16432
-rw-r--r--  1 lvwei  staff  8000713  9  4 13:56 rustup-init
(base) lvwei@lvweideMacBook-Pro hello % ./rustup-init 
zsh: permission denied: ./rustup-init
(base) lvwei@lvweideMacBook-Pro hello % chmod 777 rustup-init 
(base) lvwei@lvweideMacBook-Pro hello % ./rustup-init        

Welcome to Rust!

This will download and install the official compiler for the Rust
programming language, and its package manager, Cargo.

Rustup metadata and toolchains will be installed into the Rustup
home directory, located at:

  /Users/lvwei/.rustup

This can be modified with the RUSTUP_HOME environment variable.

The Cargo home directory is located at:

  /Users/lvwei/.cargo

This can be modified with the CARGO_HOME environment variable.

The cargo, rustc, rustup and other commands will be added to
Cargo's bin directory, located at:

  /Users/lvwei/.cargo/bin

This path will then be added to your PATH environment variable by
modifying the profile files located at:

  /Users/lvwei/.profile
  /Users/lvwei/.bash_profile
  /Users/lvwei/.bashrc
  /Users/lvwei/.zshenv

You can uninstall at any time with rustup self uninstall and
these changes will be reverted.

Current installation options:


   default host triple: aarch64-apple-darwin
     default toolchain: stable (default)
               profile: default
  modify PATH variable: yes

1) Proceed with installation (default)
2) Customize installation
3) Cancel installation
>1

info: profile set to 'default'
info: default host triple is aarch64-apple-darwin
info: syncing channel updates for 'stable-aarch64-apple-darwin'
info: latest update on 2023-08-24, rust version 1.72.0 (5680fa18f 2023-08-23)
info: downloading component 'cargo'
  5.6 MiB /   5.6 MiB (100 %) 950.3 KiB/s in  7s ETA:  0s
info: downloading component 'clippy'
  2.1 MiB /   2.1 MiB (100 %) 903.7 KiB/s in  2s ETA:  0s
info: downloading component 'rust-docs'
 13.7 MiB /  13.7 MiB (100 %) 908.8 KiB/s in 15s ETA:  0s
info: downloading component 'rust-std'
 24.8 MiB /  24.8 MiB (100 %) 940.8 KiB/s in 29s ETA:  0s
info: downloading component 'rustc'
 52.6 MiB /  52.6 MiB (100 %) 889.6 KiB/s in  1m  4s ETA:  0s
info: downloading component 'rustfmt'
  1.5 MiB /   1.5 MiB (100 %)   1.0 MiB/s in  2s ETA:  0s
info: installing component 'cargo'
info: installing component 'clippy'
info: installing component 'rust-docs'
 13.7 MiB /  13.7 MiB (100 %)   5.8 MiB/s in  2s ETA:  0s
info: installing component 'rust-std'
 24.8 MiB /  24.8 MiB (100 %)  19.3 MiB/s in  1s ETA:  0s
info: installing component 'rustc'
 52.6 MiB /  52.6 MiB (100 %)  21.5 MiB/s in  2s ETA:  0s
info: installing component 'rustfmt'
info: default toolchain set to 'stable-aarch64-apple-darwin'

  stable-aarch64-apple-darwin installed - rustc 1.72.0 (5680fa18f 2023-08-23)


Rust is installed now. Great!

To get started you may need to restart your current shell.
This would reload your PATH environment variable to include
Cargo's bin directory ($HOME/.cargo/bin).

To configure your current shell, run:
source "$HOME/.cargo/env"

```

### 4.配置rust环境变量，并查看rustc和cargo版本

rust 安装后，会在home目录创建 .cargo/env，为了以后都从国内镜像源下载包，

    RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup

可以将上面的环境变量加入到env文件。

![image](/images/post/mac-rust环境搭建/env_set.png)


```terminal
ksnowlv@MacBook-Pro-3 rustdemo % source "$HOME/.cargo/env"

ksnowlv@MacBook-Pro-3 rustdemo %  cargo --version         
cargo 1.72.0 (103a7ff2e 2023-08-15)
ksnowlv@MacBook-Pro-3 rustdemo % rustc --version         
rustc 1.72.0 (5680fa18f 2023-08-23)
```

![image](/images/post/mac-rust环境搭建/cargo_env.png)


### 5.CLion安装rust插件

![image](/images/post/mac-rust环境搭建/rust-plugin.png)

### 6.重启CLion，测试rust工程

通过rust创建Hello测试工程，并运行验证测试。

![image](/images/post/mac-rust环境搭建/rust_hello.png)