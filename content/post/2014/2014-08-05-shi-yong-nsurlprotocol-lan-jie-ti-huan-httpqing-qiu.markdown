---
title: "使用NSURLProtocol拦截替换http请求"
date: 2014-08-05
lastmod: 2014-08-05
categories:
  - "iOS"
tags:
  - "网络"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---
### 一.场景
整个工程中中图片url需要添加额外的参数支持图片优化，包括webview部分。

### 二.方案

 所以使用NSURLProtocol拦截相关URL,替换http请求，实现图片优化参数的统一支持。
### 三.详细实现

### 1.声明继承NSURLProtocol的子类QImageURLProtocol.
头文件内容如下：

``` objective-c


/**
 *  用于测试的url
 */
static NSString *KPicBURL = @"http://g.hiphotos.baidu.com/image/h%3D800%3Bcrop%3D0%2C0%2C1280%2C800/sign=ee4c561ac1fdfc03fa78eeb8e404e4e6/a686c9177f3e6709ef8de51b39c79f3df9dc5540.jpg";
static NSString *KPicAURL = @"http://d.hiphotos.baidu.com/image/h%3D800%3Bcrop%3D0%2C0%2C1280%2C800/sign=ee81c70e83cb39dbdec06a56e02d6a56/b812c8fcc3cec3fdcf460491d488d43f869427dd.jpg";


@interface QImageURLProtocol : NSURLProtocol

@end


``` 

### 2.实现文件内容

``` objective-c


@interface QImageURLProtocol ()

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation QImageURLProtocol

#pragma mark -----------NSURLProtocol-------------

+(BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSLog(@"----origin request url = %@",request.URL.absoluteString);
    if ([self isQImageURLRequest:request]) {
        return YES;
    }
    return NO;
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *cdnRequest = [request mutableCopy];
    cdnRequest.URL = [self imagesForQImageURL:request.URL];
    //[NSURLProtocol setProperty:@"YES" forKey:@"QImageURL" inRequest:cdnRequest];
    return cdnRequest;
}

- (void)startLoading {
    self.connection = [NSURLConnection connectionWithRequest:[QImageURLProtocol canonicalRequestForRequest:self.request ] delegate:self];
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark -----------------private method---------

+(BOOL)isQImageURLRequest:(NSURLRequest*)request{
    if ( [request.URL.host isEqualToString:@"d.hiphotos.baidu.com"]
        //&&nil == [NSURLProtocol propertyForKey:@"QImageURL" inRequest:request]
        )
    {
        NSLog(@"isQImageURLRequest");
        return YES;
    }
    
    return NO;
}


+(NSURL*)imagesForQImageURL:(NSURL*)url{
    //只要是KPicAURL，会被直接替换为KPicBURL
    if ([url.host isEqualToString:@"d.hiphotos.baidu.com" ]
        && [url.absoluteString isEqualToString:KPicAURL ]) {
         NSLog(@"----real request url = %@",KPicBURL);
        return [NSURL URLWithString:KPicBURL];
    };
    
    return url;
}

@end

```

### 3.调用

``` objective-c

- (void)dealloc
{
    [NSURLProtocol unregisterClass:[QImageURLProtocol class]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//关键一步
    [NSURLProtocol registerClass:[QImageURLProtocol class]];
    _imageDownloadQueue = [[NSOperationQueue alloc] init];
}

-(IBAction)requestImageEvent:(id)sender
{
    NSURLRequest *request = [ NSURLRequest requestWithURL:[NSURL URLWithString:KPicAURL]];
    [NSURLConnection sendAsynchronousRequest:request queue:_imageDownloadQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (nil == connectionError) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageView.image = image;
            });
        }
        
    }];
}


```

### 四.注意事项

### 1.拦截有效性

这种方法对于基于NSURLConnection的http请求是有效的,例如AFNetworking，对于基于CFNetwork框架的是不支持的,例如：MKNetworkKit,ASIHttpRequest

### 2.拦截范围

无论对webView还是native的,只要是基于NSURLConnection的网络请求的,可以根据相关特征进行URL拦截替换.

### 3.多次拦截注入
如果一个工程当中，注册了多个拦截基于NSURLConnection的网络请求的类的情况下，最终生效的是最后拦截者。