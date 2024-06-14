---
title: "Mac下Android Apk反编译重新打包-反编译修改代码(上篇)"
date: 2024-04-12T10:20:39+08:00
lastmod: 2024-04-12T10:20:39+08:00
keywords: ["Mac", "Android","破解", "反编译"]
tags: ["Mac", "Android","其它"]
categories: ["Mac", "Android","其它"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Mac 系统下如何对Android APK进行反编译重新打包呢？


### 1.背景

朋友app的域名需要更换，原来的最新代码没有了；因此,需要反编译下自己的apk应用，更换成新域名，尽快恢复线上业务。

我是第一次摸索着尝试，踩过许多坑；因此，总结下整个操作过程。


### 2.过程

如果要反编译apk，并修改代码重新打包，需要借助一些反编译工具，反编译出图片、XML配置、语言资源，代码，资源文件等，然后，确定apk修改方案，无论是修改代码，还是更新资源文件，都需要再签名APK文件；然后验证签名。

一般操作过程如下

* 反编译APK
* 修改APK内容
* 使用签名密钥重新签名APK
* 验证签名
* 安装APK测试验证

### 3.反编译APK工具

反编译apk需要借助工具，常见的Android APK 反编译工具有：

#### 3.1 Apktool 
[https://apktool.org/docs/install](https://apktool.org/docs/install/)

这是一个广泛使用的命令行工具，可以解包和重新打包APK文件。它允许用户提取APK的资源和清单文件，并在修改后重新打包。Apktool对于查看和修改APK的结构非常有用。


#### 3.2 dex2jar

[下载链接:https://sourceforge.net/projects/dex2jar/files/](https://sourceforge.net/projects/dex2jar/files/)


这个工具将APK中的Dex文件转换为Jar文件，这样就可以使用Java反编译工具（如JD-GUI）来查看源代码。dex2jar对于理解APK中的Java代码非常有帮助。

#### 3.3 JD-GUI
 这是一个图形界面工具，可以打开.class文件并显示Java源代码。虽然它不是专门用于Android的，但可以与dex2jar配合使用，来查看转换后的Java代码。
  
#### 3.4 jadx 
[官方链接：https://github.com/skylot/jadx](https://github.com/skylot/jadx)

这是一个相对较新的工具，提供了一个图形界面，可以直接将Dex文件反编译为Java源代码。jadx支持多种反编译选项，并提供了一些去混淆的功能，可以直接生成可读性较高的Java代码，也可以查看APK的资源文件。


#### 3.5 工具小结

结论：我们选用apktool工具。
  * 如果需要重新编译APK，通常使用Apktool；
  * 如果只是查看源代码，jadx是一个非常方便的选择，因为它可以提供较为清晰的代码结构和资源文件查看功能。

### 4.apktool安装

Mac下，直接使用**brew install apktool**命令安装，等待时间会比较长。

* 可能出现的问题1：

    curl: (28) Operation too slow. Less than 100 bytes/sec transferred the last 5 seconds

    解决方案：

    export HOMEBREW_NO_INSTALL_FROM_API=1

* 可能出现的问题2：

   .8%curl: (92) HTTP/2 stream 1 was not closed cleanly: PROTOCOL_ERROR (err 1)

    解决方案：
    
    git config --system http.version HTTP/1.1
    配置http协议1.1即可。


```shell
(base) ksnowlv@MacBook-Pro-3 homebrew-core %  brew install apktool
==> Downloading https://ghcr.io/v2/homebrew/core/apktool/manifests/2.9.3
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/b76cbfb603577b5561bb1ba2a7cf79422b3ca67195e9104a33cce35109d74b24--apktool-2.9.3.bottle_manifest.json
==> Fetching dependencies for apktool: giflib, fontconfig, ca-certificates, sqlite, gettext, glib, xorgproto, libxau, libxdmcp, libxcb, libx11, libxextiro, graphite2, harfbuzz, jpeg-turbo, libtiff, little-cms2 and openjdk
==> Downloading https://ghcr.io/v2/homebrew/core/giflib/manifests/5.2.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/51910e68b838a5c62c91c9352172d516e77a3c3c1a59a2cebaffc3f64f46adf4--giflib-5.2.1.bottle_manifest.json
==> Fetching giflib
==> Downloading https://ghcr.io/v2/homebrew/core/giflib/blobs/sha256:84a39bf9c63c3a0fd781c994921f012b5d34bcb8ab39105909453d8635488337
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/9e4f7b954f739668085b9a1bc1139ab540baf424d9c5272f4c28c537168298d0--giflib--5.2.1.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/fontconfig/manifests/2.15.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/33d176010dc9a105404ed23b6c0f8b853bf3a2df2e274876d412d7229a643320--fontconfig-2.15.0.bottle_manifest.json
==> Fetching fontconfig
==> Downloading https://ghcr.io/v2/homebrew/core/fontconfig/blobs/sha256:bbf54fe755e483815ed53755d3c5afbcba1560b5ad0b4d8b0abda3403be45079
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/486d9cd25383bca7b7ecfbb84bd6726308a0c524cb1c1dba23d26d18aff8f185--fontconfig--2.15.0.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/ca-certificates/manifests/2024-03-11
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/c431e0186df2ccc2ea942b34a3c26c2cebebec8e07ad6abdae48447a52c5f506--ca-certificates-2024-03-11.bottle_manifest.json
==> Fetching ca-certificates
==> Downloading https://ghcr.io/v2/homebrew/core/ca-certificates/blobs/sha256:cab828953672906e00a8f25db751977b8dc4115f021f8dfe82b644ade03dacdb
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/2c0842d836eaa991deac09d2f933bf5ff5b214d7c5d225c7fe042f6262ca21a9--ca-certificates--2024-03-11.all.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/sqlite/manifests/3.45.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/52aeccef7dfe87a5156de420a9e1f4b5b62f61b6c2b57633a5e6f04518b50edf--sqlite-3.45.2.bottle_manifest.json
==> Fetching sqlite
==> Downloading https://ghcr.io/v2/homebrew/core/sqlite/blobs/sha256:27b2cbea0051b4314e84c124a3b315437b25fc79c49621263f82120624653181
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/b0ae56b6b8315c7ff8dc9bb8aeb2eef9806402d79146b2000c7a5924fc1e2731--sqlite--3.45.2.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/gettext/manifests/0.22.5
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/447e45b77bb47ede0377f7eab1863825298ecaaaeed0bbd84aca3bd300b00508--gettext-0.22.5.bottle_manifest.json
==> Fetching gettext
==> Downloading https://ghcr.io/v2/homebrew/core/gettext/blobs/sha256:13492dddf82cad8dcb20d1c6375138a0712ce8e3c25b612256672446175c9727
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/0baf60d39a86f053f9e50d126e7a43d24e51d1249c7dabb6befbe22c0e80d430--gettext--0.22.5.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/glib/manifests/2.80.0_2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/bad07197fbf4d9c1af0f49bb79d89a3b369de9b90872243c8bbcfea7d4385475--glib-2.80.0_2.bottle_manifest.json
==> Fetching dependencies for glib: pcre2 and xz
==> Downloading https://ghcr.io/v2/homebrew/core/pcre2/manifests/10.43
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/4c12870adcfbf27eeeae4f44a420311ca3449f06a2fd8f6fcfe3d13db18087b4--pcre2-10.43.bottle_manifest.json
==> Fetching pcre2
==> Downloading https://ghcr.io/v2/homebrew/core/pcre2/blobs/sha256:be3af696b4ae7aa059dec0f7da50884e7a928584d44462739779345ac370620c
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/30f04ff4ab56c04c4780e3d74bb7914851c34844b8e85e00623281523c4baf25--pcre2--10.43.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/xz/manifests/5.4.6
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/b2cc4077807c100af6e0253f51d186f187ff55165638cbe3a4aa16d1c4762660--xz-5.4.6.bottle_manifest.json
==> Fetching xz
==> Downloading https://ghcr.io/v2/homebrew/core/xz/blobs/sha256:139fcf6d46fb85d3693f5d7452a37ec5f50f17b5ef044ac96a2c7deccb7983b4
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/43f3e389ca6041ad27899272abc383096ddb15ec4c51b83d5873dbc44829cabe--xz--5.4.6.sonoma.bottle.tar.gz
==> Fetching glib
==> Downloading https://ghcr.io/v2/homebrew/core/glib/blobs/sha256:39d8494c82a793f34853649e1e26a1a1f6a00e9ad89330e70e348c60a093e0b9
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/9f3b0dff6a130968695b42c3ec5df0bf690a1c4a0fda97b9524243db1398828d--glib--2.80.0_2.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/xorgproto/manifests/2024.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/d89d69340366d1d015e7214520f64081e2d82d7955fb28c6ea5f6539dcb610b2--xorgproto-2024.1.bottle_manifest.json
==> Fetching xorgproto
==> Downloading https://ghcr.io/v2/homebrew/core/xorgproto/blobs/sha256:3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/4c1f6f68a1f0f8735608642fe9278104d2031d0cfcbd737c0ea5d69b85f6841f--xorgproto--2024.1.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/libxau/manifests/1.0.11
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/7faff26297b2e07682655beaa529cff7b3de0ad1abc013863ca3d03602b79ee7--libxau-1.0.11.bottle_manifest.json
==> Fetching libxau
==> Downloading https://ghcr.io/v2/homebrew/core/libxau/blobs/sha256:10a5ba27ae98aad4e5f236a550a483a36a9ff13d3c3de388056fcfcf0b743614
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/396285d153ceb834188461fd0a380416b7a30cb9d1af770a3f0ceb84fad26cec--libxau--1.0.11.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/libxdmcp/manifests/1.1.5
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/8713e53f73d0be64780dbea522b0ee07027e6cc7828ff1a4fa0a6596f14cfe25--libxdmcp-1.1.5.bottle_manifest.json
==> Fetching libxdmcp
==> Downloading https://ghcr.io/v2/homebrew/core/libxdmcp/blobs/sha256:b43d28c50f25ee0775a1bd4269e236d00e352ac060522bfc9186b35165095c56
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/19250806e5b71fd875c53f22b8678a0cab1a06ee8c94abb73a97e28f52783f38--libxdmcp--1.1.5.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/libxcb/manifests/1.16.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/8770f5784e17b45567a2910cdf1ce0b535f85fc18cea509377ca1a6549ad6168--libxcb-1.16.1.bottle_manifest.json
==> Fetching libxcb
==> Downloading https://ghcr.io/v2/homebrew/core/libxcb/blobs/sha256:1667406532bebd840f67717678a9f7f0555b20d403192f91d97ab5c9be51c3ee
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/a1a07127668d87e7942d15bb001ed6dccab39932f36a4e2465e8650b0a123671--libxcb--1.16.1.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/libx11/manifests/1.8.9
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/ca292424919f76deb4667ed9445ade03489260780e6a18b3683e112aea943130--libx11-1.8.9.bottle_manifest.json
==> Fetching libx11
==> Downloading https://ghcr.io/v2/homebrew/core/libx11/blobs/sha256:e351920dd44b0b6df2eeb6f42f249ed0b0ed4e6f4a1fe96c9c943aa6605dc51c
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/5b411ceb2cf1e410b16e9733f74c44a686e811578e0ea5ab5e8403b7b2499d51--libx11--1.8.9.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/libxext/manifests/1.3.6
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/fedb843acbfcf682fb451396914bfc096f9ea2748376d4c43ce2af7ce1b766b7--libxext-1.3.6.bottle_manifest.json
==> Fetching libxext
==> Downloading https://ghcr.io/v2/homebrew/core/libxext/blobs/sha256:86fd68fab7f6cdcca7212812b697efc8d2c1349ceada7c74a1eeabf0f9ec8523
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/5583bffd4aa478a8474331362bad04933cbb8037a4f74079bc455c0befb94706--libxext--1.3.6.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/libxrender/manifests/0.9.11
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/134c11be8346a1b116e04983c2da6366f29c4f4c2abc17604dcdb80d0475ae9d--libxrender-0.9.11.bottle_manifest.json
==> Fetching libxrender
==> Downloading https://ghcr.io/v2/homebrew/core/libxrender/blobs/sha256:f61874ac3d98dfed35aa0a8790a71fa3a802d3d310d2e57e35570219a5864800
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/9d45608ab61cd52463b0663c8e07dae3c86d195a3baea512d1afb4ce37b2c5cb--libxrender--0.9.11.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/lzo/manifests/2.10
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/d4aa5b0c239912c53bc857d1012c6b7feb4acb509618f5e100f95bf8521f08e7--lzo-2.10.bottle_manifest.json
==> Fetching lzo
==> Downloading https://ghcr.io/v2/homebrew/core/lzo/blobs/sha256:11b8557744feb28974cb4caa92a16a89f3ead77468778cc17c2f349502df495e
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/2f0dc4a5fcf804e3ccfdd46e29b128bb47ad436437faf1d189a7e6096ae94830--lzo--2.10.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/pixman/manifests/0.42.2-1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/2b0d8f2c63712ce503fa54309b732051a7ca5cd31bd561aa4aaba331bf26bcef--pixman-0.42.2-1.bottle_manifest.json
==> Fetching pixman
==> Downloading https://ghcr.io/v2/homebrew/core/pixman/blobs/sha256:73469a943a06d34ae520803be550773c148f93b51e1e4a4aaaf9d59e16a8509d
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/b6ff83887165b685e8697f5f7666d9c9cf43b06b2e91fe6c77cc0a9301d28cf9--pixman--0.42.2.sonoma.bottle.1.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/cairo/manifests/1.18.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/1b8b7f19e38cb0e029497dfe0ad3f3557f605025c5575bdfe86c17b889c6e6d1--cairo-1.18.0.bottle_manifest.json
==> Fetching cairo
==> Downloading https://ghcr.io/v2/homebrew/core/cairo/blobs/sha256:18232de7a1880477f40f421262fa05f92278c7f494b3cabb1848dda92c545010
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/536914d97649e093c8ab328cb151b0a283678fe29a646323937cf8a8dd2813e1--cairo--1.18.0.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/graphite2/manifests/1.3.14
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/bbb4dd2ef1846301d1eb08053e19e11ca9c780f93f4d3b2d638fd94a9bf54a0c--graphite2-1.3.14.bottle_manifest.json
==> Fetching graphite2
==> Downloading https://ghcr.io/v2/homebrew/core/graphite2/blobs/sha256:afd3067ded2f8fb2ae3400d908a271825c5f7013f089312949ac9576b2a26d96
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/f1bd59181d3c8186b52b744bbe8bf9f851ba71f66a1fb83e45241c48dc973ede--graphite2--1.3.14.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/harfbuzz/manifests/8.4.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/fd47e37d9f5b5084316ec51955470aa32e038246275985aee10b1881a4f7344b--harfbuzz-8.4.0.bottle_manifest.json
==> Fetching dependencies for harfbuzz: libpng
==> Downloading https://ghcr.io/v2/homebrew/core/libpng/manifests/1.6.43
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/dd618b09b8d6d4b89203b771528951e5309631cc3afd8dc1236f0e98965f2b67--libpng-1.6.43.bottle_manifest.json
==> Fetching libpng
==> Downloading https://ghcr.io/v2/homebrew/core/libpng/blobs/sha256:12d4c09fc08f07816fd485c6e64d07e17426cce36bcd525292089bb80d4ecf22
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/43b0972b440808d42eae5772683ae39335baba2412a1caad2eb88a1bfcfb9064--libpng--1.6.43.sonoma.bottle.tar.gz
==> Fetching harfbuzz
==> Downloading https://ghcr.io/v2/homebrew/core/harfbuzz/blobs/sha256:2be9787ee914184a146b99eaf28fd3367ce487a5ff685b7cb6266022d8badd51
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/5fe573e7d46a0452964d1d9d609f4a06b0ef81dfb604977f242a40ee5cda8eed--harfbuzz--8.4.0.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/jpeg-turbo/manifests/3.0.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/54f92d3d554181004558964a73a1dfd7ce2c35088e5775217a61ca5b2344cf8e--jpeg-turbo-3.0.2.bottle_manifest.json
==> Fetching jpeg-turbo
==> Downloading https://ghcr.io/v2/homebrew/core/jpeg-turbo/blobs/sha256:4e2af273b76b2f4845b08d0f249630212e41a76b113e7d633d319cc6cfb43bef
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/b26c24b21992bce65a1d1b135922aeb984165f155dedf382b92102c7b57d78dc--jpeg-turbo--3.0.2.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/libtiff/manifests/4.6.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/9c8455a2f6bcea7bf3e3461218fba309141b0b0553b6e1afc5fe64e63caccff3--libtiff-4.6.0.bottle_manifest.json
==> Fetching libtiff
==> Downloading https://ghcr.io/v2/homebrew/core/libtiff/blobs/sha256:a89a2671064dbf7af6b84a9f2d20546b3dff82ed4b6f95c17bdfe48ce6c615fc
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/e0d4624ef841d64f88069fc9b1c4221e6c0f3900c7d9ec7478613113630fcc1a--libtiff--4.6.0.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/little-cms2/manifests/2.16
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/c4e2b31b0daade62da1f3c2e57d69f74987bac35310011b87220145fa60b3558--little-cms2-2.16.bottle_manifest.json
==> Fetching little-cms2
==> Downloading https://ghcr.io/v2/homebrew/core/little-cms2/blobs/sha256:46dd0d6ba9293999feaeb701a4c614440250a51daf0949478fbd486650a637bc
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/a154fac3e422690b623e4bda6555caed00133adc500465b214dfae983fb7cb6c--little-cms2--2.16.sonoma.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/openjdk/manifests/21.0.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/d437bb150fa297f0ee7f7f26594cb0a1e7aec55a45ec6570ed8660a033b7c3f9--openjdk-21.0.2.bottle_manifest.json
==> Fetching openjdk
==> Downloading https://ghcr.io/v2/homebrew/core/openjdk/blobs/sha256:dae1cda0c456621bc3138b597af13d13d97edc7e24e23510ee6167a8c07c6be4
############################################################################################################################################################################# 100.0%
==> Fetching apktool
==> Downloading https://ghcr.io/v2/homebrew/core/apktool/blobs/sha256:108cad7b26c5b0d9b771b6a2c4414c6b84d60875eeb2303ff76d9e672edbcfc7
############################################################################################################################################################################# 100.0%
==> Installing dependencies for apktool: giflib, fontconfig, ca-certificates, sqlite, gettext, glib, xorgproto, libxau, libxdmcp, libxcb, libx11, libxext, libxrender, lzo, pixman, cairo, graphite2, harfbuzz, jpeg-turbo, libtiff, little-cms2 and openjdk
==> Installing apktool dependency: giflib
==> Downloading https://ghcr.io/v2/homebrew/core/giflib/manifests/5.2.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/51910e68b838a5c62c91c9352172d516e77a3c3c1a59a2cebaffc3f64f46adf4--giflib-5.2.1.bottle_manifest.json
==> Pouring giflib--5.2.1.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/giflib/5.2.1: 19 files, 518.5KB
==> Installing apktool dependency: fontconfig
==> Downloading https://ghcr.io/v2/homebrew/core/fontconfig/manifests/2.15.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/33d176010dc9a105404ed23b6c0f8b853bf3a2df2e274876d412d7229a643320--fontconfig-2.15.0.bottle_manifest.json
==> Pouring fontconfig--2.15.0.sonoma.bottle.tar.gz
==> Regenerating font cache, this may take a while
==> /usr/local/Cellar/fontconfig/2.15.0/bin/fc-cache -frv
🍺  /usr/local/Cellar/fontconfig/2.15.0: 90 files, 2.2MB
==> Installing apktool dependency: ca-certificates
==> Downloading https://ghcr.io/v2/homebrew/core/ca-certificates/manifests/2024-03-11
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/c431e0186df2ccc2ea942b34a3c26c2cebebec8e07ad6abdae48447a52c5f506--ca-certificates-2024-03-11.bottle_manifest.json
==> Pouring ca-certificates--2024-03-11.all.bottle.tar.gz
==> Regenerating CA certificate bundle from keychain, this may take a while...
🍺  /usr/local/Cellar/ca-certificates/2024-03-11: 3 files, 229.7KB
==> Installing apktool dependency: sqlite
==> Downloading https://ghcr.io/v2/homebrew/core/sqlite/manifests/3.45.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/52aeccef7dfe87a5156de420a9e1f4b5b62f61b6c2b57633a5e6f04518b50edf--sqlite-3.45.2.bottle_manifest.json
==> Pouring sqlite--3.45.2.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/sqlite/3.45.2: 11 files, 4.7MB
==> Installing apktool dependency: gettext
==> Downloading https://ghcr.io/v2/homebrew/core/gettext/manifests/0.22.5
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/447e45b77bb47ede0377f7eab1863825298ecaaaeed0bbd84aca3bd300b00508--gettext-0.22.5.bottle_manifest.json
==> Pouring gettext--0.22.5.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/gettext/0.22.5: 2,043 files, 23.8MB
==> Installing apktool dependency: glib
==> Downloading https://ghcr.io/v2/homebrew/core/glib/manifests/2.80.0_2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/bad07197fbf4d9c1af0f49bb79d89a3b369de9b90872243c8bbcfea7d4385475--glib-2.80.0_2.bottle_manifest.json
==> Installing dependencies for glib: pcre2 and xz
==> Installing glib dependency: pcre2
==> Downloading https://ghcr.io/v2/homebrew/core/pcre2/manifests/10.43
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/4c12870adcfbf27eeeae4f44a420311ca3449f06a2fd8f6fcfe3d13db18087b4--pcre2-10.43.bottle_manifest.json
==> Pouring pcre2--10.43.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/pcre2/10.43: 234 files, 6.6MB
==> Installing glib dependency: xz
==> Downloading https://ghcr.io/v2/homebrew/core/xz/manifests/5.4.6
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/b2cc4077807c100af6e0253f51d186f187ff55165638cbe3a4aa16d1c4762660--xz-5.4.6.bottle_manifest.json
==> Pouring xz--5.4.6.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/xz/5.4.6: 163 files, 2.6MB
==> Installing glib
==> Pouring glib--2.80.0_2.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/glib/2.80.0_2: 524 files, 34.4MB
==> Installing apktool dependency: xorgproto
==> Downloading https://ghcr.io/v2/homebrew/core/xorgproto/manifests/2024.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/d89d69340366d1d015e7214520f64081e2d82d7955fb28c6ea5f6539dcb610b2--xorgproto-2024.1.bottle_manifest.json
==> Pouring xorgproto--2024.1.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/xorgproto/2024.1: 267 files, 3.9MB
==> Installing apktool dependency: libxau
==> Downloading https://ghcr.io/v2/homebrew/core/libxau/manifests/1.0.11
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/7faff26297b2e07682655beaa529cff7b3de0ad1abc013863ca3d03602b79ee7--libxau-1.0.11.bottle_manifest.json
==> Pouring libxau--1.0.11.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/libxau/1.0.11: 21 files, 105.6KB
==> Installing apktool dependency: libxdmcp
==> Downloading https://ghcr.io/v2/homebrew/core/libxdmcp/manifests/1.1.5
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/8713e53f73d0be64780dbea522b0ee07027e6cc7828ff1a4fa0a6596f14cfe25--libxdmcp-1.1.5.bottle_manifest.json
==> Pouring libxdmcp--1.1.5.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/libxdmcp/1.1.5: 11 files, 119.8KB
==> Installing apktool dependency: libxcb
==> Downloading https://ghcr.io/v2/homebrew/core/libxcb/manifests/1.16.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/8770f5784e17b45567a2910cdf1ce0b535f85fc18cea509377ca1a6549ad6168--libxcb-1.16.1.bottle_manifest.json
==> Pouring libxcb--1.16.1.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/libxcb/1.16.1: 2,462 files, 7MB
==> Installing apktool dependency: libx11
==> Downloading https://ghcr.io/v2/homebrew/core/libx11/manifests/1.8.9
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/ca292424919f76deb4667ed9445ade03489260780e6a18b3683e112aea943130--libx11-1.8.9.bottle_manifest.json
==> Pouring libx11--1.8.9.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/libx11/1.8.9: 1,042 files, 6.7MB
==> Installing apktool dependency: libxext
==> Downloading https://ghcr.io/v2/homebrew/core/libxext/manifests/1.3.6
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/fedb843acbfcf682fb451396914bfc096f9ea2748376d4c43ce2af7ce1b766b7--libxext-1.3.6.bottle_manifest.json
==> Pouring libxext--1.3.6.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/libxext/1.3.6: 87 files, 431.9KB
==> Installing apktool dependency: libxrender
==> Downloading https://ghcr.io/v2/homebrew/core/libxrender/manifests/0.9.11
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/134c11be8346a1b116e04983c2da6366f29c4f4c2abc17604dcdb80d0475ae9d--libxrender-0.9.11.bottle_manifest.json
==> Pouring libxrender--0.9.11.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/libxrender/0.9.11: 12 files, 198KB
==> Installing apktool dependency: lzo
==> Downloading https://ghcr.io/v2/homebrew/core/lzo/manifests/2.10
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/d4aa5b0c239912c53bc857d1012c6b7feb4acb509618f5e100f95bf8521f08e7--lzo-2.10.bottle_manifest.json
==> Pouring lzo--2.10.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/lzo/2.10: 31 files, 555.8KB
==> Installing apktool dependency: pixman
==> Downloading https://ghcr.io/v2/homebrew/core/pixman/manifests/0.42.2-1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/2b0d8f2c63712ce503fa54309b732051a7ca5cd31bd561aa4aaba331bf26bcef--pixman-0.42.2-1.bottle_manifest.json
==> Pouring pixman--0.42.2.sonoma.bottle.1.tar.gz
🍺  /usr/local/Cellar/pixman/0.42.2: 11 files, 1.4MB
==> Installing apktool dependency: cairo
==> Downloading https://ghcr.io/v2/homebrew/core/cairo/manifests/1.18.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/1b8b7f19e38cb0e029497dfe0ad3f3557f605025c5575bdfe86c17b889c6e6d1--cairo-1.18.0.bottle_manifest.json
==> Pouring cairo--1.18.0.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/cairo/1.18.0: 52 files, 2.1MB
==> Installing apktool dependency: graphite2
==> Downloading https://ghcr.io/v2/homebrew/core/graphite2/manifests/1.3.14
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/bbb4dd2ef1846301d1eb08053e19e11ca9c780f93f4d3b2d638fd94a9bf54a0c--graphite2-1.3.14.bottle_manifest.json
==> Pouring graphite2--1.3.14.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/graphite2/1.3.14: 18 files, 261KB
==> Installing apktool dependency: harfbuzz
==> Downloading https://ghcr.io/v2/homebrew/core/harfbuzz/manifests/8.4.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/fd47e37d9f5b5084316ec51955470aa32e038246275985aee10b1881a4f7344b--harfbuzz-8.4.0.bottle_manifest.json
==> Installing dependencies for harfbuzz: libpng
==> Installing harfbuzz dependency: libpng
==> Downloading https://ghcr.io/v2/homebrew/core/libpng/manifests/1.6.43
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/dd618b09b8d6d4b89203b771528951e5309631cc3afd8dc1236f0e98965f2b67--libpng-1.6.43.bottle_manifest.json
==> Pouring libpng--1.6.43.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/libpng/1.6.43: 27 files, 1.3MB
==> Installing harfbuzz
==> Pouring harfbuzz--8.4.0.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/harfbuzz/8.4.0: 76 files, 9.6MB
==> Installing apktool dependency: jpeg-turbo
==> Downloading https://ghcr.io/v2/homebrew/core/jpeg-turbo/manifests/3.0.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/54f92d3d554181004558964a73a1dfd7ce2c35088e5775217a61ca5b2344cf8e--jpeg-turbo-3.0.2.bottle_manifest.json
==> Pouring jpeg-turbo--3.0.2.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/jpeg-turbo/3.0.2: 44 files, 4.1MB
==> Installing apktool dependency: libtiff
==> Downloading https://ghcr.io/v2/homebrew/core/libtiff/manifests/4.6.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/9c8455a2f6bcea7bf3e3461218fba309141b0b0553b6e1afc5fe64e63caccff3--libtiff-4.6.0.bottle_manifest.json
==> Pouring libtiff--4.6.0.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/libtiff/4.6.0: 414 files, 6.6MB
==> Installing apktool dependency: little-cms2
==> Downloading https://ghcr.io/v2/homebrew/core/little-cms2/manifests/2.16
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/c4e2b31b0daade62da1f3c2e57d69f74987bac35310011b87220145fa60b3558--little-cms2-2.16.bottle_manifest.json
==> Pouring little-cms2--2.16.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/little-cms2/2.16: 22 files, 1.3MB
==> Installing apktool dependency: openjdk
==> Downloading https://ghcr.io/v2/homebrew/core/openjdk/manifests/21.0.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/d437bb150fa297f0ee7f7f26594cb0a1e7aec55a45ec6570ed8660a033b7c3f9--openjdk-21.0.2.bottle_manifest.json
==> Pouring openjdk--21.0.2.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/openjdk/21.0.2: 600 files, 331.5MB
==> Installing apktool
==> Pouring apktool--2.9.3.all.bottle.tar.gz
🍺  /usr/local/Cellar/apktool/2.9.3: 4 files, 22.2MB
==> Running `brew cleanup apktool`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Upgrading 6 dependents of upgraded formulae:
Disable this behaviour by setting HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
git 2.41.0_2 -> 2.44.0, nginx 1.25.2 -> 1.25.4, poco 1.13.2 -> 1.13.3, python@3.11 3.11.4_1 -> 3.11.9, ruby-build 20240221 -> 20240319, zstd 1.5.5 -> 1.5.6
==> Downloading https://ghcr.io/v2/homebrew/core/git/manifests/2.44.0
############################################################################################################################################################################# 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/nginx/manifests/1.25.4
############################################################################################################################################################################# 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/poco/manifests/1.13.3
############################################################################################################################################################################# 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/python/3.11/manifests/3.11.9
############################################################################################################################################################################# 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/ruby-build/manifests/20240319
############################################################################################################################################################################# 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/zstd/manifests/1.5.6
############################################################################################################################################################################# 100.0%
==> Checking for dependents of upgraded formulae...
==> No broken dependents to reinstall!
(base) ksnowlv@MacBook-Pro-3 homebrew-core % 
```

### 5.dex2jar下载安装

从[下载链接:https://sourceforge.net/projects/dex2jar/files/](https://sourceforge.net/projects/dex2jar/files/)下载2.0即可。


### 6.GD-GUI下载安装

从[下载链接https://github.com/java-decompiler/jd-gui](https://github.com/java-decompiler/jd-gui)下载GD-GUI，

![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/gd-gui_1.png)

出现上述情况下，打开苹果电脑设置中的隐私与安全性，如下图
![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/gd-gui_2.png)


然后，在安全性选项中，选择“仍要打开”即可；打开后，如果出现以下错误提示
![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/gd-gui_3.png)

看起来是说需要Java1.8+版本支持的问题，实际上是软件内部的bug，右键选择gd-gui.app,选中显示包内容，然后，找到如下图文件，修改JAVA路径，完成脚本文件的修改，并重启应用。

![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/gd-gui_4.png)

![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/gd-gui_5.jpg)


### 7.Apktool反编译apk

打开终端，通过 **apktool d**命令，反编译目标apk。

```shell

(base) ksnowlv@MacBook-Pro-3 apktool % apktool d demo.apk 
I: Using Apktool 2.9.3 on demo.apk
I: Loading resource table...
I: Decoding file-resources...
I: Loading resource table from file: /Users/ksnowlv/Library/apktool/framework/1.apk
I: Decoding values */* XMLs...
I: Decoding AndroidManifest.xml with resources...
I: Regular manifest package...
I: Baksmaling classes.dex...
I: Copying assets and libs...
I: Copying unknown files...
I: Copying original files...
(base) ksnowlv@MacBook-Pro-3 apktool %                               

```

反编译demo.apk，会生成demo文件夹；详细目录如下

![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/apktool_1.jpg)

其中
* smali：代码文件夹
* assets：资源文件，像logo，txt等
* res：布局，字符串等文件
  
### 8.dex2jar反编译代码

Mac下通过sh d2j-dex2jar.sh命令反编译classes.dex文件。

可以把apk修改为zip格式，解压后，包含classes.dex文件。目录结构如下：

![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/dex2jar_1.jpg)

如果遇到权限问题，修改权限即可。

```shell

(base) ksnowlv@MacBook-Pro-3 dex2jar-2.0 % sh d2j-dex2jar.sh demo-release-oversea/classes.dex 
dex2jar demo-release-oversea/classes.dex -> ./classes-dex2jar.jar
Detail Error Information in File ./classes-error.zip
Please report this file to http://code.google.com/p/dex2jar/issues/entry if possible.
(base) ksnowlv@MacBook-Pro-3 dex2jar-2.0 % 

```
成功生成了classes-dex2jar.jar

![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/dex2jar_2.jpg)


### 9.GD-GUI查看java代码，并修改smali代码

启动JD-GUI.app，并打开上一步骤生成的classes-dex2jar.jar文件，如下图

![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/gd-gui_6.png)

查找对应需要修改的代码，java代码如下图

![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/gd-gui_7.jpg)

smali代码修改如下

![image](/images/tools/Mac下Android-apk破解反编译修改代码后重新打包/smali_code.jpg)

然后，保存文件smali代码。


至此，APK代码修改完成，接下来是签名打包APK。


