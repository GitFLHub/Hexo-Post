---
title: Markdown 制作 Anki 卡片
categories: 资料整理
tags: 
  - Anki
toc: true 
mathjax: true
---

同好会arkDown 编辑器

### 方式一：MarkDown 编辑器
#### 资料准备
这里以Typora为例：
1.打开MarkDown 编辑器
2.设置标题层级
3.四级标题#### 这层标题为面试的具体问题，如“JRE和JDK的区别？”
4.五级标题##### 这层标题为面试问题的具体答案,示例如下：
```
# JAVA工程师面试

## 1.JAVA 

### (1)Java基础

#### JRE和JDK的区别

##### JDK Java Development Kit,Java 开发工具包，提供了开发环境和运行环境

##### JRE Java Runtime Environment Java 运行环境，为Java提供了所需的环境

##### 运行Java程序，JRE即可

##### 编写Java程序，需要安装JDK
```
#### 格式转换
##### 1.转为Anki批量格式CSV
网上有一个大佬做了Markdown转Anki卡片的功能，链接如下
https://hintsnet.com/tools/md2anki/index.html
##### 2.格式调整
由于下载来的文件里面默认HTML标签是< ol >,在文本编辑器中批量替换为< ul >
##### 3.导入Anki

### 方式二：网页数据爬取
#### 网页爬取数据
##### 爬取工具类
```java
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

/**
 * 网页抓取工具类
 */
public class Test1 {
    /**
     * 方法入口
     *
     * @param htmltest 要获取的资源URL
     * @param laber    anki标签
     */
    public static void demo1(String htmltest, String laber) {
        String html = htmltest;
        // HTML文档对象
        Document doc = Jsoup.parse(html);
        Elements rows = doc.select("div[class=interview_detail]").get(0).select("ul").select("li");
        Elements rowTitle = doc.select("div[class=interview_detail]");
        // 生成Anki题目
        Element pFirst = rowTitle.select("p").first();
        // rowTitle.remove(pFirst);

        StringBuffer stringBuffer = new StringBuffer();
        String res = rowTitle.html();
        if (rows.size() == 0) {

        } else {
            // 获取网页结构指定的div[class=interview_wrap] 的代码信息
            String title = doc.select("div[class=interview_wrap]").select("h2").get(0).text();
            // 替换回车
            res = res.replaceAll("(\\r\\n|\\n|\\n\\r)", " ")
                    .replaceAll("\t", "")
                    .replaceAll("class=\"language-java\"", "");
            if (pFirst != null) {
                // 删除空行
                res = res.replaceAll(pFirst.html(), "").replaceAll("<p></p>", "");
            }

            // title 是anki卡片正面
            stringBuffer.append(title).append("\t ");
            // 标签分类
            stringBuffer.append(laber).append("\t ");
            // res 是anki卡片反面
            stringBuffer.append(res);
            System.out.println(stringBuffer.toString());
        }
    }
}
```

##### maven 依赖
```xml
<dependencies>
        <!-- https://mvnrepository.com/artifact/org.jsoup/jsoup -->
        <dependency>
            <groupId>org.jsoup</groupId>
            <artifactId>jsoup</artifactId>
            <version>1.13.1</version>
        </dependency>
    </dependencies>
```

##### 主方法
```java
import java.io.*;
import java.net.URL;
import java.util.stream.Collectors;

public class Script {
    public static void main(String[] args) {

        // 这个文件里面存放了链接信息
        File file = new File("src/main/resources/url.txt");

        try {
            // 读取配置信息
            BufferedReader in = new BufferedReader(new FileReader(file));
            String str;
            String label = "";
            while ((str = in.readLine()) != null) {
                // 获取Anki标签
                if (str.contains("@")) {
                    label = str.substring(1);
                } else {
                    // 链接拼接
                    String urlStr = "https://www.javanav.com/interview/" + str + ".html"; // 网址
                    URL url = new URL(urlStr);
                    String result = new BufferedReader(new InputStreamReader(url.openStream()))
                            .lines().parallel().collect(Collectors.joining(System.lineSeparator()));
                    // 调用爬取入口
                    Test1.demo1(result, label);
                    // 读取太快会被反爬虫
                    Thread.sleep(10 * 3);
                }
            }
        } catch (IOException | InterruptedException e) {
        }
    }
}

```
##### 控制台打印结果（部分）
```
==和equals的区别是什么?	 Java基础	 <ul>   <li>== 是关系运算符，equals() 是方法，结果都返回布尔值</li>   <li>Object 的 == 和 equals() 比较的都是地址，作用相同</li>  </ul>    <p><span style="color:#000000"><strong>== 作用：</strong></span></p>  <ul>   <li>基本类型，比较值是否相等</li>   <li>引用类型，比较内存地址值是否相等</li>   <li>不能比较没有父子关系的两个对象</li>  </ul>    <p><span style="color:#000000"><strong>equals()方法的作用：</strong></span></p>  <ul>   <li>JDK 中的类一般已经重写了 equals()，比较的是内容</li>   <li>自定义类如果没有重写 equals()，将调用父类（默认 Object 类）的 equals() 方法，Object 的 equals() 比较使用了 this == obj</li>   <li>可以按照需求逻辑，重写对象的 equals() 方法（重写 equals方法，一般须重写 hashCode方法）</li>  </ul>  
基本类型和包装类对象使用 == 和 equals进行比较的结果？	 Java基础	 <p><span style="color:#000000"><strong>1、值不同，使用 ＝＝ 和 equals() 比较都返回 false</strong></span></p>  <p>&nbsp;</p>  <p><span style="color:#000000"><strong>2、值相同</strong></span></p>  <p>使用 ＝＝ 比较：</p>  <ul>   <li>基本类型 － 基本类型、基本类型 － 包装对象返回 true</li>   <li>包装对象 － 包装对象，非同一个对象（对象的内存地址不同）返回 false；对象的内存地址相同返回 true，如下值等于 100 的两个 Integer 对象（原因是 JVM 缓存部分基本类型常用的包装类对象，如 Integer -128 ~ 127 是被缓存的）</li>  </ul>  <pre> <code> Integer i1 = 100; &nbsp;Integer i2 = 100; &nbsp;Integer i3 = 200; &nbsp;Integer i4 = 200; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;System.out.println(i1==i2); //打印true &nbsp;System.out.println(i3==i4); //打印false</code></pre>  <p>&nbsp;</p>  <p>使用 equals() 比较</p>  <ul>   <li>包装对象－基本类型返回 true</li>   <li>包装对象－包装对象返回 true</li>  </ul>  <p>&nbsp;</p>  <p><strong><span style="color:#000000">3、不同类型的对象对比，返回 false</span></strong></p>  <p>&nbsp;</p>  <p>JDK1.8，实验代码</p>  <pre> <code >byte b1 = 127; Byte b2 = new Byte("127"); Byte b3 = new Byte("127"); System.out.println("Byte 基本类型和包装对象使用 == 比较 : " + (b1 == b2)); System.out.println("Byte 基本类型和包装对象使用 equals 比较 : " + b2.equals(b1)); System.out.println("Byte 包装对象和包装对象使用 == 比较 : " + (b2 == b3)); System.out.println("Byte 包装对象和包装对象使用 equals 比较 : " + b2.equals(b3)); System.out.println();  short s1 = 12; Short s2 = new Short("12"); Short s3 = new Short("12"); System.out.println("Short 基本类型和包装对象使用 == 比较 : " + (s1 == s2)); System.out.println("Short 基本类型和包装对象使用 equals 比较 : " + s2.equals(s1)); System.out.println("Short 包装对象和包装对象使用 == 比较 : " + (s2 == s3)); System.out.println("Short 包装对象和包装对象使用 equals 比较 : " + s2.equals(s3)); System.out.println();  char c1 = 'A'; Character c2 = new Character('A'); Character c3 = new Character('A'); System.out.println("Character 基本类型和包装对象使用 == 比较 : " + (c1 == c2)); System.out.println("Character 基本类型和包装对象使用 equals 比较 : " + c2.equals(c1)); System.out.println("Character 包装对象和包装对象使用 == 比较 : " + (c2 == c3)); System.out.println("Character 包装对象和包装对象使用 equals 比较 : " + c2.equals(c3)); System.out.println();  int i1 = 10000; Integer i2 = new Integer(10000); Integer i3 = new Integer(10000); System.out.println("Integer 基本类型和包装对象使用 == 比较 : " + (i1 == i2)); System.out.println("Integer 基本类型和包装对象使用 equals 比较 : " + i2.equals(i1)); System.out.println("Integer 包装对象和包装对象使用 == 比较 : " + (i2 == i3)); System.out.println("Integer 包装对象和包装对象使用 equals 比较 : " + i2.equals(i3)); System.out.println();  long l1 = 1000000000000000L; Long l2 = new Long("1000000000000000"); Long l3 = new Long("1000000000000000"); System.out.println("Long 基本类型和包装对象使用 == 比较 : " + (l1 == l2)); System.out.println("Long 基本类型和包装对象使用 equals 比较 : " + l2.equals(l1)); System.out.println("Long 包装对象和包装对象使用 == 比较 : " + (l2 == l3)); System.out.println("Long 包装对象和包装对象使用 equals 比较 : " + l2.equals(l3)); System.out.println();  float f1 = 10000.111F; Float f2 = new Float("10000.111"); Float f3 = new Float("10000.111"); System.out.println("Float 基本类型和包装对象使用 == 比较 : " + (f1 == f2)); System.out.println("Float 基本类型和包装对象使用 equals 比较 : " + f2.equals(f1)); System.out.println("Float 包装对象和包装对象使用 == 比较 : " + (f2 == f3)); System.out.println("Float 包装对象和包装对象使用 equals 比较 : " + f2.equals(f3)); System.out.println();  double d1 = 10000.111; Double d2 = new Double("10000.111"); Double d3 = new Double("10000.111"); System.out.println("Double 基本类型和包装对象使用 == 比较 : " + (d1 == d2)); System.out.println("Double 基本类型和包装对象使用 equals 比较 : " + d2.equals(d1)); System.out.println("Double 包装对象和包装对象使用 == 比较 : " + (d2 == d3)); System.out.println("Double 包装对象和包装对象使用 equals 比较 : " + d2.equals(d3)); System.out.println();  boolean bl1 = true; Boolean bl2 = new Boolean("true"); Boolean bl3 = new Boolean("true"); System.out.println("Boolean 基本类型和包装对象使用 == 比较 : " + (bl1 == bl2)); System.out.println("Boolean 基本类型和包装对象使用 equals 比较 : " + bl2.equals(bl1)); System.out.println("Boolean 包装对象和包装对象使用 == 比较 : " + (bl2 == bl3)); System.out.println("Boolean 包装对象和包装对象使用 equals 比较 : " + bl2.equals(bl3));</code></pre>  <p>&nbsp;<br> 运行结果</p>  <pre> <code>Byte 基本类型和包装对象使用 == 比较 : true Byte 基本类型和包装对象使用 equals 比较 : true Byte 包装对象和包装对象使用 == 比较 : false Byte 包装对象和包装对象使用 equals 比较 : true &nbsp; Short 基本类型和包装对象使用 == 比较 : true Short 基本类型和包装对象使用 equals 比较 : true Short 包装对象和包装对象使用 == 比较 : false Short 包装对象和包装对象使用 equals 比较 : true &nbsp; Character 基本类型和包装对象使用 == 比较 : true Character 基本类型和包装对象使用 equals 比较 : true Character 包装对象和包装对象使用 == 比较 : false Character 包装对象和包装对象使用 equals 比较 : true &nbsp; Integer 基本类型和包装对象使用 == 比较 : true Integer 基本类型和包装对象使用 equals 比较 : true Integer 包装对象和包装对象使用 == 比较 : false Integer 包装对象和包装对象使用 equals 比较 : true &nbsp; Long 基本类型和包装对象使用 == 比较 : true Long 基本类型和包装对象使用 equals 比较 : true Long 包装对象和包装对象使用 == 比较 : false Long 包装对象和包装对象使用 equals 比较 : true &nbsp; Float 基本类型和包装对象使用 == 比较 : true Float 基本类型和包装对象使用 equals 比较 : true Float 包装对象和包装对象使用 == 比较 : false Float 包装对象和包装对象使用 equals 比较 : true &nbsp; Double 基本类型和包装对象使用 == 比较 : true Double 基本类型和包装对象使用 equals 比较 : true Double 包装对象和包装对象使用 == 比较 : false Double 包装对象和包装对象使用 equals 比较 : true &nbsp; Boolean 基本类型和包装对象使用 == 比较 : true Boolean 基本类型和包装对象使用 equals 比较 : true Boolean 包装对象和包装对象使用 == 比较 : false Boolean 包装对象和包装对象使用 equals 比较 : true</code></pre>  <p><br> &nbsp;</p>  <p>ps：可以延伸一个问题，基本类型与包装对象的拆/装箱的过程</p>
什么是装箱？什么是拆箱？装箱和拆箱的执行过程？常见问题？	 Java基础	   <p>装箱：基本类型转变为包装器类型的过程。<br> 拆箱：包装器类型转变为基本类型的过程。</p>  <pre> <code >//JDK1.5之前是不支持自动装箱和自动拆箱的，定义Integer对象，必须 Integer i = new Integer(8); &nbsp; //JDK1.5开始，提供了自动装箱的功能，定义Integer对象可以这样 Integer i = 8; &nbsp; int n = i;//自动拆箱</code></pre>  <p><br> &nbsp;</p>  <p><span style="color:#000000"><strong>2、装箱和拆箱的执行过程？</strong></span></p>  <ul>   <li>装箱是通过调用包装器类的 valueOf 方法实现的</li>   <li>拆箱是通过调用包装器类的 xxxValue 方法实现的，xxx代表对应的基本数据类型。</li>   <li>如int装箱的时候自动调用Integer的valueOf(int)方法；Integer拆箱的时候自动调用Integer的intValue方法。</li>  </ul>  <p>&nbsp;</p>  <p>&nbsp;</p>  <p><span style="color:#000000"><strong>3、常见问题？</strong></span></p>  <ul>   <li>整型的包装类 valueOf 方法返回对象时，在常用的取值范围内，会返回缓存对象。</li>   <li>浮点型的包装类 valueOf 方法返回新的对象。</li>   <li>布尔型的包装类 valueOf 方法 Boolean类的静态常量 TRUE | FALSE。</li>  </ul>  <p>实验代码</p>  <pre> <code>Integer i1 = 100; Integer i2 = 100; Integer i3 = 200; Integer i4 = 200; System.out.println(i1 == i2);//true System.out.println(i3 == i4);//false &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; Double d1 = 100.0; Double d2 = 100.0; Double d3 = 200.0; Double d4 = 200.0; System.out.println(d1 == d2);//false System.out.println(d3 == d4);//false &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; Boolean b1 = false; Boolean b2 = false; Boolean b3 = true; Boolean b4 = true; System.out.println(b1 == b2);//true System.out.println(b3 == b4);//true</code></pre>  <p>&nbsp;</p>  <ul>   <li>包含算术运算会触发自动拆箱。</li>   <li>存在大量自动装箱的过程，如果装箱返回的包装对象不是从缓存中获取，会创建很多新的对象，比较消耗内存。</li>  </ul>  <p>&nbsp; &nbsp; &nbsp; &nbsp;</p>  <pre> <code >Integer s1 = 0; long t1 = System.currentTimeMillis(); for(int i = 0; i &lt;1000 * 10000; i++){ &nbsp;&nbsp; &nbsp;s1 += i; } long t2 = System.currentTimeMillis(); System.out.println("使用Integer，递增相加耗时：" + (t2 - t1));//使用Integer，递增相加耗时：68 &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; int s2 = 0; long t3 = System.currentTimeMillis(); for(int i = 0; i &lt;1000 * 10000; i++){ &nbsp;&nbsp; &nbsp;s2 += i; } long t4 = System.currentTimeMillis(); System.out.println("使用int，递增相加耗时：" + (t4 - t3));//使用int，递增相加耗时：6</code></pre>  <p>&nbsp;</p>  <p>ps：可深入研究一下 javap 命令，看下自动拆箱、装箱后的class文件组成。<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;看一下 JDK 中 Byte、Short、Character、Integer、Long、Boolean、Float、Double的 valueOf 和 xxxValue 方法的源码（xxx代表基本类型如intValue）。</p>  <p>&nbsp;</p>
hashCode()相同，equals()也一定为true吗？	 Java基础	 <p>首先，答案肯定是不一定。同时反过来 equals() 为true，hashCode() 也不一定相同。</p>  <ul>   <li>类的 hashCode() 方法和 equals() 方法都可以重写，返回的值完全在于自己定义。</li>   <li>hashCode() 返回该对象的哈希码值；equals() 返回两个对象是否相等。</li>  </ul>  <p>&nbsp;</p>  <p>关于 hashCode() 和 equals() 是方法是有一些 常规协定：</p>  <p>1、两个对象用 equals() 比较返回true，那么两个对象的hashCode()方法必须返回相同的结果。</p>  <p>2、两个对象用 equals() 比较返回false，不要求hashCode()方法也一定返回不同的值，但是最好返回不同值，以提高哈希表性能。</p>  <p>3、重写 equals() 方法，必须重写 hashCode() 方法，以保证 equals() 方法相等时两个对象 hashcode() 返回相同的值。</p>  <p>&nbsp;</p>  <p>就像打人是你的能力，但打伤了就违法了。重写 equals 和 hashCode 方法返回是否为 true 是你的能力，但你不按照上述协议进行控制，在用到对象 hash 和 equals 逻辑判断相等时会出现意外情况，如 HashMap 的 key 是否相等。</p>  <p>&nbsp;</p>
final在java中的作用	 Java基础	   <ul>   <li>被 final 修饰的类，不能够被继承</li>   <li>被 final 修饰的成员变量必须要初始化，赋初值后不能再重新赋值(可以调用对象方法修改属性值)。对基本类型来说是其值不可变；对引用变量来说其引用不可变，即不能再指向其他的对象</li>   <li>被 final 修饰的方法不能重写</li>  </ul>  <p>&nbsp;</p>
final finally finalize()区别	 Java基础	 <ul>   <li>final 表示最终的、不可改变的。用于修饰类、方法和变量。final 修饰的类不能被继承；final 方法也同样只能使用，不能重写，但能够重载；final 修饰的成员变量必须在声明时给定初值或者在构造方法内设置初始值，只能读取，不可修改；final 修饰的局部变量必须在声明时给定初值；final 修饰的变量是非基本类型，对象的引用地址不能变，但对象的属性值可以改变</li>   <li>finally 异常处理的一部分，它只能用在 try/catch 语句中，表示希望 finally 语句块中的代码最后一定被执行（存在一些情况导致 finally 语句块不会被执行，如 jvm 结束）</li>   <li>finalize() 是在 java.lang.Object 里定义的，Object 的 finalize() 方法什么都不做，对象被回收时 finalize() 方法会被调用。Java 技术允许使用 finalize() 方法在垃圾收集器将对象从内存中清除出去之前做必要清理工作，在垃圾收集器删除对象之前被调用的。一般情况下，此方法由JVM调用。特殊情况下，可重写 finalize() 方法，当对象被回收的时候释放一些资源，须调用 super.finalize() 。</li>  </ul>  
finally语句块一定执行吗？	 Java基础	   <ul>   <li>直接返回未执行到 try-finally 语句块</li>   <li>抛出异常未执行到 try-finally 语句块</li>   <li>系统退出未执行到 finally 语句块</li>  </ul>  <p>等...</p>  <p>代码如下</p>  <pre> <code >public static String test() {     String str = null;     int i = 0;     if (i == 0) {         return str;//直接返回未执行到finally语句块     }     try {         System.out.println("try...");         return str;     } finally {         System.out.println("finally...");     } }   public static String test2() {     String str = null;     int i = 0;     i = i / 0;//抛出异常未执行到finally语句块     try {         System.out.println("try...");         return str;     } finally {         System.out.println("finally...");     } }   public static String test3() {     String str = null;     try {         System.out.println("try...");         System.exit(0);//系统退出未执行到finally语句块         return str;     } finally {         System.out.println("finally...");     } }</code></pre>  <p>&nbsp;</p>
final与static的区别	 Java基础	   <ul>   <li>都可以修饰类、方法、成员变量。</li>   <li>都不能用于修饰构造方法。</li>   <li>static 可以修饰类的代码块，final 不可以。</li>   <li>static 不可以修饰方法内的局部变量，final 可以。</li>  </ul>    <p><strong><span style="color:#000000">static：</span></strong></p>  <ul>   <li>static 修饰表示静态或全局，被修饰的属性和方法属于类，可以用类名.静态属性 / 方法名 访问</li>   <li>static 修饰的代码块表示静态代码块，当 Java 虚拟机（JVM）加载类时，就会执行该代码块,只会被执行一次</li>   <li>static 修饰的属性，也就是类变量，是在类加载时被创建并进行初始化，只会被创建一次</li>   <li>static 修饰的变量可以重新赋值</li>   <li>static 方法中不能用 this 和 super 关键字</li>   <li>static 方法必须被实现，而不能是抽象的abstract</li>   <li>static 方法不能被重写</li>  </ul>    <p><strong><span style="color:#000000">final：</span></strong></p>  <ul>   <li>final 修饰表示常量、一旦创建不可改变</li>   <li>final 标记的成员变量必须在声明的同时赋值，或在该类的构造方法中赋值，不可以重新赋值</li>   <li>final 方法不能被子类重写</li>   <li>final 类不能被继承，没有子类，final 类中的方法默认是 final 的</li>  </ul>    <p>final 和 static 修饰成员变量加载过程例子</p>  <pre> <code >import java.util.Random;   public class TestStaticFinal {   public static void main(String[] args) { StaticFinal sf1 = new StaticFinal(); StaticFinal sf2 = new StaticFinal();  System.out.println(sf1.fValue == sf2.fValue);//打印false System.out.println(sf1.sValue == sf2.sValue);//打印true } }   class StaticFinal {  final int fValue = new Random().nextInt(); static int sValue = new Random().nextInt();  }</code></pre>  
```