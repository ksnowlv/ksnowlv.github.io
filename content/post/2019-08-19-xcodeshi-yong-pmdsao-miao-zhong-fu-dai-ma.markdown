---
title: "XCode使用PMD扫描重复代码（一）"
date: 2019-08-19
lastmod: 2019-08-19
categories:
  - "iOS"
tags:
  - "iOS"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

如何使用PMD在XCode下扫描重复代码（Copy&Past）呢？

### 1.下载PMD：[https://pmd.github.io](https://pmd.github.io)，放置到工程主目录下面。![image](![image](/images/post/2019-08-19-xcodeshi-yong-pmdsao-miao-zhong-fu-dai-ma/1.jpg) 	
	) 

### 2.XCode中检测脚本配置#### 1.在`Xcode`的 `Build Phases` 中，我们增加一个新的 `Run Script`，脚本内容如下：

	#检测swift代码
	#pmd cpd --files ${EXECUTABLE_NAME} --minimum-tokens 50 --language swift --encoding UTF-8 --format net.sourceforge.pmd.cpd.XMLRenderer > cpd-output.xml --failOnViolation true

	#检测objective-c代码
	pmd cpd --files ${EXECUTABLE_NAME} --minimum-tokens 20 --language objectivec --encoding UTF-8 --format net.sourceforge.pmd.cpd.XMLRenderer > cpd-output.xml --failOnViolation true

	# Running script
	php ./cpd_script.php -cpd-xml cpd-output.xml
	
	
#### 2.在工程主目录下，创建cpd_script.php文件！！！需要安装好php

	<?php
	foreach (simplexml_load_file('cpd-output.xml')->duplication as $duplication) {
	    $files = $duplication->xpath('file');
	    foreach ($files as $file) {
	        echo $file['path'].':'.$file['line'].':1: warning: '.$duplication['lines'].' copy-pasted lines from: '
	            .implode(', ', array_map(function ($otherFile) { return $otherFile['path'].':'.$otherFile['line']; },
	            array_filter($files, function ($f) use (&$file) { return $f != $file; }))).PHP_EOL;
	    }
	}
	?>
	
	
![image](/images/post/2019-08-19-xcodeshi-yong-pmdsao-miao-zhong-fu-dai-ma/2.jpg) 	
	