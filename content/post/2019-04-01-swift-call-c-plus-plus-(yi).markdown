---
title: "swift call c++（一）"
date: 2019-04-01
lastmod: 2019-04-01
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---


如何在swift调整c++代码呢？

*swift通过工程的桥接文件，调用c的代码，间接调用c++代码!!!*


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

#### 2.创建c类文件：`PersonExtension.hpp`和`PersonExtension.cpp`
`PersonExtension.hpp`内容如下

```objective-c
//
//  PersonExtension.hpp
//  SwiftCallC
//
//  Created by ksnowlv on 2019/3/29.
//  Copyright © 2019 ksnowlv. All rights reserved.
//

#ifndef PersonExtension_hpp
#define PersonExtension_hpp

#include <stdio.h>


#ifdef __cplusplus
extern "C"{
#endif
    //在这里写上c的代码
    
    //初始化一个Person的实例
    
    const void * createPerson();
    const void destroyPerson(void* p);
    const void setPersonAge(void* p, const int age);
    const int personAge(void* p);
    const void setPersonName(void* p, const char* name);
    const char* personName(void* p);
    
    
#ifdef __cplusplus
}
#endif

#endif /* PersonExtension_hpp */

```

`PersonExtension.cpp`内容如下

```objective-c

//
//  PersonExtension.cpp
//  SwiftCallC
//
//  Created by ksnowlv on 2019/3/29.
//  Copyright © 2019 ksnowlv. All rights reserved.
//

#include "PersonExtension.hpp"
#include "Person.hpp"

const void * createPerson()
{
    Person *p = new Person();
    
    return (void *)p;
}

const void destroyPerson(void* p) {
    if (p) {
        Person *person = (Person*)p;
        delete person;
    }
}


const void setPersonAge(void* p, const int age) {
    
    if (p) {
        Person *person = (Person*)p;
        person->setAge(age);
    }
}

const int personAge(void* p) {
    
    if (p) {
        Person *person = (Person*)p;
        return person->age();
    }
    
    return 0;
}

const void setPersonName(void* p, const char* name) {
    if (p) {
        Person *person = (Person*)p;
        person->setName(name);
    }
}

const char* personName(void* p) {
    if (p) {
        Person *person = (Person*)p;
        return person->name();
    }
    
    return nullptr;
}


```

#### 3.在桥接文件中,加入`PersonExtension.hpp`引用：`#include "PersonExtension.hpp""`
#### 4.swift中调用
```objective-c

      let person = UnsafeMutableRawPointer(mutating: createPerson())
      print("age =",personAge(person))
      setPersonAge(person, 10)
      print("age =",personAge(person))
        
      setPersonName(person, "ksnowlv")
        
      let nameBuf:UnsafePointer<Int8> = personName(person)
      print("name = ",String(cString: nameBuf))
        
      destroyPerson(person)   
```

结果显而易见：

```objective-c

age = 0
age = 10
name =  ksnowlv

```
