---
title: "Swift中DispatchGroup之管理异步任务"
date: 2021-06-13T18:03:47+08:00
lastmod: 2021-06-13T18:03:47+08:00
keywords: ["Swift", "GCD","DispatchGroup", "多线程", "iOS"]
tags: ["Swift", "GCD", "多线程", "iOS"]
categories: ["Swift", "GCD", "多线程", "iOS"]

comment: true
toc: true
autoCollapseToc: true
reward: true

---

<!--more-->


## DispatchGroup

swift中DispatchGroup，可以分组管理异步任务;

### 1.分组管理多个异步任务

```swift
   func dispatchGroupConcurrentTest() {
        print("class:\(type(of: self)),line:\(#line)")
        
        let WORKMAXNUM = 10
        
        let dispatchGroup = Dispatch.DispatchGroup()
        
        let queue1 = DispatchQueue(label: "1")
        let queue2 = DispatchQueue(label: "2")
        let queue3 = DispatchQueue(label: "3")
        
        queue1.async(group: dispatchGroup, execute:DispatchWorkItem {
            for i in 0..<WORKMAXNUM {
                print("\(i) execute")
            }
        } )
        
        queue2.async(group: dispatchGroup, execute:DispatchWorkItem {
            for i in 0..<WORKMAXNUM {
                print("\(i + 10) execute")
            }
        } )

        queue3.async(group: dispatchGroup, execute:DispatchWorkItem {
            for i in 0..<WORKMAXNUM {
                print("\(i + 20) execute")
            }
        } )
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
           print("main queue execute!")
        }
    }
```

### 执行结果
```swift
class:ViewController,line:19
0 execute
1 execute
2 execute
3 execute
4 execute
5 execute
6 execute
7 execute
8 execute
9 execute
10 execute
20 execute
11 execute
12 execute
13 execute
14 execute
15 execute
16 execute
21 execute
17 execute
22 execute
23 execute
24 execute
25 execute
26 execute
27 execute
18 execute
28 execute
29 execute
19 execute
main queue execute!

```


### 2.分组管理多个串行的异步任务

```swift
    func dispatchGroupSerialTest() {
        
        print("class:\(type(of: self)),line:\(#line)")
        let WORKMAXNUM = 10
        
        let dispatchGroup = Dispatch.DispatchGroup()
        
        let queue1 = DispatchQueue(label: "1")
        let queue2 = DispatchQueue(label: "2")
        let queue3 = DispatchQueue(label: "3")
        
        dispatchGroup.enter()
        queue1.async(group: dispatchGroup, execute:DispatchWorkItem {
            for i in 0..<WORKMAXNUM {
                print("\(i) execute")
            }
            dispatchGroup.leave()
        } )
        
        print("before wait")
        dispatchGroup.wait()
        print("end wait")
        dispatchGroup.enter()
        queue2.async(group: dispatchGroup, execute:DispatchWorkItem {
            for i in 0..<WORKMAXNUM {
                print("\(i + 10) execute")
            }
            
            dispatchGroup.leave()
        } )
        
        print("before wait")
        dispatchGroup.wait()
        print("end wait")
        dispatchGroup.enter()
        queue3.async(group: dispatchGroup, execute:DispatchWorkItem {
            for i in 0..<WORKMAXNUM {
                print("\(i + 20) execute")
            }
            
            dispatchGroup.leave()
        } )
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
           print("main queue execute!")
        }
    }
```

### 执行结果

```swift
class:ViewController,line:57
before wait
0 execute
1 execute
2 execute
3 execute
4 execute
5 execute
6 execute
7 execute
8 execute
9 execute
end wait
before wait
10 execute
11 execute
12 execute
13 execute
14 execute
15 execute
16 execute
17 execute
18 execute
19 execute
end wait
20 execute
21 execute
22 execute
23 execute
24 execute
25 execute
26 execute
27 execute
28 execute
29 execute
main queue execute!
```

### 3.小结
* 1.注意上述两种不同的使用场景。
* 2.注意**DispatchGroup**的**enter**和**leave**配对使用，以及与**wait**的配合使用。



