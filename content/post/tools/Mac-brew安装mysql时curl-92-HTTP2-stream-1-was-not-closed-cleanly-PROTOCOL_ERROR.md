---
title: "Mac brew安装mysql时,出现curl: (92) HTTP/2 stream 1 was not closed cleanly: PROTOCOL_ERROR (err 1)"
date: 2024-03-02T10:10:27+08:00
lastmod: 2024-03-02T10:10:27+08:00
keywords: ["mysql", "Mac"]
tags: ["mysql", "Mac"]
categories: ["mysql", "Mac"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


### 1.问题

Mac brew安装mysql时,出现curl: (92) HTTP/2 stream 1 was not closed cleanly: PROTOCOL_ERROR (err 1),如下所示，如何处理呢？
```shell
ksnowlv@MacBook-Pro-3 ~ % brew install mysql
==> Downloading https://formulae.brew.sh/api/formula.jws.json
-#O=#    #      #                                                                                                                                                                
==> Downloading https://ghcr.io/v2/homebrew/core/mysql/manifests/8.3.0_1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/f43247f7870132d01463e879b650b2cc73f402040bc580d91865bf19bd88f2e6--mysql-8.3.0_1.bottle_manifest.json
==> Fetching dependencies for mysql: libevent, libcbor, libfido2, protobuf@21, zlib and zstd
==> Downloading https://ghcr.io/v2/homebrew/core/libevent/manifests/2.1.12_1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/68b113f9ab63db45f4e1860de522ce2ca4fa081eb3c0d5c7d6005a35c3cf8d06--libevent-2.1.12_1.bottle_manifest.json
==> Fetching libevent
==> Downloading https://ghcr.io/v2/homebrew/core/libevent/blobs/sha256:5d54f13cd93d87185bd7bb592cb945d1f64cac3e88d1e46c2fb5d9ea538d9623
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/04f847fd8a3e396a3957fc7c95e77d47c292140c4dc8e2795dd8dedf9a307478--libevent--2.1.12_1.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/libcbor/manifests/0.11.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/547a8f3a73e95b1a6ae76032004f514d926b4dbe82bab530cb3dd011c85c23ed--libcbor-0.11.0.bottle_manifest.json
==> Fetching libcbor
==> Downloading https://ghcr.io/v2/homebrew/core/libcbor/blobs/sha256:d7862b97499968a3bdf6ca866c806bbc81664b465c4703788ff4501e7d77269f
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/429abdd774568e6392a85768a31081b86d3f19aa4dd484d9c559d6c1096fc3fe--libcbor--0.11.0.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/libfido2/manifests/1.14.0_1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/80a360b5085398d57cd0cf902b18e1174c82430ef8172574a07100892755a597--libfido2-1.14.0_1.bottle_manifest.json
==> Fetching libfido2
==> Downloading https://ghcr.io/v2/homebrew/core/libfido2/blobs/sha256:3dee804ca54bc15d99e4a47cbecec62e7ffe64323afa476811bf1b2c7f8326bd
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/c8f4386c43c5e8ad7a6b5a3dfbc97cfee0a1f30e34f76a7ee9f91e73d4a79a91--libfido2--1.14.0_1.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/protobuf/21/manifests/21.12-2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/583342af32dcbdcd8cfa8359e446e22f36310246bf95602d6813748f1af52728--protobuf@21-21.12-2.bottle_manifest.json
==> Fetching protobuf@21
==> Downloading https://ghcr.io/v2/homebrew/core/protobuf/21/blobs/sha256:7ed1bf5fadc538bfbe3be0aa42bfb07673c17473ebb44df48f2c12bcafeeeafc
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/8c53c78d6054c87d961f5be294f2b38933e8ccfe2bdbf4359b1ab1b26d7ad8e7--protobuf@21--21.12.sonoma.bottle.2.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/zlib/manifests/1.3.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/f68d0caf232d52f2aa586abefbbfd7e958e384d84f3967008fa83de94b5f10ae--zlib-1.3.1.bottle_manifest.json
==> Fetching zlib
==> Downloading https://ghcr.io/v2/homebrew/core/zlib/blobs/sha256:217f4245cd1da65a3388f512530089f526cd63a38d49ee5f29a90576dfeb3bb7
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/222c7e15d7af48cb9955b2e06a06440bc9b611357acf6d730aef08ae2408ec58--zlib--1.3.1.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/zstd/manifests/1.5.5-1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/fc13698599720a53800064b40cddd854399651cf8760d9b0e46092f2e8da701a--zstd-1.5.5-1.bottle_manifest.json
==> Fetching zstd
==> Downloading https://ghcr.io/v2/homebrew/core/zstd/blobs/sha256:2137fe12a266078c16b162342500c7efa263def709e6742bfb4bf8601a3f36af
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/c1582c225fbc806915b47459b308376b77da47e46e37994f2d0772f185b531cc--zstd--1.5.5.sonoma.bottle.1.tar.gz
==> Fetching mysql
==> Downloading https://ghcr.io/v2/homebrew/core/mysql/blobs/sha256:1fdc5b8989a5f8e8a1543792c8bd5a20ca6bf477280b1d31774af033600d2e3b
#############################################################################################                                                                                54.7%curl: (92) HTTP/2 stream 1 was not closed cleanly: PROTOCOL_ERROR (err 1)

Error: mysql: Failed to download resource "mysql"
Download failed: https://ghcr.io/v2/homebrew/core/mysql/blobs/sha256:1fdc5b8989a5f8e8a1543792c8bd5a20ca6bf477280b1d31774af033600d2e3b
```

### 2.解决方案

配置使用http1.1协议即可

```shell
ksnowlv@MacBook-Pro-3 ~ % sudo git config --system http.version HTTP/1.1
```