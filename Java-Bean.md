---
title: Java Bean
categories: Java
tags: 
  - Spring
  - Bean
toc: true 

---

### 3.1自动装配Bean属性

当Spring装配Bean属性时，有时候非常明确，就是需要将某个Bean的引用装配给指定属性。如果我们的应用上下文中只有一个javax.sql.DataSource类型的Bean，那么任意一个依赖DataSource的其他Bean就是需要这个DataSourceBean。毕竟这里只有一个DataSourceBean。
为了应对这种明确的装配场景，Spring提供了自动装配（autowiring）。与其显式地装配Bean的属性，为何不让Spring识别出可以自动装配的场景——不需要不需要考虑究竟要装配哪一个Bean引用。

#### 3.1.1 4种类型的自动装配

■ byName——把与Bean的属性具有相同名字（或者ID）的其他Bean自动装配到Bean的对应属性中。如果没有跟属性的名字相匹配的Bean，则该属性不进行装配。
■ byType——把与Bean的属性具有相同类型的其他Bean自动装配到Bean的对应属性中。如果没有跟属性的类型相匹配的Bean，则该属性不被装配。
■ constructor——把与Bean的构造器入参具有相同类型的其他Bean自动装配到Bean构造器的对应入参中。
■ autodetect——首先尝试使用constructor进行自动装配。如果失败，再尝试使用byType进行自动装配。
**byName自动装配**
如将以下配置信息：

```xml
<bean id="kenny2" class="com.springidol.Instrumentalist">
    <property name="song" value="Jingle Bells"></property>
    <property name="instrument" ref="piano"></property>
</bean>
```

替换成

```xml
<bean id="kenny2" class="com.springidol.Instrumentalist" autowire="byName">
    <property name="song" value="Jingle Bells"></property>
</bean>

<bean id="instrument" class="com.springidol.Saxophone"></bean>
```

byName自动装配遵循一项约定：为属性自动装配ID与该属性的名字相同的Bean。
**byType自动装配**
byType自动装配的工作方式类似于byName自动装配，只不过不再是匹配属性的名字而是检查属性的类型。当我们尝试使用byType自动装配时，Spring会寻找哪一个Bean的类型与属性的类型相匹配。
了避免因为使用byType自动装配而带来的歧义，Spring为我们提供了另外两种选择：可以为自动装配标识一个首选Bean，或者可以取消某个Bean自动装配的候选资格。为自动装配标识一个首选Bean，可以使用<bean>元素的primary属性。如果只有一个自动装配的候选Bean的primary属性设置为true，那么该Bean将比其他候选Bean优先被选择。但是primary属性有个很怪异的一点：它默认设置为true。这意味着所有的候选Bean都将变成首选Bean（因此，其实就不存在首选Bean了）。所以，为了使用primary属性，我们不得不将所有非首选Bean的primary属性设置为false。
我们希望排除某些Bean，那可以设置这些Bean的autowire-candidate属性为false，如下所示：

```xml
<beanid="saxophone"class="com.springinaction.pringidol.Saxophone"autowire-candidate="false"/>
```

**constructor自动装配**
如果要通过构造器注入来配置Bean，那我们可以移除<constructor-arg>元素，由Spring在应用上下文中自动选择Bean注入到构造器入参中。

```xml
<bean id="duke" class="com.springidol.PoeticJuggler" autowire="constructor">
</bean>
<bean id="Sonnect29" class="com.springidol.Sonnet29">
```

最佳自动装配
设置autowire属性为autodetect，由Spring来决定。
自动装配顺序
constructor->byType->byname

#### 3.1.2 默认自动装配

如果需要为Spring应用上下文中的每一个Bean（或者其中的大多数）配置相同相同的autowire属性，那么就可以要求Spring为它所创建的所有Bean应用相同的自动装配策略来简化配置。我们所需要做的仅仅是在根元素<beans>上增加一个default-autowire属性：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns=http://www.springframework.org/schema/beans xmlns:xsi=http://www.w3.org/2001/XMLSchema-instance xsi:schemaLocation=http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd default-autowire="byType">
</beans>
```

默认情况下，default-autowire属性被设置为none，标示所有Bean都不使用自动装配，除非Bean自己配置了autowire属性。在这里，我们将default-autowire属性设置为byType，希望每一个Bean的所有属性都使用byType自动装配策略进行自动装配。当然了，我们可以将default-autowire属性设置为任意一种有效的自动装配策略，并将其应用于Spring配置文件中的所有Bean。注意，我只是说default-autowire应用于指定Spring配置文件中的所有Bean；我可没说它应用于Spring应用上下文中的所有Bean。你可以在一个Spring应用上下文中定义多个配置文件，每一个配置文件都可以有自己的默认自动装配策略。同样，不能因为我们配置了一个默认的自动装配策略，就意味着所有的Bean都只能使用这个默认的自动装配策略。我们还可以使用<bean>元素的autowire属性来覆盖<beans>元素所配置的默认自动装配策略。

#### 3.1.3 混合使用默认装配和显示装配

举个例子，即使kennyBean已经配置为byType自动装配策略，但它仍然可以显式装配kenny的instrument属性，如下所示：

```xml
<bean id="kenny" class="com.springinaction.springidol.Instrumentalist" autowire="byType">
<property name="song" value="JingleBells"/>
<property name="instrument" ref="saxophone"/>
</bean>
```

例如，如果我们想为kennyBean的instrument属性装配null值，可以使用如下的配置：

```xml
<bean id="kenny" class="com.springinaction.springidol.Instrumentalist" autowire="byType">
<property name="song" value="JingleBells"/>
<property name="instrument"><null/></property>
</bean>
```

### 3.2 使用注解装配

从Spring2.5开始，最有趣的一种装配SpringBean的方式是使用注解自动装配Bean的属性。使用注解自动装配与在XML中使用autowire属性自动装配并没有太大差别。但是使用注解方式允许更细粒度的自动装配，我们可以选择性地标注某一个属性来对其应用自动装配。
Spring容器默认禁用注解装配。所以，在使用基于注解的自动装配前，我们需要在Spring配置中启用它。最简单的启用方式是使用Spring的context命名空间配置中的<context:annotation-config>元素，如下所示：
<context:annotation-config>元素告诉Spring我们打算使用基于注解的自动装配。一旦配置完成，我们就可以对代码添加注解，标识Spring应该为属性、方法和构造器进行自动装配。Spring 3支持几种不同的用于自动装配的注解：
■Spring自带的@Atutowired注解；
■JSR-330的@Inject注解；
■JSR-250的@Resource注解。
我们首先介绍如何使用Spring自带的@Autowired注解，然后再介绍如何使用Java依赖注入标准（JSR-330）的@Inject和JSR-250的@Resource。

#### 3.2.1 使用@Autowired

@Autowired示例：

```xml
<!--使用@Autowired注解需要的声明-->
<bean class="org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor "/>
<bean id="duke" class="com.springidol.PoeticJuggler" autowire="constructor">
</bean>
```

标注@Autowired

```java
@Autowired
public void setInstrument(Instrument instrument) {
    this.instrument = instrument;
}
```

另外，我们还可以使用@Autowired注解直接标注属性，并删除setter方法：

```java
@Autowired 
private Instrument instrument;
```

@Autowired甚至不会受限于private关键字。即使in-strument属性是私有的实例变量，它仍然可以被自动装配。
如果没有匹配的Bean，如何让@Autowired注解远离失败。
**可选的自动装配**
默认情况下，@Autowired具有强契约特征，其所标注的属性或参数必须是可装配的。如果没有Bean可以装配到@Autowired所标注的属性或参数中，自动装配就会失败（抛出令人讨厌的NoSuchBeanDefinitionException）。这可能是我们所期望的处理方式——当自动装配无法完成时，让Spring尽早失败，远胜于以后抛出NullPointerExcepiton异常。
属性不一定非要装配，null值也是可以接受的。在这种场景下，可以通过设置@Autowired的required属性为false来配置自动装配是可选的。例如：

```java
    @Autowired(required = false)
    private Instrument instrument;
```

在这里，Spring将尝试装配instrument属性，但是如果没有查找到与之匹配的类型为Instrument的Bean，应用就不会发生任何问题，而instrument属性的值会设置为null。
注意required属性可以用于@Autowired注解所使用的任意地方。但是当使用构造器装配时，只有一个构造器可以将@Autowired的requeired属性设置为true。其他使用@Autowired注解所标注的构造器只能将required属性设置为false。此外，当使用@Autowired标注多个构造器时，Spring就会从所有满足装配条件的构造器中选择入参最多的那个构造器。
限定歧义性的依赖
另一方面，问题或许在于Spring并不缺少适合自动装配的Bean。可能会有足够多的Bean（或者至少2个）都完全满足装配条件，并且都可以被装配到属性或参数中。、@Autowired注解没有办法选择哪一个Bean才是它真正需要的。所以抛出NoSuchBeanDefinitionException异常，明确表明装配失败了。我们可以配合使用Spring的@Qualifier注解。例如：

```java
@Autowired 
@Qualifier(" guitar") 
private Instrument instrument;
```

所示，@Qualifier注解将尝试注入ID为guitar的Bean。
除了通过Bean的ID来缩小选择范围，我们还可以通过在Bean上直接使用qualifier来缩小范围。例如：

```xml
<bean id="saxophone1" class="com.springidol.Piano">
    <qualifier value="ppp"></qualifier>
</bean>
```

```xml
@Autowired
@Qualifier("ppp")
private Instrument instrument;
```

创建自定义的限定器（Qualifier）为了创建一个自定义的限定器注解，我们所需要做的仅仅是定义一个注解，并使用@Qualifier注解作为它的元注解。

#### 3.2.2 借助@Inject实现基于标准的自动装配

为了统一各种依赖注入框架的编程模型，JCP（JavaCommunityProcess）最近发布了Java依赖注入规范，JCP将其称为JSR-330，更常见的叫法是atinject。该规范为Java带来了通用依赖注入模型。
该注解几乎可以完全替换Spring的@Au-towired注解。所以，除了使用Spring特定的@Autowired注解，我们还可以选择使用@Inject注解来标注instrument属性：
限定@Inject所标注的属性
一样，@Inject注解易导致歧义性的Bean定义。相对于@Autowired所对应的@Qualifier，@Inject所对应的是@Named注解。

#### 3.2.3 在注解注入中使用表达式

可以通过@Value直接标注某个属性、方法或者方法参数，并传入一个String类型的表达式来装配属性。例如：

```java
@Value(" Eruption") 
private String song;
```

使用SpEL从系统属性中获取一个值：

```java
@Value("#{systemProperties.myFavoriteSong}")
private String song; 
```

### 3.3 自动检测Bean

<context:annotation-config>有助于完全消除Spring配置中的<property>和<constructor-arg>元素，我们仍需要使用<bean>元素显式定义Bean。
为了配置Spring自动检测，需要使用<context:component-scan>元素来代替<context:annotation-config>元素：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:util="http://www.springframework.org/schema/util"
       xmlns:p="http://www.springframework.org/schema/p" xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd"
       default-autowire="constructor">
    <context:component-scan base-package="com.springidol"></context:component-scan>
</ beans >
```

base-package属性标识了<context:component-scan>元素所扫描的包。

#### 3.3.1 为自动检测标注Bean

默认情况下，<context:component-scan>查找使用构造型（stereotype）注解所标注的类，这些特殊的注解如下。
■@Component——通用的构造型注解，标识该类为Spring组件。
■@Controller——标识将该类定义为SpringMVCcontroller。
■@Repository——标识将该类定义为数据仓库。
■@Service——标识将该类定义为服务。
■使用@Component标注的任意自定义注解。
示例：

```java
@Component("guiterID")
public class Guiter implements Instrument {
    public Guiter() {}
    @Override
    public void play() {
        System.out.println("guiterguiterguiterguiter");
    }
}
```

#### 3.3.2 过滤组件扫描

事实上，在如何扫描来获得候选Bean方面，<context:component-scan>非常灵活。通过为<context:component-scan>配置<context:include-filter>和/或者<context:exclude-filter>子元素，我们可以随意调整扫描行为。
增加一个包含过滤器来要求<context:component-scan>自动注册所有的Instrument实现类，
<context:include-filter>的type和expression属性一起协作来定义组件扫描策略。

```xml
<context:component-scan base-package="com.springidol">
    <context:include-filter type="assignable" expression="com.springidol.Instrument"/>
    <context:exclude-filter type="annotation" expression="com.springidol.Piano"/>
</context:component-scan>
```

![图片说明](https://uploadfiles.nowcoder.com/images/20190821/802092387_1566402904546_40DB6D999F602B2967DE046A26ACDAEB "图片标题") 

### 3.4 基于Java的Spring配置

#### 3.4.1 创建基于Java的配置

需要极少量的XML来启用Java配置：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans 
       http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context 
        http://www.springframework.org/schema/context/spring-context-3.0.xsd">
</beans>
```

#### 3.4.2 定义一个配置类

在 基于 Java 的 配置 里 使用@ Configuration 注解 的 Java 类， 就 等价 于 XML 配置 中的< beans> 元素。

```java
@Configuration
public class SpringIdolConfig {
}
```

@Configuration注解会作为一个标识告知Spring：这个类将包含一个或多个SpringBean的定义。这些Bean的定义是使用@Bean注解所标注的方法。

#### 3.4.3 声明一个简单的Bean

示例：

```java
@Configuration
public class SpringIdolConfig {
    @Bean
    public Performer duke() {
        return new Juggler();
    }
}
```

在Spring的基于Java的配置中，并没有String属性。Bean的ID和类型都被视为方法签名的一部分。Bean的实际创建是在方法体中定义的。因为它们全部是Java代码，所以我们可以进行编译期检查来确保Bean的类型是合法类型，并且Bean的ID是唯一的。

#### 3.4.4 使用Spring的基于Java的配置进行注入

```java
@Configuration
public class SpringIdolConfig {
    @Bean
    public Performer duke() {
        return new Juggler();
    }

    @Bean
    public Performer duke15() {
        return new Juggler(15);
    }

    @Bean
    public Performer kenny() {
        Instrumentalist kenny = new Instrumentalist();
        kenny.setSong("aaaaaaannnnnnnnnn");
        return kenny;
    }

    @Bean
    public Poem sonnet29() {
        return new Sonnet29();
    }
    
    @Bean
    public Performer poeticDuke() {
        return new PoeticJuggler(sonnet29());
    }
}
```

在Spring的Java配置中，通过声明方法引用一个Bean并不等同于调用该方法。如果真的这样，每次调用sonnet29()，都将得到该Bean的一个新的实例。Spring要比这聪明多了。