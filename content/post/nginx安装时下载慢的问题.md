---
title: "Nginx安装时Operation too slow. Less than 100 bytes/sec transferred the last 5 seconds的问题"
date: 2023-08-24T20:51:14+08:00
lastmod: 2023-08-24T20:51:14+08:00
keywords: ["Nginx"]
tags: ["Nginx", "后台开发"]
categories: ["Nginx", "后台开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## 一.问题

在**arch -arm64 brew install nginx**安装nginx时，遇见**Operation too slow. Less than 100 bytes/sec transferred the last 5 seconds**问题

## 二.解决方案

export HOMEBREW_NO_INSTALL_FROM_API=1

## 三.执行情况

```terminal
lvwei@lvweideMacBook-Pro scrapydemo % arch -arm64 brew install nginx
Running `brew update --auto-update`...
==> Auto-updated Homebrew!
Updated 1 tap (homebrew/core).

You have 7 outdated formulae and 1 outdated cask installed.

==> Fetching dependencies for nginx: ca-certificates and pcre2
==> Fetching ca-certificates
==> Downloading https://ghcr.io/v2/homebrew/core/ca-certificates/manifests/2023-08-22
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a8cd32e30cae0b7335779e93a6554f294f09485802fc253a3a8be441337a6115--ca-certificates-2023-08-22.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/ca-certificates/blobs/sha256:a331e92e7a759571296581f029e5cc2ec7cee70cd92dc0b5f8eb76095f94a21a
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/9be22fdac2e86ffb3bf6c165d2349e6e7fb9ff474a859890bcd63f79a807641e--ca-certificates--2023-08-22.arm64_ventura.bottle.tar.gz
==> Fetching pcre2
==> Downloading https://ghcr.io/v2/homebrew/core/pcre2/manifests/10.42
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/6a53794fcaabc5cc5e05b19c02ca9c4c5f2cb9a4d65a5790a6841146465b040f--pcre2-10.42.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/pcre2/blobs/sha256:8423a338c590ab1a6f265b39a9d1a67ab1361a586f0e494a8c9555cff2867536
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/20ad76b6ed64ec2235a96dfdd8b8b933d84eb616a5b9c2cd8b94768eabe220f5--pcre2--10.42.arm64_ventura.bottle.tar.gz
==> Fetching nginx
==> Downloading https://ghcr.io/v2/homebrew/core/nginx/manifests/1.25.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/61bfffc86c753f39e11b5b59a8b3dbd0f3e122c99e08682a080da1098eb12d91--nginx-1.25.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/nginx/blobs/sha256:bb7b7e469df875b0dae7fdbb02bc25af6d711daa72c8003f421dafe3a32ba2cf
############################################################################################################################################### 100.0%
==> Installing dependencies for nginx: ca-certificates and pcre2
==> Installing nginx dependency: ca-certificates
==> Pouring ca-certificates--2023-08-22.arm64_ventura.bottle.tar.gz
==> Regenerating CA certificate bundle from keychain, this may take a while...
🍺  /opt/homebrew/Cellar/ca-certificates/2023-08-22: 3 files, 221.7KB
==> Installing nginx dependency: pcre2
==> Pouring pcre2--10.42.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/pcre2/10.42: 230 files, 6.2MB
==> Installing nginx
==> Pouring nginx--1.25.2.arm64_ventura.bottle.tar.gz
==> Caveats
Docroot is: /opt/homebrew/var/www

The default port has been set in /opt/homebrew/etc/nginx/nginx.conf to 8080 so that
nginx can run without sudo.

nginx will load all files in /opt/homebrew/etc/nginx/servers/.

To start nginx now and restart at login:
  brew services start nginx
Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/nginx/bin/nginx -g daemon\ off\;
==> Summary
🍺  /opt/homebrew/Cellar/nginx/1.25.2: 26 files, 2.4MB
==> Running `brew cleanup nginx`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Caveats
==> nginx
Docroot is: /opt/homebrew/var/www

The default port has been set in /opt/homebrew/etc/nginx/nginx.conf to 8080 so that
nginx can run without sudo.

nginx will load all files in /opt/homebrew/etc/nginx/servers/.

To start nginx now and restart at login:
  brew services start nginx
Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/nginx/bin/nginx -g daemon\ off\;
lvwei@lvweideMacBook-Pro scrapydemo % 


```

