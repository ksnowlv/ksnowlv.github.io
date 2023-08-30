---
title: "Python安装ffmpeg"
date: 2023-08-29T13:32:00+08:00
lastmod: 2023-08-29T13:32:00+08:00
keywords: ["Python", "音视频", "ffmpeg"]
tags: ["Python", "音视频"]
categories: ["Python", "音视频"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 安装ffmpeg

在Mac设备上，使用brew安装；

如果是非arm64的设备，使用

**brew install ffmpeg**
进行安装

如果是arm64的设备，使用

**arch -arm64 brew install ffmpeg**
进行安装

### 检查安装情况

可使用**ffprobe -version**命令查看

```terminal
lvwei@lvweideMacBook-Pro 1 % ffprobe -version
ffprobe version 6.0 Copyright (c) 2007-2023 the FFmpeg developers
built with Apple clang version 14.0.3 (clang-1403.0.22.14.1)
configuration: --prefix=/opt/homebrew/Cellar/ffmpeg/6.0_1 --enable-shared --enable-pthreads --enable-version3 --cc=clang --host-cflags= --host-ldflags= --enable-ffplay --enable-gnutls --enable-gpl --enable-libaom --enable-libaribb24 --enable-libbluray --enable-libdav1d --enable-libmp3lame --enable-libopus --enable-librav1e --enable-librist --enable-librubberband --enable-libsnappy --enable-libsrt --enable-libsvtav1 --enable-libtesseract --enable-libtheora --enable-libvidstab --enable-libvmaf --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxml2 --enable-libxvid --enable-lzma --enable-libfontconfig --enable-libfreetype --enable-frei0r --enable-libass --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libspeex --enable-libsoxr --enable-libzmq --enable-libzimg --disable-libjack --disable-indev=jack --enable-videotoolbox --enable-audiotoolbox --enable-neon
libavutil      58.  2.100 / 58.  2.100
libavcodec     60.  3.100 / 60.  3.100
libavformat    60.  3.100 / 60.  3.100
libavdevice    60.  1.100 / 60.  1.100
libavfilter     9.  3.100 /  9.  3.100
libswscale      7.  1.100 /  7.  1.100
libswresample   4. 10.100 /  4. 10.100
libpostproc    57.  1.100 / 57.  1.100

```

### 安装情况

需要安装的依赖比较多，等待时间会较长；如果安装失败，多试几次即可

```terminal
lvwei@lvweideMacBook-Pro 1 % arch -arm64 brew install ffmpeg
==> Downloading https://formulae.brew.sh/api/formula.jws.json
############################################################################################################################################### 100.0%
==> Downloading https://formulae.brew.sh/api/cask.jws.json
############################################################################################################################################### 100.0%
==> Fetching dependencies for ffmpeg: brotli, giflib, highway, imath, jpeg-turbo, libpng, lz4, zstd, libtiff, little-cms2, openexr, webp, jpeg-xl, libvmaf, aom, aribb24, dav1d, freetype, fontconfig, frei0r, libunistring, gettext, libidn2, libtasn1, nettle, p11-kit, libevent, libnghttp2, unbound, gnutls, lame, fribidi, glib, xorgproto, libxau, libxdmcp, libxcb, libx11, libxext, libxrender, lzo, pixman, cairo, graphite2, icu4c, harfbuzz, libunibreak, libass, libbluray, cjson, mbedtls, librist, libsoxr, libvidstab, libogg, libvorbis, libvpx, opencore-amr, openjpeg, opus, rav1e, libsamplerate, flac, mpg123, libsndfile, rubberband, sdl2, snappy, speex, srt, svt-av1, leptonica, libb2, libarchive, pango, tesseract, theora, x264, x265, xvid, libsodium, zeromq and zimg
==> Fetching brotli
==> Downloading https://ghcr.io/v2/homebrew/core/brotli/manifests/1.0.9
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/922ce7b351cec833f9bd2641f27d8ac011005f8b1f7e1119b8271cfb4c0d3cd7--brotli-1.0.9.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/brotli/blobs/sha256:dda0779953c24b98703ae950195fdd7f5ae6dbd697e026cb65520d13ea8b1258
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/44d604c75ca456a919d8c457e114f0dd38910b0e1ef107284a62aa0099484baa--brotli--1.0.9.arm64_ventura.bottle.tar.gz
==> Fetching giflib
==> Downloading https://ghcr.io/v2/homebrew/core/giflib/manifests/5.2.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/51910e68b838a5c62c91c9352172d516e77a3c3c1a59a2cebaffc3f64f46adf4--giflib-5.2.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/giflib/blobs/sha256:ced5a24b12f7057504aa8821a81c03c4d83ff6ba861487e25eba34b863237c20
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/5b08b896fd26dcbaf618db0a80e50fcdb4378ad1e9b292ccbe82d468a4b86713--giflib--5.2.1.arm64_ventura.bottle.tar.gz
==> Fetching highway
==> Downloading https://ghcr.io/v2/homebrew/core/highway/manifests/1.0.6
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/c4e039048708adda96d21defc3912f39b3fb50b9ccc80c527ea11bbde66f12de--highway-1.0.6.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/highway/blobs/sha256:0a38d434438a7796911d318b8508855c8a2002437c6e0fb41caf40504a912192
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/435893a61477e5cac7fec958650f234b746ebb81ff397c370405e19f410519a8--highway--1.0.6.arm64_ventura.bottle.tar.gz
==> Fetching imath
==> Downloading https://ghcr.io/v2/homebrew/core/imath/manifests/3.1.9
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a1667dc9df99f63d77a45c556d56932eab576af5c24e955461c65629589d7628--imath-3.1.9.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/imath/blobs/sha256:089d0a19694cd8bb2687be2d573e9f5aa1ee75f9173033bfc0aa2c4879d69e49
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/735fff26679c6296a7e496d2e8de0d0b12522e8d37a10620da01ad73db9ef3af--imath--3.1.9.arm64_ventura.bottle.tar.gz
==> Fetching jpeg-turbo
==> Downloading https://ghcr.io/v2/homebrew/core/jpeg-turbo/manifests/3.0.0
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/325e745bcb7840d6a83df7bfcafaa4dbc30b29140f252fb82b7714493df29d6d--jpeg-turbo-3.0.0.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/jpeg-turbo/blobs/sha256:1971c1fa66c2580fa0bfafe5350c6170bfe7395a4e503e7bfe0c69ec2e353010
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/2bcc4c5a6fba0d7f41f8856cecb6b424efe0fbc7c44517eaa4feaaad3e9f2ea1--jpeg-turbo--3.0.0.arm64_ventura.bottle.tar.gz
==> Fetching libpng
==> Downloading https://ghcr.io/v2/homebrew/core/libpng/manifests/1.6.40
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d2caacc64e32be045b902fa78d2bb4aea7fba8f088cef85cd34b1beab15b755a--libpng-1.6.40.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libpng/blobs/sha256:c309cf133ab08f4fd25210da897eaaff2603e9a7e1bdc178821c7e186fb9ee69
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d92c8f694c019a698b5bd9d77d9da821218c565f1d2cbf9c6744abebb8b43e74--libpng--1.6.40.arm64_ventura.bottle.tar.gz
==> Fetching lz4
==> Downloading https://ghcr.io/v2/homebrew/core/lz4/manifests/1.9.4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/379e59b981667f9585b33a2ff318769d8edca3ce6fd2e9a67ed291ae3e0cc872--lz4-1.9.4.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/lz4/blobs/sha256:cd29e40287b0a2d665a647acbea5512e8db4c371687147aab5c60bf9059b2cca
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/bdbca4231a01d687e54f87627b47f5209cd836fcba5f58353597bb599bea9cbe--lz4--1.9.4.arm64_ventura.bottle.tar.gz
==> Fetching zstd
==> Downloading https://ghcr.io/v2/homebrew/core/zstd/manifests/1.5.5-1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/fc13698599720a53800064b40cddd854399651cf8760d9b0e46092f2e8da701a--zstd-1.5.5-1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/zstd/blobs/sha256:cd3a7447c6a18cae189c2366820113f7b23425643482f8af45d03c6e91417ff8
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/928c9174f765c9995021ffc5e579f4d7fd7316f9bdb6c247dbd8c190397860a4--zstd--1.5.5.arm64_ventura.bottle.1.tar.gz
==> Fetching libtiff
==> Downloading https://ghcr.io/v2/homebrew/core/libtiff/manifests/4.5.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/7bcc5640a612ddb3a422eb41ae4c1ca8ba8ca478efa154546ad74dbe7a97a6d3--libtiff-4.5.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libtiff/blobs/sha256:c9ec64c61687ec04d3d98e017c2a7ec5c23ff8a061cdeaf54209197fdbfa53e7
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/ea9ad237af800f7700106ccfd1851cc10b38c8d12643baa861443a2fde48dd18--libtiff--4.5.1.arm64_ventura.bottle.tar.gz
==> Fetching little-cms2
==> Downloading https://ghcr.io/v2/homebrew/core/little-cms2/manifests/2.15
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/272d59128e963c029ee4be014a1cb85b12a790601ded962689c83e6190ecb0bf--little-cms2-2.15.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/little-cms2/blobs/sha256:ec43c4b1d15b75200740331b92656b624be01bd40cb993f862f41aca60ae670a
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/96b75293009f274a94ff33567f8141e6506ab46c23e31b8e5c72de5688373ccd--little-cms2--2.15.arm64_ventura.bottle.tar.gz
==> Fetching openexr
==> Downloading https://ghcr.io/v2/homebrew/core/openexr/manifests/3.1.11
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f147dfaa3895c2715af12ba01ab9ae6ee04462921963edf90801cbf3949b6e18--openexr-3.1.11.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/openexr/blobs/sha256:70521fc5a3751da3ada8d80bfba75dced5201e659aeb09b05cc37fac7fc4da56
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/5b04bb6fe29c8ab60a7ff265a196aab2b35be1787415b3f49961655bf1a7189a--openexr--3.1.11.arm64_ventura.bottle.tar.gz
==> Fetching webp
==> Downloading https://ghcr.io/v2/homebrew/core/webp/manifests/1.3.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/1d1da7ca1a2310dedd9806504bed5c32e8427736edf46cd1e4349155e4eadbe4--webp-1.3.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/webp/blobs/sha256:59410a24631f195f51044c59046086396e5ef52b4c521dbd6112af4df5c8bf79
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/49408c7c4a684730d69a7bb6c5971e59c73fcdb41454c267655cbed23473364e--webp--1.3.1.arm64_ventura.bottle.tar.gz
==> Fetching jpeg-xl
==> Downloading https://ghcr.io/v2/homebrew/core/jpeg-xl/manifests/0.8.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/395fab234e1ba873331a04e11f49d5aaacfcda0acc5de94d07ff7f6faec885a6--jpeg-xl-0.8.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/jpeg-xl/blobs/sha256:6186d463dd4c1258cb327cee90d39a0884937fc6ce98599c2ef5f1058b404972
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/c1fa5d5f3161c048cc2180eeadf79b7dcbf5a9de0b1c57db01108af6faaa6f36--jpeg-xl--0.8.2.arm64_ventura.bottle.tar.gz
==> Fetching libvmaf
==> Downloading https://ghcr.io/v2/homebrew/core/libvmaf/manifests/2.3.1-1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/2c60c744c64777df8cb83e3ae4115190f469b9e67e7d671d413220c0f4f3df55--libvmaf-2.3.1-1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libvmaf/blobs/sha256:76e8cc2dbe88b97c0ae2ee12d8c59c247c876eaa31d16c73225189bed1b37ee2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/0bcee2376708fe63a31947b025cd77958d7dad2a2b9d4dbe41188f243b5b48d0--libvmaf--2.3.1.arm64_ventura.bottle.1.tar.gz
==> Fetching aom
==> Downloading https://ghcr.io/v2/homebrew/core/aom/manifests/3.6.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/2ff52a4fcf3871fcffba76bc94ba350b180a1dc5505cba86a589359cd2400aeb--aom-3.6.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/aom/blobs/sha256:966c8e8e10fb914ce2d6272e6f44fa6235010914bd6e1b40a6a77516bbf92949
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d0ae93db91fdfa34de1b292dee091bf6df2d6079a5cc1778df7f4fe766f7ca89--aom--3.6.1.arm64_ventura.bottle.tar.gz
==> Fetching aribb24
==> Downloading https://ghcr.io/v2/homebrew/core/aribb24/manifests/1.0.4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/60185994f1623d662ea1959234838b47c2b4b891760a6b2af42d1cd3b36f2c0f--aribb24-1.0.4.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/aribb24/blobs/sha256:60ea5e1c7b35cde769b03c6172b4ff78dec340a91f8ae2e1c6b490fdce65c34a
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/bcc5aaa2f1f17d62e022058e34a7021fe0cddcdca7a9ac5f366c5d8967f0ddac--aribb24--1.0.4.arm64_ventura.bottle.tar.gz
==> Fetching dav1d
==> Downloading https://ghcr.io/v2/homebrew/core/dav1d/manifests/1.2.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/071b4251f434af9420784bdb7378219d1ab0a259ddcd352a112f5f8f8f5ade00--dav1d-1.2.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/dav1d/blobs/sha256:6e6f9a4347a07287d9649296ba3869740f4e4c01c2cc72337fea97b727b4e5cd
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/85a49a74ca046df24a44ca8bb47fcc1ec73a453c19d734a9a285235ac0b52ad0--dav1d--1.2.1.arm64_ventura.bottle.tar.gz
==> Fetching freetype
==> Downloading https://ghcr.io/v2/homebrew/core/freetype/manifests/2.13.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f23f2750170bb2e506247f3514d0791e11508e969e2439d4ceb8ac2bafd55da4--freetype-2.13.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/freetype/blobs/sha256:9770e7c6ca2660f431b95fc0de734cffa9e46c8598e90c735e4f9829180399b6
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d8a6a14e55cd37b1f5390e943a6b30c8f70229e57a2aee9a3c8310b194bc665f--freetype--2.13.2.arm64_ventura.bottle.tar.gz
==> Fetching fontconfig
==> Downloading https://ghcr.io/v2/homebrew/core/fontconfig/manifests/2.14.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/661b3d30dc143679f93265d36ce47323212b212b53bb099e319b0dba9c05594e--fontconfig-2.14.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/fontconfig/blobs/sha256:11cd488fc519d98142ed747300546eb65976c9a3bc973d955a934741c609b5df
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f7408eb81fd9b82030c57ca47c54bd3f79a905a99043960c3ccbde48e0c00b5c--fontconfig--2.14.2.arm64_ventura.bottle.tar.gz
==> Fetching frei0r
==> Downloading https://ghcr.io/v2/homebrew/core/frei0r/manifests/2.3.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/435408caaacea1d61173c90e8f54a6e0784e36cd5dceefe56ef3a8121e398eb0--frei0r-2.3.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/frei0r/blobs/sha256:4ed74b974e7139389d18023f046b110f6130077fdf439ebc5160a74c49d201a3
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/38469fec868ef74bc745365859db7cad7b2e0b7d1d9635bc975fa417be562736--frei0r--2.3.1.arm64_ventura.bottle.tar.gz
==> Fetching libunistring
==> Downloading https://ghcr.io/v2/homebrew/core/libunistring/manifests/1.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a34801f1ad5800ba51b2b3951d82a913ccf0641982f86b02df2f0aa182535055--libunistring-1.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libunistring/blobs/sha256:c78e7b0af88bef155ad7f12d63ad60f0c87e5a8cccb8f40ec5d9304f8fdfaee7
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/7fb9e9616138f3aeb84c37f10134efba75a8774100bc4301631efa2127f9b2b9--libunistring--1.1.arm64_ventura.bottle.tar.gz
==> Fetching gettext
==> Downloading https://ghcr.io/v2/homebrew/core/gettext/manifests/0.21.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/1c2f2c62faee672530e8e8e2695f99d26d1b606e74b289d1914dfa13c732c500--gettext-0.21.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/gettext/blobs/sha256:28c5b06e66800aa2d460336d001379e35e664310d12638de35a1b0f2b9a44913
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/e802c20093535dc4a2cb11b0279b8c26f8c920746bd2fdcddcd50faf461f7c3f--gettext--0.21.1.arm64_ventura.bottle.tar.gz
==> Fetching libidn2
==> Downloading https://ghcr.io/v2/homebrew/core/libidn2/manifests/2.3.4_1-1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/03ad193177f4e7d05ee2ed19a455028cb5fbf7ea1a812d88f18f5e9e8b4a4d43--libidn2-2.3.4_1-1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libidn2/blobs/sha256:b044c66cc0f1feea87d229f3f4016c5ff29a0fb0f712d0d5219f05465247b10f
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/9977cd3f036c73f93cc7e17345c9c5faba6d7b0057b39239f374efd66f656621--libidn2--2.3.4_1.arm64_ventura.bottle.1.tar.gz
==> Fetching libtasn1
==> Downloading https://ghcr.io/v2/homebrew/core/libtasn1/manifests/4.19.0
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/8abecce04f40738bc8a6921a6b96d847ea5c9759185d4bd9c7c9b5fb4922c375--libtasn1-4.19.0.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libtasn1/blobs/sha256:9fcf93a7992888a29caf2bc3ad37fb27ee8ceef180367797f4a11040fa761eac
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f3f2fd7d7501d2e2ea3390fcf447452c2b81259b41350b0ce22b1053b43a1577--libtasn1--4.19.0.arm64_ventura.bottle.tar.gz
==> Fetching nettle
==> Downloading https://ghcr.io/v2/homebrew/core/nettle/manifests/3.9.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a02ae3a1ecc6cff56e632f6452fd57f3fa72be16cde0b69e5b47747283fd3f6b--nettle-3.9.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/nettle/blobs/sha256:751e140ceac7711c462f1c05d74297c79f0abea26666f974370886c01d7bec83
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/3077218c165648f5919bb748886b09d2fa72e0d74cd28955cafeafb29eed8a79--nettle--3.9.1.arm64_ventura.bottle.tar.gz
==> Fetching p11-kit
==> Downloading https://ghcr.io/v2/homebrew/core/p11-kit/manifests/0.25.0
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/1f53b0b2b87f61522d01daa9cd2be4c4cb7a886a158054c3ddd3e4cada16777f--p11-kit-0.25.0.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/p11-kit/blobs/sha256:4dad6178e4d9f6ac8d9e20036b8ec1163d2d46dff494d1911e6ffcd7b19a4f93
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/ed1336fc457babd498edbbf4df714b88aa977aa78583313629b3850a814b789b--p11-kit--0.25.0.arm64_ventura.bottle.tar.gz
==> Fetching libevent
==> Downloading https://ghcr.io/v2/homebrew/core/libevent/manifests/2.1.12_1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/68b113f9ab63db45f4e1860de522ce2ca4fa081eb3c0d5c7d6005a35c3cf8d06--libevent-2.1.12_1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libevent/blobs/sha256:a75d453a7fe2aba1eaba334621b7bd9f0ff6f9e1f04aa400565f68711a9f6db4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/9d7ebdc8beaff8d4ea58ddd1a3ca4202469517195a6641b192e4fb1f958861ed--libevent--2.1.12_1.arm64_ventura.bottle.tar.gz
==> Fetching libnghttp2
==> Downloading https://ghcr.io/v2/homebrew/core/libnghttp2/manifests/1.55.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a7388c007744b7ed948eabea0fcc43839c4f8e3d890b17b5b1ea85764ddf964b--libnghttp2-1.55.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libnghttp2/blobs/sha256:9b8836abe3a3b7e1478fe50d1873f301dd9ae53c2ef814e44e9ce8d73cccc53f
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/914f1ee7d5a6cbc538d1b004525a2dcea1ed8fa9b1f7b3bafe4b889f0bbaa22f--libnghttp2--1.55.1.arm64_ventura.bottle.tar.gz
==> Fetching unbound
==> Downloading https://ghcr.io/v2/homebrew/core/unbound/manifests/1.17.1_1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/948115e40e109e23bad74fbd1c6903a6c54db16f0987c4acd8f461b4c037f778--unbound-1.17.1_1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/unbound/blobs/sha256:987c9200c5657ef18b7e81ba89981be152fd10bad97d4475870af1837b7eac9f
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/288ff436fb603f21d19e9292d0cfd7a2feaf448a064d0214a233a4835b214ba3--unbound--1.17.1_1.arm64_ventura.bottle.tar.gz
==> Fetching gnutls
==> Downloading https://ghcr.io/v2/homebrew/core/gnutls/manifests/3.8.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/6aa6ab211150ac0413509ee48a0b8b969ec36daf5056bc946d8c811bae202db9--gnutls-3.8.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/gnutls/blobs/sha256:e3c3e0156bee79b8af745e9d4587ccca48afe3a50a25071bfb185b3cfe41a215
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/3380cc044604790da25c7fcd593b8c9cc8a4e223afe2f0b72b81c2a68d8fe4c1--gnutls--3.8.1.arm64_ventura.bottle.tar.gz
==> Fetching lame
==> Downloading https://ghcr.io/v2/homebrew/core/lame/manifests/3.100
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/31e57f3a54d6908e2c153f5eb435715208f3bd9db71e16470b553d72e051b269--lame-3.100.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/lame/blobs/sha256:dde2fd627f56465b34aa521ec5ea789a2b6672f0336f5f9a0b6b831342b1052e
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/c2df77b961f7084cfd57099e8c0aa5928300606ac7f7366bfcac1b2e6be18364--lame--3.100.arm64_ventura.bottle.tar.gz
==> Fetching fribidi
==> Downloading https://ghcr.io/v2/homebrew/core/fribidi/manifests/1.0.13
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/0a8bdd323a3d26862d77249d5999ab774d1966995ddac29d67eb9a63d53552ff--fribidi-1.0.13.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/fribidi/blobs/sha256:0272f179bac6809467c56eb0b1fac7f1de88b4c012fd36e77411aec39e5f9b4f
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a0cbb577832d404cb6d9cb20dccea2db426d95b023d97f001b9993fe44852b44--fribidi--1.0.13.arm64_ventura.bottle.tar.gz
==> Fetching glib
==> Downloading https://ghcr.io/v2/homebrew/core/glib/manifests/2.76.4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/948354b81d1afa62d6c2c2bb260e244d78249c041da621692ead9cdee06fc7f8--glib-2.76.4.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/glib/blobs/sha256:e5995be18147cbc766ee495c2d142f79b80cc18ac95c8eb3bce6613bcad88fe3
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/3652721057cff0ee182d37759ea1aad961401f8a4571cbc42337d585d7c6eeac--glib--2.76.4.arm64_ventura.bottle.tar.gz
==> Fetching xorgproto
==> Downloading https://ghcr.io/v2/homebrew/core/xorgproto/manifests/2023.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/8740825bd79ba6441c86fb430f955cb3d08f4693dd2947fe877c11c7c8122343--xorgproto-2023.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/xorgproto/blobs/sha256:de818c35cca25c4b2286a5642d5d1748320f6031039ec46b375fd11e935ef7e3
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/838d9cbf93aa7a33dbb8c4f7dc2009c1e465930f4e78609d1c4a7612a2652855--xorgproto--2023.2.arm64_ventura.bottle.tar.gz
==> Fetching libxau
==> Downloading https://ghcr.io/v2/homebrew/core/libxau/manifests/1.0.11
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/7faff26297b2e07682655beaa529cff7b3de0ad1abc013863ca3d03602b79ee7--libxau-1.0.11.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libxau/blobs/sha256:d8cc440c5804ecf424d96d3cd4e92e88c83d43e7f927126c768caee2dffe36a8
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a1f8411236b667139ee1ecc1a4802559f26ff128c1b693516ca2ac8f9d2a3413--libxau--1.0.11.arm64_ventura.bottle.tar.gz
==> Fetching libxdmcp
==> Downloading https://ghcr.io/v2/homebrew/core/libxdmcp/manifests/1.1.4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/1af80edced252b5f690f78a3805b785cbf689dc947cd5f45dced60c97640a9c9--libxdmcp-1.1.4.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libxdmcp/blobs/sha256:2fb2d55b8f9722e68eeb76bcd77d3e9d5bbe52c96db2c05ceb70152f0ff4883d
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/7167772f3e11cc89a6e578d955ee39fa57cfc0f160bb8812f56dac6fbde59246--libxdmcp--1.1.4.arm64_ventura.bottle.tar.gz
==> Fetching libxcb
==> Downloading https://ghcr.io/v2/homebrew/core/libxcb/manifests/1.15_1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/5858488a4fb22c9e73a94e81a01991476be76cef69a5bd8b996de5a8873f1e33--libxcb-1.15_1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libxcb/blobs/sha256:cf7a5932142b247a4af6b7681ac44b74e16081806e651640e3ae460df08d71a7
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/b984cfed07a412d4a357927c64d38b64b6e5a9efd57b583bcd3003061614e7bc--libxcb--1.15_1.arm64_ventura.bottle.tar.gz
==> Fetching libx11
==> Downloading https://ghcr.io/v2/homebrew/core/libx11/manifests/1.8.6
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a047a8db00f00164a2ab2fd39f900c4966616d72331a314727c32253916bc09e--libx11-1.8.6.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libx11/blobs/sha256:12634191390f2feaad802e2c98dbee1274f688d1348ba7319462340defe2d07d
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/cd91409abce5b85842df57d69305107411f13e918438a514042470daab90f27a--libx11--1.8.6.arm64_ventura.bottle.tar.gz
==> Fetching libxext
==> Downloading https://ghcr.io/v2/homebrew/core/libxext/manifests/1.3.5
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/36b14aebd45b8fbf0f965d846bbc5126adbe882c0775c9936edb0432b347b9a1--libxext-1.3.5.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libxext/blobs/sha256:36ef5333565be1614ad8eb2d740ea93df80c5d2ee41b403145179e7c5d1e1e82
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f4c84f25a99b1eae8afd8436f9c47f3a4806aa9ecc36a7dbb9cdf5d32fe0d151--libxext--1.3.5.arm64_ventura.bottle.tar.gz
==> Fetching libxrender
==> Downloading https://ghcr.io/v2/homebrew/core/libxrender/manifests/0.9.11
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/134c11be8346a1b116e04983c2da6366f29c4f4c2abc17604dcdb80d0475ae9d--libxrender-0.9.11.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libxrender/blobs/sha256:510d0cd0f72480d716b38cd935e3a334ed1be972210ffac7309d0dd80469c8bb
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/cf4e6f27b41ee48304dfa7f1d20e9d72b3eac55c61bb7ab02360c9b46df078f1--libxrender--0.9.11.arm64_ventura.bottle.tar.gz
==> Fetching lzo
==> Downloading https://ghcr.io/v2/homebrew/core/lzo/manifests/2.10
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d4aa5b0c239912c53bc857d1012c6b7feb4acb509618f5e100f95bf8521f08e7--lzo-2.10.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/lzo/blobs/sha256:a565c627b13f2dc7fc4550aa8290a4c3feb2f48fcaa45c9f7f4bc4fe4535aa66
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/b859e0c335f31f15545d4cf698238a5ca6a91e4fccc88bda29d2763941acf9a6--lzo--2.10.arm64_ventura.bottle.tar.gz
==> Fetching pixman
==> Downloading https://ghcr.io/v2/homebrew/core/pixman/manifests/0.42.2-1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/2b0d8f2c63712ce503fa54309b732051a7ca5cd31bd561aa4aaba331bf26bcef--pixman-0.42.2-1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/pixman/blobs/sha256:e27867c503bd9cf858159261e053184d19ae00357dc89426810f80734aaaefd0
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/b95c0d0f80b93312dd8eda8e88a5734ca3bd2d948aa95e01283776d9bb571aba--pixman--0.42.2.arm64_ventura.bottle.1.tar.gz
==> Fetching cairo
==> Downloading https://ghcr.io/v2/homebrew/core/cairo/manifests/1.16.0_5
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f9e86ee818c57a136b1c1c82caecdf07bb8eaad8e31f5e59e456a10d6d1a1cc5--cairo-1.16.0_5.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/cairo/blobs/sha256:4a0f5f55a3314f6b4223661c3af406d3551349b4dcabfda7a6e7b6a569187764
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d2b099dbaabd6975ebf10144287691e611ff445acfd25a95787f9aa5c238064b--cairo--1.16.0_5.arm64_ventura.bottle.tar.gz
==> Fetching graphite2
==> Downloading https://ghcr.io/v2/homebrew/core/graphite2/manifests/1.3.14
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/bbb4dd2ef1846301d1eb08053e19e11ca9c780f93f4d3b2d638fd94a9bf54a0c--graphite2-1.3.14.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/graphite2/blobs/sha256:3ec770419ed60d211670f73bf078512824151b460c5c37740ee8b83e3dbb8357
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/9f2bba1173f565d3d7ef1ab53da317f9a8b737a7f47f0a71d58c0ddec1e7f899--graphite2--1.3.14.arm64_ventura.bottle.tar.gz
==> Fetching icu4c
==> Downloading https://ghcr.io/v2/homebrew/core/icu4c/manifests/73.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/2e5082de52a2c85ae665e51f8d0de0651611397cb02f4b4e2bb37898ba52a629--icu4c-73.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/icu4c/blobs/sha256:953797d46546c570c4fab4e8b2395624ae90acd492f75b68ff99fbd115ccd748
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/1e0f31a89e4d047dc95e651cf911b97e33b91f7e13d8909be0f60a5c18c1dc7c--icu4c--73.2.arm64_ventura.bottle.tar.gz
==> Fetching harfbuzz
==> Downloading https://ghcr.io/v2/homebrew/core/harfbuzz/manifests/8.1.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/4e9f189228b4168a3e39087fb07e7d351a438943022efb78f1a06b717083a3dd--harfbuzz-8.1.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/harfbuzz/blobs/sha256:8849b51933258f8135ca000b7125beffb8dd5d95673be2711648167459bacdf5
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/3260051ce507c99375bf7fe3b60b1e5fdcac78d8ef823fd7716d2e064285f9b8--harfbuzz--8.1.1.arm64_ventura.bottle.tar.gz
==> Fetching libunibreak
==> Downloading https://ghcr.io/v2/homebrew/core/libunibreak/manifests/5.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d71cb4e97ae4b73521741ae3b16d4d11c9d2e4d2ce3c847e47c9a9ceeadfccb9--libunibreak-5.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libunibreak/blobs/sha256:7dfc308bb0fdaf546e5d27a9c0c871778231e8f8624e5cf375da8e634b9e21f4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/8d320b92b82fdef5e5829c95296f091415595d20856d184674e54ba087f2a7c0--libunibreak--5.1.arm64_ventura.bottle.tar.gz
==> Fetching libass
==> Downloading https://ghcr.io/v2/homebrew/core/libass/manifests/0.17.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/6662860d326f7141f0177312b5ae45531f9074b409e5db04b2376adca23748ee--libass-0.17.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libass/blobs/sha256:0f5b7f92f0a546fdc3132dc9aba43cfa6a0c9817fea4ae5757c300eff84848e2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/c76fc4edd7a28fa786f3bfe8e9df949ffa8ed4f00b03671856dc205316643ff0--libass--0.17.1.arm64_ventura.bottle.tar.gz
==> Fetching libbluray
==> Downloading https://ghcr.io/v2/homebrew/core/libbluray/manifests/1.3.4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/3ca2a7bc181ca21ac727ad165abb77758d74c9c260dd155b33f741b1eee5801a--libbluray-1.3.4.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libbluray/blobs/sha256:c51fc3248e75d1cf23f9d3d2856d719e6298b913e4b161f066993b2485a79b66
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/0cd156a4275cee8678ff60535fedd66a34912bcfa547e7d80619d638942f5b7d--libbluray--1.3.4.arm64_ventura.bottle.tar.gz
==> Fetching cjson
==> Downloading https://ghcr.io/v2/homebrew/core/cjson/manifests/1.7.16-1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/fb770679a7fe607f00feffd67590eea8d4b2a5f6fd59fccd8fa2b9587bb3615b--cjson-1.7.16-1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/cjson/blobs/sha256:86ee096088caae2433c9f85afa172a6aef245fdf6ce9fcf9ff352702fe2000a6
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/5835fc5ae6ce0ff734770df10c49e2fac9aee8f0e0284075720634c45d9627dc--cjson--1.7.16.arm64_ventura.bottle.1.tar.gz
==> Fetching mbedtls
==> Downloading https://ghcr.io/v2/homebrew/core/mbedtls/manifests/3.4.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f4c89bcb645eb0c897a4d804cfc5c7043686408e127344e999fd6622aea40fa3--mbedtls-3.4.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/mbedtls/blobs/sha256:ea1d7bb96f8bb6a874bd9260b715d0c16df55b00eb0910d05df032e621f7fe3e
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/fb571f9d5d43c3bff8e1ba611fb8665bcb753b519ad1f662d1ce14e61a0253c8--mbedtls--3.4.1.arm64_ventura.bottle.tar.gz
==> Fetching librist
==> Downloading https://ghcr.io/v2/homebrew/core/librist/manifests/0.2.7_3
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/8c5e7ddf732f567ddd44e4a27d0105ae92c800b6da104c26040b97559cf1e075--librist-0.2.7_3.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/librist/blobs/sha256:42c00e005437933df6c35e1b02279574a5ba02cc291197e219dc7abba000562b
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/cfe0ac2ca12502fd01c3fd1a1d3705565f60a6073b2d0d655abb35c76a6bdf3b--librist--0.2.7_3.arm64_ventura.bottle.tar.gz
==> Fetching libsoxr
==> Downloading https://ghcr.io/v2/homebrew/core/libsoxr/manifests/0.1.3-1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f10988e95845131f890c95b52caea83e46332718a0787ff7b473f71e9ca6e536--libsoxr-0.1.3-1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libsoxr/blobs/sha256:458c15f8d4dbe92d51959fd62662b275475c36f379581385681975fbba90c8f1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/3921677559ff5e6ce45563b3665abe4328d553e7a17538e47ff49167459a603b--libsoxr--0.1.3.arm64_ventura.bottle.1.tar.gz
==> Fetching libvidstab
==> Downloading https://ghcr.io/v2/homebrew/core/libvidstab/manifests/1.1.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/cd6a6b0bc36ba382104f583fa6d59418959b6719401628d655a236dfc580cd85--libvidstab-1.1.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libvidstab/blobs/sha256:25efabe3bf9a85b25065758c1ea62ef096bf2e334ce073450ef4478f7e469b38
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a9d6c557b482ae54ca41d74018fb47083188882a15bb9fe4604578d15e0134f2--libvidstab--1.1.1.arm64_ventura.bottle.tar.gz
==> Fetching libogg
==> Downloading https://ghcr.io/v2/homebrew/core/libogg/manifests/1.3.5-2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/1c13722950e996f50a0ef7aa1e181de6b2a8a754ebb8f695c4efc56e0d592ad6--libogg-1.3.5-2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libogg/blobs/sha256:d241e81018d3b64ec0d491d5d43f5409496747d57fb8d0eff75c534bd84dd19a
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/6f9add0ebb95427a81330156e8c79eed19a8ca30b57b2af5e8fe8331d99f2e2a--libogg--1.3.5.arm64_ventura.bottle.2.tar.gz
==> Fetching libvorbis
==> Downloading https://ghcr.io/v2/homebrew/core/libvorbis/manifests/1.3.7-1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/68d211b8805a2fab148645c2ac8e43495e576876d6f50f0c4af5ea890730b7ea--libvorbis-1.3.7-1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libvorbis/blobs/sha256:941871c7cfee1e15b60191e1c70296554871bc36e4fc8104ffc8919bb767f555
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d2c67fe1b255e43867cfcd0cf1bb1572104b250f6029b3abb6431c9b32671c55--libvorbis--1.3.7.arm64_ventura.bottle.1.tar.gz
==> Fetching libvpx
==> Downloading https://ghcr.io/v2/homebrew/core/libvpx/manifests/1.13.0
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/59d5fe7c4f700a07f7a3131c2050707caa8eb665611bc4b36d0d579fee275ca9--libvpx-1.13.0.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libvpx/blobs/sha256:868daf3511cf9fb086551f407caa54103c93e149dc31d4462a8b866370dc8682
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/cbda2bfd6c41a645417d3edc1d1e89ee569abfba2e1dac57c81b25e2dcbb66c1--libvpx--1.13.0.arm64_ventura.bottle.tar.gz
==> Fetching opencore-amr
==> Downloading https://ghcr.io/v2/homebrew/core/opencore-amr/manifests/0.1.6
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/e2036ba279d7fa8546fb4e263e4b1276b5a68551a70e99aca9863561b1039962--opencore-amr-0.1.6.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/opencore-amr/blobs/sha256:673be457f0de7494de04b1d079de9074e79e03a74f1fe520227f75d7c7953265
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/22ff7c36c68b00240bcc5bc14a379856e75fc8a6c92d99f6fed60431621823ea--opencore-amr--0.1.6.arm64_ventura.bottle.tar.gz
==> Fetching openjpeg
==> Downloading https://ghcr.io/v2/homebrew/core/openjpeg/manifests/2.5.0_1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d3acfd3e45dc08593423b30691238e57dfba97ca41463eae5b4d04ffc9a6e1c5--openjpeg-2.5.0_1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/openjpeg/blobs/sha256:4608628e92a5691cd45550219c92def72e3543f372af39f88d1bda2b87a40f3b
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/6eba4730d82d83cb7c37b67ba5813b590baed6b5b1798a7be0bc20c9edf834b7--openjpeg--2.5.0_1.arm64_ventura.bottle.tar.gz
==> Fetching opus
==> Downloading https://ghcr.io/v2/homebrew/core/opus/manifests/1.4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/547fa7f5747ea451f9988691c377aa4ceb594c4d432fdda5f500a09e927bf829--opus-1.4.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/opus/blobs/sha256:6901207819378dec2bdac601e2d290e498939af95209438180f3f93a32dda447
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/9d7b492510be47834bed7b2d29d72d9b0b45d8945f2af4aa0d56d86c027422d5--opus--1.4.arm64_ventura.bottle.tar.gz
==> Fetching rav1e
==> Downloading https://ghcr.io/v2/homebrew/core/rav1e/manifests/0.6.6
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/55c782a89f28ef727a369de439c76245d2e95a25201f3bef082a5e6c43c8fdd3--rav1e-0.6.6.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/rav1e/blobs/sha256:3a0e10c10070252c551cdb863000fdfd08b3f39f73f6834f8ba468245bfd7407
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/e36824f2156afffe94a36327b3b48df03398373bbdb54152dec541a9f4b5be81--rav1e--0.6.6.arm64_ventura.bottle.tar.gz
==> Fetching libsamplerate
==> Downloading https://ghcr.io/v2/homebrew/core/libsamplerate/manifests/0.2.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/27dd59fa55dbebeb65e77b8d04f3b390a899a35dad23d3fd7a4f895b3f7fbfed--libsamplerate-0.2.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libsamplerate/blobs/sha256:3e9b241d45526b794f8f2a5873b1377ba909532da1bde00a235c8949edde1366
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/8e2797db46ddd313ef0bf9f4c02a951afa12480f6450d836dfea94f0e3335613--libsamplerate--0.2.2.arm64_ventura.bottle.tar.gz
==> Fetching flac
==> Downloading https://ghcr.io/v2/homebrew/core/flac/manifests/1.4.3
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/7672ff666ae1dc9b535827ff76c3701b41ed244aae83ed9083687bb12b7ef5bf--flac-1.4.3.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/flac/blobs/sha256:3962fce4abb2716cd21a9b9ebeda4f2e5c4bea08c32ea3cc0316f369da054019
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d30cb4026ac0cde4be120b6e3578ddacd23eb64f9d3cd08030a79d7d0a341f78--flac--1.4.3.arm64_ventura.bottle.tar.gz
==> Fetching mpg123
==> Downloading https://ghcr.io/v2/homebrew/core/mpg123/manifests/1.31.3
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/43d73d24fb3563d79b467d11a233148b7522d244c4e89caf6895ca307aea29bf--mpg123-1.31.3.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/mpg123/blobs/sha256:28c36a95aa73e8168cd267e17c00b7461afe9f72470b5a5f2ad4270cffe54d6c
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d2e71820351298ddebbab7d7ddb017269492d343b9741a71a70dfa5d6be1a1bf--mpg123--1.31.3.arm64_ventura.bottle.tar.gz
==> Fetching libsndfile
==> Downloading https://ghcr.io/v2/homebrew/core/libsndfile/manifests/1.2.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/80c55dbc8f5c46049045fd181ae41071d1939a223108dba5328685afe7dfc6f8--libsndfile-1.2.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libsndfile/blobs/sha256:0d50a581032c9791f8e36c41f7284a3883b42d7f6e23175392eab1d87989e99e
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/53b4412e46d04430ac257090e74dd79d6e0865bfad72597f598fa76e9e8f7708--libsndfile--1.2.2.arm64_ventura.bottle.tar.gz
==> Fetching rubberband
==> Downloading https://ghcr.io/v2/homebrew/core/rubberband/manifests/3.3.0
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d7b37a08cef72d7b9431b19abc4aaa4649642b6610ad91f39146347d2aaeb60a--rubberband-3.3.0.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/rubberband/blobs/sha256:206c609c7172b67789074a7cf6d7f488754c36385c8fa192be5b7d79250baa9f
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f11d7e9db46f1d92071355c866ff0e6b7e56cd875f55f9395e15fd77f963e151--rubberband--3.3.0.arm64_ventura.bottle.tar.gz
==> Fetching sdl2
==> Downloading https://ghcr.io/v2/homebrew/core/sdl2/manifests/2.28.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a4262216f444b35b52e9137f36acb0689c4d0e2d81fb32676e5e19daf243e160--sdl2-2.28.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/sdl2/blobs/sha256:cfa4fcd327d0a1bf1241df0b25c33c6e8912dd25fb0e373b85f34a696ccda894
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/b403541ce4220c6873d6cf68f405d215125c706db160ee705c207f83715d0d23--sdl2--2.28.2.arm64_ventura.bottle.tar.gz
==> Fetching snappy
==> Downloading https://ghcr.io/v2/homebrew/core/snappy/manifests/1.1.10
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/66500196008160ff18d67179e002e417a71c59707d74a6706c2e89a8aa2411b8--snappy-1.1.10.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/snappy/blobs/sha256:ca95915a51bed09a5e70ebb6f253eabe4df5b00e87ebe49aea0124f8bb51bc3c
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/2798e71cbbe55ce004e96984ddb3792d7a77bceed0b1bd7357d8f201fa237d31--snappy--1.1.10.arm64_ventura.bottle.tar.gz
==> Fetching speex
==> Downloading https://ghcr.io/v2/homebrew/core/speex/manifests/1.2.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/483f702af62f72259facb50d3d47cd0bb25c8f0fb887029d30051a8cef860be5--speex-1.2.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/speex/blobs/sha256:e8e8cbefa65f7819b2feb27b9067248d97f2e5607253c0a5c8a49a495d7fc824
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/6dbd3aefde60a527532536c5a8b01a13acdfda44c35c221e91306027a106eecf--speex--1.2.1.arm64_ventura.bottle.tar.gz
==> Fetching srt
==> Downloading https://ghcr.io/v2/homebrew/core/srt/manifests/1.5.2
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/0e3fab84ca01a96e0e4f122eeefdfce68e8de1d96715205abf71de672e123950--srt-1.5.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/srt/blobs/sha256:cd2e45f7be1158e4f9480bea9f425d1ce269457c2f6a2f18c3119c2c72b3af50
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/7f232a4a5fe946fbc7b32ef769d3d44ccc282ea00114da01ce372fe4b9f5a11d--srt--1.5.2.arm64_ventura.bottle.tar.gz
==> Fetching svt-av1
==> Downloading https://ghcr.io/v2/homebrew/core/svt-av1/manifests/1.7.0
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/2de4a517f0ce84261630cbbe14b05083a00410048200679cf0ae1e624a833a68--svt-av1-1.7.0.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/svt-av1/blobs/sha256:e3d3c790253851281b118345a97076207dd36b928b8326ff99a269f76ae02ec5
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/08cc9c9b2dc8897f06c594c4a2356edd2e056bb57b5928d20e197b795740a626--svt-av1--1.7.0.arm64_ventura.bottle.tar.gz
==> Fetching leptonica
==> Downloading https://ghcr.io/v2/homebrew/core/leptonica/manifests/1.83.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/493ffcf863b7765dce2c49a0f43730fe67b18d42bb00ce8fce046ba71a6cb875--leptonica-1.83.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/leptonica/blobs/sha256:296fb19d6f6a934416ecc0f65789a0016ae1a500ac38bd67de50664d32da62e3
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/86b6d5a2585a987704b240ec27d2aa0be5669cfe65eb41009d30d468344cdaa3--leptonica--1.83.1.arm64_ventura.bottle.tar.gz
==> Fetching libb2
==> Downloading https://ghcr.io/v2/homebrew/core/libb2/manifests/0.98.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/9bb23dca331f0d74876fa5c769113885b92af8a741a851cdfe99f6dfd420b12d--libb2-0.98.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libb2/blobs/sha256:6c9ffaf08fde8879febf2998a289d6e9bfa505ed29cdf5f4c41d52a632c11f1e
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/b800d39c35319c0788dfbbf12c8442e85b5c70cf5709187ac4a4ff1cce9da725--libb2--0.98.1.arm64_ventura.bottle.tar.gz
==> Fetching libarchive
==> Downloading https://ghcr.io/v2/homebrew/core/libarchive/manifests/3.7.1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/806257a3701dffd38c70f5676eebefddfaa77af9073cdbe371d943c90dae90cb--libarchive-3.7.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libarchive/blobs/sha256:2d7d9dddbbc96ef7c620ec4e366a91a68162b8525bc816cfd7e9c46c89bede5b
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/55c6f34d8a4a0fbe3ba3da8420c94007daa686689f7d921cfc1e45ff2c6c10c6--libarchive--3.7.1.arm64_ventura.bottle.tar.gz
==> Fetching pango
==> Downloading https://ghcr.io/v2/homebrew/core/pango/manifests/1.50.14
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/9c0c4eff2aee3f88e99725c8ca269b1bd37db7bb38fbec2fe3da6a1c42b75171--pango-1.50.14.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/pango/blobs/sha256:36b5b69c52886ea5c6599bc35bf22eb942cc44b2bcbe2ea0bd2340d72fe1d832
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/382ba514dd9fc34742f0bf72b78557e86b8bf3fc372faaf6e89aa8c80de56767--pango--1.50.14.arm64_ventura.bottle.tar.gz
==> Fetching tesseract
==> Downloading https://ghcr.io/v2/homebrew/core/tesseract/manifests/5.3.2_1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/e94a3ee7f66a84237edcfc9f3a28286362c07d8d184a3ce5288bfa6c43d0a8f6--tesseract-5.3.2_1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/tesseract/blobs/sha256:d16c37b9e59fbe63d93ab0b3625d106be443d9adc03a0c2bba83460733b1974a
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/a2c3d9995da37d6bb6be53fe24249cca9d09989d18e73b4dbd1aba7064d7d817--tesseract--5.3.2_1.arm64_ventura.bottle.tar.gz
==> Fetching theora
==> Downloading https://ghcr.io/v2/homebrew/core/theora/manifests/1.1.1-4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/dbefdb4ba8626ac7d284e0da23aaeb705c37e0bfbe0c3c22f05fe5fbcadf10e4--theora-1.1.1-4.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/theora/blobs/sha256:b4b1fe0a53ce538d88ca098fce885c20cca62175c2d2141ad96454e7163674a6
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d2b2627fb3a937c8b9375927a6db569f1c2bb4787a35abc1d983a43a2d25f6d6--theora--1.1.1.arm64_ventura.bottle.4.tar.gz
==> Fetching x264
==> Downloading https://ghcr.io/v2/homebrew/core/x264/manifests/r3095-1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d857ceb495f0fc01bc4dba1856e008add39115d3e555d23fed6159969aca6b87--x264-r3095-1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/x264/blobs/sha256:faa0ab633b7f74cf08046227a361a6ca9e196aa0509cc18fab98e0a80cb8dcfe
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/83f458954887609d838886e3dc9a99448937b20ae6027991598fbd158416b4f7--x264--r3095.arm64_ventura.bottle.1.tar.gz
==> Fetching x265
==> Downloading https://ghcr.io/v2/homebrew/core/x265/manifests/3.5-1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/b2b1f388528d2c8033213ea1b60ecf69affc11dc2e9d2a90d94831e2851bfb16--x265-3.5-1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/x265/blobs/sha256:fc0bf01af954762a85e8b808d5b03d28b9e36e8e71035783e39bb9dc0307abea
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/b8a0cc1e3638b8d148fa0d796279cebadab633b32315ceb98cb8de87929b6477--x265--3.5.arm64_ventura.bottle.1.tar.gz
==> Fetching xvid
==> Downloading https://ghcr.io/v2/homebrew/core/xvid/manifests/1.3.7
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/b5121b85b4f5dfe07f78abbcbe520ae4926d781af3342e318e588b62aba59fe0--xvid-1.3.7.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/xvid/blobs/sha256:58aa3f757ca260fb922ee623240b710ef7e1cc75dea00c314d6d5ecd98289cbf
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/5b97337010e2860369b5d2af4ac7ac1169cc936d3cd64da215d9a72c5350831a--xvid--1.3.7.arm64_ventura.bottle.tar.gz
==> Fetching libsodium
==> Downloading https://ghcr.io/v2/homebrew/core/libsodium/manifests/1.0.18_1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/d14e811d4b4dc5be4758836da0008ea37879d7a8f7d353829decd14f70a20dec--libsodium-1.0.18_1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/libsodium/blobs/sha256:9a473cc4469e5f641ff79fac0331c7b86ac22778becd1155a2395e52346116d8
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/3c17065fa853b7c22748466684ac78dbc5cb7c7419db975572feaa3875521288--libsodium--1.0.18_1.arm64_ventura.bottle.tar.gz
==> Fetching zeromq
==> Downloading https://ghcr.io/v2/homebrew/core/zeromq/manifests/4.3.4
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/975d2a6327948963304440b55f96a7ba9a9a77d67c94009aa3b737508a6ac53d--zeromq-4.3.4.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/zeromq/blobs/sha256:6bc660ae09b329a376dc1784d2fa5d7f97ebfffdbbd8548fc664668d5b7d9406
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/0adfa176c955cade017f58154e9d4b5b08455634ab3d5b17e772484db3ab1e8f--zeromq--4.3.4.arm64_ventura.bottle.tar.gz
==> Fetching zimg
==> Downloading https://ghcr.io/v2/homebrew/core/zimg/manifests/3.0.5
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/f94d5d93fe440d14fe866ceb3ada13593ef4b17f58985ebb17ea4320168b65cd--zimg-3.0.5.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/zimg/blobs/sha256:cc82dc203d39c81808f2afacf64b5b5048859de941fff9e8caea599b8db83a3f
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/497eca4854b82584de0c450483561aec0e0b026ccae80033f375f37b174c14ee--zimg--3.0.5.arm64_ventura.bottle.tar.gz
==> Fetching ffmpeg
==> Downloading https://ghcr.io/v2/homebrew/core/ffmpeg/manifests/6.0_1
Already downloaded: /Users/lvwei/Library/Caches/Homebrew/downloads/ecf40058ae2345b97cb37c91ee7dcdaf64bcc9cab71477248f5e2511930b66df--ffmpeg-6.0_1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/ffmpeg/blobs/sha256:adc16acae9282fbe6794459e2f86ac4fc257586840f72e526dbb8993c32d890a
############################################################################################################################################### 100.0%
==> Installing dependencies for ffmpeg: brotli, giflib, highway, imath, jpeg-turbo, libpng, lz4, zstd, libtiff, little-cms2, openexr, webp, jpeg-xl, libvmaf, aom, aribb24, dav1d, freetype, fontconfig, frei0r, libunistring, gettext, libidn2, libtasn1, nettle, p11-kit, libevent, libnghttp2, unbound, gnutls, lame, fribidi, glib, xorgproto, libxau, libxdmcp, libxcb, libx11, libxext, libxrender, lzo, pixman, cairo, graphite2, icu4c, harfbuzz, libunibreak, libass, libbluray, cjson, mbedtls, librist, libsoxr, libvidstab, libogg, libvorbis, libvpx, opencore-amr, openjpeg, opus, rav1e, libsamplerate, flac, mpg123, libsndfile, rubberband, sdl2, snappy, speex, srt, svt-av1, leptonica, libb2, libarchive, pango, tesseract, theora, x264, x265, xvid, libsodium, zeromq and zimg
==> Installing ffmpeg dependency: brotli
==> Pouring brotli--1.0.9.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/brotli/1.0.9: 25 files, 2.3MB
==> Installing ffmpeg dependency: giflib
==> Pouring giflib--5.2.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/giflib/5.2.1: 19 files, 540.2KB
==> Installing ffmpeg dependency: highway
==> Pouring highway--1.0.6.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/highway/1.0.6: 65 files, 3.2MB
==> Installing ffmpeg dependency: imath
==> Pouring imath--3.1.9.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/imath/3.1.9: 49 files, 935.7KB
==> Installing ffmpeg dependency: jpeg-turbo
==> Pouring jpeg-turbo--3.0.0.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/jpeg-turbo/3.0.0: 44 files, 3.4MB
==> Installing ffmpeg dependency: libpng
==> Pouring libpng--1.6.40.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libpng/1.6.40: 27 files, 1.3MB
==> Installing ffmpeg dependency: lz4
==> Pouring lz4--1.9.4.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/lz4/1.9.4: 22 files, 680.1KB
==> Installing ffmpeg dependency: zstd
==> Pouring zstd--1.5.5.arm64_ventura.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/zstd/1.5.5: 31 files, 2.1MB
==> Installing ffmpeg dependency: libtiff
==> Pouring libtiff--4.5.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libtiff/4.5.1: 473 files, 8MB
==> Installing ffmpeg dependency: little-cms2
==> Pouring little-cms2--2.15.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/little-cms2/2.15: 21 files, 1.4MB
==> Installing ffmpeg dependency: openexr
==> Pouring openexr--3.1.11.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/openexr/3.1.11: 194 files, 7.7MB
==> Installing ffmpeg dependency: webp
==> Pouring webp--1.3.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/webp/1.3.1: 63 files, 2.3MB
==> Installing ffmpeg dependency: jpeg-xl
==> Pouring jpeg-xl--0.8.2.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/jpeg-xl/0.8.2: 43 files, 10.8MB
==> Installing ffmpeg dependency: libvmaf
==> Pouring libvmaf--2.3.1.arm64_ventura.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/libvmaf/2.3.1: 234 files, 7MB
==> Installing ffmpeg dependency: aom
==> Pouring aom--3.6.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/aom/3.6.1: 23 files, 8.6MB
==> Installing ffmpeg dependency: aribb24
==> Pouring aribb24--1.0.4.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/aribb24/1.0.4: 14 files, 203.7KB
==> Installing ffmpeg dependency: dav1d
==> Pouring dav1d--1.2.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/dav1d/1.2.1: 15 files, 910KB
==> Installing ffmpeg dependency: freetype
==> Pouring freetype--2.13.2.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/freetype/2.13.2: 67 files, 2.4MB
==> Installing ffmpeg dependency: fontconfig
==> Pouring fontconfig--2.14.2.arm64_ventura.bottle.tar.gz
==> Downloading https://formulae.brew.sh/api/formula.jws.json
#=#=- #    #                                                                                                                                         
==> Regenerating font cache, this may take a while
==> /opt/homebrew/Cellar/fontconfig/2.14.2/bin/fc-cache -frv
🍺  /opt/homebrew/Cellar/fontconfig/2.14.2: 88 files, 2.4MB
==> Installing ffmpeg dependency: frei0r
==> Pouring frei0r--2.3.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/frei0r/2.3.1: 153 files, 5.5MB
==> Installing ffmpeg dependency: libunistring
==> Pouring libunistring--1.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libunistring/1.1: 56 files, 5.0MB
==> Installing ffmpeg dependency: gettext
==> Pouring gettext--0.21.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/gettext/0.21.1: 1,983 files, 20.9MB
==> Installing ffmpeg dependency: libidn2
==> Pouring libidn2--2.3.4_1.arm64_ventura.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/libidn2/2.3.4_1: 79 files, 1MB
==> Installing ffmpeg dependency: libtasn1
==> Pouring libtasn1--4.19.0.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libtasn1/4.19.0: 61 files, 717.8KB
==> Installing ffmpeg dependency: nettle
==> Pouring nettle--3.9.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/nettle/3.9.1: 94 files, 2.7MB
==> Installing ffmpeg dependency: p11-kit
==> Pouring p11-kit--0.25.0.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/p11-kit/0.25.0: 67 files, 4.8MB
==> Installing ffmpeg dependency: libevent
==> Pouring libevent--2.1.12_1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libevent/2.1.12_1: 57 files, 2.2MB
==> Installing ffmpeg dependency: libnghttp2
==> Pouring libnghttp2--1.55.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libnghttp2/1.55.1: 13 files, 728.3KB
==> Installing ffmpeg dependency: unbound
==> Pouring unbound--1.17.1_1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/unbound/1.17.1_1: 58 files, 5.7MB
==> Installing ffmpeg dependency: gnutls
==> Pouring gnutls--3.8.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/gnutls/3.8.1: 1,284 files, 10.7MB
==> Installing ffmpeg dependency: lame
==> Pouring lame--3.100.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/lame/3.100: 27 files, 2.2MB
==> Installing ffmpeg dependency: fribidi
==> Pouring fribidi--1.0.13.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/fribidi/1.0.13: 67 files, 733.4KB
==> Installing ffmpeg dependency: glib
==> Pouring glib--2.76.4.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/glib/2.76.4: 455 files, 22.2MB
==> Installing ffmpeg dependency: xorgproto
==> Pouring xorgproto--2023.2.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/xorgproto/2023.2: 267 files, 3.9MB
==> Installing ffmpeg dependency: libxau
==> Pouring libxau--1.0.11.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libxau/1.0.11: 21 files, 123.5KB
==> Installing ffmpeg dependency: libxdmcp
==> Pouring libxdmcp--1.1.4.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libxdmcp/1.1.4: 11 files, 130.4KB
==> Installing ffmpeg dependency: libxcb
==> Pouring libxcb--1.15_1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libxcb/1.15_1: 2,461 files, 7.3MB
==> Installing ffmpeg dependency: libx11
==> Pouring libx11--1.8.6.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libx11/1.8.6: 1,054 files, 7MB
==> Installing ffmpeg dependency: libxext
==> Pouring libxext--1.3.5.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libxext/1.3.5: 87 files, 445.8KB
==> Installing ffmpeg dependency: libxrender
==> Pouring libxrender--0.9.11.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libxrender/0.9.11: 12 files, 213.9KB
==> Installing ffmpeg dependency: lzo
==> Pouring lzo--2.10.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/lzo/2.10: 31 files, 566.3KB
==> Installing ffmpeg dependency: pixman
==> Pouring pixman--0.42.2.arm64_ventura.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/pixman/0.42.2: 11 files, 1.2MB
==> Installing ffmpeg dependency: cairo
==> Pouring cairo--1.16.0_5.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/cairo/1.16.0_5: 126 files, 6.4MB
==> Installing ffmpeg dependency: graphite2
==> Pouring graphite2--1.3.14.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/graphite2/1.3.14: 18 files, 281.2KB
==> Installing ffmpeg dependency: icu4c
==> Pouring icu4c--73.2.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/icu4c/73.2: 268 files, 80.1MB
==> Installing ffmpeg dependency: harfbuzz
==> Pouring harfbuzz--8.1.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/harfbuzz/8.1.1: 76 files, 9.1MB
==> Installing ffmpeg dependency: libunibreak
==> Pouring libunibreak--5.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libunibreak/5.1: 17 files, 328.7KB
==> Installing ffmpeg dependency: libass
==> Pouring libass--0.17.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libass/0.17.1: 11 files, 531.7KB
==> Installing ffmpeg dependency: libbluray
==> Pouring libbluray--1.3.4.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libbluray/1.3.4: 21 files, 1MB
==> Installing ffmpeg dependency: cjson
==> Pouring cjson--1.7.16.arm64_ventura.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/cjson/1.7.16: 23 files, 254KB
==> Installing ffmpeg dependency: mbedtls
==> Pouring mbedtls--3.4.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/mbedtls/3.4.1: 160 files, 11.9MB
==> Installing ffmpeg dependency: librist
==> Pouring librist--0.2.7_3.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/librist/0.2.7_3: 28 files, 752.9KB
==> Installing ffmpeg dependency: libsoxr
==> Pouring libsoxr--0.1.3.arm64_ventura.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/libsoxr/0.1.3: 29 files, 323.4KB
==> Installing ffmpeg dependency: libvidstab
==> Pouring libvidstab--1.1.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libvidstab/1.1.1: 25 files, 187.9KB
==> Installing ffmpeg dependency: libogg
==> Pouring libogg--1.3.5.arm64_ventura.bottle.2.tar.gz
🍺  /opt/homebrew/Cellar/libogg/1.3.5: 103 files, 536.7KB
==> Installing ffmpeg dependency: libvorbis
==> Pouring libvorbis--1.3.7.arm64_ventura.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/libvorbis/1.3.7: 157 files, 2.4MB
==> Installing ffmpeg dependency: libvpx
==> Pouring libvpx--1.13.0.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libvpx/1.13.0: 20 files, 3.8MB
==> Installing ffmpeg dependency: opencore-amr
==> Pouring opencore-amr--0.1.6.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/opencore-amr/0.1.6: 17 files, 655KB
==> Installing ffmpeg dependency: openjpeg
==> Pouring openjpeg--2.5.0_1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/openjpeg/2.5.0_1: 536 files, 13.8MB
==> Installing ffmpeg dependency: opus
==> Pouring opus--1.4.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/opus/1.4: 15 files, 979.6KB
==> Installing ffmpeg dependency: rav1e
==> Pouring rav1e--0.6.6.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/rav1e/0.6.6: 14 files, 140.2MB
==> Installing ffmpeg dependency: libsamplerate
==> Pouring libsamplerate--0.2.2.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libsamplerate/0.2.2: 32 files, 3MB
==> Installing ffmpeg dependency: flac
==> Pouring flac--1.4.3.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/flac/1.4.3: 284 files, 6.9MB
==> Installing ffmpeg dependency: mpg123
==> Pouring mpg123--1.31.3.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/mpg123/1.31.3: 33 files, 2.0MB
==> Installing ffmpeg dependency: libsndfile
==> Pouring libsndfile--1.2.2.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libsndfile/1.2.2: 53 files, 1MB
==> Installing ffmpeg dependency: rubberband
==> Pouring rubberband--3.3.0.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/rubberband/3.3.0: 13 files, 1.7MB
==> Installing ffmpeg dependency: sdl2
==> Pouring sdl2--2.28.2.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/sdl2/2.28.2: 93 files, 6.4MB
==> Installing ffmpeg dependency: snappy
==> Pouring snappy--1.1.10.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/snappy/1.1.10: 18 files, 164.3KB
==> Installing ffmpeg dependency: speex
==> Pouring speex--1.2.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/speex/1.2.1: 25 files, 855.4KB
==> Installing ffmpeg dependency: srt
==> Pouring srt--1.5.2.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/srt/1.5.2: 20 files, 4.4MB
==> Installing ffmpeg dependency: svt-av1
==> Pouring svt-av1--1.7.0.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/svt-av1/1.7.0: 24 files, 3.5MB
==> Installing ffmpeg dependency: leptonica
==> Pouring leptonica--1.83.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/leptonica/1.83.1: 56 files, 6.8MB
==> Installing ffmpeg dependency: libb2
==> Pouring libb2--0.98.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libb2/0.98.1: 8 files, 109.6KB
==> Installing ffmpeg dependency: libarchive
==> Pouring libarchive--3.7.1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libarchive/3.7.1: 64 files, 3.9MB
==> Installing ffmpeg dependency: pango
==> Pouring pango--1.50.14.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/pango/1.50.14: 68 files, 3.3MB
==> Installing ffmpeg dependency: tesseract
==> Pouring tesseract--5.3.2_1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/tesseract/5.3.2_1: 73 files, 32.6MB
==> Installing ffmpeg dependency: theora
==> Pouring theora--1.1.1.arm64_ventura.bottle.4.tar.gz
🍺  /opt/homebrew/Cellar/theora/1.1.1: 97 files, 2MB
==> Installing ffmpeg dependency: x264
==> Pouring x264--r3095.arm64_ventura.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/x264/r3095: 11 files, 4.2MB
==> Installing ffmpeg dependency: x265
==> Pouring x265--3.5.arm64_ventura.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/x265/3.5: 11 files, 6.6MB
==> Installing ffmpeg dependency: xvid
==> Pouring xvid--1.3.7.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/xvid/1.3.7: 10 files, 1.2MB
==> Installing ffmpeg dependency: libsodium
==> Pouring libsodium--1.0.18_1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/libsodium/1.0.18_1: 73 files, 778.0KB
==> Installing ffmpeg dependency: zeromq
==> Pouring zeromq--4.3.4.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/zeromq/4.3.4: 83 files, 5.9MB
==> Installing ffmpeg dependency: zimg
==> Pouring zimg--3.0.5.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/zimg/3.0.5: 27 files, 1.1MB
==> Installing ffmpeg
==> Pouring ffmpeg--6.0_1.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/ffmpeg/6.0_1: 284 files, 49.2MB
==> Running `brew cleanup ffmpeg`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).


```