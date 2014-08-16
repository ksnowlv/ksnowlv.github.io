---
layout: post
title: "__block使用限制"
date: 2014-08-15 19:53
comments: true
categories: iOS
---

` __block`变量有两个限制
    
    1.不能是可变长度的数组。
    2.不能是包含C99可变长度数组的结构体。
    

####1.可变数组
####C99中的可变长数组（variable length array，简称VLA）
    
    可变长指的是编译期可变，数组定义时,其长度可为整数类型的表达式.
    
####C99中的可变改类型（variably modified type，简称VM）。    
  
    一个含有源自VLA派生的完整声明器被称为可变改的。VM包含了VLA和指向VLA的指针;
    注意VM类型并没有创建新的类型种类，VLA和指向VLA的指针仍然属于数组类型和指针类型，
    是数组类型和指针类型的扩展
    
####总结:
####VLA虽然定义时长度可变，但还不是动态数组，在运行期内不能再改变;
代码示例:
![image](/images/post/2014-08-15-__block-shi-yong-xian-zhi/var_length_demo.png)

####而指针类型的数组是在运行期间确定下来的，而且在运行期间也是可以改变的。

``` objective-c

     __block char* string = NULL;
    __block size_t stringLength = 0;
    
    void (^showMessage)(NSString *message);
    
    showMessage = ^(NSString *message)
    {
        int length = [message lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        stringLength = (length + 1) * sizeof(char);
        string = calloc(stringLength,stringLength);
        memcpy(string, [message UTF8String], stringLength);
        NSLog(@"string = %s",string);
    };
    
    showMessage(@"hello world");
  
    
    if (string && stringLength > 0) {
        
        NSLog(@"string = %s, string[0] = %c",string,string[0]);
        
        free(string);
        string = NULL;
    }


```
    
 
####2.柔性数组结构成员
     1.结构中的最后一个元素允许是未知大小的数组，这就叫做柔性数组成员；
     2.结构中的柔性数组成员前面必须至少一个其他成员。
     柔性数组成员允许结构中包含一个大小可变的数组。
     sizeof返回的这种结构大小不包括柔性数组的内存。
     包含柔性数组成员的结构用malloc ()函数进行内存的动态分配。
     

####一种可变长度的结构 代码示例:

``` objective-c

#声明一结构体
typedef struct TStudent
{
    int number;
    char name[];
}StudentType;

#创建一结构体

StudentType *p = (StudentType *) malloc( sizeof ( StudentType )+10*sizeof(char));

```
     
 
