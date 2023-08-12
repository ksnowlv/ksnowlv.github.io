---
title: "为Xcode增加主题"
date: 2014-08-29
categories:
  - "iOS"
tags:
  - "Xcode"
---
<!--more-->

把`Xcode`主题文件拷贝到`/Users/ksnowlv/Library/Developer/Xcode/UserData/FontAndColorThemes`目录下。

<!--more-->

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/xcode_theme_dir.png)

那以`dvtcolortheme`格式是什么文件呢？iOS/Mac OS中的`plist`，实质xml文件。

打开`Anubis.dvtcolortheme`文件，其内容如下(部分内容限于篇幅省略...):

``` xml
    
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>DVTConsoleDebuggerInputTextColor</key>
	<string>0.7653 0.699234 0.758969 1</string>
	<key>DVTConsoleDebuggerInputTextFont</key>
	<string>Menlo-Regular - 11.0</string>
	<key>DVTConsoleDebuggerOutputTextColor</key>
	<string>0.6431 0.5881 0.637824 1</string>
	<key>DVTConsoleDebuggerOutputTextFont</key>
	<string>Menlo-Regular - 11.0</string>
    ...
	<dict>
		<key>xcode.syntax.attribute</key>
		<string>0.335 0.456 0.488 1</string>
		<key>xcode.syntax.character</key>
		<string>0.616 0.499 0.951 1</string>
		<key>xcode.syntax.comment</key>
		<string>0.651579 0.600072 0.644145 1</string>
       ...
	</dict>
	<key>DVTSourceTextSyntaxFonts</key>
	<dict>
		<key>xcode.syntax.attribute</key>
		<string>SourceCodePro-Regular - 12.0</string>
		<key>xcode.syntax.character</key>
		<string>SourceCodePro-Regular - 12.0</string>
       ...
	</dict>
</dict>
</plist>

```


常用的Xcode主题

1.[Solarized Light & Dark](https://github.com/jbrennan/xcode4themes)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/solarized_theme_overview.png)


2.[tomorrow-theme](https://github.com/chriskempson/tomorrow-theme)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/tomorrow_theme_overview.png)

3.[Twilight](https://github.com/brunodecarvalho/xcode-themes)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/twilight_theme_overview.png)

4.[Anubis](https://raw.githubusercontent.com/gtranchedone/XcodeThemes/master/Anubis.dvtcolortheme)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/anubis_theme_overview.png)

5.[armadillu](https://raw.githubusercontent.com/armadillu/XcodeColorSchemes/master/Xcode5/armadillu.dvtcolortheme)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/armadillu_theme_overview.png)

6.[today-xcode-theme](https://github.com/alenofx/today-xcode-theme)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/today_theme_overview.png)

7.[zenburn](https://github.com/colinta/zenburn)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/zenburn_theme_overview.png)

8.[Urban](https://github.com/UrbanApps/Urban)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/urban_theme_overview.png)

9.[Toy-Chest-Theme](https://github.com/JacksonGariety/Toy-Chest-Theme)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/toy_chest_theme_overview.png)

10.[Colour-and-standards](https://github.com/tkemp/Colour-and-standards)

![image](/images/post/2014-08-29-wei-xcode-zeng-jia-zhu-ti/chocolate_cake_theme_overview.png)
