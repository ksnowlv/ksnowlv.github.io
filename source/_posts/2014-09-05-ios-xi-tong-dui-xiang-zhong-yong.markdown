---
layout: post
title: "iOS系统对象重用"
date: 2014-09-05 16:24
comments: true
categories: iOS-内存
---

####当我们重复创建/销毁对象的操作时，iOS系统对象是否会被重用呢？
####结论:iOS系统较低概率会输出可重用的对象,so,注意内存使用效率[可用Allocation工具检测]。

>不要寄希望于系统对你低效的代码进行了你想象中的优化!

####测试思路

    以0.1s为间隔的timer,周期性的创建UILabel/NSMutableData，观察它们内存地址变化情况？
    
####测试代码
``` objective-c

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleNewObject) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleNewObject{
    UILabel *label = [[UILabel alloc] init];
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:1024];
    NSLog(@"UILabel address = %p,NSMutableData address = %p",label,data);
}

```    

####截取部分日志情况
``` objective-c
2014-09-05 16:22:43.564 DataReuseTest[70877:5448269] UILabel address = 0xba12bd0,NSMutableData address = 0xba06aa0
2014-09-05 16:22:43.664 DataReuseTest[70877:5448269] UILabel address = 0xae104c0,NSMutableData address = 0xae19f70
2014-09-05 16:22:43.764 DataReuseTest[70877:5448269] UILabel address = 0xbb0d7d0,NSMutableData address = 0xbb08710
2014-09-05 16:22:43.864 DataReuseTest[70877:5448269] UILabel address = 0xba315f0,NSMutableData address = 0xba12330
2014-09-05 16:22:43.964 DataReuseTest[70877:5448269] UILabel address = 0xae104c0,NSMutableData address = 0xae19f70
2014-09-05 16:22:44.064 DataReuseTest[70877:5448269] UILabel address = 0xba315f0,NSMutableData address = 0xba12330
2014-09-05 16:22:44.164 DataReuseTest[70877:5448269] UILabel address = 0xba315f0,NSMutableData address = 0xae0d9d0
2014-09-05 16:22:44.263 DataReuseTest[70877:5448269] UILabel address = 0xba315f0,NSMutableData address = 0xba12330
2014-09-05 16:22:44.364 DataReuseTest[70877:5448269] UILabel address = 0xba315f0,NSMutableData address = 0xba12330
2014-09-05 16:22:44.464 DataReuseTest[70877:5448269] UILabel address = 0xae104c0,NSMutableData address = 0xae19f70
2014-09-05 16:22:44.564 DataReuseTest[70877:5448269] UILabel address = 0xba315f0,NSMutableData address = 0xba12330
2014-09-05 16:22:44.664 DataReuseTest[70877:5448269] UILabel address = 0xba315f0,NSMutableData address = 0xbb02d20
2014-09-05 16:22:44.764 DataReuseTest[70877:5448269] UILabel address = 0xae104c0,NSMutableData address = 0xae19f70
2014-09-05 16:22:44.864 DataReuseTest[70877:5448269] UILabel address = 0xba315f0,NSMutableData address = 0xba13490
2014-09-05 16:22:44.963 DataReuseTest[70877:5448269] UILabel address = 0xba315f0,NSMutableData address = 0xba13490
2014-09-05 16:22:45.064 DataReuseTest[70877:5448269] UILabel address = 0xae104c0,NSMutableData address = 0xae19f70
2014-09-05 16:22:45.164 DataReuseTest[70877:5448269] UILabel address = 0xb84ea90,NSMutableData address = 0xb811d60

``` 