---
title: JVM 虚拟机基础
categories: Java
tags: 
  - 虚拟机
toc: true 
---

![file](http://img.ron.zone/oneblog/article/20210323010135389.png)
JVM中的堆一般分为三部分，新生代、老年代和永久代。

### 新生代

主要是用来存放新生的对象。一般占据堆空间的1/3，由于频繁创建对象，所以新生代会频繁触发MinorGC进行垃圾回收。
新生代分为Eden区、ServivorFrom、ServivorTo三个区。

#### Eden区：

Java新对象的出生地(如果新创建的对象占用内存很大则直接分配给老年代)。当Eden区内存不够的时候就会触发一次MinorGc，对新生代区进行一次垃圾回收。

#### ServivorTo：

保留了一次MinorGc过程中的幸存者。

#### ServivorFrom: 

上一次GC的幸存者，作为这一次GC的被扫描者。
当JVM无法为新建对象分配内存空间的时候(Eden区满的时候)，JVM触发MinorGc。**因此新生代空间占用越低，MinorGc越频繁。MinorGC采用复制算法。**

### 老年代

老年代的对象比较稳定，所以MajorGC不会频繁执行。

#### 触发MinorGC的条件：

1 在进行MajorGC之前，一般都先进行了一次MinorGC，使得有新生代的对象进入老年代，**当老年代空间不足时就会触发MajorGC。**
2 当**无法找到足够大的连续空间**分配给新创建的较大对象时，也会触发MajorGC进行垃圾回收腾出空间。

MajorGC采用**标记—清除**算法(或者标记—整理算法)
MajorGC的耗时比较长，因为**要先整体扫描再回收**，**MajorGC会产生内存碎片**。为了减少内存损耗，一般需要**合并或者标记出来方便下次直接分配**。

当**老年代也满了装不下**的时候，就会抛出**OOM**。

### 永久代(元数据区)

指内存的永久保存区域，主要存放Class和Meta（元数据）的信息。
**Class在被加载的时候元数据信息会放入永久区域**，但是GC不会在主程序运行的时候清除永久代的信息。所以这也导致永久代的信息会随着类加载的增多而膨胀，**最终导致OOM**。
注意: 在Java8中，永久代已经被移除，被一个称为“元数据区”（元空间）的区域所取代。

元空间的本质和永久代类似，都是对JVM规范中方法区的实现。不过元空间与永久代之间最大的区别在于：
1.元空间并**不在虚拟机中**，而是使用**本地内存**。因此默认情况下元空间的大小仅仅受**本地内存的大小限制**。类的元数据放入 native memory, 字符串池和类的静态变量放入java堆中。 这样可以加载多少类的元数据就**不再由MaxPermSize**控制, 而由系统的**实际可用空间**来控制。

### MajorGC和FullGC的区别

(这里参考1建议不要纠结这两个概念的区别，而是应该专注于解决问题)

#### Full GC 

是清理整个堆空间—包括年轻代和老年代。

#### Major GC 

是清理老年代。

#### MinorGC 触发机制

1 Eden区满的时候，JVM会触发MinorGC。

#### MajorGC 触发机制

1 在进行MajorGC之前，一般都先进行了一次MinorGC，使得有新生代的对象进入老年代，当老年代空间不足时就会触发MajorGC。
2 当无法找到足够大的连续空间分配给新创建的**较大对象时**(如大数组)，也会触发MajorGC进行垃圾回收腾出空间。

#### Full GC触发机制：

1 调用System.gc时，系统建议执行Full GC，但是不必然执行
2 **老年代空间**不足
3 **方法区空间**不足
4 通过**Minor GC**后进入老年代的**平均大小大**于老年代的可用内存
5 由Eden区、survivor space1（From Space）区向survivor space2（To Space）区复制时，
4 当**永久代满时也会引发Full GC**，会导致**Class、Method元信息的卸载**。

虚拟机给每个对象定义了一个对象年龄（Age）计数器。如果对象在 Eden 出生并经过第一次 Minor GC 后仍然存活，并且能被 Survivor 容纳的话，将被移动到 Survivor 空间中，并将对象年龄设为 1。对象在 Survivor 区中每熬过一次 Minor GC，年龄就增加 1 岁，　　当它的年龄增加到一定程度（默认为 15 岁）时，就会被晋升到老年代中。对象晋升老年代的年龄阈值，可以通过参数 -XX:MaxTenuringThreshold (阈值)来设置。

参考：
1 原文: Minor GC vs Major GC vs Full GC
2 Java中的新生代、老年代、永久代和各种GC

作者：Aaron_Swartz
链接：https://www.jianshu.com/p/d3a0b4e36c28
来源：简书


# 