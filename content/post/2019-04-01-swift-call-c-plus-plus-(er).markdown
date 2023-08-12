---
title: "swift call c++（二）"
date: 2019-04-01
categories:
  - "swift-基础"
tags:
  - "swift-基础"
---
<!--more-->



如何在swift调整c++代码呢？

*swift通过工程的桥接文件，调用oc的代码，间接调用c++代码!!!*


#### 1.创建C++ Person类文件：`Person.hpp`和`Person.cpp`
`Person.hpp`内容如下：

```objective-c

//
//  Person.hpp
//  SwiftCallC
//
//  Created by ksnowlv on 2019/3/28.
//  Copyright © 2019 ksnowlv. All rights reserved.
//

#ifndef Person_hpp
#define Person_hpp

#include <stdio.h>

class Person {
public:
    Person();
    ~Person();
    
    void setName(const char* pName);
    const char* name();
    
    void setAge(const int age);
    const int age() const;
    
private:
    char *m_pName;
    int m_age;
};


#endif /* Person_hpp */

```

`Person.cpp`内容如下


```objective-c

//
//  Person.cpp
//  SwiftCallC
//
//  Created by ksnowlv on 2019/3/28.
//  Copyright © 2019 ksnowlv. All rights reserved.
//

#include "Person.hpp"
#include <string.h>


Person::Person() {
    m_pName = nullptr;
    m_age = 0;
}

Person::~Person() {
    
    if (m_pName) {
        delete [] m_pName;
        m_pName = nullptr;
    }
}

void Person::setAge(const int age) {
    m_age = age;
}

const int Person::age()const {
    return m_age;
}

void Person::setName(const char *pName) {
    if (m_pName) {
        delete [] m_pName;
        m_pName = nullptr;
    }
    
    if (pName) {
        const size_t len = strlen(pName) + 1;
        m_pName = new char[len];
        memset(m_pName, 0, len);
        strcpy(m_pName, pName);
    }
}

const char* Person::name() {
    return m_pName;
}


```

#### 2.创建oc类文件：`PersonExt.h`和`PersonExt.mm`
`PersonExt.h`内容如下

```objective-c
//
//  PersonExt.h
//  SwiftCallC
//
//  Created by ksnowlv on 2019/4/1.
//  Copyright © 2019 ksnowlv. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface PersonExt : NSObject 


@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) NSInteger age;


@end

NS_ASSUME_NONNULL_END

```

`PersonExt.mm`内容如下

```objective-c

//
//  PersonExt.m
//  SwiftCallC
//
//  Created by ksnowlv on 2019/4/1.
//  Copyright © 2019 ksnowlv. All rights reserved.
//

#import "PersonExt.h"
#include "Person.hpp"

@interface PersonExt () {
    Person *_person;
}


@end

@implementation PersonExt

- (id)init {
    self = [super init];
    
    if (self) {
        _person = new Person();
    }
    
    return self;
}

- (void)dealloc {
    
    if (_person) {
        delete _person;
        _person = nil;
    }
}

- (void)setName:(NSString *)name {
    if (_person) {
        _person->setName([name UTF8String]);
    }
}

- (NSString *)name {
    if (_person) {
        const char *name = _person->name();
        
        if (name) {
            return  [NSString stringWithUTF8String:name];
        }
    }
    
    return nil;
}

- (void)setAge:(NSInteger)age {
    
    if (_person) {
        _person->setAge((const int)age);
    }
}

- (NSInteger)age {
    if (_person) {
        return  _person->age();
    }
    
    return 0;
}

@end


```

#### 3.在桥接文件中,加入`PersonExt.h`引用：`#include "PersonExt.h"`
#### 4.swift中调用
```objective-c

    let personExt = PersonExt()
    var age = personExt.age
    print("age =",age)
    personExt.age = 20
    age = personExt.age
    print("age =",age)
        
    personExt.name = "ksnowlv"
    print("name = ",personExt.name) 
```

结果显而易见：

```objective-c
age = 0
age = 20
name =  ksnowlv

```



