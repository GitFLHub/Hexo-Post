---
title: Bean的操作
categories: Java
tags: 
  - Bean
toc: true 

---

### 2.1 声明Bean

#### 2.1.1创建Spring配置

Spring提供两种装配Bean的方式。传统上Spring使用多个XML文件作为配置文件。
也可以采用基于Java注解的配置方式。
在XML文件中声明Bean时，Spring配置文件的根元素是来源于Spring beans命名空间所定义的<beans>元素。Spring XML配置文件例子如下：

```xml
<? xml version=" 1. 0" encoding=" UTF- 8"?> 
< beans xmlns=" http:// www. springframework. org/ schema/ beans" xmlns: xsi=" http:// www. w3. org/ 2001/ XMLSchema- instance" xsi: schemaLocation=" http:// www. springframework. org/ schema/ beans http:// www. springframework. org/ schema/ beans/ spring- beans- 3. 0. xsd"> 
<!-- Bean declarations go here --> 
</ beans>
```

在beans元素内，可以放置所有的Spring配置信息。
Spring的核心框架自带了10个命名空间。
![图片说明](https://uploadfiles.nowcoder.com/images/20190819/802092387_1566229489947_1DB20C1C030ACEF84B17A298B49861BE "图片标题") 

#### 2.1.2声明一个简单的Bean

```java
package com. springinaction. springidol;
public class Juggler implements Performer { 
private int beanBags = 3; 
public Juggler() { } 
public Juggler( int beanBags) { this. beanBags = beanBags; }
public void perform() throws PerformanceException { System. out. println(" JUGGLING " + beanBags + " BEANBAGS"); } 
}
```

```xml
<bean id=”duke” class=”com.springinaction.springidol.Juggler”></bean>
```

通过<bean>的配置方式。创建了一个由Spring容器管理的名字为duke的Juggler的Bean，其中id属性定义了Bean的名字，也作为该Bean在Spring容器中的引用。
在Spring容器加载Bean时，Spring将使用默认的构造器来实例化duke

```java
new com.springinacation.springidol.Juggler();
ApplicationContext ctx = new ClassPathXmlApplicationContext( "com/ springinaction/ springidol/ spring- idol. xml"); 
Performer performer = (Performer) ctx. getBean(" duke"); 
performer. perform();
```

####  2.1.3通过构造器注入

1，Juggler类能够以两种不同的方式构造：
■使用默认的构造器；
■使用带有一个int参数的构造方法，该参数设置了Juggler可以同时抛在空中的豆袋子的个数。
带参数的配置方法

```xml
<bean id=”duke” class=”com.springinaction.springidol.Juggler”>
	<constructor-arg value=”15” />
</bean>
```

<constructor-arg>的value属性设置为15
通过构造器注入对象

```bean
package com. springinaction. springidol;
public class PoeticJuggler extends Juggler { 
    private Poem poem;

    public PoeticJuggler(Poem poem) {
        super();
        this.poem = poem;
    }
    public PoeticJuggler(int beanBags, Poem poem) {
        super(beanBags);
        this.poem = poem;
    }
    public void perform() throws PerformanceException { 
	super.perform();
        System. out. println(" JUGGLING " + beanBags + " BEANBAGS"); 
        poem.recite();
    } 
}
```

poem接口：

```java
package com. springinaction. springidol;
public interface Poem { 
	void recite(); 
}
package com. springinaction. springidol; 
public class Sonnet29 implements Poem { 
	private static String[] LINES = { 
	"When, in disgrace with fortune and men' s eyes,", 
	"I all alone beweep my outcast state", 
	"And trouble deaf heaven with my bootless cries", 
	"And look upon myself and curse my fate,", 
	"Wishing me like to one more rich in hope,", 
	"Featured like him, like him with friends possess' d,",
	"Desiring this man' s art and that man' s scope,",
	"With what I most enjoy contented least;", 
	"Yet in these thoughts myself almost despising,",
	"Haply I think on thee, and then my state,",
	"Like to the lark at break of day arising",
	"From sullen earth, sings hymns at heaven' s gate;",
	"For thy sweet love remember' d such wealth brings",
	"That then I scorn to change my state with kings."
	}; 
	public Sonnet29() { } 
	public void recite() 
	{ 
		for (int i = 0; i < LINES. length; i++) { 
			System. out. println(LINES[i]);
		}
	}
}
```

可以XML将Sonn t29声明为一个Spring<bean>:

```xml
<bean id=”sonnett29” class=”com.springinaction.springidol.Sonnect29” />
```

有了poem，现将poem赋于Duke。<bean>声明如下：

```xml
<bean id="poeticDuke" class="com.springinaction.springidol.PoeticJuggler">
    <constructor-arg value="15"/>
    <constructor-arg ref="sonnet29"/>
</bean>
```

通过工厂方法创建Bean
有时候静态工厂方法是实例化对象的唯一方法。Spring支持通过<bean>元素的factory-method属性来装配工厂创建的Bean。
为单例类配置Bean

   ```xml
<bean id=”theStage” class=” com.springinaction.springidol.PoeticJuggler” factory-method=”getInstance” />
   ```

这种配置方式可以用来创建静态方法

#### 2.1.4 Bean的作用域

当在Spring中配置<bean>元素时，我们可以为Bean声明一个作用域。为了让Spring在每次请求时都为Bean产生一个新的实例，则需要配置scope属性为prototype即可。例如，把演出门票声明为Spring Bean:

```xml
<bean id=”ticket” class=” com.springinaction.springidol.PoeticJuggler” scope=”prototype” />
```

除了prototype，Spring还提供了其他几个作用域的选项。
 ![图片说明](https://uploadfiles.nowcoder.com/images/20190819/802092387_1566229508182_AB0D0BAC02A7431FFADE7BB063A05FCB "图片标题") 

#### 2.1.5初始化和销毁Bean

Spring提供了Bean生命周期的钩子方法。
为了Bean定义初始化和销毁操作，只需要使用init-method和destroy-method参数来配置<bean>元素。
为bean定义初始化和销毁操作，只需要使用init-method和destory-method参数来配置<bean>元素。
如舞台类活动Auditorium

```java
public class Auditorium { 
    public void turnOnLights() { 
        . 
    } 
    public void turnOffLights() { 
    . 
    }
}
```

为了实例化对象的初始化和注销需求，我们可以使用initmethod和destorymethod属性来声明auditoriumBean：

```xml
<bean id="auditorium" class="com.springinaction.springidol.Auditorium" init-method="turnOnLights" destroy-method="turnOffLights"/>
```

这样的配置方式会让auditoriumBean实例化后会立即调用turnOn-Lights()方法。在该Bean从容器移除和销毁前，会调用turnOffLights()
InitializingBean和DisposableBean
为Bean定义初始化和销毁方法的另一种可选方式是，让Bean实现Spring的InitializingBean和DisposableBean接口。Spring容器以特殊的方式对待实现这两个接口的Bean，允许它们进入Bean的生命周期。InitializingBean声明了一个afterPropertiesSet()方法作为初始化方法。而DisposableBean声明了一个destroy()方法，该方法在Bean从应用上下文移除时会被调用。使用这些生命周期接口的最大好处就是Spring能够自动检测实现了这些接口的Bean，而无需额外的配置。实现这些接口的缺点是Bean与Spring的API产生了耦合。就因为这条理由，所以我还是推荐使用init-method和destory-method属性来初始化和销毁Bean。唯一可能使用Spring的生命周期接口的场景是，开发一个明确在Spring容器内使用的框架Bean。
可以使用<beans>元素的default-init-method和default-destory-method属性：

```xml
<? xml version=" 1. 0" encoding=" UTF- 8"?> 
< beans xmlns=" http:// www. springframework. org/ schema/ beans" xmlns: xsi=" http:// www. w3. org/ 2001/ XMLSchema- instance" xsi: schemaLocation=" http:// www. springframework. org/ schema/ beans http:// www. springframework. org/ schema/ beans/ spring- beans- 3. 0. xsd" 
default- init- method=" turnOnLights" 
default- destroy- method=" turnOffLights">
 ... 
</ beans>
```

default-init-method属性为应用上下文中所有的Bean设置了共同的初始化方法。类似的是，default-destory-method为应用上下文中所有的Bean设置了一个共同的销毁方法。

### 2.2注入Bean属性

#### 2.2.1注入Bean属性

使用<property>元素配置Bean的属性。<property>在许多方面与<constructor-arg>类似。
<constructor-arg>通过构造参数来注入值
<property>通过setter方式来注入值
例子：

```xml
<beanid="kenny"class="com.springinaction.springidol.Instrumentalist">
<propertyname="song"value="JingleBells"/>
</bean>
```

一旦Instrumentalist被实例化，Spring就会调用<property>元素所指定属性的setter方法为该属性注入值。在这段XML代码中，<property>元素会指示Spring调用setSong()方法将song属性的值设置为“JingleBells”。
但是<property>元素并没有限制只能注入String类型的值，value属性同样可以指定数值型（int、float、java.lang.Double等）以及boolen型的值。
例子：

```xml
<bean id=" kenny" class=" com. springinaction. springidol. Instrumentalist">
<property name=" song" value=" Jingle Bells" /> 
<property name=" age" value=" 37" /> 
</bean>
```

#### 2.2.2引用其他Bean

程序清单2.6 saxophone实现了Instrument接口：

```java
package com.springinaction.springidol;
public class Saxophone implements Instrument {
    public Saxophone() {}
    public void play() {
        System.out.println("TOOT TOOT TOOT");
    }
}
```

配置文件

```xml
<bean id=" saxophone" class=" com. springinaction. springidol. Saxophone" />
<bean id=" kenny2" class=" com. springinaction. springidol. Instrumentalist">
<property name=" song" value=" Jingle Bells" /> 
<property name=" instrument" ref=" saxophone" /> 
</bean>
```

调用方法:

```java
ApplicationContext ctx = new ClassPathXmlApplicationContext("com/springinaction/ springidol/spring- idol. xml"); 
Performer performer = (Performer) ctx. getBean(" kenny");
performer. perform();
```

注入内部 Bean
重新配置了kenny Bean

```xml
<bean id=" kenny" class="com.springinaction.springidol.Instrumentalist">
<property name=" song" value=" Jingle Bells" /> 
<property name=" instrument"> 
<bean class=" org. springinaction. springidol. Saxophone" /> 
</property> 
</bean>
```

内部Bean是通过直接声明一个<bean>元素作为<prop-erty>元素的子节点而定义的。
内部Bean并不限于setter注入，还可以把内部Bean装配到构造方法的入参中
例子：

```xml
<bean id=" duke" class=" com. springinaction. springidol. PoeticJuggler"> 
<constructor- arg value=" 15" /> 
<constructor- arg> 
<bean class=" com. springinaction. springidol. Sonnet29" /> 
</constructor- arg> 
</bean>
```

注意内部Bean没有ID属性，说明内部Bean不能被复用。内部Bean仅仅适用于一次注入。而且也不能被其他Bean所引用。

#### 2.2.3使用Spring的命名空间p装配属性

```xml
<bean id=" kenny" class="com.springinaction.springidol.Instrumentalist" p: song = "Jingle Bells" p: instrument-ref = "saxophone" />
```

p:song属性的值被设置为“JingleBells”，将使用该值装配song属性。同样，p:instrument-ref属性的值被设置为“saxophone”，将使用一个ID为saxophone的Bean引用来装配instrument属性。-ref后缀作为一个标识来告知Spring应该装配一个引用而不是字面值。

#### 2.2.4装配集合

当配置集合类型的Bean属性时，Spring提供了4种类型的集合配置元素。
 ![图片说明](https://uploadfiles.nowcoder.com/images/20190819/802092387_1566229540614_EF91E2DACAD99DFB4BBE9DCA129FC2E6 "图片标题") 
当装配类型为数组或者java.util.Collection任意实现的属性时，<list>和<set>元素非常有用。我们很快就会看到，其实属性实际定义的集合类型与选择<list>或者<set>元素没有任何关系。如果属性为任意的java.util.Collec-tion类型时，这两个配置元素在使用时几乎可以完全互换。

<map>和<props>这两个元素分别对应java.util.Map和java.util.Properties。当我们需要由键-值对组成的集合时，这两种配置元素非常有用。这两种配置元素的关键区别在于，<props>要求键和值都必须为String类型，而<map>允许键和值可以是任意类型。
```
public class OneManBand implements PerformanceException {
	public OneManBand() {


```java
public void perform() {
	for(Instrument instrument : implements) {
		instrument.play();
	}
}

private Collection<Instrument> implements;

private void setInstruments(Collection<Instrument> implements) {
	this.implements = implement;
}
}
```

装配List、Set和Array
让我们使用<list>配置元素，为Hank赋予表演时所用到的乐器集合：

```xml
<bean id=" hank" class=" com. springinaction. springidol. OneManBand"> 
<property name=" instruments"> 
<list> 
<ref bean=" guitar" /> 
<ref bean=" cymbal" /> 
<ref bean=" harmonica" />
</list> 
</property> 
</bean>
```

.<list>元素包含一个或多个值。这里的<ref>元素用来定义Spring上下文中的其他Bean引用，当然还可以使用其他的Spring设值元素作为<list>的成员，包括<value>、<bean>和<null/>。实际上，<list>可以包含另外一个<list>作为其成员，形成多维列表。
中，OneManBand的instruments属性为java.util.Collection类型，使用了Java5范型来限制集合中的元素必须为Instrument类型。如果Bean的属性类型为数组类型或java.util.Collection接口的任意实现，都可以使用<list>元素。换句话说，即使像下面那样配置instruments属性，<list>元素也一样有效：
使用Set装配

```xml
<bean id=" hank" class=" com. springinaction. springidol. OneManBand"> 
<property name=" instruments"> 
<set> 
<ref bean=" guitar" /> 
<ref bean=" cymbal" /> 
<ref bean=" harmonica" /> 
<ref bean=" harmonica" /> 
</set> 
</property> 
</bean>
```

无论<list>还是<set>都可以用来装配类型为java.util.Collection的任意实现或者数组的属性。不能因为属性为java.util.Set类型，就表示用户必须使用<set>元素来完成装配。

装配Map集合

```java
public class OneManBand implements PerformanceException {
	public Map<String, Instrument> instruments;

    public OneManBand() {
    
    }
    
    @Override
    public void perform() throws PerformanceException {
        for (String key : instruments.keySet()) {
            System.out.println(key + ":");
            Instrument instrument = instruments.get(key);
            instrument.play();
        }
    }
    
    public void setInstruments(Map<String, Instrument> instruments) {
        this.instruments = instruments;
}
}
```

配置文件

```xml
<bean id="hank" class="com.springidol.OneManBand">
<property name="instruments">
           <map>
                <entry key="saxophone" value-ref="saxophone"></entry>
                <entry key="piano" value-ref="piano"></entry>
            </map>        
</property>
</bean>
```

装配Properties集合
当将OneManBand的instrument属性声明为Map类型时，需要使用value-ref指定每一个entry的值。这是因为每一个entry最终都会成为Spring上下文中的一个Bean。但是如果所配置Map的每一个entry的键和值都为String类型时，我们可以考虑使用java.util.Properties代替Map。Properties类提供了和Map大致相同的功能，但是它限定键和值必须为String类型。为了演示，OneManBand使用String-to-String的java.util.Propeties集合来装配，代替之前键为String类型而值为Bean引用的Map。修改后的instruments属性如下所示：

```java
@Override
    public void perform() throws PerformanceException {
        Collection<String> instrumentsObject = instruments.stringPropertyNames();
        for(String key : instrumentsObject) {
            String instrumentValue = instruments.getProperty(key);
            System.out.println(key + ":" + instrumentValue);
        }
    }

    public void setInstruments(Properties instruments) {
        this.instruments = instruments;
}
```

配置如下：

```xml
<property name="instruments">
            <props>
                <prop key="saxophone">saxophonesaxophonesaxophone</prop>
                <prop key="piano">pianopianopiano</prop>
            </props>
</property>
```

<props>元素构建了一个java.util.Properties值，这个Properties的每一个成员都由<prop>元素定义。每一个<prop>元素都有一个key属性，其定义了Properties每个成员的键，而每一个成员的值由<prop>元素的内容所定义。在我们的示例中，键为“GUITAR”的元素，它的值为“STRUMSTRUMSTRUM”。这可能是我们所讨论的最复杂的Spring配置元素了。这是因为术语属性（property）包含了太多的含义。请牢记下面的配置要点：
■<property>元素用于把值或Bean引用注入到Bean的属性中；
■<props>元素用于定义一个java.util.Properties类型的集合值；
■<prop>元素用于定义<props>集合的一个成员。

#### 2.2.5装配空值

除了为Bean的属性或构造器参数装配其他任意类型的值外，Spring还可以装配一个空值。或者更准确地讲，Spring可以装配null值。
为属性设置null值，只需使用<null/>元素。例如：

```xml
<property name="someNonNullProperty"><null/></property>
```



# 