---
title: Java实现堆排序，快速排序，归并排序
categories: 算法
tags: 
  - 排序
toc: true 
---

## 堆排序
### 算法思想
堆排序(大根堆，降序排序为例)的算法思想

①将输入元素构造成堆

②构造完成后找到最右下元素的父节点开始进行局部调整

③依次往前，重复②的操作，直到调整到堆的根节点。

④输出堆顶元素

⑤重复②③④步骤，直到堆被清空。
### 代码如下
主函数入口
```java
package solution;

import struct.Heap;
public class Method3 {
    public static void main(String[] args) {
        // 初始化堆
        Heap heap = new Heap(new Integer[]{4,1,2,5,3,8,11,23,15,16,18});
        // 调整为大根堆
        heap.turnMaxHeap();
        // 输出堆顶元素
        while (heap.size > 0) {
            // 循环输出堆顶元素
            System.out.println(heap.peakHeapTop());
        }
        return;
    }
}
```
Heap类
```java
package struct;

public class Heap {
    // 假设堆的最大大小为100
    public final static int MAX_SIZE = 100;
    // 存放数据的元素
    public Integer[] elems = new Integer[MAX_SIZE];
    // 堆的大小
    public int size = 0;

    // 构造堆的函数
    public Heap(Integer[] arr) {
        for (Integer i = 0; i < arr.length; i++) {
            elems[i] = arr[i];
            size++;
        }
    }
    
    /**
     * 构造大根堆
     */
    public void turnMaxHeap() {
        // 从最右下节点的父节点开始遍历
        int index = size / 2 - 1;
        for (int i = index; i >= 0; i--) {
            // 局部调整
            turnPartialMaxHeap(i);
        }
    }
    
    /**
     * 堆进行局部调整
     *
     * @param currentIndex 子树的根节点
     */
    public void turnPartialMaxHeap(int currentIndex) {
        // 左孩子索引
        Integer leftChildIndex = getLeftChildIndex(currentIndex);
        // 右孩子索引
        Integer rightChildIndex = getRightChildIndex(currentIndex);
    
        // 判断
        if (leftChildIndex == null && rightChildIndex == null) {
            // 说明当前已经找到了叶结点
            return;
        } else if (leftChildIndex != null && rightChildIndex == null) {
            // 只有左孩子
            if (elems[currentIndex] < elems[leftChildIndex]) {
                Integer temp = elems[currentIndex];
                elems[currentIndex] = elems[leftChildIndex];
                elems[leftChildIndex] = temp;
            }
        } else if (leftChildIndex != null && rightChildIndex != null) {
            // 左孩子右孩子同时存在,取左右节点的最大值与父节点进行比较
            if (elems[leftChildIndex] > elems[rightChildIndex]) {
                // 左孩子为孩子王
                if (elems[currentIndex] < elems[leftChildIndex]) {
                    Integer temp = elems[currentIndex];
                    elems[currentIndex] = elems[leftChildIndex];
                    elems[leftChildIndex] = temp;
                }
            } else {
                // 有孩子为孩子王或者左右孩子相等
                if (elems[currentIndex] < elems[rightChildIndex]) {
                    Integer temp = elems[currentIndex];
                    elems[currentIndex] = elems[rightChildIndex];
                    elems[rightChildIndex] = temp;
                }
            }
            // 继续调整左右子树
            turnPartialMaxHeap(2 * (currentIndex + 1) - 1);
            turnPartialMaxHeap(2 * (currentIndex + 1));
        }
    }
    
    /**
     * 摘取堆顶元素
     *
     * @return
     */
    public Integer peakHeapTop() {
        Integer res = null;
        // 如果堆为空，则返回null
        if (size != 0) {
            // 取出堆顶元素
            res = elems[0];
            // 补上堆顶元素
            elems[0] = elems[size - 1];
            // size 自减
            size--;
            // 重新建立大根堆
            turnMaxHeap();
        }
        return res;
    }
    
    /**
     * 获取节点的左孩子
     *
     * @param index
     * @return
     */
    public Integer getLeftChild(Integer index) {
        if (getLeftChildIndex(index) != null) {
            return elems[getLeftChildIndex(index)];
        } else {
            return null;
        }
    }
    
    /**
     * 获取左孩子索引
     *
     * @param index
     * @return
     */
    public Integer getLeftChildIndex(Integer index) {
        if (index >= 0 && (index + 1) * 2 <= size) {
            return (index + 1) * 2 - 1;
        } else {
            return null;
        }
    }
    
    /**
     * 获取节点的右孩子
     *
     * @param index
     * @return
     */
    public Integer getRightChild(Integer index) {
        if (getRightChildIndex(index) != null) {
            return elems[getRightChildIndex(index)];
        } else {
            return null;
        }
    }
    
    /**
     * 获取右孩子索引
     *
     * @param index
     * @return
     */
    public Integer getRightChildIndex(Integer index) {
        if (index >= 0 && (index + 1) * 2 + 1 <= size) {
            return (index + 1) * 2;
        } else {
            return null;
        }
    }
}
```

## 快速排序
### 算法思想
①将待排序数组的第一个元素作为标准，将比第一个元素小的放到参照元素的左边，将比第一个元素大的放到参照元素的右边。
②放置完成后，把原数组划分为参照元素前后两个子数组
③重复①②过程，直到子数组中只有一个元素时停止排序

### 实现代码
主函数
```java
public static void main(String[] args) {
        int[] res = quickSort(new int[]{6, 9, 7, 2, 0, 9, 6, 5, 3, 1}, 0, 9);
}
```
排序函数
```java
     /**
     * 快速排序
     *
     * @param arr        待排序数组
     * @param startIndex 起始下标
     * @param endIndex   结束下标
     * @return 返回开始结束下标之间的一次快排操作结果
     */
    public static int[] quickSort(int[] arr, int startIndex, int endIndex) {
        // 下标异常返回arr,跳出递归过程
        if (startIndex >= endIndex || startIndex < 0 || endIndex < 0) {
            return arr;
        }
        // 参考值
        int splitNum = arr[startIndex];
        int frontIndex = startIndex;
        int rearIndex = endIndex;
        // 起始下标小于结束下标时进行循环
        boolean lastMoveIsFront = true;
        while (rearIndex > frontIndex) {
            // 从数组尾巴上找到第一个比参考值小的元素
            while (rearIndex > frontIndex && arr[rearIndex] >= splitNum) {
                rearIndex--;
            }
            // 判断循环跳出原因
            if (arr[rearIndex] < splitNum) {
                // 将小数左移
                arr[frontIndex++] = arr[rearIndex];
                // 标记最后一次移动是头指针
                lastMoveIsFront = true;
            }
            // 从数组头部找到一个比参考值大的元素
            while (rearIndex > frontIndex && arr[frontIndex] <= splitNum) {
                frontIndex++;
            }
        }
        // 判断循环跳出原因
        if (arr[frontIndex] > splitNum) {
            // 将大数后移
            arr[rearIndex--] = arr[frontIndex];
            // 标记最后一次移动是尾指针
            lastMoveIsFront = true;
        }
        // 将参考值放入合适的位置 此处犯过错误
        if (lastMoveIsFront) {
            arr[frontIndex--] = splitNum;
        } else {
            arr[frontIndex++] = splitNum;
        }
        // 分治处理当前参考值左右边子数组
        quickSort(arr, startIndex, rearIndex - 1);
        quickSort(arr, rearIndex + 1, endIndex);
        return arr;
    }
```
## 归并排序
### 算法思想
①将待排序数组的以2,4,8,,,2^n的步长划分为若干个子数组
②对这些子数组进行排序，这里选择的是快速排序
### 实现代码
```java
/**
     * 归并排序
     *
     * @param arr 输入数组
     * @return
     */
    public static int[] mergeSort(int[] arr) {
        // 起始步长为1
        int spet = 1;
        while (spet < arr.length) {
            spet *= 2;
            for (int i = 0; i < arr.length; i += spet) {
                int start = i;
                int end = i + spet - 1 < arr.length - 1 ? i + spet - 1 : arr.length - 1;
                quickSort(arr, start, end);
            }
        }
        return arr;
    }

```