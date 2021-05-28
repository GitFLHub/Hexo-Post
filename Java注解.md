---
title: Java注解
categories: Java
tags: 
  - Java 注解
toc: true 

---

之前一直以为注释=注解，em.....
Java5之后可以在源代码中嵌入一些补充信息，这种补充信息称为注解。例如在方法覆盖中使用@Override，注解，注解都是用@符号开头的。
有的注解可以在运行时读写字节码文件信息

## 1.基本注解

无论哪一种注解，本质上都是一种数据类型，是一种接口类型。到Java8为止，Java提供了11种内置注解。其中有5种是基本注解，他们来自于java.lang包；
有六种是元注解（meta annotation），他们来自于java.lang.annotation包，自定义注解会用到元注解。
基本注解类型包括@Override,@Deprecated,@SuppressWarnings,@SafeVarargs,@FunctionalInterface。下面逐一介绍

### 1.1 @Override:

@Override只能用于方法，子类覆盖父类方法（或者实现接口方法）时可以@Override注解。编译器会检查被@Override的方法，确保该父类中存在的方法，否则会有编译错误。

### 1.2 @Deprecated

@Deprecated用来指示API已经过时了。@Deprecated可以用来注释类，接口，成员方法和变量。调用@Deprecated方法的代码会出现删除线

### 1.3@SuppressWarnnings

@SuppressWarnnings注释用来抑制编译器警告，如果确认程序中的警告没有问题，可以不用理会。若是不想看到相关警告，可以使用@SuppressWarnning方法来消除警告。

### 1.4@SafeVarargs

@SafeVarargs可以抑制将非范型变量值赋值给范型变量值

### 1.5@FunctionalInterface

@FunctionalInterface用于接口注释

## 2.元注解

元注解包括@Documented，@Tagget，@Retention，@Inherited，@Repeatable，@Native。元注解是为其他注解进行说明的注释。
当自定义一个新的注解类型时，其中可以使用元注解。

### 1.@Documented

如果在一个自定义注解中引用@Documented注解，那么该注解可以修饰代码元素(类、接口、成员变量和成员方法)，javadoc等工具可以提取这些元素

### 2.@Target

@Target注解用来指定一个新注解的适用目标。@Target注解中有一个成员（value）用来设置目标，value是java.lang.annotation.ElementType枚举类型的数组，ElementType描述Java程序元素类型，他有10个枚举常量。
枚举常量	说明
ANNOTATION_TYPE	其他注释类型声明
CONSTRUCTOR	构造方法声明
FIELD	成员变量或常量声明
LOCAL_VARIABLE	局部变量声明
METHOD	方法声明
PACKAGE	包声明
PARAMETER	参数声明
TYPE	类、接口声明
TYPE_PARAMETER	用于泛型中类型参数的声明
TYPE_USE	用于任何类型的声明，Java8推出

### 3,@Retention

@Rentention注释用来指定一个新注解的有效范围，@Retention注解一个成员（value）用来设置保留策略，value是java.lang.annotation.RetentionPolicy枚举类型，RetentionPolicy描述注释保留类型策略，他有三个枚举常量
枚举常量	说明
SOURCE	只适用于Java源代码文件中，此范围最小
CLASS	编译器把注释信息记录在字节码文件中，此范围居中
RUNTIME	编译器把注释信息记录在字节码文件中，并在运行时可以读取这些信息，此范围最大

### 4.@Inherited

@Inherited注释用来指定一个新注解可以被继承。假定一个类A被该注释修饰，那么这个A类的子类会继承该新注解

### 5.@Repeatable

@Repeatable注解允许在相同的程序元素中重复注解。可重复的注解必须使用@Repeatable进行注解。

### 6.@Native

@Native 注释一个成员变量，指示这个变量可以被本地代码引用。常常被代码生成工具使用

## 3.自定义注解

### 1.声明注解

声明自定义注解可以使用@Interface关键字实现，最简单的形式的注释实例代码如下：
//Marker.java文件
package.com.a51work6;
public @Interface Marker{}
一个源文件中可以声明多个注解，但是只有一个是公有访问权限的，源文件命名与公有访问权限的注解名一致。
Marker注解中不包含任何成员，这种注解称为标记注解，基本注解中的@Override就属于标记注解。根据需要，注解中可以包含一些成员，实例代码
//Marker.java文件
package.com.a51work6;  //单值注解
@Interface MyAnnotation{
    String value();
} 
代码中声明MyAnnotation注解，他有一个成员value，注意value后面有对小括号。value前面的是数据类型。成员也可以有访问权限修饰符，但是只能是公有权限和默认权限。
注释中的成员也可以有默认值，示例代码如下：
//Marker.java文件
package.com.a51work6; 
//单值注解
@Interface MyAnnotation1{
    String value() default "注解信息";
    int count() default 0;   
}

### 2.案例：使用元注解

前面啰嗦了一大堆，直接写个例子吧，不然要睡着了。
例子：
import javax.xml.bind.Element;
import java.lang.annotation.*;
//指定MyAnnotation注解信息可以被javadoc工具读取
@Documented
//指定注解用于修饰类和接口等类型
@Target({ ElementType.TYPE })
//指定注释信息可以在运行时被读取
@Retention( RetentionPolicy.RUNTIME )
public @interface MyAnnotation {
    //注解的成员
    String description();
}
还是不知道这个用来干嘛。再来一个例子试试
//MemberAnnotation.java
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Documented
@Retention(RetentionPolicy.RUNTIME)
//指定MemberAnnotation注解用于修饰类中的成员
@Target({ ElementType.FIELD, ElementType.METHOD })
public @interface MemberAnnotation {
    //type类型是Class<T>，默认值是void.class
    //<?>表示不限定类型，用？作为占位符
    Class<?> type() default void.class;
    //description类型是String，没有默认值
    String description();
}
import javax.xml.bind.Element;
import java.lang.annotation.*;
//指定MyAnnotation注解信息可以被javadoc工具读取
@Documented
//指定注解用于修饰类和接口等类型
@Target({ ElementType.TYPE})
//指定注释信息可以在运行时被读取
@Retention( RetentionPolicy.RUNTIME )
public @interface MyAnnotation {
    //注解的成员
    String description();
}
@MyAnnotation(description = "这是一个测试类")
public class Person {
    //修饰成员变量
    @MemberAnnotation(type = String.class, description = "名字")
    private String name;

    @MemberAnnotation(type = int.class, description = "年龄")
    private int age;
    
    @MemberAnnotation(type = String.class, description = "获得名字")
    public String getName() {
        return name;
    }
    //修饰成员方法
    @MemberAnnotation(type = int.class, description = "获得年龄")
    public int getAge() {
        return age;
    }
    
    @MemberAnnotation(description = "设置姓名和年龄")
    public void setNameAndAge(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    @Override
    public String toString() {
        return "Person [name=" + name + ", age=" + age + "]";
    }

}
还是不知道要干嘛。。。。

### 3.案例读取运行时注解信息

注解是为工具读取信息而准备的。有些工具可以读取源代码文件中的注解信息；有的可以读取字节码文件中的注解信息；有的可以在运行时读取注解信息。但是读取这些注解信息都是一样的，区别只在于自定义注解中@Retention的保留策略不同。
读取注解信息要反射相关API，Class类有如下方法。
<A extends Annotation>A getAnnotation(Class<A> annotation Class):如果此元素存在annotationClass类型的注解，则返回注解，否则返回null。
Annotation[] getAnnotations():返回此元素上存在的所有注解。
Annotation[] getDeclaredAnnotations():返回直接存在于此元素上的所有注解。与getAnnotations()区别在于，该方法将不返回继承的注释。
boolbean isAnnotationPresent(Class<? extends Annotation> annotationClass):如果此元素存在annotationClass的注解，则返回true，否则返回false。
boolbean isAnnotation():如果此Class对象表示一个注解类型，则返回true。
运行时Person类中注解信息代码如下：

```java
import java.lang.reflect.Field;
import java.lang.reflect.Method;
public class mainFun {
    public static void main(String[] args) {
        try {
            //创建Person类对应的对象
            Class<?> clz = Class.forName("Person");
            //读取类注解
            //判断Person类是否存在MyAnnotation注解
            if (clz.isAnnotationPresent(MyAnnotation.class)) {
                //返回注解实例
                MyAnnotation myAnnotation = (MyAnnotation) clz.getAnnotation(MyAnnotation.class);
                //读取注解中的表达式
                System.out.printf("类%s,读取注释描述：%s\n", clz.getName(), myAnnotation.description());
            }
            //读取成员方法的注解详情
            Method[] methods = clz.getDeclaredMethods();
            for (Method method : methods) {
                //判断方法是否存在MemberAnnotation注解
                if (method.isAnnotationPresent(MemberAnnotation.class)) {
                    //返回MemberAnnotation注解实例
                    MemberAnnotation memberAnnotation = method.getAnnotation(MemberAnnotation.class);
                    //读取MemberAnnotation实例的注解表达式
                    System.out.printf("方法%s，读取注解描述： %s\n", method.getName(), memberAnnotation.description());
                }
            }
    
            //读取成员变量的注解信息
            Field[] fields = clz.getDeclaredFields();
            for (Field field : fields) {
                //判断变量是否存在MemberAnnotation注解
                if (field.isAnnotationPresent(MemberAnnotation.class)) {
                    //返回MemberAnnotation注解实例
                    MemberAnnotation memberAnnotation = field.getAnnotation(MemberAnnotation.class);
                    //读取MemberAnnotation实例的注解表达式
                    System.out.printf("成员变量%s,读取注解描述:%s\n", field.getName(), memberAnnotation.description());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

执行结果：

```shell
"C:\Program Files\Java\jdk1.8.0_181\bin\java.exe" "-javaagent:C:\Program Files\JetBrains\IntelliJ IDEA 2019.1.3\lib\idea_rt.jar=55483:C:\Program Files\JetBrains\IntelliJ IDEA 2019.1.3\bin" -Dfile.encoding=UTF-8 -classpath "C:\Program Files\Java\jdk1.8.0_181\jre\lib\charsets.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\deploy.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\access-bridge-64.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\cldrdata.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\dnsns.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\jaccess.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\jfxrt.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\localedata.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\nashorn.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\sunec.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\sunjce_provider.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\sunmscapi.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\sunpkcs11.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\ext\zipfs.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\javaws.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\jce.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\jfr.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\jfxswt.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\jsse.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\management-agent.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\plugin.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\resources.jar;C:\Program Files\Java\jdk1.8.0_181\jre\lib\rt.jar;E:\编程\eclipseJavaCode\IXml\out\production\IXml;E:\编程\eclipseJavaCode\IXml\lib\jaxws-api.jar;E:\编程\eclipseJavaCode\IXml\lib\jaxws-rt.jar;E:\编程\eclipseJavaCode\IXml\lib\jaxws-tools.jar;E:\编程\eclipseJavaCode\IXml\lib\activation.jar;E:\编程\eclipseJavaCode\IXml\lib\FastInfoset.jar;E:\编程\eclipseJavaCode\IXml\lib\gmbal-api-only.jar;E:\编程\eclipseJavaCode\IXml\lib\http.jar;E:\编程\eclipseJavaCode\IXml\lib\jaxb-api.jar;E:\编程\eclipseJavaCode\IXml\lib\jaxb-impl.jar;E:\编程\eclipseJavaCode\IXml\lib\jsr173_api.jar;E:\编程\eclipseJavaCode\IXml\lib\jsr181-api.jar;E:\编程\eclipseJavaCode\IXml\lib\jsr250-api.jar;E:\编程\eclipseJavaCode\IXml\lib\management-api.jar;E:\编程\eclipseJavaCode\IXml\lib\mimepull.jar;E:\编程\eclipseJavaCode\IXml\lib\policy.jar;E:\编程\eclipseJavaCode\IXml\lib\resolver.jar;E:\编程\eclipseJavaCode\IXml\lib\saaj-api.jar;E:\编程\eclipseJavaCode\IXml\lib\saaj-impl.jar;E:\编程\eclipseJavaCode\IXml\lib\stax-ex.jar;E:\编程\eclipseJavaCode\IXml\lib\streambuffer.jar;E:\编程\eclipseJavaCode\IXml\lib\woodstox.jar;E:\编程\eclipseJavaCode\IXml\lib\jaxb-xjc.jar" mainFun
类Person,读取注释描述：这是一个测试类
方法getName，读取注解描述： 获得名字
方法getAge，读取注解描述： 获得年龄
方法setNameAndAge，读取注解描述： 设置姓名和年龄
成员变量name,读取注解描述:名字
成员变量age,读取注解描述:年龄

Process finished with exit code 0
```

终于知道要干嘛了。。。