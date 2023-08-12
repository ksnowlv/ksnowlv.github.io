---
title: "iOS的输入/输出流"
date: 2014-09-05
categories:
  - "iOS-网络"
tags:
  - "iOS-网络"
---
<!--more-->

使用Cocoa框架中的输入输出流，可以从文件或应用中内存读取数据，也可以向文件/应用中内存写入数据。你可以在基于socket连接的远程服务交换数据中使用。---翻译自苹果文档。

<!--more-->

#### 其主要类与方法
![image](/images/post/2014-09-05-ios-de-shu-ru-slash-shu-chu-liu/cocoa_stream_class.jpg)

使用示例：我们从使用输入流从本地文件中读取图片，使用输出流存储读取的图片数据并显示。


#### 1.声明输入/输出流/图片框属性。
``` objective-c

@property(nonatomic, strong) NSInputStream *imageInputStream;
@property(nonatomic, strong) NSOutputStream *imageOutputStream;
@property(nonatomic, strong) IBOutlet UIImageView *imageView;

```

#### 2.初始化输出流/输入流，清理方法，相关方法调用。
``` objective-c

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  NSString *filePath =
      [[NSBundle mainBundle] pathForResource:@"qq_head" ofType:@"jpg"];
  [self loadImageFile:filePath];
}


#pragma mark---------NSStreamDelegate----------

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {

  const NSUInteger kBufferSize = 2048;

  if (aStream == _imageInputStream) {
    NSLog(@"eventcode = %u", eventCode);

    switch (eventCode) {
    case NSStreamEventHasBytesAvailable: {

      uint8_t buf[kBufferSize];
      memset(buf, 0, kBufferSize * sizeof(uint8_t));
      NSInteger numOfBytes =
          [(NSInputStream *)aStream read:buf maxLength:kBufferSize];

      if (numOfBytes > 0) {
        [_imageOutputStream write:(const void *)buf maxLength:numOfBytes];
      }

      break;
    }

    case NSStreamEventEndEncountered: {

      NSLog(@"The end of the stream has been reached.");

      NSData *imageData = [_imageOutputStream
          propertyForKey:NSStreamDataWrittenToMemoryStreamKey];

      if (imageData.length > 0) {
        UIImage *icon = [[UIImage alloc] initWithData:imageData];
        _imageView.image = icon;
      }

      [self cleanUpStream];

      break;
    }

    case NSStreamEventErrorOccurred: {
      NSLog(@"NSStreamEventErrorOccurred!!");

      [self cleanUpStream];
    }
    default:
      break;
    }
  }
}

- (IBAction)loadNewImageFileEvnet:(id)sender {

  NSString *filePath =
      [[NSBundle mainBundle] pathForResource:@"qq_head_1" ofType:@"jpg"];
  [self loadImageFile:filePath];
}

/**
 *  从本地图片文件中初始化输入流，同时初始化输出流。
 *
 *  @param fileName 图片文件全路径
 */
- (void)loadImageFile:(NSString *)fileName {

  if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {

    self.imageInputStream = [NSInputStream inputStreamWithFileAtPath:fileName];
    _imageInputStream.delegate = self;
    [_imageInputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                 forMode:NSDefaultRunLoopMode];
    [_imageInputStream open];

    self.imageOutputStream = [NSOutputStream outputStreamToMemory];
    [_imageOutputStream open];
  } else {
    NSLog(@"%@ ---not found the file", fileName);
  }
}

/**
 *  清理输出输入流
 */
- (void)cleanUpStream {

  [_imageInputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
  _imageInputStream.delegate = nil;
  [_imageInputStream close];
  _imageInputStream = nil;

  [_imageOutputStream close];
  _imageOutputStream = nil;
}


```

