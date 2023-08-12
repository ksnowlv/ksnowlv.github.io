---
title: "阻止文件被iTunes和iCloud同步"
date: 2014-12-03
categories:
  - "iOS-基础"
tags:
  - "iOS-基础"
---
<!--more-->

### 1.参考官方文档[How do I prevent files from being backed up to iCloud and iTunes?](https://developer.apple.com/library/ios/#qa/qa1719/_index.html)
<!--more-->

### 2.示例代码```objective-c
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path {
  BOOL success = NO;

  const char *filePath = [path fileSystemRepresentation];
  const char *attrName = "com.apple.MobileBackup";

  void *check = (void *)&NSURLIsExcludedFromBackupKey;
  if (check != NULL) {
    // First try and remove the extended attribute if it is present
    int result = getxattr(filePath, attrName, NULL, sizeof(u_int8_t), 0, 0);
    if (result != -1) {
      // The attribute exists, we need to remove it
      int removeResult = removexattr(filePath, attrName, 0);
      if (removeResult == 0) {
        NSLog(@"Removed extended attribute on item at path %@", path);
      }
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    success = [url setResourceValue:[NSNumber numberWithBool:YES]
                             forKey:NSURLIsExcludedFromBackupKey
                              error:nil];
  } else {
    // iOS 5.0.1 and lower
    u_int8_t attrValue = 1;
    int result =
        setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    success = (result == 0);
  }
  NSLog(@"Add skip backup attribute for item at path: %@, result: %d", path,
        success);
  return success;
}
```

       通过上述方法可以使该目录和该目录包含的所有文件和文件夹不被icloud和itunes同步了！

