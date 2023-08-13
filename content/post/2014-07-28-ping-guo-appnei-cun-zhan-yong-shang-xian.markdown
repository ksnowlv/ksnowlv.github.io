---
title: "iOS/iPad App内存占用上限(二)"
date: 2014-07-28
lastmod: 2014-07-28
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

iOS/iPad App内存占用上限是多少呢？


#### iOS/iPad App内存占用在打开许多App后，打开demo App,该demo App占用内存的上限能达到多少呢？
#### 使用下面的代码,点击按钮后，观察内存警告时，App被kill时的日志输出。

##### 内存警告时
``` objective-c

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"------------------------memory warning");
    [self mallocMemory];
    NSLog(@"------------------------memory warningx");
}

```

##### 手动触发该按钮事件后，等待被“kill”吧。
``` objective-c

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

#### 使用iPad mini2设备，统计7欠被杀死的情况。根据日志输出，整理其在被系统杀死时各项内存占用，如下：
| 序号  |  内存(M)  |  虚拟内存(M)  |  空闲内存(M)  |  物理内存(M)  |  非内核内存(M)   |
|------|-----------|--------------|-------------|--------------|------------|
|1     |192.1      |  1275.4      |30.2         |976           |815         
|2     |157.1      |  1304.6      |39.8         |976           |813         
|3     |151.7      |  1277.4      |29.1         |976           |821         
|4     |153.3      |  1304.7      |37.8         |976           |817.5       
|5     |138.3      |  2073.9      |29.7         |976           |817.9       
|6     |137.1      |  2074.4      |35.8         |976           |817.9       

#### 结论：    1.占有虚拟内存 < 2G,非内核内存占用在820M左右，即为死亡线。
    2.内存警告线，离这个死亡线很近。
    3.实际内存占用不高，虚拟内存较高，也会被“kill”。
    根源：内存使用效率不高，dirty memory较高！

#### 因此，对内存的优化，需要集中两方面
1.内存的占用。

2.内存的使用效率

    这个会涉及到cache,可能会增加内存的占用。
    尽是提高clean memory，降低dirty memory。

#### 注：更详细的数据分析及结论，如果需要，可以联系我。