---
title: "二维数组的创建释放"
date: 2013-05-10
lastmod: 2013-05-10
categories:
  - "C++"
tags:
  - "C++"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

```objective-c
template<class T>
void CreateArray(T** &aArray, const int aRow,const int aCol) {
 T** aArray = new T*[aRow];

 for (int i = 0; i < aRow; ++i)
 {
  aArray[i] = new T[aCol];
 }
}

template<class T>
void ReleaseArray(T** &aArray, const int aRow,const int aCol) {

 for (int i = aRow - 1; i >= 0; --i)
 {
  delete [] aArray[i];
 }

 delete[] aArray;
 aArray = NULL;
}

```

记得两年前，面试腾讯时，到部门老大面试的时候 

突然让写个这玩意，从来没有写过，凭借对指针的理解写出如上代码，当时没有用模板，用给定的int类型的数组，后来回来，写了个测试例子验证下，当时写对了。好险！后来写的测试例子如下：

```objective-c
void TestMgr::testArray()
{
 const int KCol = 3;
 const int KRow = 4;

 int** p = new int*[KCol];
 

 for (int i = 0; i < KCol; ++i )
 {
  p[i] = new int[KRow];
  memset(p[i],0,KRow * sizeof(int));
  
 }
 memset(*p,0, KCol* sizeof(int));
 for (int i = 0; i < KCol; ++i )
 {
  for (int j = 0; j < KRow; ++j)
  {
   p[i][j] = (i + 1) *(j +1);
   cout<<p[i][j]<<",";
  }
  cout<<endl;
 }


 for (int i = KCol - 1; i >=0; --i)
 {
  delete []p[i];
 }

 delete []p;
 
}

template<class T>
void CreateArray(T** &aArray, const int aRow,const int aCol)
{
 T** aArray = new T*[aRow];

 for (int i = 0; i < aRow; ++i)
 {
  aArray[i] = new T[aCol];
 }
}

template<class T>
void ReleaseArray(T** &aArray, const int aRow,const int aCol)
{

 for (int i = aRow - 1; i >= 0; --i)
 {
  delete [] aArray[i];
 }

 delete[] aArray;
 aArray = NULL;
}

```

结论：基础一定得扎实，即使遇见过从来没有用过的，也可以通过其实质写对！


