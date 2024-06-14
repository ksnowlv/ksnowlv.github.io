---
title: "Mac下AndroidApk反编译重新打包-签名打包(下篇)"
date: 2024-04-13T10:08:16+08:00
lastmod: 2024-04-13T10:08:16+08:00
keywords: ["Mac", "Android","破解", "反编译"]
tags: ["Mac", "Android","工具"]
categories: ["Mac", "Android","工具"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## 签名工具

重新给apk打包需要使用签名，签名是什么呢？我们简单先介绍下

### 1.签名工具：
* Jarsigner
  * 是JDK提供的针对jar包签名的通用工具,位于JDK/bin/jarsigner
* Apksigner
  * Google官方提供的针对android apk签名及验证的专用工具,位于Android SDK/build-tools/SDK版本/apksigner
  

### 2.apk签名
* V1签名:(Jar Signature)
    Android 7.0以下版本, 只能用旧签名方案 V1 scheme (JAR signing)
* V2签名:(Full APK Signature)
  * Android 7.0开始, 谷歌增加新签名方案 V2 Signature，同时支持v1，v2。
  
### 3.注意事项

因多数手机使用Android7及以上系统，所以，我们选用V2签名。

### 4.签名工具环境变量设置

在/Users/用户名/Library/Android/sdk/build-tools目录下，有各个版本的签名工具

![image](/images/tools/Mac下AndroidApk反编译重新打包-签名打包下篇/apksigner.jpg)


打开 **.bash_profile**  文件,添加apksigner如下的环境变量，并保存文件。

    export PATH=$PATH:/Users/ksnowlv/Library/Android/sdk/build-tools/29.0.3

至此，签名工具已准备好。



## 二.重新打包签名APK

对反编译后的代码完成修改后，我们将新代码重新打包成APK文件。
我们使用 **apktool** 工具重新打包.

### 2.1.打包未签名的APK

使用 apktool b 命令可以将经过修改的应用程序文件重新打包成一个新的 APK 文件。这个过程包括将修改后的资源文件和代码重新打包成一个新的 APK 文件，以便将修改应用之后的应用程序安装到设备上运行。

通常，使用apktool b的语法如下：

    apktool b <反编译后的目录> -o <输出APK文件>

其中，<反编译后的目录> 是您进行过修改的应用程序的反编译后的目录，-o 用于指定输出的 APK 文件名。

```shell
(base) ksnowlv@MacBook-Pro-3 apktool % apktool b demo-release-oversea -o new_app.apk
I: Using Apktool 2.9.3
I: Checking whether sources has changed...
I: Checking whether resources has changed...
I: Building resources...
I: Building apk file...
I: Copying unknown files/dir...
I: Built apk into: new_app.apk
(base) ksnowlv@MacBook-Pro-3 apktool % 
```
通过上述命令，我们可以将反编译后的代码重新打包为“new_app.apk"文件。


### 2.2.zipalign

zipalign是一个由 **Android SDK **提供的工具，用于调整APK文件的内部结构，以优化应用程序的内存映像加载。

通过执行 **zipalign** ，可以确保APK内部的资源文件对齐到文件中的固定位置，这能够提高应用程序的性能，并且减少在加载和运行时的内存占用。这个操作通常在应用程序签名之前执行，以确保应用发布时能够发挥最佳性能。


使用zipalign取决于您使用的签名工具。

#### 2.2.1.使用apksigner工具签名
  
  必须在APK文件签名之前使用zipalign。如果您在使用 apksigner为APK签名之后对APK 做出了进一步更改签名便会失效。

####  2.2.2.使用jarsigner工具签名
  
  在APK文件签名之后使用 zipalign

#### 2.2.3.参数说明

* zipalign命令常用参数说明

    * -c :检查对齐。此参数用于检查APK文件是否已经进行了正确的对齐，不会修改APK文件，仅进行检查操作。
    * -v :详细模式。打印详细的输出信息，显示对齐前后的文件大小变化等详细信息。
    * -p :指定字节对齐。可以指定数字参数，表示以指定字节数进行对齐。默认情况下，zipalign 会使用 4 字节对齐。
    * -f :强制对齐。强制进行对齐操作，即使APK文件看起来已经对齐了。
    * 
例如，要对一个APK文件进行对齐，并显示详细的信息，可以使用下面的命令：

    zipalign -v 4 input.apk output.apk

这会将 input.apk 文件以4字节对齐的方式重新保存为 output.apk，并显示详细的对齐信息。


#### 2.2.4.zipalign优化

我们使用apksigner工具签名签名，因此，先使用zipalign对齐，再签名。
```shell
(base) ksnowlv@MacBook-Pro-3 apktool % zipalign -p -f -v 4 new_app.apk align.apk
Verifying alignment of align.apk (4)...
      49 AndroidManifest.xml (OK - compressed)
    2919 META-INF/CERT.RSA (OK - compressed)
    3988 META-INF/CERT.SF (OK - compressed)
   38050 META-INF/MANIFEST.MF (OK - compressed)
   70716 META-INF/androidx.activity_activity.version (OK)
   70812 META-INF/androidx.annotation_annotation-experimental.version (OK)
   70920 META-INF/androidx.appcompat_appcompat-resources.version (OK)
   71008 META-INF/androidx.appcompat_appcompat.version (OK)
   71092 META-INF/androidx.arch.core_core-runtime.version (OK)
   71200 META-INF/androidx.asynclayoutinflater_asynclayoutinflater.version (OK)
   71280 META-INF/androidx.camera_camera-core.version (OK)
   71372 META-INF/androidx.camera_camera-lifecycle.version (OK)
   71468 META-INF/androidx.camera_camera-view.version (OK)
   71580 META-INF/androidx.coordinatorlayout_coordinatorlayout.version (OK)
   71660 META-INF/androidx.core_core.version (OK)
   71756 META-INF/androidx.cursoradapter_cursoradapter.version (OK)
   71848 META-INF/androidx.customview_customview.version (OK)
   71944 META-INF/androidx.documentfile_documentfile.version (OK)
   72040 META-INF/androidx.drawerlayout_drawerlayout.version (OK)
   72136 META-INF/androidx.exifinterface_exifinterface.version (OK)
   72224 META-INF/androidx.fragment_fragment.version (OK)
   72320 META-INF/androidx.interpolator_interpolator.version (OK)
   72420 META-INF/androidx.legacy_legacy-support-core-ui.version (OK)
   72520 META-INF/androidx.legacy_legacy-support-core-utils.version (OK)
   72612 META-INF/androidx.legacy_legacy-support-v4.version (OK)
   72716 META-INF/androidx.lifecycle_lifecycle-livedata-core.version (OK)
   72812 META-INF/androidx.lifecycle_lifecycle-livedata.version (OK)
   72908 META-INF/androidx.lifecycle_lifecycle-runtime.version (OK)
   73008 META-INF/androidx.lifecycle_lifecycle-viewmodel.version (OK)
   73092 META-INF/androidx.loader_loader.version (OK)
   73204 META-INF/androidx.localbroadcastmanager_localbroadcastmanager.version (OK)
   73284 META-INF/androidx.media_media.version (OK)
   73364 META-INF/androidx.print_print.version (OK)
   73460 META-INF/androidx.recyclerview_recyclerview.version (OK)
   73552 META-INF/androidx.savedstate_savedstate.version (OK)
   73656 META-INF/androidx.slidingpanelayout_slidingpanelayout.version (OK)
   73764 META-INF/androidx.swiperefreshlayout_swiperefreshlayout.version (OK)
   73856 META-INF/androidx.transition_transition.version (OK)
   73956 META-INF/androidx.vectordrawable_vectordrawable-animated.version (OK)
   74056 META-INF/androidx.vectordrawable_vectordrawable.version (OK)
   74164 META-INF/androidx.versionedparcelable_versionedparcelable.version (OK)
   74252 META-INF/androidx.viewpager_viewpager.version (OK)
   74342 META-INF/annotation-experimental_release.kotlin_module (OK - compressed)
   74427 META-INF/kotlin-stdlib-common.kotlin_module (OK - compressed)
   75243 META-INF/kotlin-stdlib.kotlin_module (OK - compressed)
   77254 META-INF/okio.kotlin_module (OK - compressed)
   77552 META-INF/retrofit.kotlin_module (OK - compressed)
   77652 META-INF/rxjava.properties (OK - compressed)
   78094 assets/STO_CPCL.txt (OK - compressed)
   78963 assets/TTKD.txt (OK - compressed)
   80111 assets/ZhongTong.txt (OK - compressed)
   81188 assets/ic.png (OK)
  230376 assets/ic_launcher1.png (OK)
  237600 assets/logo3.png (OK)
  244688 assets/logo_sto_print1.png (OK)
  248184 assets/logo_sto_print2.png (OK)
  250934 classes.dex (OK - compressed)
 3571512 kotlin/annotation/annotation.kotlin_builtins (OK - compressed)
 3572147 kotlin/collections/collections.kotlin_builtins (OK - compressed)
 3573742 kotlin/coroutines/coroutines.kotlin_builtins (OK - compressed)
 3573969 kotlin/internal/internal.kotlin_builtins (OK - compressed)
 3574485 kotlin/kotlin.kotlin_builtins (OK - compressed)
 3578702 kotlin/ranges/ranges.kotlin_builtins (OK - compressed)
 3579726 kotlin/reflect/reflect.kotlin_builtins (OK - compressed)
 3581005 lib/arm64-v8a/libLZO.so (OK - compressed)
 3587454 lib/arm64-v8a/libjniPdfium.so (OK - compressed)
 3755424 lib/arm64-v8a/libmodpdfium.so (OK - compressed)
 6260925 lib/armeabi-v7a/libLZO.so (OK - compressed)
 6269756 lib/armeabi-v7a/libjniPdfium.so (OK - compressed)
 6320183 lib/armeabi-v7a/libmodpdfium.so (OK - compressed)
 8760132 lib/armeabi/libLZO.so (OK - compressed)
 8769187 lib/armeabi/libjniPdfium.so (OK - compressed)
 8822386 lib/armeabi/libmodpdfium.so (OK - compressed)
11262332 lib/mips/libLZO.so (OK - compressed)
11268878 lib/mips/libjniPdfium.so (OK - compressed)
11346486 lib/mips/libmodpdfium.so (OK - compressed)
14148390 lib/mips64/libLZO.so (OK - compressed)
14154817 lib/x86/libLZO.so (OK - compressed)
14161950 lib/x86/libjniPdfium.so (OK - compressed)
14233046 lib/x86/libmodpdfium.so (OK - compressed)
16879751 lib/x86_64/libLZO.so (OK - compressed)
16887620 lib/x86_64/libjniPdfium.so (OK - compressed)
17062738 lib/x86_64/libmodpdfium.so (OK - compressed)
19681868 okhttp3/internal/publicsuffix/publicsuffixes.gz (OK)
19715922 res/anim/abc_fade_in.xml (OK - compressed)
19716194 res/anim/abc_fade_out.xml (OK - compressed)
19719745 res/anim/btn_checkbox_to_checked_box_inner_merged_animation.xml (OK - compressed)
19720480 res/anim/btn_checkbox_to_checked_box_outer_merged_animation.xml (OK - compressed)
....
19744230 res/color/switch_thumb_material_light.xml (OK - compressed)
19744533 res/color/ucrop_scale_text_view_selector.xml (OK - compressed)
19744834 res/drawable-anydpi-v21/picture_ic_camera.xml (OK - compressed)
19745350 res/drawable-anydpi-v21/picture_ic_flash_auto.xml (OK - compressed)
19781100 res/drawable-ldrtl-xxxhdpi-v17/abc_spinner_mtrl_am_alpha.9.png (OK)
19781628 res/drawable-mdpi-v4/abc_ab_share_pack_mtrl_alpha.9.png (OK)
19781984 res/drawable-mdpi-v4/abc_btn_check_to_on_mtrl_000.png (OK)
19796284 res/drawable-mdpi-v4/abc_text_select_handle_middle_mtrl_dark.png (OK)
19796696 res/drawable-mdpi-v4/abc_text_select_handle_middle_mtrl_light.png (OK)
19797956 res/drawable-mdpi-v4/abc_textfield_default_mtrl_alpha.9.png (OK)
19798232 res/drawable-mdpi-v4/abc_textfield_search_activated_mtrl_alpha.9.png (OK)
19798512 res/drawable-mdpi-v4/abc_textfield_search_default_mtrl_alpha.9.png (OK)
19930676 res/drawable-xxxhdpi-v4/abc_spinner_mtrl_am_alpha.9.png (OK)
19933028 res/drawable-xxxhdpi-v4/abc_text_select_handle_left_mtrl_light.png (OK)
19933644 res/drawable-xxxhdpi-v4/abc_text_select_handle_right_mtrl_dark.png (OK)
19934260 res/drawable-xxxhdpi-v4/abc_text_select_handle_right_mtrl_light.png (OK)
19934848 res/drawable-xxxhdpi-v4/picture_ic_camera.png (OK)
19949984 res/drawable/abc_ratingbar_material.xml (OK - compressed)
19952466 res/drawable/abc_switch_thumb_material.xml (OK - compressed)
19956754 res/drawable/btn_radio_off_mtrl.xml (OK - compressed)
19957539 res/drawable/btn_radio_off_to_on_mtrl_animation.xml (OK - compressed)
19957904 res/drawable/btn_radio_on_mtrl.xml (OK - compressed)
19958665 res/drawable/btn_radio_on_to_off_mtrl_animation.xml (OK - compressed)
19959028 res/drawable/code128.gif (OK)
19967912 res/drawable/edittext_no_arc.xml (OK - compressed)
19982624 res/drawable/imageselector_title_right_bg.xml (OK - compressed)
19983080 res/drawable/itf.gif (OK)
19985690 res/drawable/linearlayout3.xml (OK - compressed)
19986031 res/drawable/linearlayout4.xml (OK - compressed)
19986368 res/drawable/logo.png (OK)
20001289 res/drawable/picture_original_wechat_checkbox.xml (OK - compressed)
20001590 res/drawable/picture_original_wechat_normal.xml (OK - compressed)
20001956 res/drawable/picture_original_wechat_selected.xml (OK - compressed)
20002468 res/drawable/picture_preview_gallery_border_bg.xml (OK - compressed)
20229964 res/mipmap-xxxhdpi-v4/scan.png (OK)
20230540 res/raw/beep.ogg (OK)
20236996 res/raw/picture_music.wav (OK)
20256509 res/xml/download_files_public.xml (OK - compressed)
20256713 res/xml/file_paths.xml (OK - compressed)
20256972 res/xml/util_code_provider_paths.xml (OK - compressed)
20257339 res/xml/web_files_public.xml (OK - compressed)
20257556 resources.arsc (OK)
Verification succesful

```

### 2.3.签名apk

我们使用apksigner进行V2签名，命令如下

    apksigner sign --v2-signing-enabled true --v1-signing-enabled false --ks my-release-key.keystore --ks-key-alias key1 --verbose -out alignsigned-app.apk align.apk

命令说明

* apksigner sign :这是调用 apksigner 工具并指定进行签名操作的命令。

* --v2-signing-enabled true :这个参数指示启用 APK Signature Scheme v2 签名。APK Signature Scheme v2 是一种用于对 APK 进行数字签名的机制，提供了更安全和高效的签名方案。

* --v1-signing-enabled false :这个参数指示禁用 APK Signature Scheme v1 签名。APK Signature Scheme v1 是较早的一种APK签名机制，此处将其禁用；当然将其开启也可以的

* --ks my-release-key.keystore :这个参数指定了用于签名的 keystore 文件，这里使用的是名为 my-release-key.keystore 的 keystore 文件。

* --ks-key-alias key1 :指定了要用来对 APK 进行签名的密钥别名。这里使用的是名为 key1 的密钥别名。

* --verbose :启用详细输出，这样在签名过程中会显示更多的信息。

* -out alignsigned-app.apk :指定了签名后的输出文件名为 alignsigned-app.apk。

* align.apk :最后的参数是指定要进行签名的输入 APK 文件，这里使用的是名为 align.apk 的文件。

根据这个命令的设置，apksigner 将会使用 APK Signature Scheme v2 进行签名，禁用 v1 签名，使用指定的 keystore 文件和密钥别名进行签名，并且输出签名后的文件名为 alignsigned-app.apk。


```

(base) ksnowlv@MacBook-Pro-3 apktool %  apksigner sign --v2-signing-enabled true --v1-signing-enabled false --ks my-release-key.keystore --ks-key-alias key1 --verbose -out alignsigned-app.apk align.apk                
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
Keystore password for signer #1: //此处输入的是keystore密码。
Signed
(base) ksnowlv@MacBook-Pro-3 apktool % apksigner verify alignsigned-app.apk 
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
DOES NOT VERIFY
ERROR: Missing META-INF/MANIFEST.MF
(base) ksnowlv@MacBook-Pro-3 apktool % 

```

此处因为我有签名文件，直接签名即可。

如果反编译的apk没有签名文件，密钥等信息，可以自己生成密钥文件，然后再按上面的操作流程直接签名即可。


生成密钥文件步骤如下

* 步骤一：生成密钥库

使用 keytool 工具来生成一个。以下是示例命令：

    keytool -genkeypair -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

这个命令会生成一个名为my-release-key.jks的密钥库文件，并要求你输入有关密钥库和密钥的信息，记录下密钥库和密钥信息即可。

* 步骤二：将密钥库与APK相关联

在签名之前，你需要将 APK 与你的密钥库相关联。你可以使用 apksigner 工具完成这一步骤：

    apksigner sign --ks your-release-key.jks your-app.apk

其中

your-release-key.jks 是你的密钥库文件的名称

your-app.apk 是你要重签名的 APK 文件名。

上述操作完成后，目录如下

![image](/images/tools/Mac下AndroidApk反编译重新打包-签名打包下篇/apk_dir.png)

### 2.4.测试安装

在Android手机上安装测试通过,完美~



