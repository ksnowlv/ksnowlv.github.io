---
layout: post
title: "iOS计算时间差值"
date: 2014-09-30 15:14
comments: true
categories: iOS基础
---

iOS中，以1970年1月1日00：00：00起始到现在，计算时间差值，可采用NSDate直接合成计算。如果需要重复计算次数较高，可能会导致NSDate大量生成；有没有更好的方法呢？

<!--more-->

>使用**CFAbsoluteTimeGetCurrent**来计算,减去2001年1月1日00:00:00到1970年1月1日00：00：00差值和时区差值即可。

####具体方法
###1.计算时间差值

``` objective-c
//1970年1月1日00：00：00到2001年1月1日00:00:00差值和时区差值之和
NSString *string = @"2001-01-01 00:00:00";
NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
NSDate *date = [formatter dateFromString:string];
_deltaTimeSince1970To2001 = [date timeIntervalSince1970] + [NSTimeZone systemTimeZone].secondsFromGMT;

``` 

###2.计算当前时间到截止时间的差值,避免了可能大量生成NSDate.

``` objective-c

- (TBHDCountDownTimerTimeIntervalType)handleTimerEvent:(id)sender{
    
//   NSUInteger timeOffset =  _deadLine - [[NSDate date] timeIntervalSince1970];
    //减少NSDate对象的消耗
    NSInteger timeOffset =  _deadLine - _deltaTimeSince1970To2001 - CFAbsoluteTimeGetCurrent();
    
    if (timeOffset > 0) {
        NSUInteger dayCount = timeOffset/KCountDownDay;
        double leftTime = timeOffset - (dayCount * KCountDownDay);
        
        NSUInteger hourCount = leftTime / 3600;
        
        leftTime = timeOffset - (dayCount * KCountDownDay) - (hourCount * 3600);
        
        NSUInteger minuteCount = leftTime / 60;
        
        leftTime = timeOffset - (dayCount * KCountDownDay) - (hourCount * 3600) - (minuteCount * 60);
        
        if (_timeCountBlcok) {
            _timeCountBlcok(dayCount,hourCount,minuteCount,leftTime);
        }
        
        //根据时间间隔大小调整计时器间隔大小的策略尚未添加。
        if (dayCount > 0 && hourCount > 0) {
            return TBHDCountDownTimerTimeIntervalTypeHour;
        }
        else if (dayCount >0 && hourCount == 0 && minuteCount > 0){
            return TBHDCountDownTimerTimeIntervalTypeMinute;
        }
        else{
            return TBHDCountDownTimerTimeIntervalTypeSecond;
        }
    }
    else{
        if (_timeCountBlcok) {
            _timeCountBlcok(0,0,0,0);
        }
    }
    
    return TBHDCountDownTimerTimeIntervalTypeNone;
}

``` 

创建如下:

``` objective-c

self.countDownTimer.deadLine = _deadLine;
self.countDownTimer.isCountTime = YES;
```

销毁如下：

``` objective-c

- (void)dealloc{
    
    _countDownTimer.isCountTime = NO;
    _countDownTimer = nil;
} 

```

其它：明天就回山东了，国庆后回北京，结束在杭州出差的日子^_^.

