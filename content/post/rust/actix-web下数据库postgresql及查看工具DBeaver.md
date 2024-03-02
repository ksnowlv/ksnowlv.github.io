---
title: "Actix Web下数据库postgresql及查看工具DBeaver"
date: 2024-03-01T20:00:28+08:00
lastmod: 2024-03-01T20:00:28+08:00
keywords: ["rust", "Actix Web", "后端开发","数据库"]
tags: ["rust", "Actix Web", "后端开发","数据库" ]
categories: ["rust", "Actix Web", "后端开发","数据库"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### Mac安装postgresql数据库

```shell
ksnowlv@MacBook-Pro-3 ~ % brew install postgresql
Warning: Formula postgresql was renamed to postgresql@14.
==> Downloading https://ghcr.io/v2/homebrew/core/postgresql/14/manifests/14.11_1
########################################################################################################################################################################## 100.0%
==> Fetching dependencies for postgresql@14: icu4c, ca-certificates, openssl@3, krb5, lz4 and readline
==> Downloading https://ghcr.io/v2/homebrew/core/icu4c/manifests/74.2
########################################################################################################################################################################## 100.0%
==> Fetching icu4c
==> Downloading https://ghcr.io/v2/homebrew/core/icu4c/blobs/sha256:ac4fb9cc76372d8ad8dff5c740ff2b5b6287a5303de625dd865e7afccbfd6b70
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/ca-certificates/manifests/2023-12-12
########################################################################################################################################################################## 100.0%
==> Fetching ca-certificates
==> Downloading https://ghcr.io/v2/homebrew/core/ca-certificates/blobs/sha256:5c99ffd0861f01adc19cab495027024f7d890e42a9e7b689706b85c8e2b9c9b3
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/openssl/3/manifests/3.2.1-1
########################################################################################################################################################################## 100.0%
==> Fetching openssl@3
==> Downloading https://ghcr.io/v2/homebrew/core/openssl/3/blobs/sha256:ef8211c5115fc85f01261037f8fea76cc432b92b4fb23bc87bbf41e9198fcc0f
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/krb5/manifests/1.21.2
########################################################################################################################################################################## 100.0%
==> Fetching krb5
==> Downloading https://ghcr.io/v2/homebrew/core/krb5/blobs/sha256:20a39d385f0cdc34029de2e0c030fc0787940a7be69cdcaa9de6899170cbb731
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/lz4/manifests/1.9.4
########################################################################################################################################################################## 100.0%
==> Fetching lz4
==> Downloading https://ghcr.io/v2/homebrew/core/lz4/blobs/sha256:2bad368b2869db32b1b22cea76a6e65da2f4e599ac8ee327b4825d54c4579445
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/readline/manifests/8.2.10
########################################################################################################################################################################## 100.0%
==> Fetching readline
==> Downloading https://ghcr.io/v2/homebrew/core/readline/blobs/sha256:9796e0ff1cc29ae7e75d8fc1a3e2c5e8ae2aeade8d9d59a16363306bf6c5b8f4
########################################################################################################################################################################## 100.0%
==> Fetching postgresql@14
==> Downloading https://ghcr.io/v2/homebrew/core/postgresql/14/blobs/sha256:8215acbfa15734c5f1742ec0d9a3fd415e0e082fc59186607b2ca5153af8f2bf
########################################################################################################################################################################## 100.0%
==> Installing dependencies for postgresql@14: icu4c, ca-certificates, openssl@3, krb5, lz4 and readline
==> Installing postgresql@14 dependency: icu4c
==> Downloading https://ghcr.io/v2/homebrew/core/icu4c/manifests/74.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/3e5230e726e5548db28bc0cf75710d6405903b742f941113d3dbe7483fad72a4--icu4c-74.2.bottle_manifest.json
==> Pouring icu4c--74.2.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/icu4c/74.2: 270 files, 77.3MB
==> Installing postgresql@14 dependency: ca-certificates
==> Downloading https://ghcr.io/v2/homebrew/core/ca-certificates/manifests/2023-12-12
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/13aa86e429e05d02a76005d1881eaf625091a5ac4dc7d7674c706d12ba48796a--ca-certificates-2023-12-12.bottle_manifest.json
==> Pouring ca-certificates--2023-12-12.all.bottle.tar.gz
==> Downloading https://formulae.brew.sh/api/formula.jws.json
########################################################################################################################################################################## 100.0%
==> Regenerating CA certificate bundle from keychain, this may take a while...
🍺  /usr/local/Cellar/ca-certificates/2023-12-12: 3 files, 226.7KB
==> Installing postgresql@14 dependency: openssl@3
==> Downloading https://ghcr.io/v2/homebrew/core/openssl/3/manifests/3.2.1-1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/f7b6e249843882452d784a8cbc4e19231186230b9e485a2a284d5c1952a95ec2--openssl@3-3.2.1-1.bottle_manifest.json
==> Pouring openssl@3--3.2.1.sonoma.bottle.1.tar.gz
🍺  /usr/local/Cellar/openssl@3/3.2.1: 6,874 files, 32.5MB
==> Installing postgresql@14 dependency: krb5
==> Downloading https://ghcr.io/v2/homebrew/core/krb5/manifests/1.21.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/1dac813e15dc58f7f64511565951ee43912a4a82b355448e23600e07b1b7107c--krb5-1.21.2.bottle_manifest.json
==> Pouring krb5--1.21.2.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/krb5/1.21.2: 162 files, 4.9MB
==> Installing postgresql@14 dependency: lz4
==> Downloading https://ghcr.io/v2/homebrew/core/lz4/manifests/1.9.4
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/379e59b981667f9585b33a2ff318769d8edca3ce6fd2e9a67ed291ae3e0cc872--lz4-1.9.4.bottle_manifest.json
==> Pouring lz4--1.9.4.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/lz4/1.9.4: 22 files, 656.5KB
==> Installing postgresql@14 dependency: readline
==> Downloading https://ghcr.io/v2/homebrew/core/readline/manifests/8.2.10
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/4ddd52803319828799f1932d4c7fa8d11c667049b20a56341c0c19246a1be93b--readline-8.2.10.bottle_manifest.json
==> Pouring readline--8.2.10.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/readline/8.2.10: 50 files, 1.7MB
==> Installing postgresql@14
==> Pouring postgresql@14--14.11_1.sonoma.bottle.tar.gz
==> /usr/local/Cellar/postgresql@14/14.11_1/bin/initdb --locale=C -E UTF-8 /usr/local/var/postgresql@14
==> Caveats
This formula has created a default database cluster with:
  initdb --locale=C -E UTF-8 /usr/local/var/postgresql@14
For more details, read:
  https://www.postgresql.org/docs/14/app-initdb.html

To start postgresql@14 now and restart at login:
  brew services start postgresql@14
Or, if you don't want/need a background service you can just run:
  /usr/local/opt/postgresql@14/bin/postgres -D /usr/local/var/postgresql@14
==> Summary
🍺  /usr/local/Cellar/postgresql@14/14.11_1: 3,319 files, 45.1MB
==> Running `brew cleanup postgresql@14`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Upgrading 10 dependents of upgraded formulae:
Disable this behaviour by setting HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
cffi 1.15.1 -> 1.16.0_1, nginx 1.25.2 -> 1.25.4, pycparser 2.21 -> 2.21_1, python-certifi 2023.7.22 -> 2024.2.2, python-cryptography 41.0.3 -> 42.0.5, python@3.11 3.11.4_1 -> 3.11.8, ruby 3.0.2 -> 3.3.0, ruby@2.7 2.7.4 -> 2.7.8_1, sqlite 3.43.0 -> 3.45.1, scrapy 2.10.0 -> 2.11.1
Warning: ruby@2.7 has been deprecated because it is not supported upstream!
==> Downloading https://ghcr.io/v2/homebrew/core/ruby/2.7/manifests/2.7.8_1
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/sqlite/manifests/3.45.1
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/ruby/manifests/3.3.0
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/python-certifi/manifests/2024.2.2
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/pycparser/manifests/2.21_1-1
########################################################################################################################################################################## 100.0%
==> Fetching pycparser
==> Downloading https://ghcr.io/v2/homebrew/core/pycparser/blobs/sha256:c0489c6c4e0c24d77cb92db77b41c6f5225ad0718202fc8852715c6e092cb50a
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/cffi/manifests/1.16.0_1-1
########################################################################################################################################################################## 100.0%
==> Fetching dependencies for cffi: python-setuptools
==> Downloading https://ghcr.io/v2/homebrew/core/python-setuptools/manifests/69.1.1
########################################################################################################################################################################## 100.0%
==> Fetching python-setuptools
==> Downloading https://ghcr.io/v2/homebrew/core/python-setuptools/blobs/sha256:831f03611c0d478e4bbacbeefee6936291cbe3d2f5dce1b7c774be029f2ab1d8
########################################################################################################################################################################## 100.0%
==> Fetching cffi
==> Downloading https://ghcr.io/v2/homebrew/core/cffi/blobs/sha256:825ca5c9bf25ca28db6cd0d7ddb088cb66aa86dc69f85e24775e2ed526ebd9ac
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/python-cryptography/manifests/42.0.5
########################################################################################################################################################################## 100.0%
==> Fetching python-cryptography
==> Downloading https://ghcr.io/v2/homebrew/core/python-cryptography/blobs/sha256:f37e9ff879eadcaf5c0436081b98f3b0f06f0175478b6c259cda45dccd97a601
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/python/3.11/manifests/3.11.8
########################################################################################################################################################################## 100.0%
==> Fetching dependencies for python@3.11: mpdecimal, sqlite and xz
==> Downloading https://ghcr.io/v2/homebrew/core/mpdecimal/manifests/4.0.0-1
########################################################################################################################################################################## 100.0%
==> Fetching mpdecimal
==> Downloading https://ghcr.io/v2/homebrew/core/mpdecimal/blobs/sha256:377dc5e30dd1292ac1666dd43a447b861ad283024f70a3e914c7e11572ae869e
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/sqlite/manifests/3.45.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/71097ce212759125014f67983b78169c6f0e4db27076f1fd794028b9700e6d0c--sqlite-3.45.1.bottle_manifest.json
==> Fetching sqlite
==> Downloading https://ghcr.io/v2/homebrew/core/sqlite/blobs/sha256:12a4ffd47ab34b8fe8edf219cb185632d93389580f5958fcda87c9664cdfe498
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/xz/manifests/5.6.0
########################################################################################################################################################################## 100.0%
==> Fetching xz
==> Downloading https://ghcr.io/v2/homebrew/core/xz/blobs/sha256:1a24ab5c033d33089fc23fa581b112a6b72c8c72452fe20553c9416aeb08bc08
########################################################################################################################################################################## 100.0%
==> Fetching python@3.11
==> Downloading https://ghcr.io/v2/homebrew/core/python/3.11/blobs/sha256:4ef81eae2485a89c0c403e3974389d1c228232b2369b45ea4c6d9543358e055f
#############################################################################################################################                                               73.6%curl: (92) HTTP/2 stream 1 was not closed cleanly: PROTOCOL_ERROR (err 1)

Error: python@3.11: Failed to download resource "python@3.11"
Download failed: https://ghcr.io/v2/homebrew/core/python/3.11/blobs/sha256:4ef81eae2485a89c0c403e3974389d1c228232b2369b45ea4c6d9543358e055f
==> Downloading https://ghcr.io/v2/homebrew/core/scrapy/manifests/2.11.1-1
########################################################################################################################################################################## 100.0%
==> Fetching dependencies for scrapy: python-certifi and python@3.12
==> Downloading https://ghcr.io/v2/homebrew/core/python-certifi/manifests/2024.2.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/801ca527ea69993f853dd420731d29cb1765f7bd7be0d34d1cc8d11a386084f5--python-certifi-2024.2.2.bottle_manifest.json
==> Fetching python-certifi
==> Downloading https://ghcr.io/v2/homebrew/core/python-certifi/blobs/sha256:67d34f242d69fc17839289068c245d1b00a79410bf9bbe7046f19a05dc25b472
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/python/3.12/manifests/3.12.2_1
########################################################################################################################################################################## 100.0%
==> Fetching python@3.12
==> Downloading https://ghcr.io/v2/homebrew/core/python/3.12/blobs/sha256:99fcd3eb3dff129c97ae0e4afb8fb90e39fa8595ea61b19854020cd4561e1e92
########################################################################################################################################################################## 100.0%
==> Fetching scrapy
==> Downloading https://ghcr.io/v2/homebrew/core/scrapy/blobs/sha256:ee122ad4dd56aa0863b8531d2d24f3db435c81cf18d0866172bcea436bfcd9e9
########################################################################################################################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/nginx/manifests/1.25.4
########################################################################################################################################################################## 100.0%
==> Upgrading pycparser
  2.21 -> 2.21_1 

==> Pouring pycparser--2.21_1.sonoma.bottle.1.tar.gz
🍺  /usr/local/Cellar/pycparser/2.21_1: 76 files, 1.2MB
==> Running `brew cleanup pycparser`...
Removing: /usr/local/Cellar/pycparser/2.21... (46 files, 656.5KB)
==> Upgrading cffi
  1.15.1 -> 1.16.0_1 

==> Installing dependencies for cffi: python-setuptools
==> Installing cffi dependency: python-setuptools
==> Downloading https://ghcr.io/v2/homebrew/core/python-setuptools/manifests/69.1.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/6514dfabd12fb67bab30b15df3c6f92962735910c8abdef9d242d986a3c7a622--python-setuptools-69.1.1.bottle_manifest.json
==> Pouring python-setuptools--69.1.1.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/python-setuptools/69.1.1: 264 files, 2.9MB
==> Installing cffi
==> Pouring cffi--1.16.0_1.sonoma.bottle.1.tar.gz
🍺  /usr/local/Cellar/cffi/1.16.0_1: 69 files, 1.1MB
==> Running `brew cleanup cffi`...
Removing: /usr/local/Cellar/cffi/1.15.1... (33 files, 581.5KB)
==> Upgrading python-cryptography
  41.0.3 -> 42.0.5 

==> Pouring python-cryptography--42.0.5.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/python-cryptography/42.0.5: 215 files, 7.9MB
==> Running `brew cleanup python-cryptography`...
Removing: /usr/local/Cellar/python-cryptography/41.0.3... (109 files, 3.7MB)
==> Upgrading scrapy
  2.10.0 -> 2.11.1 

==> Installing dependencies for scrapy: python-certifi, mpdecimal, sqlite, xz and python@3.12
==> Installing scrapy dependency: python-certifi
==> Downloading https://ghcr.io/v2/homebrew/core/python-certifi/manifests/2024.2.2
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/801ca527ea69993f853dd420731d29cb1765f7bd7be0d34d1cc8d11a386084f5--python-certifi-2024.2.2.bottle_manifest.json
==> Pouring python-certifi--2024.2.2.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/python-certifi/2024.2.2: 30 files, 24.6KB
==> Installing scrapy dependency: mpdecimal
==> Downloading https://ghcr.io/v2/homebrew/core/mpdecimal/manifests/4.0.0-1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/7b63c3b34bee402290af49fac829a6682ab45ea5c9258b6fe03b590a03a4c4a9--mpdecimal-4.0.0-1.bottle_manifest.json
==> Pouring mpdecimal--4.0.0.sonoma.bottle.1.tar.gz
🍺  /usr/local/Cellar/mpdecimal/4.0.0: 21 files, 613.2KB
==> Installing scrapy dependency: sqlite
==> Downloading https://ghcr.io/v2/homebrew/core/sqlite/manifests/3.45.1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/71097ce212759125014f67983b78169c6f0e4db27076f1fd794028b9700e6d0c--sqlite-3.45.1.bottle_manifest.json
==> Pouring sqlite--3.45.1.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/sqlite/3.45.1: 11 files, 4.7MB
==> Installing scrapy dependency: xz
==> Downloading https://ghcr.io/v2/homebrew/core/xz/manifests/5.6.0
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/dae61a60095680979c8a199f93b6d78d4cc0891501b87f0855e924cfd9831dbd--xz-5.6.0.bottle_manifest.json
==> Pouring xz--5.6.0.sonoma.bottle.tar.gz
🍺  /usr/local/Cellar/xz/5.6.0: 166 files, 2.6MB
==> Installing scrapy dependency: python@3.12
==> Downloading https://ghcr.io/v2/homebrew/core/python/3.12/manifests/3.12.2_1
Already downloaded: /Users/ksnowlv/Library/Caches/Homebrew/downloads/db6a7027cff95a641d6d0c07e00f7b8fa26b0733b6d215c3752b745a381ebcb8--python@3.12-3.12.2_1.bottle_manifest.json
==> Pouring python@3.12--3.12.2_1.sonoma.bottle.tar.gz
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
Could not symlink bin/2to3
Target /usr/local/bin/2to3
already exists. You may want to remove it:
  rm '/usr/local/bin/2to3'

To force the link and overwrite all conflicting files:
  brew link --overwrite python@3.12

To list all files that would be deleted:
  brew link --overwrite python@3.12 --dry-run

Possible conflicting files are:
/usr/local/bin/2to3 -> /Library/Frameworks/Python.framework/Versions/3.11/bin/2to3
/usr/local/bin/idle3 -> /Library/Frameworks/Python.framework/Versions/3.11/bin/idle3
/usr/local/bin/pydoc3 -> /Library/Frameworks/Python.framework/Versions/3.11/bin/pydoc3
/usr/local/bin/python3 -> /Library/Frameworks/Python.framework/Versions/3.11/bin/python3
/usr/local/bin/python3-config -> /Library/Frameworks/Python.framework/Versions/3.11/bin/python3-config
==> Downloading https://formulae.brew.sh/api/formula.jws.json
########################################################################################################################################################################## 100.0%
==> /usr/local/Cellar/python@3.12/3.12.2_1/bin/python3.12 -Im ensurepip
==> /usr/local/Cellar/python@3.12/3.12.2_1/bin/python3.12 -Im pip install -v --no-index --upgrade --isolated --target=/usr/local/lib/python3.12/site-packages /usr/local/Cellar/p
==> Summary
🍺  /usr/local/Cellar/python@3.12/3.12.2_1: 3,237 files, 63.6MB
==> Installing scrapy
==> Pouring scrapy--2.11.1.sonoma.bottle.1.tar.gz
🍺  /usr/local/Cellar/scrapy/2.11.1: 2,164 files, 25.3MB
==> Running `brew cleanup scrapy`...
Removing: /usr/local/Cellar/scrapy/2.10.0... (1,866 files, 22.3MB)
==> Checking for dependents of upgraded formulae...
==> No broken dependents to reinstall!
==> Caveats
==> postgresql@14
This formula has created a default database cluster with:
  initdb --locale=C -E UTF-8 /usr/local/var/postgresql@14
For more details, read:
  https://www.postgresql.org/docs/14/app-initdb.html

To start postgresql@14 now and restart at login:
  brew services start postgresql@14
Or, if you don't want/need a background service you can just run:
  /usr/local/opt/postgresql@14/bin/postgres -D /usr/local/var/postgresql@14
ksnowlv@MacBook-Pro-3 ~ % 

ksnowlv@MacBook-Pro-3 homebrew %  brew reinstall postgresql
Warning: Formula postgresql was renamed to postgresql@14.
Warning: Formula postgresql was renamed to postgresql@14.
Warning: Formula postgresql was renamed to postgresql@14.
==> Downloading https://ghcr.io/v2/homebrew/core/postgresql/14/manifests/14.11_1
########################################################################################################################################################################## 100.0%
==> Fetching postgresql@14
==> Downloading https://ghcr.io/v2/homebrew/core/postgresql/14/blobs/sha256:8215acbfa15734c5f1742ec0d9a3fd415e0e082fc59186607b2ca5153af8f2bf
########################################################################################################################################################################## 100.0%
==> Reinstalling postgresql@14 
==> Pouring postgresql@14--14.11_1.sonoma.bottle.tar.gz
==> Caveats
This formula has created a default database cluster with:
  initdb --locale=C -E UTF-8 /usr/local/var/postgresql@14
For more details, read:
  https://www.postgresql.org/docs/14/app-initdb.html

To start postgresql@14 now and restart at login:
  brew services start postgresql@14
Or, if you don't want/need a background service you can just run:
  /usr/local/opt/postgresql@14/bin/postgres -D /usr/local/var/postgresql@14
==> Summary
🍺  /usr/local/Cellar/postgresql@14/14.11_1: 3,319 files, 45.1MB
==> Running `brew cleanup postgresql@14`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
ksnowlv@MacBook-Pro-3 homebrew %  brew services start postgresql@14
==> Tapping homebrew/services
Cloning into '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-services'...
remote: Enumerating objects: 2720, done.
remote: Counting objects: 100% (413/413), done.
remote: Compressing objects: 100% (161/161), done.
remote: Total 2720 (delta 277), reused 315 (delta 248), pack-reused 2307
Receiving objects: 100% (2720/2720), 729.23 KiB | 13.00 KiB/s, done.
Resolving deltas: 100% (1314/1314), done.
Tapped 1 command (48 files, 917.4KB).
==> Successfully started `postgresql@14` (label: homebrew.mxcl.postgresql@14)


```

### DBeaver安装

[DBeaver](https://dbeaver.io/download/)