---
layout: post
title: "initialize实现单例"
date: 2014-07-26 17:34
comments: true
categories: ios-oc语法
---

initialize

Initializes the class before it receives its first message.

+ (void)initialize
Discussion
The runtime sends initialize to each class in a program just before the class, or any class that inherits from it, is sent its first message from within the program. The runtime sends the initialize message to classes in a thread-safe manner. Superclasses receive this message before their subclasses. The superclass implementation may be called multiple times if subclasses do not implement initialize—the runtime will call the inherited implementation—or if subclasses explicitly call [super initialize]. If you want to protect yourself from being run multiple times, you can structure your implementation along these lines:

+ (void)initialize {
  if (self == [ClassName self]) {
    // ... do the initialization ...
  }
}
Because initialize is called in a thread-safe manner and the order of initialize being called on different classes is not guaranteed, it’s important to do the minimum amount of work necessary in initialize methods. Specifically, any code that takes locks that might be required by other classes in their initialize methods is liable to lead to deadlocks. Therefore you should not rely on initialize for complex initialization, and should instead limit it to straightforward, class local initialization.

Special Considerations
initialize is invoked only once per class. If you want to perform independent initialization for the class and for categories of the class, you should implement load methods.



那么，在objective-c中使用 NSObject类的
{% codeblock lang:objective-c %}
+(void)initialize
{% endcodeblock %}

可以实现单例模式

代码如下：

{% codeblock lang:objective-c %}

@implementation QBaseObject

static QBaseObject *_sharedBaseObject;
static BOOL _initialized = NO;

+ (void)initialize
{
    if (!_initialized)
    {
        _sharedBaseObject = [[QBaseObject alloc] init];
        _initialized = YES;
    }
}

@end

{% endcodeblock %}