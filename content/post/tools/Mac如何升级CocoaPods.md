---
title: "Mac如何升级CocoaPods"
date: 2024-03-08T08:31:09+08:00
lastmod: 2024-03-08T08:31:09+08:00
keywords: ["Mac", "iOS", "CocoaPods"]
tags: ["Mac", "iOS"]
categories: ["Mac", "iOS"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## Mac升级CocoaPods

```shell
ksnowlv@MacBook-Pro-3 ~ % pod --version                
/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/universal-darwin23/rbconfig.rb:21: warning: Insecure world writable dir /Users/ksnowlv/Documents in PATH, mode 040707
Ignoring ffi-1.15.4 because its extensions are not built. Try: gem pristine ffi --version 1.15.4
1.11.2
ksnowlv@MacBook-Pro-3 ~ % gem cleanup ffi
Cleaning up installed gems...
Clean up complete
ksnowlv@MacBook-Pro-3 ~ % gem install ffi -v '1.15.4'
Fetching ffi-1.15.4.gem
Building native extensions. This could take a while...
Successfully installed ffi-1.15.4
Parsing documentation for ffi-1.15.4
Installing ri documentation for ffi-1.15.4
Done installing documentation for ffi after 4 seconds
1 gem installed
ksnowlv@MacBook-Pro-3 ~ % pod --version
/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/universal-darwin23/rbconfig.rb:21: warning: Insecure world writable dir /Users/ksnowlv/Documents in PATH, mode 040707
Ignoring ffi-1.15.4 because its extensions are not built. Try: gem pristine ffi --version 1.15.4
1.11.2
```


## 解决方案

### 使用rbenv和Homebrew安装新的Ruby环境

安装rbenv,这是用于管理Ruby版本的工具，终端中使用Homebrew来安装rbenv。

```shell
ksnowlv@MacBook-Pro-3 ~ % brew install rbenv                   
==> Downloading https://ghcr.io/v2/homebrew/core/rbenv/manifests/1.2.0
########################################################################################################################################################################### 100.0%
==> Fetching dependencies for rbenv: ruby-build
==> Downloading https://ghcr.io/v2/homebrew/core/ruby-build/manifests/20240221
########################################################################################################################################################################### 100.0%
==> Fetching dependencies for ruby-build: autoconf
==> Downloading https://ghcr.io/v2/homebrew/core/autoconf/manifests/2.72
########################################################################################################################################################################### 100.0%
==> Fetching autoconf
==> Downloading https://ghcr.io/v2/homebrew/core/autoconf/blobs/sha256:12368e33b89d221550ba9e261b0c6ece0b0e89250fb4c95169d09081e0ebb2dd
########################################################################################################################################################################### 100.0%
==> Fetching ruby-build
==> Downloading https://ghcr.io/v2/homebrew/core/ruby-build/blobs/sha256:688c401d7956253cbe003c4c842353b7a341fda6d0fb51d18046398219b5bb23
########################################################################################################################################################################### 100.0%
==> Fetching rbenv
==> Downloading https://ghcr.io/v2/homebrew/core/rbenv/blobs/sha256:59a2e9120361bc20b5c3fe8122438e5e43ee00e475ea6730fe507fda2de6d7ab
########################################################################################################################################################################### 100.0%
==> Installing dependencies for rbenv: ruby-build
==> Installing rbenv dependency: ruby-build
==> Downloading https://ghcr.io/v2/homebrew/core/ruby-build/manifests/20240221
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/c781523fbe7732bf8298f9e2a83f94ed7fb11fb587be043bc78c01d1ca7cf384--ruby-build-20240221.bottle_manifest.json
==> Installing dependencies for ruby-build: autoconf
==> Installing ruby-build dependency: autoconf
==> Downloading https://ghcr.io/v2/homebrew/core/autoconf/manifests/2.72
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/b73cdb320c4261bbf8d02d03e50dc755c869c5859c1d4e93616898fc7cd939ff--autoconf-2.72.bottle_manifest.json
==> Pouring autoconf--2.72.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/autoconf/2.72: 71 files, 3.6MB
==> Installing ruby-build
==> Pouring ruby-build--20240221.all.bottle.tar.gz
🍺  /usr/local/Cellar/ruby-build/20240221: 602 files, 317.2KB
==> Installing rbenv
==> Pouring rbenv--1.2.0.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/rbenv/1.2.0: 35 files, 108.1KB
==> Running `brew cleanup rbenv`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Upgrading 1 dependent of upgraded formulae:
Disable this behaviour by setting HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
automake 1.16.4 -> 1.16.5
==> Downloading https://ghcr.io/v2/homebrew/core/automake/manifests/1.16.5
########################################################################################################################################################################### 100.0%
==> Checking for dependents of upgraded formulae...
==> No broken dependents found!
ksnow
```

安装完成后，将rbenv添加到您的Shell配置文件（例如 .bash_profile 或 .zshrc）中。

```shell
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

!!!记得打开新终端，使rbenv新版本生效。

### 安装新的Ruby版本

#### 查看可用的 Ruby 版本
```shell
ksnowlv@MacBook-Pro-3 ~ % rbenv install -l
3.0.6
3.1.4
3.2.3
3.3.0
jruby-9.4.6.0
mruby-3.3.0
picoruby-3.0.0
truffleruby-23.1.2
truffleruby+graalvm-23.1.2

Only latest stable releases for each Ruby implementation are shown.
Use `rbenv install --list-all' to show all local versions.
```

#### 安装3.2.3稳定版

因3.3.0无法正常下载，故安装3.2.3版本

```shell
ksnowlv@MacBook-Pro-3 ~ % rbenv install 3.3.0
ruby-build: using openssl@3 from homebrew
==> Downloading ruby-3.3.0.tar.gz...
-> curl -q -fL -o ruby-3.3.0.tar.gz https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.0.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:36 --:--:--     0
  1 21.0M    1  272k    0     0   7300      0  0:50:22  0:00:38  0:49:44 62324
  1 21.0M    1  330k    0     0   8648      0  0:42:31  0:00:39  0:41:52 75624
  2 21.0M    2  611k    0     0   3939      0  1:33:21  0:02:38  1:30:43     0
  2 21.0M    2  611k    0     0   3477      0  1:45:46  0:02:59  1:42:47     0
  2 21.0M    2  611k    0     0   3439      0  1:46:56  0:03:01  1:43:55     0
  2 21.0M    2  611k    0     0   3402      0  1:48:06  0:03:03  1:45:03     0
  2 21.0M    2  611k    0     0   3192      0  1:55:12  0:03:15  1:51:57     0^C%                                                                                                 ksnowlv@MacBook-Pro-3 ~ % rbenv install 3.2.3
ruby-build: using openssl@3 from homebrew
==> Downloading ruby-3.2.3.tar.gz...
-> curl -q -fL -o ruby-3.2.3.tar.gz https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.3.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0
100 19.6M  100 19.6M    0     0   279k      0  0:01:11  0:01:11 --:--:--  133k
==> Installing ruby-3.2.3...
ruby-build: using readline from homebrew
ruby-build: using libyaml from homebrew
ruby-build: using gmp from homebrew
-> ./configure "--prefix=$HOME/.rbenv/versions/3.2.3" --with-openssl-dir=/usr/local/opt/openssl@3 --enable-shared --with-readline-dir=/usr/local/opt/readline --with-libyaml-dir=/usr/local/opt/libyaml --with-gmp-dir=/usr/local/opt/gmp --with-ext=openssl,psych,+
-> make -j 12
-> make install
==> Installed ruby-3.2.3 to /Users/ksnowlv/.rbenv/versions/3.2.3

NOTE: to activate this Ruby version as the new default, run: rbenv global 3.2.3
ksnowlv@MacBook-Pro-3 ~ % 
```

### 更新ruby默认版本：

```shell
ksnowlv@MacBook-Pro-3 ~ % rbenv global 3.2.3
```
### 安装CocoaPods

使用pod --version验证版本

```shell
ksnowlv@MacBook-Pro-3 ~ % gem install cocoapods
Fetching ruby-macho-2.5.1.gem
Fetching atomos-0.1.3.gem
Fetching CFPropertyList-3.0.7.gem
Fetching claide-1.1.0.gem
Fetching xcodeproj-1.24.0.gem
Fetching colored2-3.1.2.gem
Fetching nanaimo-0.3.0.gem
Fetching nap-1.1.0.gem
Fetching molinillo-0.8.0.gem
Fetching gh_inspector-1.1.3.gem
Fetching fourflusher-2.3.1.gem
Fetching escape-0.0.4.gem
Fetching cocoapods-try-1.2.0.gem
Fetching netrc-0.11.0.gem
Fetching cocoapods-trunk-1.6.0.gem
Fetching cocoapods-search-1.0.1.gem
Fetching cocoapods-plugins-1.0.0.gem
Fetching cocoapods-downloader-2.1.gem
Fetching cocoapods-deintegrate-1.0.5.gem
Fetching ethon-0.16.0.gem
Fetching typhoeus-1.4.1.gem
Fetching public_suffix-4.0.7.gem
Fetching fuzzy_match-2.0.4.gem
Fetching concurrent-ruby-1.2.3.gem
Fetching httpclient-2.8.3.gem
Fetching algoliasearch-1.27.5.gem
Fetching ffi-1.16.3.gem
Fetching tzinfo-2.0.6.gem
Fetching connection_pool-2.4.1.gem
Fetching activesupport-7.1.3.2.gem
Fetching cocoapods-core-1.15.2.gem
Fetching cocoapods-1.15.2.gem
Fetching addressable-2.8.6.gem
Fetching i18n-1.14.4.gem
Successfully installed nanaimo-0.3.0
Successfully installed colored2-3.1.2
Successfully installed claide-1.1.0
Successfully installed CFPropertyList-3.0.7
Successfully installed atomos-0.1.3
Successfully installed xcodeproj-1.24.0
Successfully installed ruby-macho-2.5.1
Successfully installed nap-1.1.0
Successfully installed molinillo-0.8.0
Successfully installed gh_inspector-1.1.3
Successfully installed fourflusher-2.3.1
Successfully installed escape-0.0.4
Successfully installed cocoapods-try-1.2.0
Successfully installed netrc-0.11.0
Successfully installed cocoapods-trunk-1.6.0
Successfully installed cocoapods-search-1.0.1
Successfully installed cocoapods-plugins-1.0.0
Successfully installed cocoapods-downloader-2.1
Successfully installed cocoapods-deintegrate-1.0.5
Building native extensions. This could take a while...

Successfully installed ffi-1.16.3
Successfully installed ethon-0.16.0
Successfully installed typhoeus-1.4.1
Successfully installed public_suffix-4.0.7
Successfully installed fuzzy_match-2.0.4
Successfully installed concurrent-ruby-1.2.3
Successfully installed httpclient-2.8.3
A new major version is available for Algolia! Please now use the https://rubygems.org/gems/algolia gem to get the latest features.
Successfully installed algoliasearch-1.27.5
Successfully installed addressable-2.8.6
Successfully installed tzinfo-2.0.6
Successfully installed i18n-1.14.4
Successfully installed connection_pool-2.4.1
Successfully installed activesupport-7.1.3.2
Successfully installed cocoapods-core-1.15.2
Successfully installed cocoapods-1.15.2
Parsing documentation for nanaimo-0.3.0
Installing ri documentation for nanaimo-0.3.0
Parsing documentation for colored2-3.1.2
Installing ri documentation for colored2-3.1.2
Parsing documentation for claide-1.1.0
Installing ri documentation for claide-1.1.0
Parsing documentation for CFPropertyList-3.0.7
Installing ri documentation for CFPropertyList-3.0.7
Parsing documentation for atomos-0.1.3
Installing ri documentation for atomos-0.1.3
Parsing documentation for xcodeproj-1.24.0
Installing ri documentation for xcodeproj-1.24.0
Parsing documentation for ruby-macho-2.5.1
Installing ri documentation for ruby-macho-2.5.1
Parsing documentation for nap-1.1.0
Installing ri documentation for nap-1.1.0
Parsing documentation for molinillo-0.8.0
Installing ri documentation for molinillo-0.8.0
Parsing documentation for gh_inspector-1.1.3
Installing ri documentation for gh_inspector-1.1.3
Parsing documentation for fourflusher-2.3.1
Installing ri documentation for fourflusher-2.3.1
Parsing documentation for escape-0.0.4
Installing ri documentation for escape-0.0.4
Parsing documentation for cocoapods-try-1.2.0
Installing ri documentation for cocoapods-try-1.2.0
Parsing documentation for netrc-0.11.0
Installing ri documentation for netrc-0.11.0
Parsing documentation for cocoapods-trunk-1.6.0
Installing ri documentation for cocoapods-trunk-1.6.0
Parsing documentation for cocoapods-search-1.0.1
Installing ri documentation for cocoapods-search-1.0.1
Parsing documentation for cocoapods-plugins-1.0.0
Installing ri documentation for cocoapods-plugins-1.0.0
Parsing documentation for cocoapods-downloader-2.1
Installing ri documentation for cocoapods-downloader-2.1
Parsing documentation for cocoapods-deintegrate-1.0.5
Installing ri documentation for cocoapods-deintegrate-1.0.5
Parsing documentation for ffi-1.16.3
Installing ri documentation for ffi-1.16.3
Parsing documentation for ethon-0.16.0
Installing ri documentation for ethon-0.16.0
Parsing documentation for typhoeus-1.4.1
Installing ri documentation for typhoeus-1.4.1
Parsing documentation for public_suffix-4.0.7
Installing ri documentation for public_suffix-4.0.7
Parsing documentation for fuzzy_match-2.0.4
Installing ri documentation for fuzzy_match-2.0.4
Parsing documentation for concurrent-ruby-1.2.3
Installing ri documentation for concurrent-ruby-1.2.3
Parsing documentation for httpclient-2.8.3
Installing ri documentation for httpclient-2.8.3
Parsing documentation for algoliasearch-1.27.5
Installing ri documentation for algoliasearch-1.27.5
Parsing documentation for addressable-2.8.6
Installing ri documentation for addressable-2.8.6
Parsing documentation for tzinfo-2.0.6
Installing ri documentation for tzinfo-2.0.6
Parsing documentation for i18n-1.14.4
Installing ri documentation for i18n-1.14.4
Parsing documentation for connection_pool-2.4.1
Installing ri documentation for connection_pool-2.4.1
Parsing documentation for activesupport-7.1.3.2
Couldn't find file to include 'activesupport/README.rdoc' from lib/active_support.rb
Installing ri documentation for activesupport-7.1.3.2
Parsing documentation for cocoapods-core-1.15.2
Installing ri documentation for cocoapods-core-1.15.2
Parsing documentation for cocoapods-1.15.2
Installing ri documentation for cocoapods-1.15.2
Done installing documentation for nanaimo, colored2, claide, CFPropertyList, atomos, xcodeproj, ruby-macho, nap, molinillo, gh_inspector, fourflusher, escape, cocoapods-try, netrc, cocoapods-trunk, cocoapods-search, cocoapods-plugins, cocoapods-downloader, cocoapods-deintegrate, ffi, ethon, typhoeus, public_suffix, fuzzy_match, concurrent-ruby, httpclient, algoliasearch, addressable, tzinfo, i18n, connection_pool, activesupport, cocoapods-core, cocoapods after 21 seconds
34 gems installed

A new release of RubyGems is available: 3.4.19 → 3.5.6!
Run `gem update --system 3.5.6` to update your installation.

ksnowlv@MacBook-Pro-3 ~ % 
ksnowlv@MacBook-Pro-3 ~ % pod --version
1.15.2

```

### 用flutter验证下cocoapod是否升级成功


```shell
ksnowlv@MacBook-Pro-3 ~ % pod --version
1.15.2
ksnowlv@MacBook-Pro-3 ~ % flutter doctor

┌─────────────────────────────────────────────────────────┐
│ A new version of Flutter is available!                  │
│                                                         │
│ To update to the latest version, run "flutter upgrade". │
└─────────────────────────────────────────────────────────┘
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.19.2, on macOS 14.3.1 23D60 darwin-x64, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 15.2)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2023.1)
[✓] IntelliJ IDEA Ultimate Edition (version 2021.3.1)
[✓] VS Code (version 1.87.0)
[✓] Connected device (3 available)
[!] Network resources
    ✗ An HTTP error occurred while checking "https://github.com/": Connection closed before full header was received

! Doctor found issues in 1 category.
```