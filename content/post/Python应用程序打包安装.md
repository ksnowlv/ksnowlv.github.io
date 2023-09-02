---
title: "Python应用程序打包安装"
date: 2023-08-16T19:41:33+08:00
lastmod: 2023-08-16T19:41:33+08:00
keywords: ["Python"]
tags: ["Python"]
categories: ["Python"]

comment: true
toc: true
autoCollapseToc: true
reward: true

---

<!--more-->

## 一.安装pyinstaller

```terminal
pip install pyinstaller

```

## 二.将应用程序打包成可执行文件

在终端中，切换到您的 Python 应用程序所在的目录，然后使用以下命令将其打包为可执行文件；

```terminal
lvwei@lvweideMacBook-Pro queue_test % pyinstaller __main__.py 
431 INFO: PyInstaller: 5.6.2
431 INFO: Python: 3.11.0
514 INFO: Platform: macOS-13.5-x86_64-i386-64bit
515 INFO: wrote /Users/lvwei/Documents/python_projects/queue_test/__main__.spec
520 INFO: UPX is not available.
521 INFO: Extending PYTHONPATH with paths
['/Users/lvwei/Documents/python_projects/queue_test']
3830 INFO: checking Analysis
3830 INFO: Building Analysis because Analysis-00.toc is non existent
3830 INFO: Initializing module dependency graph...
3832 INFO: Caching module graph hooks...
3837 WARNING: Several hooks defined for module 'numpy'. Please take care they do not conflict.
3840 INFO: Analyzing base_library.zip ...
4487 INFO: Loading module hook 'hook-encodings.py' from '/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/PyInstaller/hooks'...
4822 INFO: Loading module hook 'hook-heapq.py' from '/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/PyInstaller/hooks'...
5119 INFO: Loading module hook 'hook-pickle.py' from '/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/PyInstaller/hooks'...
7039 INFO: Caching module dependency graph...
7101 INFO: running Analysis Analysis-00.toc
7109 INFO: Analyzing /Users/lvwei/Documents/python_projects/queue_test/__main__.py
7119 INFO: Processing module hooks...
7126 INFO: Looking for ctypes DLLs
7134 INFO: Analyzing run-time hooks ...
7135 INFO: Including run-time hook '/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/PyInstaller/hooks/rthooks/pyi_rth_inspect.py'
7136 INFO: Including run-time hook '/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/PyInstaller/hooks/rthooks/pyi_rth_subprocess.py'
7139 INFO: Looking for dynamic libraries
7406 INFO: Looking for eggs
7406 INFO: Using Python library /Library/Frameworks/Python.framework/Versions/3.11/Python
7408 INFO: Warnings written to /Users/lvwei/Documents/python_projects/queue_test/build/__main__/warn-__main__.txt
7415 INFO: Graph cross-reference written to /Users/lvwei/Documents/python_projects/queue_test/build/__main__/xref-__main__.html
7425 INFO: checking PYZ
7425 INFO: Building PYZ because PYZ-00.toc is non existent
7425 INFO: Building PYZ (ZlibArchive) /Users/lvwei/Documents/python_projects/queue_test/build/__main__/PYZ-00.pyz
7573 INFO: Building PYZ (ZlibArchive) /Users/lvwei/Documents/python_projects/queue_test/build/__main__/PYZ-00.pyz completed successfully.
7574 INFO: EXE target arch: x86_64
7574 INFO: Code signing identity: None
7574 INFO: checking PKG
7574 INFO: Building PKG because PKG-00.toc is non existent
7574 INFO: Building PKG (CArchive) __main__.pkg
7582 INFO: Building PKG (CArchive) __main__.pkg completed successfully.
7583 INFO: Bootloader /Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/PyInstaller/bootloader/Darwin-64bit/run
7583 INFO: checking EXE
7583 INFO: Building EXE because EXE-00.toc is non existent
7583 INFO: Building EXE from EXE-00.toc
7583 INFO: Copying bootloader EXE to /Users/lvwei/Documents/python_projects/queue_test/build/__main__/__main__
7584 INFO: Converting EXE to target arch (x86_64)
10027 INFO: Removing signature(s) from EXE
10096 INFO: Appending PKG archive to EXE
10097 INFO: Fixing EXE headers for code signing
10106 INFO: Re-signing the EXE
10135 INFO: Building EXE from EXE-00.toc completed successfully.
10137 INFO: checking COLLECT
10137 INFO: Building COLLECT because COLLECT-00.toc is non existent
10137 INFO: Building COLLECT COLLECT-00.toc
10826 INFO: Building COLLECT COLLECT-00.toc completed successfully.
lvwei@lvwei

```

## 三.编辑main.spec

```
block_cipher = None


a = Analysis(
    ['__main__.py', 'qthread.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='queue_test',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='queue_test',
)

app = BUNDLE(
    coll,
    name='com.queue_test.app',
    icon=None,
    bundle_identifier=None,
)

```


## 四.使用pkgbuild打包生成安装文件

```terminal
lvwei@lvweideMacBook-Pro queue_test % pkgbuild --identifier com.queue_test.app --version 1.0 --root ./dist/ --install-location /Applications YourApp.pkg
pkgbuild: Inferring bundle components from contents of ./dist/
pkgbuild: Wrote package to YourApp.pkg

```