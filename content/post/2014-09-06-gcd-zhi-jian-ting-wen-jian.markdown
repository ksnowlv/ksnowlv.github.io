---
title: "GCD之监听文件"
date: 2014-09-06
lastmod: 2014-09-06
categories:
  - "iOS"
tags:
  - "多线程"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

GCD可以用来监听文件变化，例如目录变化，重命名等之类的。
例如我们监听`Document`目录下，`ksnow`目录的变化。

``` objective-c

NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);

  if (paths.count == 0) {
    return;
  }

  NSString *ksnowDir =
      [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ksnow"];

  NSLog(@"ksnowdir = %@", ksnowDir);

  NSURL *directoryURL = [NSURL URLWithString:ksnowDir];

  int const fd =
      open([[directoryURL path] fileSystemRepresentation], O_EVTONLY);
  if (fd < 0) {

    NSLog(@"Unable to open the path = %@", [directoryURL path]);
    return;
  }
  dispatch_source_t source =
      dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd,
                             DISPATCH_VNODE_WRITE | DISPATCH_VNODE_RENAME,
                             DISPATCH_TARGET_QUEUE_DEFAULT);
  dispatch_source_set_event_handler(source, ^() {
      unsigned long const type = dispatch_source_get_data(source);

      switch (type) {
      case DISPATCH_VNODE_WRITE: {
        NSLog(@"目录内容改变!!!");
        break;
      }
      case DISPATCH_VNODE_RENAME: {
        NSLog(@"目录被重命名!!!");
        break;
      }

      default:
        break;
      }
  });
  dispatch_source_set_cancel_handler(source, ^() { close(fd); });
  self.source = source;
  dispatch_resume(self.source);

```

对`/Users/ksnowlv/Library/Developer/CoreSimulator/Devices/DCA2391F-AA20-484C-AC45-BB762077A904/data/Containers/Data/Application/C268F09F-1B97-4546-BED0-EF56782A50B8/Documents/ksnow`该目录进行重命名，添加文件，删除文件等操作。

```objective-c

2014-09-06 17:50:06.473 GCDWatchFileTest[6257:881686] ksnowdir = /Users/ksnowlv/Library/Developer/CoreSimulator/Devices/DCA2391F-AA20-484C-AC45-BB762077A904/data/Containers/Data/Application/C268F09F-1B97-4546-BED0-EF56782A50B8/Documents/ksnow
2014-09-06 17:50:26.799 GCDWatchFileTest[6257:882512] 目录被重命名!!!
2014-09-06 17:50:40.113 GCDWatchFileTest[6257:883922] 目录被重命名!!!
2014-09-06 17:50:47.472 GCDWatchFileTest[6257:884919] 目录内容改变!!!
2014-09-06 17:50:53.632 GCDWatchFileTest[6257:884919] 目录内容改变!!!

```
