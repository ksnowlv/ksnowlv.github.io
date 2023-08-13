---
title: "排序-插入冒泡交换选择与二分查找"
date: 2013-05-15
lastmod: 2013-05-15
categories:
  - "算法与数据结构"
tags:
  - "算法与数据结构"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

![image](/images/post/2013-05-15-pai-xu-cha-ru-mou-pao-jiao-huan-xuan-ze-yu-er-fen-cha-zhao/1.png) 


##### 核心点是：模板不支持分离编译。（当然，如果你仅仅是编译模板函数而不调用不会导致如上错误！注意前提条件）
```objective-c
/**交换T的值**/
template <typename T>
void swap(T* p, T* q)
{
    T tmp = *p;
    *p = *q;
    *q = tmp;
}

/**输出T数组中各个元素的值**/
template <typename T>
void showArray(const T* pArray,const int arrayLen)
{
    for (int i = 0; i < arrayLen; ++i) {
        printf("%d->",pArray[i]);
    }
    printf("end");
}

/**直接插入排序，时间复杂度，平方级，稳定排序**/
template <typename T>
void insertSort(T* pArray, const int arrayLen)
{
    T tmp;
    
    for (int i = 1; i < arrayLen; ++i) {
        
        tmp = pArray[i];
        int j = 0;
        
        for (j = i; j > 0; --j) {
            
            if (tmp < pArray[j - 1]) {
                pArray[j] = pArray[j - 1];
            }
            else
            {
                break;
            }
        }
        
        pArray[j] = tmp;
        
    }
}

/**冒泡排序，时间复杂度，平方级，稳定排序**/
template <typename T>
void bubbleSort(T* pArray, const int arrayLen)
{
    bool isExchanged = false;
    for (int i = arrayLen - 1; i >= 0; --i) {
        
        isExchanged = false;
        
        for (int j = 0 ; j < i; ++j) {
            if (pArray[j + 1] < pArray[j]) {
                swap(&pArray[j + 1], &pArray[j]);
                isExchanged = true;
            }
        }
        
        if (!isExchanged) {
            break;
        }
    }
}

/**交换排序**/
template <typename T>
void exchangeSort(T* pArray, const int arrayLen)
{
    for (int i = 0; i < arrayLen; ++i) {
        
        for (int j = i + 1; j < arrayLen; ++j) {
            
            if (pArray[j] < pArray[i]) {
                swap(&pArray[j], &pArray[i]);
            }
            
        }
        
    }
}

/**选择排序**/
template <typename T>
void selectSort(T* pArray, const int arrayLen)
{
    int smallIndex = 0;
    
    for (int i = 0; i < arrayLen; ++i) {
        
        smallIndex = i;
        
        for (int j = i + 1; j < arrayLen; ++j) {
            if (pArray[smallIndex] > pArray[j]) {
                smallIndex = j;
            }
        }
        
        if (i != smallIndex) {
            swap(&pArray[i], &pArray[smallIndex]);
        }
        
    }
}

template <typename T>
const int binaryFind(const T* pArray, const int arrayLen,const T value)
{
    int mid = 0;
    int low = 0;
    int high = arrayLen - 1;
    
    while (low <= high) {
        mid = low + (high - low)/2;
        
        if (pArray[mid] > value)
        {
            high = mid - 1;
        }
        else if (pArray[mid] < value)
        {
            low = mid + 1;
        }
        else if (pArray[mid] == value) {
            return mid;
        }
    }
    
    return -1;
}

调用CODE如下：
- (void)viewDidLoad
{
    [super viewDidLoad];
// Do any additional setup after loading the view, typically from a nib.
    
    const int  KArrayLength = 10;
    int  pArray[KArrayLength] = {22,34,89,0,3,81,99,23,1,10} ;
   
    showArray(pArray, KArrayLength);
    //insertSort(pArray, KArrayLength);
    //bubbleSort(pArray, KArrayLength);
    //selectSort(pArray, KArrayLength);
    exchangeSort(pArray, KArrayLength);
    printf("\n");
    showArray(pArray, KArrayLength);

    int index = binaryFind(pArray, KArrayLength, 81);
    printf("\nindex = %d\n",index);
    
    index = binaryFind(pArray, KArrayLength, 811);
    printf("index = %d",index);
}

```

执行如下：

	22->34->89->0->3->81->99->23->1->10->end
	0->1->3->10->22->23->34->81->89->99->end
	index = 7
	index = -1