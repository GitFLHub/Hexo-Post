---
title: JAVA虚拟机基础概念
categories: Java
tags:
  - JVM
toc: true
---

![file](http://img.ron.zone/oneblog/article/20210319023906389.png)
### 类装载子系统
将编译好的.class文件装载到运行时数据区
### 运行时数据区
#### 堆
new 出来的对象放在内存堆
首先是新生代的伊甸园区，然后minor gc 定期检查该（伊甸园区和survivor区）对象，检查后将有用对象将对象放入另一个 survivor 区域
伊甸园：Survivor ：Survivor = 8 : 1: 1
当Survivor 区中的年代数达到15， 则会被移入老年代，新生代放中Survivor 对象大小超过Survivor大小的50%，也会直接被放入老年代
![file](http://img.ron.zone/oneblog/article/20210319025844233.png)
#### 栈
栈帧：
调用一个方法，生成自己专属的内存空间（栈帧），符合FILO，
存放局部变量、操作数、动态链接、方法出口

例如java源代码：
```java
package com.tuling.redission;

public class Math {
    public static final int intData = 666;
    public static User user = new User();
    public int compute() {
        int a = 1;
        int b = 2;
        int c =(a + b) * 10;
        return c;
    }

    public static void main(String[] args) {
        Math math = new Math();
        System.out.println(math.compute());
    }
}

```
可使用cmd命令来反汇编class文件
```shell
javap -c xxx.class > xxx.txt
```
得到该目录下的反汇编指令文件
```java
Compiled from "Math.java"
public class com.tuling.redission.Math {
  public static final int intData;

  public static com.tuling.redission.HelloWorld helloWorld;

  public com.tuling.redission.Math();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public int compute();
    Code:
	   0: iconst_1 
       1: istore_1
       2: iconst_2
       3: istore_2
       4: iload_1
       5: iload_2
       6: iadd
       7: bipush        10
       9: imul
      10: istore_3
      11: iload_3
      12: ireturn

  public static void main(java.lang.String[]);
    Code:
       0: new           #2                  // class com/tuling/redission/Math
       3: dup
       4: invokespecial #3                  // Method "<init>":()V
       7: astore_1
       8: getstatic     #4                  // Field java/lang/System.out:Ljava/io/PrintStream;
      11: aload_1
      12: invokevirtual #5                  // Method compute:()I
      15: invokevirtual #6                  // Method java/io/PrintStream.println:(I)V
      18: return

  static {};
    Code:
       0: new           #7                  // class com/tuling/redission/HelloWorld
       3: dup
       4: invokespecial #8                  // Method com/tuling/redission/HelloWorld."<init>":()V
       7: putstatic     #9                  // Field helloWorld:Lcom/tuling/redission/HelloWorld;
      10: return
}

```
指令解释链接：http://www.ronblog.cn//article/6

##### 局部变量 和 操作数
![file](http://img.ron.zone/oneblog/article/20210319020336510.png)
如对指令进行分析

```java
    int a = 1;
```

就是给变量a 分配 局部变量栈空间，再将1复制到操作数栈。然后操作数1出栈，写入a的局部变量空间。
**局部变量 0 ** 调用当前方法的this指针
**局部变量math**
![file](http://img.ron.zone/oneblog/article/20210319022656643.png)
*栈和堆的关系也可以理解为：*
栈 中有很多指向 堆的指针

##### 动态链接：
把符号引用换成直接引用。实现函数的调用，找到函数名称对应的方法内存入口
##### 程序计数器
存放下一条指令的行号（其实是方法区的指令内存空间地址）。目的是为了进行线程切换。
其值由字节码执行引擎进行修改。
##### 方法出口
指向调用函数 如main（）方法
#### 方法区
又叫元空间，存放常量、静态变量、类信息、函数方法
例如静态变量user
```java
    public static User user = new User();
```
静态变量user存放在方法区中，但还是一个指针，指向了堆
![file](http:///oneblog/article/20210319023122673.png)

####  本地方法栈
一些JAVA的底层C++ 的具体实现：
例如：
```java
     new Thread().start();
```
查看源码能看见底层
```java
    private native void start();
```
### 字节码执行引擎
1.执行内存里的代码
2.开启垃圾收集线程，收集的垃圾对象

#### 垃圾回收
##### 算法：可达性分析（类比数据结构）
将GC root 对象作为起点，线程的本地变量、静态变量、本地方法栈等等
从这些起点开始向下搜索文件。从直接引用找到间接引用，这些对象都是非垃圾对象
![file](http://img.ron.zone/oneblog/article/20210319024402200.png)
 minor gc 会回收整个年轻代的内存空间