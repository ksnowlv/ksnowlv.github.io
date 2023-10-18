---
title: "Mac-nginx安装及运行"
date: 2023-08-28T08:46:20+08:00
lastmod: 2023-08-28T08:46:20+08:00
keywords: ["后端开发","nginx"]
tags: ["后端开发","nginx"]
categories: ["后端开发","nginx"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

Mac arm64设备安装nginx

### 1.安装nginx

```terminal
arch -arm64 brew install nginx
```

### 2.启动nginx

```terminal
brew services start nginx
```

### 3.停止nginx

```terminal
brew services stop nginx
```


### 4.执行情况

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
lvwei@lvweideMacBook-Pro scrapydemo % ls
lvwei@lvweideMacBook-Pro scrapydemo %  brew services start nginx
==> Tapping homebrew/services
Cloning into '/opt/homebrew/Library/Taps/homebrew/homebrew-services'...
remote: Enumerating objects: 2482, done.
remote: Counting objects: 100% (235/235), done.
remote: Compressing objects: 100% (122/122), done.
remote: Total 2482 (delta 144), reused 135 (delta 113), pack-reused 2247
Receiving objects: 100% (2482/2482), 687.46 KiB | 445.00 KiB/s, done.
Resolving deltas: 100% (1144/1144), done.
Tapped 1 command (45 files, 857KB).
==> Successfully started `nginx` (label: homebrew.mxcl.nginx)
lvwei@lvweideMacBook-Pro scrapydemo %  brew services stop nginx 
Stopping `nginx`... (might take a while)
==> Successfully stopped `nginx` (label: homebrew.mxcl.nginx)
lvwei@lvweideMacBook-Pro scrapydemo % 

```
