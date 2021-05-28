---
title: Octave 绘制图像
categories: AI
tags: 
  - Octave
  - 工具
toc: true
---
## Octace 绘制图像
### 二维图像

#### 三角函数

```matlab
# 生成从0 到 0.98 的数组，步长为0.01
t = [0:0.01:0.98]; 
# 构造y1 和 t的关系式
y1 = sin(2*pi*4*t); 
# 生成二维图像
plot(t,y1); 
```

![image-20210527181550349](http://img.ron.zone/20210527232137.png)

```matlab
# 构造y21 和 t的关系式
y2 = cos(2*pi*4*t); 
# 生成二维图像
plot(t,y2); 
```
![image-20210527182145214](http://img.ron.zone/20210527232146.png)

在原有基础上添加第一个图像

```matlab
# 保留绘制的第一个图
hold on
# 继续绘制第二个图
plot(t,y1,'r')
```
![image-20210527234250205](http://img.ron.zone/20210527234311.png)

```matlab
# x轴标签
xlabel('time') 
# y轴标签
ylabel('value') 
# 线型标注
legend('sin','cos') 
# 图表名称
title('my plot') 
# 输出图片
print -dpng 'myplot.png' 
```

![image-20210527235201685](http://img.ron.zone/20210527235221.png)

#### 显示多个图像

```matlab
# 分割出第一个子图 1 * 2 两个子图
subplot(1,2,1); 
# 填充第一个子图
plot(t,y1); 
# 分割出第二个子图
subplot(1,2,2);
# 填充第二个子图
plot(t,y2);
# 设置第二个子图的坐标轴范围
axis([0.5 1 -1 1]) 
```



![image-20210528000514488](http://img.ron.zone/20210528000519.png)

#### 矩阵图示

```matlab
# 随机生成5*5矩阵
A = magic(5)
# 图示矩阵
imagesc(A)
A =
   17   24    1    8   15
   23    5    7   14   16
    4    6   13   20   22
   10   12   19   21    3
   11   18   25    2    9
```



![image-20210528001441719](http://img.ron.zone/image-20210528001441719.png)

```matlab
A =
   17   24    1    8   15
   23    5    7   14   16
    4    6   13   20   22
   10   12   19   21    3
   11   18   25    2    9
# 组合命令 colorbar 生成条状尺度图 gray 灰度图
imagesc(A), colorbar, colormap gray;
```



![image-20210528002043991](http://img.ron.zone/image-20210528002043991.png)

```matlab
# 更大的尺度图
imagesc(magic(25)), colorbar, colormap gray;
```



![image-20210528002258670](http://img.ron.zone/image-20210528002258670.png)