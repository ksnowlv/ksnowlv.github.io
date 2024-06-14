---
title: "C++关于快速排序示例"
date: 2024-05-18T20:39:16+08:00
lastmod: 2024-05-18T20:39:16+08:00
keywords: ["C++"]
tags: ["C++"]
categories: ["C++"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

### 1.快速排序主要思想

快速排序是一种常用的排序算法，其主要思想是选择一个基准值，将数组分割成两部分，左边的部分都比基准值小，右边的部分都比基准值大，然后对左右两部分分别进行递归排序，最终实现整个数组的排序。

快速排序的主要步骤：

* 1.选择基准值
  * 从数组中选择一个基准值，通常是数组中的第一个元素、最后一个元素或者中间的元素。

* 2.分割
  * 将数组中小于基准值的元素放在左边，大于基准值的元素放在右边，基准值处于最终排序位置的中间。

* 3.递归排序
  * 对基准值左右两部分的子数组分别递归进行快速排序。

* 4.合并
  * 不需要合并步骤，因为在分割的过程中，子数组的顺序会得到维护。
  
### 2.C++示例

```C++
void SortTest::quickSort(int *p,const int start, const int end) {

    if (start < end) {
        int pivot = p[end];
        int i = start - 1;

        for (int j = start; j < end  ; ++j) {

            if (p[j] <= pivot) {
                ++i;
                std::swap(p[i], p[j]);
            }
        }
        std::swap(p[i + 1], p[end]);
        int pivotIndex = i + 1;//分区并获取枢纽索引

        quickSort(p, 0, pivotIndex - 1);//对枢纽左侧的子数组进行快速排序
        quickSort(p, pivotIndex + 1, end);//对枢纽右侧的子数组进行快速排序
    }
}
```

调用如下

```C++

void SortTest::test() {
    const int KLenOfArray = 11;
    int p[KLenOfArray] = { 10, 6, 12, 5, 1, 8, 11, 32, 1, 21, 3 };
    int q[KLenOfArray];
    memset(q, 0, sizeof(int) * KLenOfArray);
    memcpy(q, p, sizeof(int) * KLenOfArray);
    std::cout<<"quickSort快速排序后为"<<endl;
    quickSort(q, 0, KLenOfArray - 1);
    showArray(q, KLenOfArray);
}

```

### 3.效果

```C++
quickSort快速排序后为
arraylist infommation:1,1,3,5,6,8,10,11,12,21,32,
```

### 4.小结

此文看下C++代码的排版及风格，后面可能会添加C++方向的笔记，不喜勿喷。