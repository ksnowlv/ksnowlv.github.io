---
title: "iOS/iPad App内存占用上限(一)"
date: 2014-07-27
lastmod: 2014-07-27
categories:
  - "iOS"
tags:
  - "内存"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

如何测试iOS/iPad App内存占用上限呢？


#### iOS/iPad App内存占用在只有一个App运行时，该App占用内存的上限能达到多少呢？
#### 关闭设备上所有其它应用,测试 demo app 占用内存上限.
``` objective-c

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"------------------------memory warning");
    [self mallocMemory];
    NSLog(@"------------------------memory warningx");
}

- (IBAction)startMallocEvent:(id)sender
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
   _timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(mallocMemory) userInfo:nil repeats:YES];
}

- (void)mallocMemory
{
    const CGFloat KMemoryLength = 1024.0f * 1024.0f;
    _pMemory[_count]  = malloc(KMemoryLength);
    memset(_pMemory[_count], 0, KMemoryLength);
    ++_count;
    

    //实际内存
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t error = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    
    long curMemorySize = 0;
    long curVirtualMemorySize = 0;
    
    if (error == KERN_SUCCESS) {
        curMemorySize = info.resident_size;
        curVirtualMemorySize = info.virtual_size;
    }
    
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    
    
    long freeMemorySize =  vm_stat.free_count * pagesize;
    
    NSLog(@"curMemorySize = %5.1fM,VirtualMemorySize = %5.1fM,freeMemorySize = %5.1fM",
          curMemorySize/KMemoryLength,
          curVirtualMemorySize/KMemoryLength,
          freeMemorySize/KMemoryLength);
    
    uint64_t physicalMemorySize = 0;
    uint64_t userMemorySize = 0;
    
    int mib[2];
    size_t length;
    mib[0] = CTL_HW;
    
    mib[1] = HW_MEMSIZE;
    length = sizeof(int64_t);
    sysctl(mib, 2, &physicalMemorySize, &length, NULL, 0);
    
    mib[1] = HW_USERMEM;
    length = sizeof(int64_t);
    sysctl(mib, 2, &userMemorySize, &length, NULL, 0);
    
    NSLog(@"physicalMemorySize = %5.1fM,userMemorySize = %5.1fM",
          physicalMemorySize/KMemoryLength,
          userMemorySize/KMemoryLength);
    
}


```

#### 测试工具:使用苹果自带测试工具,点击按钮后, 直到 app 被系统杀死。被杀死时    内存占用情况如下：    activity monitor 显示的内存占用为:468M.
    allocation 显示的内存占用为:681M. 
    

详情如下：
   
   ![image](/images/post/2014-07-27-ping-guo-app-nei-cun-zhan-yong-shang-xian/1.png)
    
  ![image](/images/post/2014-07-27-ping-guo-app-nei-cun-zhan-yong-shang-xian/2.png)
    
  
连续几次结果在上述值多一点。

    曾有相关资料介绍,单个 app 占用内存上限为 ram 值的一半。
    
看来是有道理的。尽管如此, 我们不能奢求用户只开咱们一个App这种理想化的条件。


