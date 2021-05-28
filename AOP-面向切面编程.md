---
title: AOP 面向切面编程
categories: Java
tags: 
  - AOP
toc: true 

---

### 4.1 面向切面编程的介绍

横切关注点可以被描述为影响应用多处的功能。例如，安全就是一个横切关注点，应用中的许多方法都会涉及安全规则。图4.1直观呈现了横切关注点的概念。
 ![图片说明](https://uploadfiles.nowcoder.com/images/20190824/802092387_1566608872495_E766F569F1A3A6E089CAE2976F7E7FD0 "图片标题") 
切面提供了取代继承和委托的另一种选择，而且在很多场景下更清晰简洁。在使用面向切面编程时，我们仍然在一个地方定义通用功能，可以通过声明的方式定义这个功能以何种方式在何处应用，而无需修改受影响的类。横切关注点可以被模块化为特殊的类，这些类被称为切面。
好处：
每个关注点现在都只集中于一处，而不是分散到多处代码中；
其次，服务模块更简洁，因为它们只包含主要关注点（或核心功能）的代码，而次要关注点的代码被转移到切面中了。

#### 4.1.1 定义AOP术语

AOP的术语：
通知（advice）、切点（pointcut）和连接点（joinpoint）。
他们之间的联系
 ![图片说明](https://uploadfiles.nowcoder.com/images/20190824/802092387_1566608898589_FB8366D59260D0AF5790285AFF941560 "图片标题") 
通知（advice）：
切面的工作内容被称为通知。
通知定义了切面是什么以及何时使用。除了描述切面要完成的工作，通知还解决了何时执行这个工作的问题。它应该应用于某个方法被调用之前？之后？之前和之后？还是只在方法抛出异常时？Spring切面可以应用5种类型的通知。
■Before——在方法被调用之前调用通知。
■After——在方法完成之后调用通知，无论方法执行是否成功。
■After-returning——在方法成功执行之后调用通知。
■After-throwing——在方法抛出异常后调用通知。
■Around——通知包裹了被通知的方法，在被通知的方法调用之前和调用之后执行自定义的行为。
**连接点（Joinpoint）**
连接点是在应用执行过程中能够插入切面的一个点。这个点可以是调用方法时、抛出异常时、甚至修改一个字段时。切面代码可以利用这些点插入到应用的正常流程之中，并添加新的行为。
**切点（Poincut）**
切点的定义会匹配通知所要织入的一个或多个连接点。我们通常使用明确的类和方法名称来指定这些切点，或是利用正则表达式定义匹配的类和方法名称模式来指定这些切点。有些AOP框架允许我们创建动态的切点，可以根据运行时的决策（比如方法的参数值）来决定是否应用通知。
**切面（Aspect）**
切面是通知和切点的结合。通知和切点共同定义了关于切面的全部内容——它是什么，在何时和何处完成其功能。
**引入（Introduction）**
引入允许我们向现有的类添加新方法或属性。例如，我们可以创建一个Auditable通知类，该类记录了对象最后一次修改时的状态。这很简单，只需一种方法，setLastModified(Date)，和一个实例变量来保存这个状态。然后，这个新方法和实例变量就可以被引入到现有的类中。从而可以在无需修改这些现有的类的情况下，让它们具有新的行为和状态。
**织入（Weaving）**
织入是将切面应用到目标对象来创建新的代理对象的过程。切面在指定的连接点被织入到目标对象中。在目标对象的生命周期里有多个点可以进行织入。
■编译期——切面在目标类编译时被织入。这种方式需要特殊的编译器。AspectJ的织入编译器就是以这种方式织入切面的。
■类加载期——切面在目标类加载到JVM时被织入。这种方式需要特殊的类加载器（ClassLoader），它可以在目标类被引入应用之前增强该目标类的字节码。AspectJ5的LTW（load-timeweaving）就支持以这种方式织入切面。
■运行期——切面在应用运行的某个时刻被织入。一般情况下，在织入切面时，AOP容器会为目标对象动态地创建一个代理对象。SpringAOP就是以这种方式织入切面的。

#### 4.1.2 Spring对AOP的支持

Spring 提供 了 4 种 各具特色 的 AOP 支持： 
■ 基于 代理 的 经典 AOP；
■@ AspectJ 注解 驱动 的 切面； 
■ 纯 POJO 切面； 
■ 注入 式 AspectJ 切面（ 适合 Spring 各 版本）。
**Spring通知是Java编写的**
Spring所创建的通知都是用标准的Java类编写的。这样的话，我们就可以使用与普通Java开发一样的集成开发环境（IDE）来开发切面。而且，定义通知所应用的切点通常在Spring配置文件里采用XML来编写的。这意味着切面的代码和配置语法对于Java开发人员来说是相当熟悉的。
AspectJ与之相反。虽然AspectJ现在支持基于注解的切面，但是AspectJ最初是以Java语言扩展的方式实现的。这种方式既有优点也有缺点。通过特有的AOP语言，我们可以获得更强大和细粒度的控制，以及更丰富的AOP工具集，但是我们需要额外学习新的工具和语法。
**Spring在运行期通知对象**
通过在代理类中包裹切面，Spring在运行期将切面织入到Spring管理的Bean中。代理类封装了目标类，并拦截被通知的方法的调用，再将调用转发给真正的目标Bean。
当拦截到方法调用时，在调用目标Bean方法之前，代理会执行切面逻辑。直到应用需要被代理的Bean时，Spring才创建代理对象。如果使用的是ApplicationContext，在ApplicationContext从BeanFactory中加载所有Bean时，Spring创建被代理的对象。因为Spring运行时才创建代理对象，所以我们不需要特殊的编译器来织入SpringAOP的切面。
Spring只支持方法连接点正如前面所探讨过的，通过各种AOP实现可以支持多种连接点模型。因为Spring基于动态代理，所以Spring只支持方法连接点。这与其他一些AOP框架是不同的，例如AspectJ和Jboss，除了方法切点，它们还提供了字段和构造器接入点。Spring缺少对字段连接点的支持，无法让我们创建细粒度的通知，例如拦截对象字段的修改。而且Spring也不支持构造器连接点，我们也无法在Bean创建时应用通知。但是方法拦截可以满足绝大部分的需求。如果需要方法拦截之外的连接点拦截，我们可以利用Aspect来协助SpringAOP。

### 4.2 使用切点选择连接点

在SpringAOP中，需要使用AspectJ的切点表达式语言来定义切点。Spring仅支持AspectJ切点指示器（pointcutdesignator）的一个子集。Spring是基于代理的，而某些切点表达式是与基于代理的AOP无关的。
 ![图片说明](https://uploadfiles.nowcoder.com/images/20190824/802092387_1566608972613_3A0E6EE02FAD7B1848A6B22C6A624FDC "图片标题") 
在Spring中尝试使用AspectJ其他指示器时，将会抛出IllegalArgumentException异常。只有execution指示器是唯一的执行匹配，而其他的指示器都是用于限制匹配的。

#### 4.2.1 编写切点

例如，如图4.4所示的切点表达式表示当Instrument的play()方法执行时会触发通知。我们使用execution()指示器选择Instrument的play()方法。方法表达式以*号开始，标识了我们不关心方法返回值的类型。然后，我们指定了全限定类名和方法名。对于方法参数列表，我们使用（..）标识切点选择任意的play()方法，无论该方法的入参是什么。
 ![图片说明](https://uploadfiles.nowcoder.com/images/20190824/802092387_1566608994487_E1878029C2E9DA654BAFC131C8E6CDC9 "图片标题") 
现在 假设 我们 需要 配置 切点 仅 匹配 com. springinaction. springidol 包。 在此 场景 下， 可以 使用 within() 指示器 来 限制 匹配， 如图 4. 5 所示。
 ![图片说明](https://uploadfiles.nowcoder.com/images/20190824/802092387_1566609010087_1BF8C8A5BE45566350FFE74F647784F3 "图片标题") 
&&操作符把execution()和within()指示器连接在一起形成and关系（切点必须匹配所有的指示器）。
因为&在XML中有特殊含义，所以在使用Spring的基于XML配置来描述切点时，我们可以使用and来代替&&。同样，or和not可以使用||和!来分别代替。

#### 4.2.2 使用Spring的bean()指示器

Spring2.5还引入了一个新的bean()指示器，该指示器允许我们在切点表达式中使用Bean的ID来标识Bean。bean()使用BeanID或Bean名称作为参数来限制切点只匹配特定的Bean。
例如：

```java
execution(* com. springinaction. springidol. Instrument. play()) and bean(eddie)。
```

希望在执行Instrument的play()方法时应用通知，但限定Bean的ID为eddie。

```java
execution(* com. springinaction. springidol. Instrument. play()) and !bean(eddie) 
```

在此场景下，切面的通知会被编织到所有的ID不为eddie的Bean中。

### 4.3在XML中声明切面

Spring的AOP配置元素简化了基于POJO切面的声明
 ![图片说明](https://uploadfiles.nowcoder.com/images/20190824/802092387_1566609242460_B7EE8D40DFA2D4C41D33A35BAF9BDD02 "图片标题") 
定义一个类，然后再XML中进行配置

```java
package com.springidol;

/**
 * @author : FL
 * @Classname : com.springidol.Audience
 * @Version :
 * @date : 2019-08-21 21:30
 * @describe :
 */
public class Audience {
    public void takeSeats() {
        System.out.println("taking seats");
    }

    public void turnOffCellPhones() {
        System.out.println("turnOffCellPhones");
    }

    public void applaud() {
        System.out.println("applaud");
    }

    public void demandrefund() {
        System.out.println("Boo!We what our money back");
    }

}
```

配置文件中声明：

```xml
<bean id="audience" class="com.springidol.Audience">

</bean>
```

#### 4.3.1 声明前置后后置通知

把audienceBean变成一个切面
配置文件修改如下

```xml
<aop:config proxy-target-class="true">
    <aop:aspect ref="audience">
        <aop:before method="takeSeats" pointcut="execution(* com.springidol.Performer.perform(..))" />
        <aop:before method="turnOffCellPhones" pointcut="execution(* com.springidol.Performer.perform(..))" />
        <aop:after-returning method="applaud" pointcut="execution(* com.springidol.Performer.perform())" />
        <aop:after-throwing method="demandrefund" pointcut="execution(* com.springidol.Performer.perform())" />
    </aop:aspect>
</aop:config>
```

<aop:config>元素内，可以声明多个通知器、切面或者切点
两个<aop:before>元素定义了匹配切点的方法执行之前调用前置通知方法——audienceBean的takeSeats()和turnOffCellPhones()方法（由method属性所声明）。<aop:after-returning>元素定义了一个返回后（after-returning）通知，在切点所匹配的方法调用之后再执行applaud()方法。同样，<aop:after-throwing>元素定义了抛出后通知，如果所匹配的方式执行时抛出任何异常，都将调用demandRefund()方法。图4.6展示了通知逻辑如何编织到业务逻辑中。
 ![图片说明](https://uploadfiles.nowcoder.com/images/20190824/802092387_1566609263845_5F9DE531E571A90987342F3D36B3C60E "图片标题") 
在所有的通知元素中，pointcut属性定义了通知所应用的切点。pointcut属性的值是使用AspectJ切点表达式语法所定义的切点。
使用<aop:pointcut>元素来定义一个可以在所有的通知元素中使用的命名切点。

```xml
<bean id="audience" class="com.springidol.Audience">

</bean>
<aop:config proxy-target-class="true">
    <aop:aspect ref="audience">
        <aop:pointcut id="performance" expression="execution(* com.springidol.Performer.perform())"/>
        <aop:before method="takeSeats" pointcut-ref="performance" />
        <aop:before method="turnOffCellPhones" pointcut-ref="performance" />
        <aop:after-returning method="applaud" pointcut-ref="performance" />
        <aop:after-throwing method="demandrefund" pointcut-ref="performance" />
    </aop:aspect>
</aop:config>
```

#### 4.3.2 声明环绕通知

```java
public void watchPerformance(ProceedingJoinPoint joinPoint) {
    try {
        System.out.println("takingSeats");
        System.out.println("turningoffphone");
        long start = System.currentTimeMillis();
        
        joinPoint.proceed();
        
        long end = System.currentTimeMillis();
        System.out.println("clap>>>>>>>>>>>>>>>>");
        System.out.println("time:" + (end - start) + "ms");
    } catch (Throwable t) {
        System.out.println("money back");
    }
}
```

对于新的通知方法，我们首先会注意到它使用了ProceedingJoinPoint作为方法的入参。这个对象非常重要，因为它能让我们在通知里调用被通知方法。通知方法可以完成任何它所需要做的事情，而且如果希望把控制转给被通知的方法时，我们可以调用ProceedingJoinPoint的proceed()方法。谨记我们必须调用proceed()方法。如果忘记这样做，通知将会阻止被通知的方法的调用。或许这正是我们所需要的，但是更好的方式是在某一点执行被通知的方法。更有意思的是，正如我们可以忽略调用proceed()方法来阻止执行被通知的方法，我们还可以在通知里多次调用被通知的方法。这样做的一个原因是实现重试逻辑，在被通知的方法执行失败时反复重试。在此示例中的audience切面，watchPerformance()方法包含之前4个通知方法的所有逻辑，但所有的逻辑都放在一个单独的方法中了，而且该方法还会负责自身的异常处理。同时我们也注意到在连接点的proceed()方法被调用之前，当前时间被记录在一个局部变量中；当方法返回后，系统会打印执行时间。声明环绕通知与声明其他类型的通知并没有太大区别。我们所需要做的仅仅是使用
<aop:around>元素。

```xml
<aop:config proxy-target-class="true">
    <aop:aspect ref="audience">
        <aop:pointcut id="performance2" expression="execution(* com.springidol.Performer.perform())"/>
        <aop:around method="watchPerformance" pointcut-ref="performance2"/>
    </aop:aspect>
</aop:config>
```

#### 4.3.3 为通知传递参数

切面和实例化对象进行传参：
配置文件：

```xml
<bean id="volunteer" class="com.springidol.Volunteer" />
<bean id="magician" class="com.springidol.Magician"/>
<aop:config proxy-target-class="true">
    <aop:aspect ref="magician">
        <aop:pointcut id="thinking1" expression="execution(* com.springidol.Volunteer.setVolunteerThoughts(String)) and args(thoughts)"/>
        <aop:before pointcut-ref="thinking1" method="interceptThoughts" arg-names="thoughts"></aop:before>
    </aop:aspect>
</aop:config>
```

其中Volunteer和Magician的定义如下

```java
public class Volunteer implements Thinker {
    private String volunteerThoughts;

    public void thinkOfSomething(String volunteerThoughts) {
        this.volunteerThoughts = volunteerThoughts;
    }
    public String getThoughts() {
        return volunteerThoughts;
    }
}

public class Magician implements MindReader {
    private String thoughts;

    public void interceptThoughts(String thoughts) {
        System.out.println("Intercepting...............");
        this.thoughts = thoughts;
    }

    public String getThoughts() {
        return thoughts;
    }
}
```

#### 4.3.4 通过切面引入新功能

 ![图片说明](https://uploadfiles.nowcoder.com/images/20190824/802092387_1566609281913_A131396199707E772EC51BF27DC0DFA4 "图片标题") 
当引入接口的方法被调用时，代理将此调用委托给实现了新接口的某个其他对象。实际上，Bean的实现被拆分到了多个类。

```
<aop:config>
    <aop:aspect>
        <aop:declare-parents types-matching="com.springidol.Performer+" implement-interface="com.springidol.Contestant" default-impl="com.springidol.GraciousContestant" />
    </aop:aspect>
</aop:config>
```

暂时不懂要干嘛

### 4.4注解切面

使用注解来创建切面是AspectJ5所引入的关键特性。AspectJ5之前，编写As-pectJ切面需要学习一种Java语言的扩展，但是AspectJ面向注解的模型可以非常简便地通过少量注解把任意类转变为切面。这种新特性通常称为@AspectJ。

```java
@Aspect
public class Audience {
    @Pointcut("execution(* com.springidol.Performer.perform())")
    
    public void performance() {
        
    }
    
    @Before("performance()")
    public void takeSeats() {
        System.out.println("taking seats");
    }


    @Before("performance()")
    public void turnOffCellPhones() {
        System.out.println("turnOffCellPhones");
    }

    @AfterReturning("performance()")
    public void applaud() {
        System.out.println("applaud");
    }

    @AfterThrowing
    public void demandFraud() {
        System.out.println("Boo!We what our money back");
    }
    public void watchPerformance(ProceedingJoinPoint joinPoint) {
        try {
//            System.out.println("takingSeats");
//            System.out.println("turningoffphone");
            long start = System.currentTimeMillis();

            joinPoint.proceed();

            long end = System.currentTimeMillis();
//            System.out.println("clap>>>>>>>>>>>>>>>>");
            System.out.println("time:" + (end - start) + "ms");
        } catch (Throwable t) {
            System.out.println("money back");
        }
    }
}
```

新的Audience类现在已经使用@AspectJ注解进行了标注。该注解标识了Audience不仅仅是一个POJO，还是一个切面。@Pointcut注解用于定义一个可以在@AspectJ切面内可重用的切点。@Pointcut注解的值是一个AspectJ切点表达式——这里标识该切点必须匹配Performer的perform()方法。切点的名称来源于注解所应用的方法名称。因此，该切点的名称为performance()。performance()方法的实际内容并不重要，在这里它事实上是空的。其实该方法本身只是一个标识，供@Pointcut注解依附。
Audience的每一个方法都使用了通知注解来标注。takeSeats()和turnOffCellPhones()方法使用@Before注解来标识它们是前置通知方法。applaud()方法使用@AfterReturning注解来标识它是后置通知方法，而demandRefund()方法使用了@AfterThrowing注解，所以如果在表演时抛出任何异常，该方法都会被调用。
performance()切点的名称作为参数的值赋给了所有的通知注解。以这种方式来标识每一个通知方法应该应用在哪里。注意，除了那些注解和无操作的performance()方法，Audience类在实现上并没有任何改变。这意味着Audience仍然是一个简单的Java对象，能够像以前一样使用。该类仍然可以像下面一样在Spring中进行装配：
<bean id="audience" class="com.springinaction.springidol.Audience"/>
因为Audience类本身包含了所有它所需要定义的切点和通知，所以我们不再需要在XML配置中声明切点和通知。最后一件需要做的事是让Spring将Audience应用为一个切面。我们需要在Spring上下文中声明一个自动代理Bean，该Bean知道如何把@AspectJ注解所标注的Bean转变为代理通知。
为此，Spring自带了名为AnnotationAwareAspectJAutoProxyCreator的自动代理创建类。我们可以在Spring上下文中把AnnotationAwareAspectJAutoProxyCreator注册为一个Bean，但是我们需要需要 敲一大段的文字（相信我……我之前敲过几次了）。因此，为了简化如此长的名字，Spring在aop命名空间中提供了一个自定义的配置元素，该元素很容易被记住：
<aop:aspectj-autoproxy/>
<aop:aspectj-autoproxy/>将在Spring上下文中创建一个AnnotationAwareAspectJAutoProxyCreator类，它会自动代理一些Bean，这些Bean的方法需要与使用@Aspect注解的Bean中所定义的切点相匹配，而这些切点又是使用@Pointcut注解定义出来的。
为了使用<aop:asepctj-autoproxy>配置元素，我们需要在Spring的配置文件中包含aop命名空间：

```
<beans xmlns="http://www.springframework.org/schema/beans"xmlns:xsi=http://www.w3.org/2001/XMLSchema-instance xmlns:aop=”http://www.springframework.org/schema/aop” xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-3.0.xsd">
```

我们需要记住<aop:asepectj-autoproxy>仅仅使用@AspectJ注解作为指引来创建基于代理的切面，但本质上它仍然是一个Spring风格的切面。这非常有意义，因为这意味着虽然我们使用@AspectJ的注解，但是我们仍然限于代理方法的调用。如果想利用AspectJ的所有能力，我们必须在运行时使用AspectJ并不依赖Spring来创建基于代理的切面。
同样值得一提的是，<aop:aspect>元素和@AspectJ注解都是把一个POJO转变为一个切面的有效方式。但是<aop:aspect>相对于@AspectJ的一个明显优势是我们不需要实现切面功能的源码。通过@AspectJ，我们必须标注类和方法，它需要有源码。而<aop:aspect>可以引用任意一个Bean。

#### 4.4.1 注解环绕通知

```java
@Around(" performance()")
public void watchPerformance(ProceedingJoinPoint joinPoint) {
    try {
        System.out.println("takingSeats");
        System.out.println("turningoffphone");
        long start = System.currentTimeMillis();

        joinPoint.proceed();

        long end = System.currentTimeMillis();
        System.out.println("clap>>>>>>>>>>>>>>>>");
        System.out.println("time:" + (end - start) + "ms");
    } catch (Throwable t) {
        System.out.println("money back");
    }
}
```

但是简单地使用@Around注解来标注方法并不足以调用proceed()方法，因此，被环绕通知的方法必须接受一个ProceedingJoinPoint对象作为方法入参，并在对象上调用proceed()方法。

#### 4.4.2 传递参数给所标注的通知

```java
@Aspect
public class Magician implements MindReader {
    private String thoughts;

    @Pointcut("execution(* com.springidol." + "Thinker.thinkOfSomething(String)) && args(thoughts)")
    public void thinking(String thoughts) {

    }

    @Before("thinking(thoughts)")
    public void interceptThoughts(String thoughts) {
        System.out.println("Intercepting...............");
        this.thoughts = thoughts;
    }

    public String getThoughts() {
        return thoughts;
    }
}
```

<aop:pointcut>元素变为@Pointcut注解，而<aop:before>元素变为@Before注解。在这里，唯一发生显著变化的是@AspectJ能够依靠Java语法来判断为通知所传递参数的细节。因此，这里并不需要与<aop:before>元素的argnames属性所对应的注解。

Spring提供了几种技巧，可以帮助我们减少XML的配置数量。
**自动装配**（autowiring）有助于减少甚至消除配置<property>元素和<constructor-arg>元素，让Spring自动识别如何装配Bean的依赖关系。
**自动检测**（autodiscovery）比自动装配更进了一步，让Spring能够自动识别哪些类需要被配置成SpringBean，从而减少对<bean>元素的使用。当自动装配和自动检测一起使用时，它们可以显著减少Spring的XML配置数量。通常只需要配置少量的几行XML代码，而无需知道在Spring的应用上下文中究竟有多少Bean。