---
title: RabbitMQ学习笔记
categories: 知识
updated: 2021-11-05
date: 2021-11-05
tags: [RabbitMQ, 消息中间件]
cover: https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage.bubuko.com%2Finfo%2F201910%2F20191018012402811963.png&refer=http%3A%2F%2Fimage.bubuko.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1671267173&t=5d1df4c7b1043f63bcf583ceffddf4d3
---

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1630671540955-650bc67f-569a-4cef-a095-ec73a3b34897.png#clientId=uc20dad1f-a2b4-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=740&id=u64b4ea35&margin=%5Bobject%20Object%5D&name=image.png&originHeight=740&originWidth=1340&originalType=binary&ratio=1&rotation=0&showTitle=false&size=584856&status=done&style=none&taskId=u20a11e76-4e9c-49b4-8ca4-cc25eac0808&title=&width=1340#averageHue=%23efe7e7&crop=0&crop=0&crop=1&crop=1&id=FmDdj&originHeight=740&originWidth=1340&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1630672453989-c5f9d3cf-e77f-4c3e-8a9d-173b49f0aa4c.png#clientId=uc20dad1f-a2b4-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=473&id=ub505e50f&margin=%5Bobject%20Object%5D&name=image.png&originHeight=473&originWidth=1544&originalType=binary&ratio=1&rotation=0&showTitle=false&size=451836&status=done&style=none&taskId=u973d9d93-5ee4-44e2-9f50-b28d8e8f15e&title=&width=1544#averageHue=%23f6f6f6&crop=0&crop=0&crop=1&crop=1&id=N1Vbj&originHeight=473&originWidth=1544&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1630673109375-2f65953f-32f5-4be8-9353-9d08abb6587f.png#clientId=uc20dad1f-a2b4-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=794&id=uce851ada&margin=%5Bobject%20Object%5D&name=image.png&originHeight=794&originWidth=1520&originalType=binary&ratio=1&rotation=0&showTitle=false&size=669042&status=done&style=none&taskId=u1e0c19d3-9eae-4ab1-9e35-b33c4bbbcd6&title=&width=1520#averageHue=%23b2b1b0&crop=0&crop=0&crop=1&crop=1&id=zGC4d&originHeight=794&originWidth=1520&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 为什么要用 rabbitMQ？

### 1. 流量削峰

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1637998719062-ee3b7961-8606-40b9-9bd6-139143630402.png#clientId=udb8aea13-24db-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=91&id=u7a7d8c10&margin=%5Bobject%20Object%5D&name=image.png&originHeight=182&originWidth=990&originalType=binary&ratio=1&rotation=0&showTitle=false&size=78126&status=done&style=none&taskId=u903bdc4d-2ce4-4ac8-97d1-9cf8226327b&title=&width=495#averageHue=%23f3f3f3&crop=0&crop=0&crop=1&crop=1&id=Ds1E5&originHeight=182&originWidth=990&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 2. 应用解耦

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1637998760193-a4f14c2c-a22b-4c92-b207-ae58a962577a.png#clientId=udb8aea13-24db-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=182&id=u8f01ca2b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=363&originWidth=1085&originalType=binary&ratio=1&rotation=0&showTitle=false&size=190648&status=done&style=none&taskId=u30e77d52-0f3b-4d69-b06f-8229a9c232f&title=&width=542.5&referrerpolicy=no-referrer#averageHue=%23f7f7f7&crop=0&crop=0&crop=1&crop=1&id=hMEcn&originHeight=363&originWidth=1085&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 3. 异步处理

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638009293978-1fde3fa6-5de6-476b-bc8f-4381749e748c.png#clientId=udb8aea13-24db-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=315&id=u2602b5b4&margin=%5Bobject%20Object%5D&name=image.png&originHeight=630&originWidth=1167&originalType=binary&ratio=1&rotation=0&showTitle=false&size=283589&status=done&style=none&taskId=uf5236049-2c88-4e12-b15e-7d99585efad&title=&width=583.5#averageHue=%23f6f6f6&crop=0&crop=0&crop=1&crop=1&id=EqXpn&originHeight=630&originWidth=1167&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## RabbitMQ 核心部分

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638009378104-cb162a2f-4170-4d24-99c1-4e3ee09087ae.png#clientId=udb8aea13-24db-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=284&id=u45cac300&margin=%5Bobject%20Object%5D&name=image.png&originHeight=568&originWidth=1077&originalType=binary&ratio=1&rotation=0&showTitle=false&size=305514&status=done&style=none&taskId=u95a38925-5c34-45dd-bfca-d140d73dc3f&title=&width=538.5#averageHue=%23f8f2f1&crop=0&crop=0&crop=1&crop=1&id=TB3Zf&originHeight=568&originWidth=1077&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 各个名词介绍

### RabbitMQ 工作原理

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638009501957-eb0902f3-1fa1-47d5-9bc7-8d03f6e12de0.png#clientId=udb8aea13-24db-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=257&id=u79c375f5&margin=%5Bobject%20Object%5D&name=image.png&originHeight=514&originWidth=1060&originalType=binary&ratio=1&rotation=0&showTitle=false&size=210068&status=done&style=none&taskId=ue02a7c50-c563-46af-a784-5ae4c1dcdfe&title=&width=530#averageHue=%23efc150&crop=0&crop=0&crop=1&crop=1&id=sf1J3&originHeight=514&originWidth=1060&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638009567915-6084eb1d-d428-47ec-844f-b3b48c6c6d0c.png#clientId=udb8aea13-24db-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=310&id=u9337433a&margin=%5Bobject%20Object%5D&name=image.png&originHeight=619&originWidth=1135&originalType=binary&ratio=1&rotation=0&showTitle=false&size=776522&status=done&style=none&taskId=uced2ac5e-e117-4050-8e39-087f63ff410&title=&width=567.5#averageHue=%23e1dccf&crop=0&crop=0&crop=1&crop=1&id=ft4q6&originHeight=619&originWidth=1135&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638009610891-4a5dba18-6006-41bf-a068-b2f33ed7df48.png#clientId=udb8aea13-24db-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=63&id=u38d6f233&margin=%5Bobject%20Object%5D&name=image.png&originHeight=126&originWidth=1128&originalType=binary&ratio=1&rotation=0&showTitle=false&size=136646&status=done&style=none&taskId=u3dada18e-9ab8-40c9-8042-2e2f9f40306&title=&width=564#averageHue=%23cdc5b8&crop=0&crop=0&crop=1&crop=1&id=rJuNv&originHeight=126&originWidth=1128&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 安装

[rabbitmq.com/download.html](https://www.rabbitmq.com/download.html)
erlang 和 rabbitMQ 版本匹配：
[https://www.cnblogs.com/gne-hwz/p/10714013.html](https://www.cnblogs.com/gne-hwz/p/10714013.html)
安装：[https://blog.csdn.net/almahehe/article/details/75390572](https://blog.csdn.net/almahehe/article/details/75390572)
（建议看尚硅谷视频进行快速安装）
安装之后，可以访问 ip:15672 ，查看发送消息的端口（5672）和用户。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638169386681-e382c30c-baba-4fbb-bd40-aaa7b0a1eac6.png#clientId=uc4bbfa15-6ab6-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=173&id=u1a771f9c&margin=%5Bobject%20Object%5D&name=image.png&originHeight=102&originWidth=450&originalType=binary&ratio=1&rotation=0&showTitle=false&size=28980&status=done&style=none&taskId=ua13bea1f-438b-4ef8-8913-b4ccb9fa78c&title=&width=761.9931030273438#averageHue=%23f1f1f1&crop=0&crop=0&crop=1&crop=1&id=pNXMC&originHeight=102&originWidth=450&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 简单队列模式

### 生产者代码

1. 项目依赖：

```xml
<dependencies>
        <!--指定jdk编译版本-->
        <dependency>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.1</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/com.rabbitmq/amqp-client -->
        <!--rabbitmq依赖客户端-->
        <dependency>
            <groupId>com.rabbitmq</groupId>
            <artifactId>amqp-client</artifactId>
            <version>5.8.0</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/commons-io/commons-io -->
        <!--操作文件流的依赖-->
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>2.6</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-simple</artifactId>
            <version>1.7.25</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
```

2. 生产者代码：

```java
japackage com.atguigu.rabbitmq.one;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/11/28 22:15
 * 生产者 ：发消息
 */
public class Producer {
    //队列名称
    private static final String QUEUE_NAME = "hello";

    //发消息
    public static void main(String[] args) throws IOException, TimeoutException {
        //创建一个连接工厂
        ConnectionFactory factory = new ConnectionFactory();
        //设置工厂ip  连接rabbitmq的队列
        factory.setHost("59.110.171.189");
        //用户名
        factory.setUsername("admin");
        //密码
        factory.setPassword("123");
        //创建连接
        Connection connection = factory.newConnection();
        //获取信道
        Channel channel = connection.createChannel();
        /**
         * 生成一个队列
         * 参数；1.队列名称
         *      2.队列里面的消息是否持久化（磁盘），默认消息存储在内存中（不持久化false）
         *      3.该队列是否只供一个消费者进行消费，是否消息独有，true只允许一个消费者进行消费，默认是false（可以多个消费者消费）
                4. 是否自动删除，最后一个消费者断开连接后，该队列是否自动删除，true自动删除，false不自动删除
                5.其他参数（延迟消息......）
         */

        channel.queueDeclare(QUEUE_NAME,false,false,false,null);
        //发消息
        String message = "hello world";
        /**
         * 发送一个消息
         * 1. 发送到哪个交换机
         * 2. 路由的key值是哪个，本次是队列的名称
         * 3. 其他参数信息
         * 4. 发送消息的消息体
         */
        channel.basicPublish("",QUEUE_NAME,null,message.getBytes());
        System.out.println("消息发送完毕");
    }
}
```

如果运行报超时错误，需要打开云服务器的安全组 5672 端口。
（参考博客：[https://www.cnblogs.com/jxearlier/p/11920825.html](https://www.cnblogs.com/jxearlier/p/11920825.html)）

### 消费者代码

```xml
package com.atguigu.rabbitmq.one;

import com.rabbitmq.client.*;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/11/29 15:04
 * 消费者:接收消息
 */
public class Consumer {
    //队列名称
    public static final String QUEUE_NAME = "hello";

    //接收消息
    public static void main(String[] args) throws IOException, TimeoutException {
        //创建连接工厂
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("59.110.171.189");
        factory.setUsername("admin");
        factory.setPassword("123");
        Connection connection = factory.newConnection();
        Channel channel = connection.createChannel();
        //声明 接收消息
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println(message);
        };
        //取消消息时的回调
        CancelCallback cancelCallback = consumerTag -> {
            System.out.println("消息消费被中断");
        };
        /**
         * 消费者 消费消息
         * 1.消费哪个队列
         * 2. 消费成功之后是否要自动应答，true代表自动应答,false代表手动应答。
         * 3. 消费者未成功消费的回调。
         * 4. 消费者取消消费的回调
         */
        channel.basicConsume(QUEUE_NAME, true,deliverCallback,cancelCallback);
    }
}
```

运行结果：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638172828992-073b0df6-a480-4260-a724-e17e9191a44c.png#clientId=uc4bbfa15-6ab6-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=20&id=u3ee077b2&margin=%5Bobject%20Object%5D&name=image.png&originHeight=20&originWidth=296&originalType=binary&ratio=1&rotation=0&showTitle=false&size=2932&status=done&style=none&taskId=ud645c173-0157-49f2-89fb-5d58c2cd89a&title=&width=296#averageHue=%232f3e49&crop=0&crop=0&crop=1&crop=1&id=kWU4Y&originHeight=20&originWidth=296&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 测试生产者和消费者代码：

1. 先运行消费者代码，发现没有消息，再运行生产者代码，发送消息，再看消费者代码控制台，此时已经接收到消息。

## 工作队列模式

### 轮训分发消息

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638191830547-a43bbaa1-a524-4603-b6a9-0824e943cf9c.png#clientId=u43ded51d-0244-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=546&id=ucf96c5e0&margin=%5Bobject%20Object%5D&name=image.png&originHeight=546&originWidth=1278&originalType=binary&ratio=1&rotation=0&showTitle=false&size=220503&status=done&style=none&taskId=ub030755f-49df-4184-9d0d-65bfa0e561e&title=&width=1278#averageHue=%23f7f7f7&crop=0&crop=0&crop=1&crop=1&id=kyxCV&originHeight=546&originWidth=1278&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

1. 抽取连接工厂工具类：

```xml
package com.atguigu.rabbitmq.utils;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import java.io.IOException;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/11/29 19:48
 * 连接工厂创建信道的工具类
 */
public class RabbitMqUtils {
    public static Channel getChannel() throws IOException, TimeoutException {
        //创建连接工厂
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("59.110.171.189");
        factory.setUsername("admin");
        factory.setPassword("123");
        Connection connection = factory.newConnection();
        Channel channel = connection.createChannel();
        return channel;
    }
}
```

2. 工作线程代码：（消费者）

```xml
package com.atguigu.rabbitmq.two;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.CancelCallback;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;
import com.rabbitmq.client.Delivery;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/11/29 19:55
 * 这是一个工作线程（相当于之前的消费者）
 */
public class Worker01 {
    //队列名称
    public static final String QUEUE_NAME = "hello";

    //接收消息 的工作线程
    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //消息的接收
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println("接收到的消息：" + new String(message.getBody()));
        };
        //消息接收被取消时 执行
        CancelCallback cancelCallback = (consumerTag) -> {
            System.out.println(consumerTag + "消费者取消消费接口回调逻辑");
        };
        /*
         * 消费者 消费消息
         * 1.消费哪个队列
         * 2. 消费成功之后是否要自动应答，true代表自动应答,false代表手动应答。
         * 3. 消费者未成功消费的回调。
         * 4. 消费者取消消费的回调
         */
        channel.basicConsume(QUEUE_NAME, true, deliverCallback, cancelCallback);
    }
}
```

3. 启动两个工作线程（消费者）

前提是在 idea 设置允许方法多个并行运行：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638188489814-b081e679-bc7f-4cad-964e-bfb80575820c.png#clientId=u43ded51d-0244-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=636&id=uf61f07dc&margin=%5Bobject%20Object%5D&name=image.png&originHeight=869&originWidth=1143&originalType=binary&ratio=1&rotation=0&showTitle=false&size=94819&status=done&style=none&taskId=u4472c929-c48f-4a7d-ab7d-ec2994b75e5&title=&width=836.9862060546875#averageHue=%233b4043&crop=0&crop=0&crop=1&crop=1&id=zVInE&originHeight=869&originWidth=1143&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638188418807-97ce766a-47ef-458c-8413-d496cbcddbed.png#clientId=u43ded51d-0244-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=172&id=u35f12aab&margin=%5Bobject%20Object%5D&name=image.png&originHeight=172&originWidth=669&originalType=binary&ratio=1&rotation=0&showTitle=false&size=20804&status=done&style=none&taskId=uf688cf36-6dc9-43f1-be3d-946b8a45d78&title=&width=669#averageHue=%232a373f&crop=0&crop=0&crop=1&crop=1&id=yNG1N&originHeight=172&originWidth=669&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

4. 生产者代码：

```xml
package com.atguigu.rabbitmq.two;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;

import java.io.IOException;
import java.util.Scanner;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/11/29 21:04
 * 生产者 发送大量消息
 */
public class Task01 {
    public static final String QUEUE_NAME = "hello";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        /*
         * 生成一个队列
         * 参数；1.队列名称
         *      2.队列里面的消息是否持久化（磁盘），默认消息存储在内存中（不持久化false）
         *      3.该队列是否只供一个消费者进行消费，是否消息独有，true只允许一个消费者进行消费，默认是false（可以多个消费者消费）
         4. 是否自动删除，最后一个消费者断开连接后，该队列是否自动删除，true自动删除，false不自动删除
         5.其他参数（延迟消息......）
         */
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNext()) {
            String message = scanner.next();
            channel.basicPublish("", QUEUE_NAME, null, message.getBytes());
            System.out.println("发送消息完成：" + message);
        }
    }
}
```

5. 测试：启动生产者

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638192109706-2649384b-8559-4d7e-8609-220f576c3e25.png#clientId=u43ded51d-0244-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=275&id=u4261e57f&margin=%5Bobject%20Object%5D&name=image.png&originHeight=275&originWidth=591&originalType=binary&ratio=1&rotation=0&showTitle=false&size=25224&status=done&style=none&taskId=ue3dff20d-583f-4d0b-bb12-94ccae95bc1&title=&width=591#averageHue=%232c373d&crop=0&crop=0&crop=1&crop=1&id=PuJou&originHeight=275&originWidth=591&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
可以看见消费者轮循接收消息：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638192164342-16d183be-bbe5-4de9-bac4-d87bd87a746b.png#clientId=u43ded51d-0244-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=179&id=ue97a7cdb&margin=%5Bobject%20Object%5D&name=image.png&originHeight=179&originWidth=591&originalType=binary&ratio=1&rotation=0&showTitle=false&size=23018&status=done&style=none&taskId=u7cff6d1a-b142-4d52-a1c5-1cca6fd241e&title=&width=591#averageHue=%232f3c44&crop=0&crop=0&crop=1&crop=1&id=Upfv4&originHeight=179&originWidth=591&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638192176544-d380de90-ff7a-48a7-a080-c4a1ac193460.png#clientId=u43ded51d-0244-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=198&id=ubb73d589&margin=%5Bobject%20Object%5D&name=image.png&originHeight=198&originWidth=598&originalType=binary&ratio=1&rotation=0&showTitle=false&size=23978&status=done&style=none&taskId=u3ac63e3a-6d82-4340-9fed-c68c8fbf564&title=&width=598#averageHue=%232f3b43&crop=0&crop=0&crop=1&crop=1&id=xLv8Q&originHeight=198&originWidth=598&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 消息应答

### 自动应答

不建议使用，仅适用在消费者可以高效并以某种速率能够处理这些消息的情况。

### 手动应答

#### 消息应答的方法：

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638193415623-6b7ff26f-8cc3-4abd-b1c6-41f79897f0cf.png#clientId=u43ded51d-0244-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=312&id=ud16b0385&margin=%5Bobject%20Object%5D&name=image.png&originHeight=312&originWidth=737&originalType=binary&ratio=1&rotation=0&showTitle=false&size=100867&status=done&style=none&taskId=u39cf8244-b605-4c5d-baca-fe2103cd9d3&title=&width=737#averageHue=%23f5f5f5&crop=0&crop=0&crop=1&crop=1&id=S2b1y&originHeight=312&originWidth=737&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

#### 批量处理 Multiple

手动应答的好处：可以批量应答，并减少网络拥堵。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638282925466-4d3081e6-809c-4a5f-9472-741dacb0cc7c.png#clientId=ub82069db-0272-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=588&id=u97ebb457&margin=%5Bobject%20Object%5D&name=image.png&originHeight=811&originWidth=1024&originalType=binary&ratio=1&rotation=0&showTitle=false&size=292383&status=done&style=none&taskId=uf04a703e-97b1-4fe2-b58f-33d8b0dff4d&title=&width=741.9931030273438#averageHue=%23f6f5f5&crop=0&crop=0&crop=1&crop=1&id=rUzZh&originHeight=811&originWidth=1024&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
但是批量应答可能会丢失消息。所以尽量不要批量应答，将 multiple 设置为 false。

### 消息自动重新入队

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638317239422-ab1bab41-ac6f-4a05-b3c5-c539d9e6dcd1.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=85&id=u97c18f3b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=79&originWidth=665&originalType=binary&ratio=1&rotation=0&showTitle=false&size=57746&status=done&style=none&taskId=u14e494b5-3291-4daf-ada5-47aafa5eab0&title=&width=715.0000610351562#averageHue=%23ebeae9&crop=0&crop=0&crop=1&crop=1&id=qAYOD&originHeight=79&originWidth=665&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638317701734-1133a417-ebbe-4ad9-8453-f0803583491a.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=308&id=u7be19416&margin=%5Bobject%20Object%5D&name=image.png&originHeight=469&originWidth=1088&originalType=binary&ratio=1&rotation=0&showTitle=false&size=306122&status=done&style=none&taskId=u7d90ec89-bd9a-4090-bda5-c09c6014c27&title=&width=714.9862060546875#averageHue=%23e5e4df&crop=0&crop=0&crop=1&crop=1&id=o9cFt&originHeight=469&originWidth=1088&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
测试：

1.  生产者：

```xml
package com.atguigu.rabbitmq.three;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;

import java.io.IOException;
import java.util.Scanner;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/1 14:46
 * 消息在手动应答时不丢失,放回队列中重新消费
 */
public class Task2 {
    //队列名称
    public static final String TASK_QUEUE_NAME = "ack_queue";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //声明队列
        channel.queueDeclare(TASK_QUEUE_NAME, false, false, false, null);
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNext()) {
            String message = scanner.next();
            channel.basicPublish("", TASK_QUEUE_NAME, null, message.getBytes());
            System.out.println("生产者发出消息：" + message);
        }
    }
}
```

2. 两个消费者（消息手动应答）：

消费者一：

```xml
package com.atguigu.rabbitmq.three;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.atguigu.rabbitmq.utils.SleepUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/1 14:58
 * 消息在手动应答时不丢失，放回队列中重新消费
 */
public class Work03 {
    //队列名称
    public static final String TASK_QUEUE_NAME = "ack_queue";

    //接收消息
    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        System.out.println("C1等待接收消息处理时间较短");
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            //沉睡1s
            SleepUtils.sleep(1);
            System.out.println("接收到的消息：" + new String(message.getBody(), StandardCharsets.UTF_8));
            //手动应答（通过信道）
            /*参数：
            1. 消息的标记 tag
            2. 是否批量应答  false:不批量应答信道中的消息，true:批量
             */
            channel.basicAck(message.getEnvelope().getDeliveryTag(), false);
        };
        //采用手动应答
        boolean autoAck = false;
        channel.basicConsume(TASK_QUEUE_NAME, autoAck, deliverCallback, (consumerTag -> {
            System.out.println(consumerTag + "消费者取消消费接口的回调逻辑");
        }));
    }
}
```

消费者二：

```xml
package com.atguigu.rabbitmq.three;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.atguigu.rabbitmq.utils.SleepUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/1 14:58
 * 消息在手动应答时不丢失，放回队列中重新消费
 */
public class Work04 {
    //队列名称
    public static final String TASK_QUEUE_NAME = "ack_queue";

    //接收消息
    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        System.out.println("C2等待接收消息处理时间较短");
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            //沉睡1s
            SleepUtils.sleep(30);
            System.out.println("接收到的消息：" + new String(message.getBody(), StandardCharsets.UTF_8));
            //手动应答（通过信道）
            /*参数：
            1. 消息的标记 tag
            2. 是否批量应答  false:不批量应答信道中的消息，true:批量
             */
            channel.basicAck(message.getEnvelope().getDeliveryTag(), false);
        };
        //采用手动应答
        boolean autoAck = false;
        channel.basicConsume(TASK_QUEUE_NAME, autoAck, deliverCallback, (consumerTag -> {
            System.out.println(consumerTag + "消费者取消消费接口的回调逻辑");
        }));
    }
}
```

测试步骤：
① 先启动 task2，创建 ack_queue 队列；（在 ip:15672 的 queue 列表中可以看到目前拥有的队列）
② 启动 work02，work03 接收消息（消费者）；
③ 发消息：在 task2 控制台输入 aa,bb,cc,dd,ee,ff，可以看到 work2 和 work3 是轮训接收消息；如果到 work03 应该接收消息 ee 时，work03 突然挂掉，此时 ee 会被转发给 work02 中的 C1，这时 C1 会接收到 ee，因此消息不会丢失，这说明了 rabbitmq 有手动应答的能力，只要没有收到消息，就不会手动应答，从而将消息放回队列。而队列又再次将消息传递给 C1 进行重新消费，从而导致 ee 并没有丢失。![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638348662336-051f5011-f512-44d1-bb05-053e49ba050c.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=499&id=u60c5aa9e&margin=%5Bobject%20Object%5D&name=image.png&originHeight=499&originWidth=1092&originalType=binary&ratio=1&rotation=0&showTitle=false&size=254728&status=done&style=none&taskId=u6c03afcd-9d58-4d4b-b839-5e4801e20e0&title=&width=1092#averageHue=%23f5f5f5&crop=0&crop=0&crop=1&crop=1&id=Rq0q6&originHeight=499&originWidth=1092&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 队列持久化

如果存在同名未被持久化的队列，则需要先删除原先的未被持久化的队列，再重新生成一个持久化队列。

```java
//声明队列
boolean durable = true; //在生产者中，需要让queue进行持久化
channel.queueDeclare(TASK_QUEUE_NAME, durable, false, false, null);
```

生成一个持久化队列之后，在 rabbitmq 控制台中这个队列的 features 属性会出现 D（代表持久化）。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638359722330-59d15b49-1b8d-4d93-85aa-ecd40227bd45.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=129&id=ufd6f763b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=129&originWidth=781&originalType=binary&ratio=1&rotation=0&showTitle=false&size=13881&status=done&style=none&taskId=uab54d6ef-4036-4edf-bca6-ba4a9dcac1d&title=&width=781#averageHue=%23f3f1f0&crop=0&crop=0&crop=1&crop=1&id=iMXeX&originHeight=129&originWidth=781&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 消息持久化

```java
//设置生产者发送消息为持久化消息（要求保存到磁盘上MessageProperties.PERSISTENT_TEXT_PLAIN）
channel.basicPublish("", TASK_QUEUE_NAME, MessageProperties.PERSISTENT_TEXT_PLAIN, message.getBytes());
```

## 不公平分发

```java
//在消费者中接收消息之前设置不公平分发
int prefetchCount = 1;
channel.basicQos(prefetchCount);
```

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638361240814-a1349c7f-2e3e-410a-ba3b-f2f872fab0bb.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=232&id=u1ff04a34&margin=%5Bobject%20Object%5D&name=image.png&originHeight=232&originWidth=385&originalType=binary&ratio=1&rotation=0&showTitle=false&size=20173&status=done&style=none&taskId=ub1b60899-802e-4d67-9aed-a99c48b5db3&title=&width=385#averageHue=%23303d45&crop=0&crop=0&crop=1&crop=1&id=vTMLG&originHeight=232&originWidth=385&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638361251165-68b13d22-fe49-4fd8-9471-26161051c180.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=177&id=u477bebf6&margin=%5Bobject%20Object%5D&name=image.png&originHeight=177&originWidth=431&originalType=binary&ratio=1&rotation=0&showTitle=false&size=18613&status=done&style=none&taskId=ue60522ee-50ed-46f9-ae69-472369ce4b6&title=&width=431#averageHue=%232c3a42&crop=0&crop=0&crop=1&crop=1&id=zGQk4&originHeight=177&originWidth=431&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 预取值

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638361857297-fa168e46-191d-44b2-8ce2-df2cb52a382d.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=282&id=ue1e2c233&margin=%5Bobject%20Object%5D&name=image.png&originHeight=453&originWidth=1130&originalType=binary&ratio=1&rotation=0&showTitle=false&size=347909&status=done&style=none&taskId=ue241edd5-d375-46cb-9668-4a4eb4d7c9c&title=&width=703.0000610351562#averageHue=%23e4e4e5&crop=0&crop=0&crop=1&crop=1&id=mwjn3&originHeight=453&originWidth=1130&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

```java
int prefetchCount = 5;
channel.basicQos(prefetchCount);
```

## 发布确认原理

## ![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638364988019-b29d7c44-ebca-4978-95fd-034500d1bd7b.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=369&id=u98ff6bb0&margin=%5Bobject%20Object%5D&name=image.png&originHeight=369&originWidth=930&originalType=binary&ratio=1&rotation=0&showTitle=false&size=222643&status=done&style=none&taskId=ua25c2547-8233-4893-8d5b-4406b84e85f&title=&width=930#averageHue=%23fafafb&crop=0&crop=0&crop=1&crop=1&id=Xek0V&originHeight=369&originWidth=930&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

在信道之后开启发布确认：

```java
//信道开启发布确认
channel.confirmSelect();
```

## 单个发布确认

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638365489548-64267da5-f60d-4b88-98af-bdf5806d5038.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=203&id=ub1148f56&margin=%5Bobject%20Object%5D&name=image.png&originHeight=203&originWidth=993&originalType=binary&ratio=1&rotation=0&showTitle=false&size=342872&status=done&style=none&taskId=u2df32a3e-4c69-4599-868a-d81e33495ec&title=&width=993#averageHue=%23d0dcda&crop=0&crop=0&crop=1&crop=1&id=qVQAu&originHeight=203&originWidth=993&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

```java
package com.atguigu.rabbitmq.four;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;

import java.io.IOException;
import java.util.UUID;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/1 21:32
 * 发布确认模式：
 * 使用的时间  比较哪种确认方式是最好的
 * 1.单个确认
 * 2.批量确认
 * 3.异步批量确认
 */
public class ConfireMessage {
    //批量发消息的个数
    public static final int MESSAGE_COUNT = 1000;

    public static void main(String[] args) throws InterruptedException, TimeoutException, IOException {
        //1. 单个确认
        ConfireMessage.publicMessageIndividually(); //发布1000个单独确认消息，耗时29726ms
    }

    //单个确认
    public static void publicMessageIndividually() throws IOException, TimeoutException, InterruptedException {
        Channel channel = RabbitMqUtils.getChannel();
        String queueName = UUID.randomUUID().toString();
        //用信道声明队列
        channel.queueDeclare(queueName, true, false, false, null);
        //开启发布确认
        channel.confirmSelect();
        //开始时间
        long begin = System.currentTimeMillis();
        //批量发消息
        for (int i = 0; i < MESSAGE_COUNT; i++) {
            String massage = i + "";
            channel.basicPublish("", queueName, null, massage.getBytes());
            //单个消息就马上进行发布确认
            boolean flag = channel.waitForConfirms();
            if (flag) {
                System.out.println("消息发送成功");
            }
        }
        long end = System.currentTimeMillis();
        System.out.println("发布"+MESSAGE_COUNT+"个单独确认消息，耗时"+(end - begin)+"ms");
    }
}
```

## 批量发布确认

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638366964213-10397181-357d-4896-9e91-84690b69c982.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=137&id=ude627a73&margin=%5Bobject%20Object%5D&name=image.png&originHeight=137&originWidth=968&originalType=binary&ratio=1&rotation=0&showTitle=false&size=206130&status=done&style=none&taskId=u0c3dafe3-1f66-4cc1-83ba-f5e8edae8b3&title=&width=968#averageHue=%23d7d9d8&crop=0&crop=0&crop=1&crop=1&id=tMsLz&originHeight=137&originWidth=968&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

```java
//批量发布确认
    public static void publicMessageBatch() throws IOException, TimeoutException, InterruptedException {
        Channel channel = RabbitMqUtils.getChannel();
        String queueName = UUID.randomUUID().toString();
        //用信道声明队列
        channel.queueDeclare(queueName, true, false, false, null);
        //开启发布确认
        channel.confirmSelect();
        //开始时间
        long begin = System.currentTimeMillis();
        //批量确认消息大小
        int batchSize = 100;
        //批量发布消息， 批量发布确认
        for (int i = 0; i < MESSAGE_COUNT; i++) {
            String message = i + "";
            channel.basicPublish("", queueName, null, message.getBytes());
            //发布确认
            if (i % batchSize == 0) {
                channel.waitForConfirms();
            }
        }
        long end = System.currentTimeMillis();
        System.out.println("发布" + MESSAGE_COUNT + "个批量确认消息，耗时" + (end - begin) + "ms");
    }
```

## 异步发布确认

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638368249755-46e1c3b8-f891-48b0-a77b-21b9a80f4e5e.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=119&id=u5fcd19f7&margin=%5Bobject%20Object%5D&name=image.png&originHeight=119&originWidth=1189&originalType=binary&ratio=1&rotation=0&showTitle=false&size=231115&status=done&style=none&taskId=u473c99f9-e088-4ad3-84e3-82e606c7d63&title=&width=1189#averageHue=%23e2dfd4&crop=0&crop=0&crop=1&crop=1&id=Jwh7I&originHeight=119&originWidth=1189&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638368124379-5cdb8cbd-707a-4a1f-92f4-3dc511a9ec11.png#clientId=u446e2507-b64d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=571&id=u4b5d988b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=441&originWidth=964&originalType=binary&ratio=1&rotation=0&showTitle=false&size=239080&status=done&style=none&taskId=ua0b85de0-7119-4e3a-a0be-75854b9aaac&title=&width=1248.9931030273438#averageHue=%23f7f7f7&crop=0&crop=0&crop=1&crop=1&id=T1TVR&originHeight=441&originWidth=964&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

```java
//批量发消息的个数
    public static final int MESSAGE_COUNT = 1000;

    public static void main(String[] args) throws InterruptedException, TimeoutException, IOException {
        //1. 单个确认
//        ConfireMessage.publicMessageIndividually(); //发布1000个单独确认消息，耗时29726ms
//        2. 批量确认
//        ConfireMessage.publicMessageBatch();  //发布1000个批量确认消息，耗时761ms（弊端：无法确认哪个消息未被确认）
//        3. 异步确认
        ConfireMessage.publicMessageAsync(); //发布1000个异步确认消息，耗时181ms
    }
//异步发布确认
    public static void publicMessageAsync() throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        String queueName = UUID.randomUUID().toString();
        //用信道声明队列
        channel.queueDeclare(queueName, true, false, false, null);
        //开启发布确认
        channel.confirmSelect();
        //开始时间
        long begin = System.currentTimeMillis();
        //消息确认成功，回调函数
        ConfirmCallback ackCallback = (deliveryTag, multiple) -> {
            System.out.println("确认的消息" + deliveryTag);
        };
        //消息确认失败，回调函数
        ConfirmCallback nackCallback = (deliveryTag, multiple) -> {
            System.out.println("未确认的消息" + deliveryTag);
        };
        //准备消息的监听器，监听哪些消息成功了，哪些消息失败了
        channel.addConfirmListener(ackCallback, nackCallback);  //异步通知
        //异步发布确认
        for (int i = 0; i < MESSAGE_COUNT; i++) {
            String massage = "消息" + i;
            channel.basicPublish("", queueName, null, massage.getBytes());

        }
        long end = System.currentTimeMillis();
        System.out.println("发布" + MESSAGE_COUNT + "个异步确认消息，耗时" + (end - begin) + "ms");
    }
```

## 如何处理异步未确认消息

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638404469016-06a08296-9aa6-4d65-8d1c-4c70fb4cd5b8.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=97&id=u0927e367&margin=%5Bobject%20Object%5D&name=image.png&originHeight=97&originWidth=1033&originalType=binary&ratio=1&rotation=0&showTitle=false&size=122865&status=done&style=none&taskId=u67d3a3c6-2f1a-4be9-9c0c-f7d2e743935&title=&width=1033#averageHue=%23dcd8cd&crop=0&crop=0&crop=1&crop=1&id=frSPr&originHeight=97&originWidth=1033&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
上述异步确认有两个线程：

- 发消息的线程
- 监听器的线程

两个线程之间交互，只能用**并发链路式队列（可以在确认发布与发布线程之间进行消息传递）**。

```java
//异步发布确认
    public static void publicMessageAsync() throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        String queueName = UUID.randomUUID().toString();
        //用信道声明队列
        channel.queueDeclare(queueName, true, false, false, null);
        //开启发布确认
        channel.confirmSelect();
        /*
        线程安全有序的哈希表，适用于高并发的情况
        1. 轻松的将序号与消息进行关联
        2. 轻松批量删除条目，只要给序号
        3.支持高并发(多线程)
         */
        ConcurrentSkipListMap<Long,String> outstandingConfirms = new ConcurrentSkipListMap<>();

        //消息确认成功，回调函数
        ConfirmCallback ackCallback = (deliveryTag, multiple) -> {
            //2. 删除已经确认的消息   剩下的就是未确认的消息
            if(multiple){
                //如果是批量确认，就去批量删除
                ConcurrentNavigableMap<Long,String> confirmed = outstandingConfirms.headMap(deliveryTag);
                confirmed.clear();
            }else{
                //如果是单个确认，就去单个删除
                outstandingConfirms.remove(deliveryTag);
            }
            System.out.println("确认的消息" + deliveryTag);
        };
        //消息确认失败，回调函数
        ConfirmCallback nackCallback = (deliveryTag, multiple) -> {
            //3. 打印未确认的消息有哪些
            String message = outstandingConfirms.get(deliveryTag);
            System.out.println("未确认的消息是："+message+":::::未确认的消息tag:" + deliveryTag);
        };
        //准备消息的监听器，监听哪些消息成功了，哪些消息失败了
        channel.addConfirmListener(ackCallback, nackCallback);  //异步通知
        //开始时间
        long begin = System.currentTimeMillis();
        //批量发送消息
        for (int i = 0; i < MESSAGE_COUNT; i++) {
            String message = "消息" + i;
            // 1. 此处记录下所有要发送的消息  消息的总和(每发一次消息就记录一次)
            outstandingConfirms.put(channel.getNextPublishSeqNo(),message);
            channel.basicPublish("", queueName, null, message.getBytes());

        }
        long end = System.currentTimeMillis();
        System.out.println("发布" + MESSAGE_COUNT + "个异步确认消息，耗时" + (end - begin) + "ms");
    }
```

> 以上三种发布确认速度对比：

- 单独发布消息：同步等待确认，简单，但吞吐量非常有限。
- 批量发布消息：批量同步等待确认，简单，合理的吞吐量，一旦出现问题，很难推断出是哪条出现了问题
- 异步处理：最佳性能和资源利用，在出现错误的情况下，可以很好的控制，但是实现起来稍微难些。

## 交换机

### 交换机的作用

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638406810806-e429e00e-78d1-42e2-ab92-c3a53f8c2fa9.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=270&id=uc3415ba1&margin=%5Bobject%20Object%5D&name=image.png&originHeight=387&originWidth=1291&originalType=binary&ratio=1&rotation=0&showTitle=false&size=191628&status=done&style=none&taskId=uee2f50b0-7b80-4d38-9c1b-25806445f5f&title=&width=900.9896240234375#averageHue=%23f5f4f4&crop=0&crop=0&crop=1&crop=1&id=tFgNi&originHeight=387&originWidth=1291&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 交换机的类型

- 直接（direct）== 路由类型
- 主题（topic）
- 标题（headers）（企业不常用）
- 扇出（fanout）== 发布订阅类型
- 无名类型（默认类型），通常用空串进行识别

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638407294007-f1bd9624-be98-4b90-ba72-9c29d88c326d.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=76&id=u21ac6756&margin=%5Bobject%20Object%5D&name=image.png&originHeight=76&originWidth=987&originalType=binary&ratio=1&rotation=0&showTitle=false&size=103665&status=done&style=none&taskId=u47150f74-3b3b-4cc4-befe-f25d9650214&title=&width=987#averageHue=%23cbc7bb&crop=0&crop=0&crop=1&crop=1&id=KlfHY&originHeight=76&originWidth=987&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 临时队列

不带有持久化，一旦断开消费者的连接，队列将被自动删除。

创建临时队列：

```java
String queueName = channel.queueDeclare().getQueue();
```

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638407906977-786b78e8-bfba-4cab-9aee-9ac7ec38a884.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=278&id=u31ce7deb&margin=%5Bobject%20Object%5D&name=image.png&originHeight=410&originWidth=1086&originalType=binary&ratio=1&rotation=0&showTitle=false&size=55531&status=done&style=none&taskId=ub3aa0ca4-c823-418b-b8c7-0b7fbd67333&title=&width=736.9896240234375#averageHue=%23f4f2f1&crop=0&crop=0&crop=1&crop=1&id=T0K86&originHeight=410&originWidth=1086&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 绑定

就是交换机与队列之间的捆绑关系。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638408143523-d4c904d9-33e5-46bd-ad67-885e78b4c34b.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=637&id=u8140e36d&margin=%5Bobject%20Object%5D&name=image.png&originHeight=637&originWidth=487&originalType=binary&ratio=1&rotation=0&showTitle=false&size=26522&status=done&style=none&taskId=ua5ea4c46-36c5-4183-aefe-f6a3f676385&title=&width=487#averageHue=%23faf5f5&crop=0&crop=0&crop=1&crop=1&id=fwITJ&originHeight=637&originWidth=487&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 发布订阅模式（扇出模式 fanout）

类似广播，两个 routingkey 相同
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638408427104-577b627a-521a-4d94-89be-5bf0102440ea.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=218&id=u3ae99c2f&margin=%5Bobject%20Object%5D&name=image.png&originHeight=292&originWidth=1200&originalType=binary&ratio=1&rotation=0&showTitle=false&size=205919&status=done&style=none&taskId=ufe252eb8-02f2-410e-8b74-b8d091c0d4a&title=&width=894#averageHue=%23f8ebea&crop=0&crop=0&crop=1&crop=1&id=PeGnm&originHeight=292&originWidth=1200&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

1. 生产者

```java
package com.atguigu.rabbitmq.five;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 9:59
 * 发消息：交换机
 */
public class EmitLog {
    public static final String EXCHANGE_NAME = "logs";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        channel.exchangeDeclare(EXCHANGE_NAME, "fanout");
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNext()) {
            String message = scanner.next();
            channel.basicPublish(EXCHANGE_NAME, "", null, message.getBytes(StandardCharsets.UTF_8));
            System.out.println("生产者发出消息：" + message);
        }
    }
}
```

2. 两个消费者

```java
package com.atguigu.rabbitmq.five;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 9:35
 */
public class ReceiveLogs01 {
    //交换机的名称
    public static final String EXCHANGE_NAME = "logs";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //声明一个交换机
        channel.exchangeDeclare(EXCHANGE_NAME, "fanout");
        //声明一个队列  临时队列 (生成一个临时队列，队列的名称是随机的，当消费者断开与队列的连接的时候，队列就自动删除)
        String queueName = channel.queueDeclare().getQueue();
        //绑定交换机与队列
        channel.queueBind(queueName, EXCHANGE_NAME, "");
        System.out.println("等待接收消息，把接收的消息打印在屏幕上。。。。");
        //接收消息
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println("ReceiveLogs01控制台接收到消息：" + new String(message.getBody(), StandardCharsets.UTF_8));
        };
        channel.basicConsume(queueName, true,  deliverCallback,consumerTag->{});
    }
}
```

```java
package com.atguigu.rabbitmq.five;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 9:35
 */
public class ReceiveLogs02 {
    //交换机的名称
    public static final String EXCHANGE_NAME = "logs";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //声明一个交换机
        channel.exchangeDeclare(EXCHANGE_NAME, "fanout");
        //声明一个队列  临时队列 (生成一个临时队列，队列的名称是随机的，当消费者断开与队列的连接的时候，队列就自动删除)
        String queueName = channel.queueDeclare().getQueue();
        //绑定交换机与队列
        channel.queueBind(queueName, EXCHANGE_NAME, "");
        System.out.println("等待接收消息，把接收的消息打印在屏幕上。。。。");
        //接收消息
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println("ReceiveLogs02控制台接收到消息：" + new String(message.getBody(), StandardCharsets.UTF_8));
        };
        channel.basicConsume(queueName, true,  deliverCallback,consumerTag->{});
    }
}
```

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638410904168-80b297c1-26ef-4ee4-815c-065abea79bd2.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=328&id=u29891926&margin=%5Bobject%20Object%5D&name=image.png&originHeight=328&originWidth=580&originalType=binary&ratio=1&rotation=0&showTitle=false&size=28269&status=done&style=none&taskId=u6700fa8b-9b2f-4717-91cf-0dfb20b528b&title=&width=580#averageHue=%232c383f&crop=0&crop=0&crop=1&crop=1&id=Jf7Cl&originHeight=328&originWidth=580&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638410913426-c4d1faa3-7b8b-478c-ba35-665d73e98e8b.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=248&id=ua55ed718&margin=%5Bobject%20Object%5D&name=image.png&originHeight=248&originWidth=528&originalType=binary&ratio=1&rotation=0&showTitle=false&size=34020&status=done&style=none&taskId=u415b65a3-7d21-4e16-a1a0-a15d7f3c4ca&title=&width=528#averageHue=%23323e46&crop=0&crop=0&crop=1&crop=1&id=HNmyl&originHeight=248&originWidth=528&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638410920504-2f4c6248-02a0-4765-8647-4c8ab63551e1.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=255&id=u9c537a4f&margin=%5Bobject%20Object%5D&name=image.png&originHeight=255&originWidth=517&originalType=binary&ratio=1&rotation=0&showTitle=false&size=35282&status=done&style=none&taskId=u97bfb701-f8bd-45ca-ac41-6f8259d9775&title=&width=517#averageHue=%23323e46&crop=0&crop=0&crop=1&crop=1&id=BBNfG&originHeight=255&originWidth=517&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 直接交换机（路由模式 direct）

两个 routingkey 不相同
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638411099834-bf80fb1d-473a-4a01-8553-e47ee2cd3670.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=303&id=ueba6aa41&margin=%5Bobject%20Object%5D&name=image.png&originHeight=303&originWidth=874&originalType=binary&ratio=1&rotation=0&showTitle=false&size=98369&status=done&style=none&taskId=u2145da18-8429-4959-ab30-43bcc28bb61&title=&width=874#averageHue=%23f6e6e4&crop=0&crop=0&crop=1&crop=1&id=t5eGH&originHeight=303&originWidth=874&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
可以多重绑定。
**生产者发消息给队列，直接交换机通过不同 routingkey 路由到相应的队列，然后消费者接收指定日志。**

1. 发消息

```java
package com.atguigu.rabbitmq.six;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 9:59
 * 发消息：交换机
 */
public class DirectLogs {
    public static final String EXCHANGE_NAME = "direct_logs";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNext()) {
            String message = scanner.next();
            channel.basicPublish(EXCHANGE_NAME, "error", null, message.getBytes(StandardCharsets.UTF_8));
            System.out.println("生产者发出消息：" + message);
        }
    }
}
```

2. 接收消息

```java
package com.atguigu.rabbitmq.six;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.BuiltinExchangeType;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 10:15
 */
public class ReceiveLogsDirect01 {
    public static final String EXCHANGE_NAME = "direct_logs";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //声明一个交换机
        channel.exchangeDeclare(EXCHANGE_NAME, BuiltinExchangeType.DIRECT);
        //声明一个队列
        channel.queueDeclare("console",false,false,false,null);
        channel.queueBind("console",EXCHANGE_NAME,"info");
        channel.queueBind("console",EXCHANGE_NAME,"warning");
        //接收消息
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println("ReceiveLogs01控制台接收到消息：" + new String(message.getBody(), StandardCharsets.UTF_8));
        };
        channel.basicConsume("console", true,  deliverCallback,consumerTag->{});

    }
}
```

```java
package com.atguigu.rabbitmq.six;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.BuiltinExchangeType;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 10:15
 */
public class ReceiveLogsDirect02 {
    public static final String EXCHANGE_NAME = "direct_logs";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //声明一个交换机
        channel.exchangeDeclare(EXCHANGE_NAME, BuiltinExchangeType.DIRECT);
        //声明一个队列
        channel.queueDeclare("disk",false,false,false,null);
        channel.queueBind("disk",EXCHANGE_NAME,"error");
        //接收消息
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println("ReceiveLogs02控制台接收到消息：" + new String(message.getBody(), StandardCharsets.UTF_8));
        };
        channel.basicConsume("disk", true,  deliverCallback,consumerTag->{});

    }
}
```

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638413931242-2c3ef4c2-f3e6-4e6e-ba39-5437dad24d40.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=182&id=u9de2b784&margin=%5Bobject%20Object%5D&name=image.png&originHeight=182&originWidth=630&originalType=binary&ratio=1&rotation=0&showTitle=false&size=21691&status=done&style=none&taskId=u7cd93b89-df35-4f94-aa33-6626b0dc70b&title=&width=630#averageHue=%232c3941&crop=0&crop=0&crop=1&crop=1&id=eyPPs&originHeight=182&originWidth=630&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638413948375-568b73ae-0203-4f53-9a9b-528667192aa2.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=182&id=uc8400be0&margin=%5Bobject%20Object%5D&name=image.png&originHeight=182&originWidth=683&originalType=binary&ratio=1&rotation=0&showTitle=false&size=24900&status=done&style=none&taskId=u38d71d59-3dd8-4324-9fae-335fd043524&title=&width=683#averageHue=%232e3b43&crop=0&crop=0&crop=1&crop=1&id=U0kJT&originHeight=182&originWidth=683&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 主题交换机（Topic）

规范：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638414479059-98f3dc8e-ee99-4093-b2cb-81eaecec9acb.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=226&id=u34e92b6a&margin=%5Bobject%20Object%5D&name=image.png&originHeight=226&originWidth=834&originalType=binary&ratio=1&rotation=0&showTitle=false&size=170475&status=done&style=none&taskId=ue217ff8b-9da9-493e-9a4b-07c6ab22bab&title=&width=834#averageHue=%23cfcac1&crop=0&crop=0&crop=1&crop=1&id=KCIOt&originHeight=226&originWidth=834&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638415621949-8c1e4089-881d-482e-a377-ab7f224a2c92.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=257&id=u76cf3ab8&margin=%5Bobject%20Object%5D&name=image.png&originHeight=257&originWidth=801&originalType=binary&ratio=1&rotation=0&showTitle=false&size=151366&status=done&style=none&taskId=u98d7748e-2fc6-4df3-a740-cae3ba06db9&title=&width=801#averageHue=%23e6a198&crop=0&crop=0&crop=1&crop=1&id=HeQJL&originHeight=257&originWidth=801&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638415680787-e95ef7a6-bec4-44b3-8e45-1e0c4adac6f7.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=350&id=u280d2c9d&margin=%5Bobject%20Object%5D&name=image.png&originHeight=350&originWidth=829&originalType=binary&ratio=1&rotation=0&showTitle=false&size=181864&status=done&style=none&taskId=u67807a72-c793-4b0b-a14e-e6270164016&title=&width=829#averageHue=%23e08176&crop=0&crop=0&crop=1&crop=1&id=ZuvJl&originHeight=350&originWidth=829&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638415855921-8e2750b0-e5df-4b1c-90a3-7e3f696543d6.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=188&id=uf97e55b4&margin=%5Bobject%20Object%5D&name=image.png&originHeight=188&originWidth=920&originalType=binary&ratio=1&rotation=0&showTitle=false&size=178229&status=done&style=none&taskId=ufb1118a1-0b9d-4a97-bd09-0ff626585f5&title=&width=920#averageHue=%23c2beb2&crop=0&crop=0&crop=1&crop=1&id=iZC7I&originHeight=188&originWidth=920&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 主题交换机（实战）

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638416303199-5f9e655c-c5c2-4a16-9d12-ba873c31c8e6.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=331&id=u07108cc7&margin=%5Bobject%20Object%5D&name=image.png&originHeight=331&originWidth=1114&originalType=binary&ratio=1&rotation=0&showTitle=false&size=231103&status=done&style=none&taskId=ud57ef875-e371-4fa6-980a-20a29a7366e&title=&width=1114#averageHue=%23f4eae8&crop=0&crop=0&crop=1&crop=1&id=zgYBJ&originHeight=331&originWidth=1114&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

1. 消费者

```java
package com.atguigu.rabbitmq.seven;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 11:37
 * 声明主题交换机  及相关队列
 * <p>
 * 消费者 C2
 */
public class ReceiveLogsTopic01 {
    //交换机名称
    public static final String EXCHANGE_NAME = "topic_logs";

    //接收消息
    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //声明交换机
        channel.exchangeDeclare(EXCHANGE_NAME, "topic");
        //声明队列
        String queueName = "Q1";
        channel.queueDeclare(queueName, false, false, false, null);
        //交换机绑定 routingkey
        channel.queueBind(queueName, EXCHANGE_NAME, "*.orange.*");
        System.out.println("等待接收消息。。。。。");
        //接收消息
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println(new String(message.getBody(), StandardCharsets.UTF_8));
            System.out.println("接收队列：" + queueName + "绑定键：" + message.getEnvelope().getRoutingKey());
        };
        //接收消息
        channel.basicConsume(queueName, true, deliverCallback, consumerTag -> {
        });
    }

}
```

```java
package com.atguigu.rabbitmq.seven;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 11:37
 * 声明主题交换机  及相关队列
 * <p>
 * 消费者 C2
 */
public class ReceiveLogsTopic02 {
    //交换机名称
    public static final String EXCHANGE_NAME = "topic_logs";

    //接收消息
    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //声明交换机
        channel.exchangeDeclare(EXCHANGE_NAME, "topic");
        //声明队列
        String queueName = "Q2";
        channel.queueDeclare(queueName, false, false, false, null);
        //交换机绑定 routingkey
        channel.queueBind(queueName, EXCHANGE_NAME, "*.*.rabbit");
        channel.queueBind(queueName, EXCHANGE_NAME, "lazy.#");
        System.out.println("等待接收消息。。。。。");
        //接收消息
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println(new String(message.getBody(), StandardCharsets.UTF_8));
            System.out.println("接收队列：" + queueName + "绑定键：" + message.getEnvelope().getRoutingKey());
        };
        //接收消息
        channel.basicConsume(queueName, true, deliverCallback, consumerTag -> {
        });
    }

}
```

2. 生产者

```java
package com.atguigu.rabbitmq.seven;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.Channel;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.spec.ECField;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 14:45
 * 生产者
 */
public class EmitLogTopic {
    public static final String EXCHANGE_NAME = "topic_logs";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        /**
         * 下图绑定关系如下：
         * Q1--> 绑定的是： 中间带3个单词的字符串（*.orange*）
         * Q2--> 绑定的是： 最后一个单词是rabbit的3个单词（*.*.rabbit）
         *                第一个单词是lazy的多个单词（lazy.#）
         */
        Map<String, String> bindingKeyMap = new HashMap<>();
        bindingKeyMap.put("quick.orange.rabbit", "被队列Q1Q2接收到");
        bindingKeyMap.put("lazy.orange.elephant", "被队列Q1Q2接收到");
        bindingKeyMap.put("lazy.pink.rabbit", "被队列Q1接收到");
        bindingKeyMap.put("quick.brown.fox", "被队列Q2接收到");
        bindingKeyMap.put("quick.orange.male.rabbit", "虽然满足两个绑定但只被队列Q2接收一次");
        bindingKeyMap.put("quick.brown.fox", "不匹配任何绑定不会被任何队列接收到会被丢弃");
        bindingKeyMap.put("lazy.orange.male.rabbit", "是四个单词不匹配任何绑定定会丢弃");
        bindingKeyMap.put("lazy.orange.male.rabbit", "是四个单词但匹配Q2");

        for (Map.Entry<String, String> bindingKeyEntry : bindingKeyMap.entrySet()) {
            String routingKey = bindingKeyEntry.getKey();
            String message = bindingKeyEntry.getValue();
            channel.basicPublish(EXCHANGE_NAME, routingKey, null, message.getBytes(StandardCharsets.UTF_8));
            System.out.println("生产者发出消息" + message);
        }
    }
}
```

先启动消费者，再启动生产者。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638430253833-e55a9ffe-37a0-4c04-b7b7-093a65480f71.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=540&id=u94f62b22&margin=%5Bobject%20Object%5D&name=image.png&originHeight=540&originWidth=683&originalType=binary&ratio=1&rotation=0&showTitle=false&size=63817&status=done&style=none&taskId=u846aee7e-23e7-429c-8c68-098657667fa&title=&width=683#averageHue=%232e3a41&crop=0&crop=0&crop=1&crop=1&id=r1tul&originHeight=540&originWidth=683&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638430292235-0a8fd8ca-fdd9-4f2e-9a52-de2398da4db4.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=548&id=u5b1d2810&margin=%5Bobject%20Object%5D&name=image.png&originHeight=548&originWidth=649&originalType=binary&ratio=1&rotation=0&showTitle=false&size=60902&status=done&style=none&taskId=uf769df3d-232c-4803-866e-9b789b65799&title=&width=649#averageHue=%23303b42&crop=0&crop=0&crop=1&crop=1&id=p0vbD&originHeight=548&originWidth=649&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638430299720-f401248d-7efc-425f-aff1-59f8cda3349d.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=257&id=u7c6af404&margin=%5Bobject%20Object%5D&name=image.png&originHeight=257&originWidth=674&originalType=binary&ratio=1&rotation=0&showTitle=false&size=33728&status=done&style=none&taskId=u0e4568aa-d243-4696-a1eb-02eebf586cf&title=&width=674#averageHue=%23313d44&crop=0&crop=0&crop=1&crop=1&id=Axrk6&originHeight=257&originWidth=674&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 死信队列

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638430356782-4196f6b8-209f-489a-a5e5-e61974e711ef.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=299&id=ud95905f1&margin=%5Bobject%20Object%5D&name=image.png&originHeight=299&originWidth=1069&originalType=binary&ratio=1&rotation=0&showTitle=false&size=430772&status=done&style=none&taskId=ue469e4ea-c3e9-44f2-a5e6-4ac2443deba&title=&width=1069#averageHue=%23dad7cf&crop=0&crop=0&crop=1&crop=1&id=ZL2Da&originHeight=299&originWidth=1069&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638430504276-84f3e02c-d80f-4fe9-9b9a-b8d9ac3b8290.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=298&id=u8670c10d&margin=%5Bobject%20Object%5D&name=image.png&originHeight=298&originWidth=643&originalType=binary&ratio=1&rotation=0&showTitle=false&size=162345&status=done&style=none&taskId=ue72cf50e-a8d2-4f86-8a8f-e35ebf10e89&title=&width=643#averageHue=%23ddd6c3&crop=0&crop=0&crop=1&crop=1&id=rBdXQ&originHeight=298&originWidth=643&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638430601814-eb3112b8-d77b-4213-ad2c-df3c394a36b7.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=553&id=ufda1712c&margin=%5Bobject%20Object%5D&name=image.png&originHeight=553&originWidth=1136&originalType=binary&ratio=1&rotation=0&showTitle=false&size=162361&status=done&style=none&taskId=u55e88e2a-dc14-44b5-9eb9-8663773f317&title=&width=1136#averageHue=%23fbfafa&crop=0&crop=0&crop=1&crop=1&id=pQqf7&originHeight=553&originWidth=1136&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

- 消费者 1：

```java
package com.atguigu.rabbitmq.eight;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.BuiltinExchangeType;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 15:40
 * 死信队列
 * 消费者1
 */
public class Consumer01 {
    //普通交换机的名称
    public static final String NORMAL_EXCHANGE = "normal_exchange";
    //死信队列的名称
    public static final String DEAD_EXCHANGE = "dead_exchange";
    //普通队列的名称
    public static final String NORMAL_QUEUE = "normal_queue";
    //死信队列的名称
    public static final String DEAD_QUEUE = "dead_queue";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //声明死信和普通交换机， 类型为direct
        channel.exchangeDeclare(NORMAL_EXCHANGE, BuiltinExchangeType.DIRECT);
        channel.exchangeDeclare(DEAD_EXCHANGE, BuiltinExchangeType.DIRECT);
        //声明普通队列
        Map<String, Object> arguments = new HashMap<>();
        //过期时间
//        arguments.put("x-message-ttl",10000);
        //正常队列设置死信交换机
        arguments.put("x-dead-letter-exchange", DEAD_EXCHANGE);
        //设置死信RoutingKey
        arguments.put("x-dead-letter-routing-key", "lisi");
        //设置正常队列的长度的限制
//        arguments.put("x-max-length", 19);
        channel.queueDeclare(NORMAL_QUEUE, false, false, false, arguments);
        ///////////////////////////////////////////////////
        //声明死信队列
        channel.queueDeclare(DEAD_QUEUE, false, false, false, null);
        //交换机与队列绑定
        //绑定普通交换机与普通队列
        channel.queueBind(NORMAL_QUEUE, NORMAL_EXCHANGE, "zhangsan");
        //绑定死信交换机与死信队列
        channel.queueBind(DEAD_QUEUE, DEAD_EXCHANGE, "lisi");
        System.out.println("等待接收消息.........");
        //接收消息
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            String msg = new String(message.getBody(), StandardCharsets.UTF_8);
            if (msg.equals("info5")) {
                System.out.println("此消息被C1拒绝的" + msg);
                //拒绝此消息，并且不放回队列中。因此成为死信
                channel.basicReject(message.getEnvelope().getDeliveryTag(), false);
            } else {
                System.out.println("Consumer01接收的消息" + msg);
                //不批量应答
                channel.basicAck(message.getEnvelope().getDeliveryTag(), false);
            }
        };
        //开启手动应答（如果不开启手动应答，就不存在拒绝了）
        channel.basicConsume(NORMAL_QUEUE, false, deliverCallback, consumerTag -> {
        });
    }
}
```

- 消费者 2：

```java
package com.atguigu.rabbitmq.eight;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.BuiltinExchangeType;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DeliverCallback;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 15:40
 * 死信队列
 * 消费者2
 */
public class Consumer02 {
    //死信队列的名称
    public static final String DEAD_QUEUE = "dead_queue";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        System.out.println("等待接收消息.........");
        //接收消息
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println("Consumer02接收的消息" + new String(message.getBody(), StandardCharsets.UTF_8));
        };
        channel.basicConsume(DEAD_QUEUE, false, deliverCallback, consumerTag -> {

        });
    }
}
```

- 生产者：

```java
package com.atguigu.rabbitmq.eight;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.AMQP;
import com.rabbitmq.client.Channel;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 16:13
 * 死信队列-生产者
 */
public class Producer {
    //普通交换机的名称
    public static final String NORMAL_EXCHANGE = "normal_exchange";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //死信时间  设置ttl时间
        AMQP.BasicProperties properties = new AMQP.BasicProperties().builder().expiration("10000").build();
        for (int i = 1; i < 11; i++) {
            String message = "info" + i;
            channel.basicPublish(NORMAL_EXCHANGE, "zhangsan", properties, message.getBytes());
        }
    }
}
```

测试步骤：

1. 运行消费者：会发现普通和死信交换机已经绑定各自的队列。

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638445377947-e4a087d0-b755-4178-aa6d-7ae082107bb0.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=495&id=ud91030e8&margin=%5Bobject%20Object%5D&name=image.png&originHeight=495&originWidth=541&originalType=binary&ratio=1&rotation=0&showTitle=false&size=23775&status=done&style=none&taskId=u8f85c23d-a811-41b4-a478-a20609fc50a&title=&width=541#averageHue=%23f8f7f6&crop=0&crop=0&crop=1&crop=1&id=xwjE9&originHeight=495&originWidth=541&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638445475857-ba40932b-588f-43d3-b3a6-5f2660bcd241.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=498&id=ub28b2410&margin=%5Bobject%20Object%5D&name=image.png&originHeight=498&originWidth=601&originalType=binary&ratio=1&rotation=0&showTitle=false&size=25129&status=done&style=none&taskId=u8de3a461-08ce-49b9-9936-e0cf7fa1363&title=&width=601#averageHue=%23f8f7f7&crop=0&crop=0&crop=1&crop=1&id=Jcymv&originHeight=498&originWidth=601&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

2. 测试**队列达到最大长度**，关闭消费者 1 和 2，开启生产者：消息会积压在队列中，消费者 1 所在的普通队列消息限制有 6 条，剩下的 4 条会进入消费者 2 所在的死信队列。如下图所示：

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638448087379-8c4e5c46-39ca-49fd-8024-4111b0a5d431.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=571&id=u9eb9c88a&margin=%5Bobject%20Object%5D&name=image.png&originHeight=571&originWidth=1083&originalType=binary&ratio=1&rotation=0&showTitle=false&size=79389&status=done&style=none&taskId=ua5f78b60-fd26-4cb8-9cf8-f0e0f17270b&title=&width=1083#averageHue=%23f1eeed&crop=0&crop=0&crop=1&crop=1&id=s5bzi&originHeight=571&originWidth=1083&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

3. 取消普通队列的最大长度限制，测试**消息 ttl 过期**：关闭消费者 1 和 2，开启生产者发送消息。（消息会因为没人接收，会在 ttl 时间内积压在普通队列中， ttl 过期后，消息会进入死信队列中。）

生产者：

```java
package com.atguigu.rabbitmq.eight;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.AMQP;
import com.rabbitmq.client.Channel;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 16:13
 * 死信队列-生产者
 */
public class Producer {
    //普通交换机的名称
    public static final String NORMAL_EXCHANGE = "normal_exchange";

    public static void main(String[] args) throws IOException, TimeoutException {
        Channel channel = RabbitMqUtils.getChannel();
        //死信时间  设置ttl时间
        AMQP.BasicProperties properties = new AMQP.BasicProperties().builder().expiration("10000").build();
        for (int i = 1; i < 11; i++) {
            String message = "info" + i;
            channel.basicPublish(NORMAL_EXCHANGE, "zhangsan", properties, message.getBytes());
        }
    }
}
```

4. 测试**消息被拒**：

开启消费者 1 和 2，再开启生产者。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638450659287-e191b69a-07c6-4d5e-8f54-05d22263a235.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=274&id=u03d42d3b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=274&originWidth=642&originalType=binary&ratio=1&rotation=0&showTitle=false&size=32103&status=done&style=none&taskId=uf69d66f1-feae-4ff6-83ca-af7f8a83127&title=&width=642#averageHue=%232e3b43&crop=0&crop=0&crop=1&crop=1&id=jR4qW&originHeight=274&originWidth=642&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638450668535-06aa1842-3563-455e-bb20-6376694fae1f.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=202&id=u33f7f3ac&margin=%5Bobject%20Object%5D&name=image.png&originHeight=202&originWidth=616&originalType=binary&ratio=1&rotation=0&showTitle=false&size=23460&status=done&style=none&taskId=ua7a303f7-25d6-4fc0-8d46-d522a51ded6&title=&width=616#averageHue=%232d3a42&crop=0&crop=0&crop=1&crop=1&id=vAYSS&originHeight=202&originWidth=616&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 延迟队列（基于死信队列）

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638450862631-363c8d24-6a72-463a-b827-201e6f79cb79.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=128&id=u8aa7212b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=128&originWidth=1081&originalType=binary&ratio=1&rotation=0&showTitle=false&size=190603&status=done&style=none&taskId=ue97c71c8-4947-4c82-be00-e98e36ba920&title=&width=1081#averageHue=%23e1dfd3&crop=0&crop=0&crop=1&crop=1&id=xrjpE&originHeight=128&originWidth=1081&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638451047144-5f4983f1-3a0e-472b-95f3-26635a911749.png#clientId=u268c19fe-902d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=399&id=ud5620b6f&margin=%5Bobject%20Object%5D&name=image.png&originHeight=399&originWidth=869&originalType=binary&ratio=1&rotation=0&showTitle=false&size=265988&status=done&style=none&taskId=ub1f53a1e-1377-4e43-ab1d-13e29cf4118&title=&width=869#averageHue=%23f3f3f2&crop=0&crop=0&crop=1&crop=1&id=O4W2R&originHeight=399&originWidth=869&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 整合 SpringBoot

#### 实现延迟队列：

1. 依赖：

```java
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.6.1</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.atguigu.rabbitmq</groupId>
    <artifactId>springboot-rabbitmq</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>springboot-rabbitmq</name>
    <description>Demo project for Spring Boot</description>
    <properties>
        <java.version>1.8</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-amqp -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-amqp</artifactId>
            <version>2.6.1</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-web -->
        <!--web服务器，可以自启动-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>2.6.1</version>
        </dependency>
        <!--快速进行json转换-->
        <!-- https://mvnrepository.com/artifact/com.alibaba/fastjson -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>1.2.78</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/io.springfox/springfox-swagger2 -->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
            <version>3.0.0</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/io.springfox/springfox-swagger-ui -->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger-ui</artifactId>
            <version>3.0.0</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.springframework.amqp/spring-rabbit-test -->
        <dependency>
            <groupId>org.springframework.amqp</groupId>
            <artifactId>spring-rabbit-test</artifactId>
            <version>2.4.0</version>
            <scope>test</scope>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.projectlombok/lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.22</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```

2. yml 配置文件：

```java
spring:
  rabbitmq:
    host: 59.110.171.189
    port: 5672
    username: admin
    password: 123
```

3. swagger 配置类：

```java
package com.atguigu.rabbitmq.springbootrabbitmq.config;

import org.springframework.context.annotation.Bean;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/2 22:34
 */
public class SwaggerConfig {
    @Bean
    public Docket webApiConfig() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("webApi")
                .apiInfo(webApiInfo())
                .select()
                .build();
    }

    private ApiInfo webApiInfo() {
        return new ApiInfoBuilder()
                .title("rabbitmq  接口文档")
                .description(" 本文档描述了 rabbitmq  微服务接口定义")
                .version("1.0")
                .contact(new Contact("enjoy6288", "http://atguigu.com",
                        "1846015350@qq.com"))
                .build();
    }
}
```

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638490298754-a2b1ced5-676b-4f68-86e0-31f05266088f.png#clientId=u7522214d-0203-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=215&id=u8ba627f6&margin=%5Bobject%20Object%5D&name=image.png&originHeight=215&originWidth=1100&originalType=binary&ratio=1&rotation=0&showTitle=false&size=132048&status=done&style=none&taskId=ud9c3f28a-b8df-44d1-b9df-dc90c70e046&title=&width=1100#averageHue=%23f9f8f6&crop=0&crop=0&crop=1&crop=1&id=Iv7m8&originHeight=215&originWidth=1100&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

4. 声明队列配置文件：

```java
package com.atguigu.rabbitmq.springbootrabbitmq.config;

import org.springframework.amqp.core.*;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.HashMap;
import java.util.Map;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 8:15
 * TTL队列，  配置文件类代码
 */
@Configuration
public class TtlQueueConfig {
    //普通交换机的名称
    public static final String X_EXCHANGE = "X";
    //死信交换机的名称
    public static final String Y_DEAD_LETTER_EXCHANGE = "Y";
    //普通队列的名称
    public static final String QUEUE_A = "QA";
    public static final String QUEUE_B = "QB";
    //死信队列的名称
    public static final String DEAD_LETTER_QUEUE = "QD";

    //声明xExchange 别名
    @Bean("xExchange")
    public DirectExchange xExchange() {
        return new DirectExchange(X_EXCHANGE);
    }

    @Bean("yExchange")
    public DirectExchange yExchange() {
        return new DirectExchange(Y_DEAD_LETTER_EXCHANGE);
    }

    //声明普通队列  ttl为10s
    @Bean("queueA")
    public Queue queueA() {
        Map<String, Object> arguments = new HashMap<>(3);
        //设置死信交换机
        arguments.put("x-dead-letter-exchange", Y_DEAD_LETTER_EXCHANGE);
        //设置死信 routing-key
        arguments.put("x-dead-letter-routing-key", "YD");
        //设置ttl  单位为ms
        arguments.put("x-message-ttl", 10000);
        return QueueBuilder.durable(QUEUE_A).withArguments(arguments).build();
    }

    //声明普通队列  ttl为40s
    @Bean("queueB")
    public Queue queueB() {
        Map<String, Object> arguments = new HashMap<>(3);
        //设置死信交换机
        arguments.put("x-dead-letter-exchange", Y_DEAD_LETTER_EXCHANGE);
        //设置死信 routing-key
        arguments.put("x-dead-letter-routing-key", "YD");
        //设置ttl  单位为ms
        arguments.put("x-message-ttl", 40000);
        return QueueBuilder.durable(QUEUE_B).withArguments(arguments).build();
    }

    //死信队列
    @Bean("queueD")
    public Queue queueD() {
        return QueueBuilder.durable(DEAD_LETTER_QUEUE).build();
    }

    //绑定交换机和队列
    @Bean
    public Binding queueABindingX(@Qualifier("queueA") Queue queueA, @Qualifier("xExchange") DirectExchange xExchange) {
        return BindingBuilder.bind(queueA).to(xExchange).with("XA");
    }

    @Bean
    public Binding queueBBindingX(@Qualifier("queueB") Queue queueB, @Qualifier("xExchange") DirectExchange xExchange) {
        return BindingBuilder.bind(queueB).to(xExchange).with("XB");
    }

    @Bean
    public Binding queueDBindingY(@Qualifier("queueD") Queue queueD, @Qualifier("yExchange") DirectExchange yExchange) {
        return BindingBuilder.bind(queueD).to(yExchange).with("YD");
    }
}
```

5. 消费者：接收消息

```java
package com.atguigu.rabbitmq.springbootrabbitmq.consumer;

import com.rabbitmq.client.Channel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 9:01
 * 队列ttl 消费者
 */
@Slf4j
@Component
public class DeadLetterQueueConsumer {

    //接收消息
    @RabbitListener(queues = "QD")
    public void receiveD(Message message, Channel channel) {
        String msg = new String(message.getBody());
        log.info("当前时间：{}，收到死信队列的消息：{}", new Date().toString(), msg);
    }
}
```

6. 发送消息：Controller

```java
package com.atguigu.rabbitmq.springbootrabbitmq.controller;

import io.swagger.annotations.ApiModelProperty;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 8:47
 * 发送延迟消息
 * <p>
 * http://localhost:8080/ttl/sendMsg/嘻嘻嘻
 */
@Slf4j
@RestController
@RequestMapping("/ttl")
public class SendMsgController {
    @Autowired
    private RabbitTemplate rabbitTemplate;

    //开始发消息
    @GetMapping("/sendMsg/{message}")
    public void sendMsg(@PathVariable String message) {
        log.info("当前时间：{}，发送一条消息给两个ttl队列:{}", new Date().toString(), message);
        rabbitTemplate.convertAndSend("X", "XA", "消息来自ttl为10s的队列" + message);
        rabbitTemplate.convertAndSend("X", "XB", "消息来自ttl为40s的队列" + message);
    }
}
```

访问：[http://localhost:8080/ttl/sendMsg/](http://localhost:8080/ttl/sendMsg/)嘻嘻嘻
控制台打印结果：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638494307481-a59aaddb-4efb-4200-9e05-0e34602ded36.png#clientId=u7522214d-0203-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=202&id=u66541ef9&margin=%5Bobject%20Object%5D&name=image.png&originHeight=202&originWidth=1365&originalType=binary&ratio=1&rotation=0&showTitle=false&size=62756&status=done&style=none&taskId=ua128108f-eaa5-47fc-ab0d-e56fe3f57f4&title=&width=1365#averageHue=%23333e45&crop=0&crop=0&crop=1&crop=1&id=tO8el&originHeight=202&originWidth=1365&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

#### 延迟队列优化：

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638494906968-c2a2e16a-a5b3-4c44-83bc-5846e35977d0.png#clientId=u7522214d-0203-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=333&id=u5def25ea&margin=%5Bobject%20Object%5D&name=image.png&originHeight=333&originWidth=1070&originalType=binary&ratio=1&rotation=0&showTitle=false&size=169463&status=done&style=none&taskId=uede9888d-c22a-46c9-a810-c9c1899d23a&title=&width=1070#averageHue=%23faf9f8&crop=0&crop=0&crop=1&crop=1&id=PCbH9&originHeight=333&originWidth=1070&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
增加一个 QC 普通队列声明后并绑定交换机 XC。
队列配置 中添加：

```java
//--------------------------------优化延迟队列-------------------------------------
    //普通队列的名称（为了优化延迟队列）
    public static final String QUEUE_C = "QC";

    //声明QC
    @Bean("queueC")
    public Queue queueC() {
        Map<String, Object> arguments = new HashMap<>(2);
        //设置死信交换机
        arguments.put("x-dead-letter-exchange", Y_DEAD_LETTER_EXCHANGE);
        //设置死信routing-key
        arguments.put("x-dead-letter-routing-key", "YD");
        return QueueBuilder.durable(QUEUE_C).withArguments(arguments).build();
    }

    //绑定普通队列QC和交换机
    @Bean
    public Binding queueCBindingX(@Qualifier("queueC") Queue queueC,
                                  @Qualifier("xExchange") DirectExchange xExchange) {
        return BindingBuilder.bind(queueC).to(xExchange).with("XC");
    }
    //-----------------------------------优化延迟队列----------------------------------
```

添加 Controller 发消息控制器：

```java
//开始发消息  消息ttl
    @GetMapping("/sendExpireMsg/{message}/{ttlTime}")
    public void sendMsg(@PathVariable String message, @PathVariable String ttlTime) {
        log.info("当前时间：{}，发送一条时长{}毫秒，ttl信息给队列QC:{}", new Date().toString(), ttlTime, message);
        rabbitTemplate.convertAndSend("X", "XC", message, msg -> {
            //发送消息的时候  延迟时长
            msg.getMessageProperties().setExpiration(ttlTime);
            return msg;
        });
    }
```

测试：

1. http://localhost:8080/ttl/sendExpireMsg/你好 1/20000
2. http://localhost:8080/ttl/sendExpireMsg/你好 2/2000

结果：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638517312025-dfbbfd0b-a82c-4432-a395-2e7cc7c6e48f.png#clientId=u7522214d-0203-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=149&id=u18e59259&margin=%5Bobject%20Object%5D&name=image.png&originHeight=149&originWidth=1285&originalType=binary&ratio=1&rotation=0&showTitle=false&size=42107&status=done&style=none&taskId=uff6fb06a-df03-451f-b886-52364055048&title=&width=1285#crop=0&crop=0&crop=1&crop=1&id=efjYm&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 延迟队列（基于插件）

进入 rabbitmq 安装目录下的 plugins 目录 ，cd /usr/lib/rabbitmq/lib/rabbitmq_server-3.8.8/plugins
执行命令让该插件生效：rabbitmq-plugins enable rabbitmq_delayed_message_exchange
然后重启 rabbitmq：systemctl restart rabbitmq-server
会发现交换机多了一个新类型，意味着延迟消息将由交换机来完成，而不是队列。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638519642120-f3258006-3639-4551-805e-26bbd1e67c85.png#clientId=u7522214d-0203-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=530&id=u66b7d498&margin=%5Bobject%20Object%5D&name=image.png&originHeight=767&originWidth=690&originalType=binary&ratio=1&rotation=0&showTitle=false&size=56472&status=done&style=none&taskId=u707609ca-e368-4b6c-9833-ec8cc57ca15&title=&width=477.00006103515625#crop=0&crop=0&crop=1&crop=1&id=PD1AH&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

原来的情况：基于死信
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638520455616-cfcde47e-bee3-4ef6-83b6-6630dbe54d9a.png#clientId=u7522214d-0203-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=443&id=ua9957719&margin=%5Bobject%20Object%5D&name=image.png&originHeight=601&originWidth=1033&originalType=binary&ratio=1&rotation=0&showTitle=false&size=226301&status=done&style=none&taskId=ua95f3b09-635a-4782-abfd-57901f34a8b&title=&width=760.9862060546875#crop=0&crop=0&crop=1&crop=1&id=UOPGa&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
现在：基于延迟插件
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638520591056-7591eaf6-b99f-4059-8cbb-6a6ee0ea64f2.png#clientId=u7522214d-0203-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=177&id=u11577081&margin=%5Bobject%20Object%5D&name=image.png&originHeight=224&originWidth=976&originalType=binary&ratio=1&rotation=0&showTitle=false&size=94107&status=done&style=none&taskId=u47b17a31-4f94-4f3c-a75f-2014f181765&title=&width=770.9896240234375#crop=0&crop=0&crop=1&crop=1&id=a4gyh&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
代码架构：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638520764180-7b9e927e-1166-470d-ac32-dda16bb87ae1.png#clientId=u7522214d-0203-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=188&id=ud9b4ba5b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=188&originWidth=1062&originalType=binary&ratio=1&rotation=0&showTitle=false&size=84300&status=done&style=none&taskId=u12c568cb-6151-4b2f-8f49-3f721530b6d&title=&width=1062#crop=0&crop=0&crop=1&crop=1&id=cPAio&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

1. 配置类

```java
package com.atguigu.rabbitmq.springbootrabbitmq.config;

import org.springframework.amqp.core.*;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.HashMap;
import java.util.Map;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 16:41
 */
@Configuration
public class DelayedQueueConfig {
    //队列
    public static final String DELAYED_QUEUE_NAME = "delayed.name";
    //交换机
    public static final String DELAYED_EXCHANGE_NAME = "delayed.exchange";
    //routing-key
    public static final String DELAYED_ROUTING_KEY = "delayed.routingkey";

    //声明队列
    @Bean
    public Queue delayedQueue() {
        return QueueBuilder.durable(DELAYED_QUEUE_NAME).build();
    }

    //声明交换机 基于插件
    @Bean
    public CustomExchange delayedExchange() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("x-delayed-type", "direct");
        /**
         * 1. 交换机的名称
         * 2. 交换机的类型
         * 3. 是否需要持久化
         * 4. 是否需要自动删除
         * 5. 其他的参数
         */
        return new CustomExchange(DELAYED_EXCHANGE_NAME, "x-delayed-message", true, false, arguments);
    }

    //绑定
    @Bean
    public Binding delayedQueueBindingDelayedExchange(@Qualifier("delayedQueue") Queue delayedQueue,
                                                      @Qualifier("delayedExchange") CustomExchange delayedExchange) {
        return BindingBuilder.bind(delayedQueue).to(delayedExchange).with(DELAYED_ROUTING_KEY).noargs();
    }
}
```

2. Controller 生产者：

```java
//发消息  基于延迟插件
    @GetMapping("/sendDelayMsg/{message}/{delayTime}")
    public void sendMsg(@PathVariable String message, @PathVariable Integer delayTime) {
        log.info("当前时间:{},发送一条时长{}毫秒信息给延迟队列delayed.queue:{}", new Date().toString(), delayTime, message);
        rabbitTemplate.convertAndSend(DelayedQueueConfig.DELAYED_EXCHANGE_NAME, DelayedQueueConfig.DELAYED_ROUTING_KEY, message, msg -> {
            //发送消息的时候   延迟时长  单位：ms
            msg.getMessageProperties().setDelay(delayTime);
            return msg;
        });
    }
```

3. 消费者：

```java
package com.atguigu.rabbitmq.springbootrabbitmq.consumer;

import com.atguigu.rabbitmq.springbootrabbitmq.config.DelayedQueueConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 19:36
 * 消费者 基于插件的延迟消息
 */
@Slf4j
@Component
public class DelayQueueConsumer {
    //监听消息
    @RabbitListener(queues = DelayedQueueConfig.DELAYED_QUEUE_NAME)
    public void receiveDelayQueue(Message message) {
        String msg = new String(message.getBody());
        log.info("当前时间:{},收到延迟队列的消息：{}", new Date().toString(), msg);
    }
}
```

测试：
发起请求：[http://localhost:8080/ttl/sendDelayMsg/com](http://localhost:8080/ttl/sendDelayMsg/com) on baby1/20000
[http://localhost:8080/ttl/sendDelayMsg/com](http://localhost:8080/ttl/sendDelayMsg/com) on baby2/2000
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638532349237-315b969f-d021-4448-8aa8-d5a1d41950a0.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=208&id=uf33e7fe7&margin=%5Bobject%20Object%5D&name=image.png&originHeight=208&originWidth=1432&originalType=binary&ratio=1&rotation=0&showTitle=false&size=71640&status=done&style=none&taskId=ue722c22b-16d9-40a2-9a28-e95348df5d0&title=&width=1432#crop=0&crop=0&crop=1&crop=1&id=P79jF&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638532663153-40afab72-d363-4536-94fc-4889e40d764b.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=224&id=u7813c3ed&margin=%5Bobject%20Object%5D&name=image.png&originHeight=266&originWidth=1121&originalType=binary&ratio=1&rotation=0&showTitle=false&size=457006&status=done&style=none&taskId=u0e4002d8-2179-43cc-bcfd-7c69cd127b5&title=&width=941.9896240234375#crop=0&crop=0&crop=1&crop=1&id=aEVGf&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 发布确认高级

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638533419869-3aa9b7ad-ee4e-4fd8-9e42-fd6af4aafe70.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=225&id=u7ed4e098&margin=%5Bobject%20Object%5D&name=image.png&originHeight=341&originWidth=945&originalType=binary&ratio=1&rotation=0&showTitle=false&size=186643&status=done&style=none&taskId=uc65852ff-c2a9-416e-bef6-2991c80fa8b&title=&width=623.0000610351562#crop=0&crop=0&crop=1&crop=1&id=OAmnb&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638533456413-9ead4e1d-f118-4a55-8d05-bcdd4d5fc47f.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=131&id=u954992f9&margin=%5Bobject%20Object%5D&name=image.png&originHeight=144&originWidth=839&originalType=binary&ratio=1&rotation=0&showTitle=false&size=73103&status=done&style=none&taskId=u9819bc42-f398-487a-b319-358e2acd1ba&title=&width=762.9931030273438#crop=0&crop=0&crop=1&crop=1&id=sjopK&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 回调接口 : (若交换机收不到消息)

1. 配置类

```java
package com.atguigu.rabbitmq.springbootrabbitmq.config;

import org.springframework.amqp.core.*;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 20:15
 * 配置类  发布确认 （高级）
 */
@Configuration
public class ConfirmConfig {
    //交换机
    public static final String CONFIRM_EXCHANGE_NAME = "confirm_exchange";
    //队列
    public static final String CONFIRM_QUEUE_NAME = "confirm_queue";
    //routing-key
    public static final String CONFIRM_ROUTING_KEY = "key1";

    //声明交换机
    @Bean
    public DirectExchange confirmExchange() {
        return new DirectExchange(CONFIRM_EXCHANGE_NAME);
    }

    //声明队列
    @Bean
    public Queue confirmQueue() {
        return QueueBuilder.durable(CONFIRM_QUEUE_NAME).build();
    }

    //绑定交换机和队列
    @Bean
    public Binding queueBindingExchange(@Qualifier("confirmQueue") Queue confirmQueue,
                                        @Qualifier("confirmExchange") DirectExchange confirmExchange) {
        return BindingBuilder.bind(confirmQueue).to(confirmExchange).with(CONFIRM_ROUTING_KEY);
    }
}
```

2. 生产者：发消息

```java
package com.atguigu.rabbitmq.springbootrabbitmq.controller;

import com.atguigu.rabbitmq.springbootrabbitmq.config.ConfirmConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.connection.CorrelationData;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 20:27
 * 开始发消息
 */
@Slf4j
@RestController
@RequestMapping("/confirm")
public class ProducerController {
    @Autowired
    private RabbitTemplate rabbitTemplate;

    //发消息
    @GetMapping("/sendMessage/{message}")
    public void sendMessage(@PathVariable String message) {
        CorrelationData correlationData = new CorrelationData("1");
        rabbitTemplate.convertAndSend(ConfirmConfig.CONFIRM_EXCHANGE_NAME, ConfirmConfig.CONFIRM_ROUTING_KEY, message, correlationData);
        log.info("发送消息内容为：{}", message);
    }
}
```

3. 消费者：

```java
package com.atguigu.rabbitmq.springbootrabbitmq.consumer;

import com.atguigu.rabbitmq.springbootrabbitmq.config.ConfirmConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 20:33
 * 接收消息
 */
@Slf4j
@Component
public class Consumer {
    @RabbitListener(queues = ConfirmConfig.CONFIRM_QUEUE_NAME)
    public void receiveConfirmMessage(Message message) {
        String msg = new String(message.getBody());
        log.info("接收到的队列confirm.queue消息：{}", msg);
    }
}
```

4. 回调接口

```java
package com.atguigu.rabbitmq.springbootrabbitmq.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.connection.CorrelationData;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 20:50
 * 回调接口
 */
@Slf4j
@Component
public class MyCallBack implements RabbitTemplate.ConfirmCallback {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @PostConstruct
    public void init() {
        //注入 （需要将当前实现类注入到RabbitTemplate的ConfirmCallback函数式接口中）
        rabbitTemplate.setConfirmCallback(this);
    }

    /**
     * 交换机确认回调方法
     * 1. 发消息  交换机接收到了  回调
     * 1.1 correlationData 保存回调消息的id及相关信息
     * 1.2 交换机收到消息  ack = true
     * 1.3 cause  null
     * 2. 发消息 交换机接收失败 回调
     * 2.1 correlationData 保存回调消息的id及相关信息
     * 2.2 交换机收到消息 ack = false
     * 2.3 cause  失败的原因
     *
     * @param correlationData
     * @param ack
     * @param cause
     */
    @Override
    public void confirm(CorrelationData correlationData, boolean ack, String cause) {
        String id = correlationData != null ? correlationData.getId() : "";
        if (ack) {
            log.info("交换机已经收到id为：{}的消息", id);
        } else {
            log.error("交换机还未收到id为:{}的消息，由于原因：{}", id, cause);
        }
    }
}
```

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638537772169-a45dc229-e5ed-410a-8e46-69f3fb39f21e.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=518&id=u396acbb1&margin=%5Bobject%20Object%5D&name=image.png&originHeight=518&originWidth=973&originalType=binary&ratio=1&rotation=0&showTitle=false&size=369736&status=done&style=none&taskId=u8a93ee99-1d87-4fd1-880d-a166a5e50f1&title=&width=973#crop=0&crop=0&crop=1&crop=1&id=Bk8N5&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

```java
spring:
  rabbitmq:
    host: 59.110.171.189
    port: 5672
    username: admin
    password: 123
    publisher-confirm-type: correlated    # 消息确认机制
```

5. 发送请求 : http://localhost:8080/confirm/sendMessage/大家好 1

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638537854600-e11783cd-28be-4b75-8f36-434ecab3f990.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=190&id=ue332f12f&margin=%5Bobject%20Object%5D&name=image.png&originHeight=190&originWidth=1135&originalType=binary&ratio=1&rotation=0&showTitle=false&size=51915&status=done&style=none&taskId=uba52e997-898f-49e3-9067-645cfb69f68&title=&width=1135#crop=0&crop=0&crop=1&crop=1&id=Emijw&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

6. 测试交换机收不到消息：在发送消息中，将交换机名字后面拼接上"123"，再次启动，发送请求： http://localhost:8080/confirm/sendMessage/大家好 1

会得到：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638538268620-8dcbc2ae-eaa1-4b60-8822-9cd20f509c52.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=222&id=u3e470d69&margin=%5Bobject%20Object%5D&name=image.png&originHeight=222&originWidth=1872&originalType=binary&ratio=1&rotation=0&showTitle=false&size=66288&status=done&style=none&taskId=u7f0330f7-a846-488e-8b25-71c1f3cf0a7&title=&width=1872#crop=0&crop=0&crop=1&crop=1&id=J3ZRH&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

7. 测试队列收不到消息

```java
package com.atguigu.rabbitmq.springbootrabbitmq.controller;

import com.atguigu.rabbitmq.springbootrabbitmq.config.ConfirmConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.connection.CorrelationData;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 20:27
 * 开始发消息  生产者
 */
@Slf4j
@RestController
@RequestMapping("/confirm")
public class ProducerController {
    @Autowired
    private RabbitTemplate rabbitTemplate;

    //发消息
    @GetMapping("/sendMessage/{message}")
    public void sendMessage(@PathVariable String message) {
        CorrelationData correlationData1 = new CorrelationData("1");
        rabbitTemplate.convertAndSend(ConfirmConfig.CONFIRM_EXCHANGE_NAME,
                ConfirmConfig.CONFIRM_ROUTING_KEY, message, correlationData1);
        log.info("发送消息内容为：{}", message);

        CorrelationData correlationData2 = new CorrelationData("2");
        rabbitTemplate.convertAndSend(ConfirmConfig.CONFIRM_EXCHANGE_NAME,
                ConfirmConfig.CONFIRM_ROUTING_KEY+"2", message, correlationData2);
        log.info("发送消息内容为：{}", message);
    }
}
```

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638538743381-bfc4680e-692b-4303-a0f3-87cd9425978d.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=247&id=u241a2996&margin=%5Bobject%20Object%5D&name=image.png&originHeight=247&originWidth=1157&originalType=binary&ratio=1&rotation=0&showTitle=false&size=67266&status=done&style=none&taskId=u3edf7078-e740-4b0a-866c-03de3cfb9db&title=&width=1157#crop=0&crop=0&crop=1&crop=1&id=SGy2Z&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
可见，队列没有收到消息，也没有应答和确认。

### 若队列收不到消息

#### 回退消息

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638539584832-557a9bbc-89d4-4162-a0d4-599eb7f3df21.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=210&id=u40b5093d&margin=%5Bobject%20Object%5D&name=image.png&originHeight=210&originWidth=976&originalType=binary&ratio=1&rotation=0&showTitle=false&size=298616&status=done&style=none&taskId=u13a46749-be43-4430-beb2-483ea013efc&title=&width=976#crop=0&crop=0&crop=1&crop=1&id=thCkG&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

```java
spring:
  rabbitmq:
    host: 59.110.171.189
    port: 5672
    username: admin
    password: 123
    publisher-confirm-type: correlated   # 消息确认机制
    publisher-returns: true       # 发布确认机制（消息在交换机那若路由失败，则会回退消息给生产者）
```

回退接口：

```java
//注入
@PostConstruct
    public void init() {
        //注入 （需要将当前实现类注入到RabbitTemplate的ConfirmCallback函数式接口中）
        rabbitTemplate.setConfirmCallback(this);
        rabbitTemplate.setReturnsCallback(this);
    }
/**
     * 可以在当消息传递过程中，不可达目的地时将消息返回给生产者
     * 只有不可到目的地时，才进行回退
     *
     * @param returnedMessage
     */
    @Override
    public void returnedMessage(ReturnedMessage returnedMessage) {
        log.error("消息{}，被交换机{}退回，退回原因：{},路由key:{}",
                new String(returnedMessage.getMessage().getBody()),
                returnedMessage.getExchange(),
                returnedMessage.getReplyText(),
                returnedMessage.getRoutingKey());
    }
```

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638542234889-03b41ef6-8fc5-4ffb-9f36-7287d4ff9476.png#clientId=u44e4b0cf-fc9d-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=267&id=uddd5e8ec&margin=%5Bobject%20Object%5D&name=image.png&originHeight=267&originWidth=1293&originalType=binary&ratio=1&rotation=0&showTitle=false&size=78730&status=done&style=none&taskId=u4c513758-cf34-415c-a9f3-845a33faec5&title=&width=1293#crop=0&crop=0&crop=1&crop=1&id=tOHQ4&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

#### 备份交换机

添加一个交换机和两个队列。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638578627259-759238ba-aac5-42f9-b645-401c5c9a05d2.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=328&id=ud35a1613&margin=%5Bobject%20Object%5D&name=image.png&originHeight=328&originWidth=930&originalType=binary&ratio=1&rotation=0&showTitle=false&size=197049&status=done&style=none&taskId=u04e4ef45-34c3-49a8-84c0-93d70b4ebb6&title=&width=930#crop=0&crop=0&crop=1&crop=1&id=j2ALj&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

1. 配置类

```java
package com.atguigu.rabbitmq.springbootrabbitmq.config;

import org.springframework.amqp.core.*;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/3 20:15
 * 配置类  发布确认 （高级）
 */
@Configuration
public class ConfirmConfig {
    //交换机
    public static final String CONFIRM_EXCHANGE_NAME = "confirm_exchange";
    //队列
    public static final String CONFIRM_QUEUE_NAME = "confirm_queue";
    //routing-key
    public static final String CONFIRM_ROUTING_KEY = "key1";
    // --------------------------备份交换机---------------------------------
    //备份交换机
    public static final String BACKUP_EXCHANGE_NAME = "backup_exchange";

    //备份队列
    public static final String BACKUP_QUEUE_NAME = "backup_queue";

    //报警队列
    public static final String WARNING_QUEUE_NAME = "warning_queue";

    //--------------------------------------------------------------------
    //声明确认交换机（要转发到备份交换机）
    @Bean
    public DirectExchange confirmExchange() {
        return ExchangeBuilder.directExchange(CONFIRM_EXCHANGE_NAME).durable(true)
                .withArgument("alternate-exchange", BACKUP_EXCHANGE_NAME).build();
    }

    //声明队列
    @Bean
    public Queue confirmQueue() {
        return QueueBuilder.durable(CONFIRM_QUEUE_NAME).build();
    }

    //绑定交换机和队列
    @Bean
    public Binding queueBindingExchange(@Qualifier("confirmQueue") Queue confirmQueue,
                                        @Qualifier("confirmExchange") DirectExchange confirmExchange) {
        return BindingBuilder.bind(confirmQueue).to(confirmExchange).with(CONFIRM_ROUTING_KEY);
    }

    //备份交换机
    @Bean
    public FanoutExchange backupExchange() {
        return new FanoutExchange(BACKUP_EXCHANGE_NAME);
    }

    //备份队列
    @Bean
    public Queue backupQueue() {
        return QueueBuilder.durable(BACKUP_QUEUE_NAME).build();
    }

    //报警队列
    @Bean
    public Queue warningQueue() {
        return QueueBuilder.durable(WARNING_QUEUE_NAME).build();
    }

    //绑定（备份交换机和备份队列）
    @Bean
    public Binding backupQueueBindingBackupExchange(@Qualifier("backupExchange") FanoutExchange backupExchange, @Qualifier("backupQueue") Queue backupQueue) {
        return BindingBuilder.bind(backupQueue).to(backupExchange);
    }

    //绑定（备份交换机和报警队列）
    @Bean
    public Binding warningQueueBindingBackupExchange(@Qualifier("backupExchange") FanoutExchange backupExchange, @Qualifier("warningQueue") Queue warningQueue) {
        return BindingBuilder.bind(warningQueue).to(backupExchange);
    }
}
```

2. 消费者（报警消费者）

```java
package com.atguigu.rabbitmq.springbootrabbitmq.consumer;

import com.atguigu.rabbitmq.springbootrabbitmq.config.ConfirmConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/12/4 9:10
 * 报警消费者
 */
@Component
@Slf4j
public class WarningConsumer {
    //接收报警消息
    @RabbitListener(queues = ConfirmConfig.WARNING_QUEUE_NAME)
    public void receiveWarningMsg(Message message) {
        String msg = new String(message.getBody());
        log.error("报警发现不可路由消息：{}", msg);
    }
}
```

发送请求：http://localhost:8080/confirm/sendMessage/大家好 1
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638581402507-07326d95-5109-4750-b3ab-c4751b23d55d.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=263&id=udc9907e1&margin=%5Bobject%20Object%5D&name=image.png&originHeight=263&originWidth=1171&originalType=binary&ratio=1&rotation=0&showTitle=false&size=75848&status=done&style=none&taskId=u7fb8b716-7979-4acf-b11c-fe1cb99bebd&title=&width=1171#crop=0&crop=0&crop=1&crop=1&id=Lep12&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

> **备份交换机的优先级高于回退消息、**

## 其他知识点

### 幂等性

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638581856478-4611604a-34c1-486b-a3b7-c809f3d94f0e.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=620&id=ua03a1a2a&margin=%5Bobject%20Object%5D&name=image.png&originHeight=620&originWidth=977&originalType=binary&ratio=1&rotation=0&showTitle=false&size=628166&status=done&style=none&taskId=u3bbefde1-d01a-481e-b831-abe2598835f&title=&width=977#crop=0&crop=0&crop=1&crop=1&id=pWlKw&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638582165848-9189cc73-c68b-4631-b30d-dad30387a032.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=523&id=u37f187c9&margin=%5Bobject%20Object%5D&name=image.png&originHeight=523&originWidth=1001&originalType=binary&ratio=1&rotation=0&showTitle=false&size=609037&status=done&style=none&taskId=udd6ff171-0753-4d6f-a510-a8761c65fcb&title=&width=1001#crop=0&crop=0&crop=1&crop=1&id=o6DXP&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 优先级队列

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638582363595-025332ba-94e1-4485-b6ab-e0542d69fab7.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=326&id=u83200fbd&margin=%5Bobject%20Object%5D&name=image.png&originHeight=326&originWidth=987&originalType=binary&ratio=1&rotation=0&showTitle=false&size=447217&status=done&style=none&taskId=ueea7db03-7906-4cef-baef-0ebe50a0185&title=&width=987#crop=0&crop=0&crop=1&crop=1&id=h3cca&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638582579936-dd221c3d-efc6-4e4b-b854-6667d27682a1.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=343&id=u3930b1c7&margin=%5Bobject%20Object%5D&name=image.png&originHeight=402&originWidth=1186&originalType=binary&ratio=1&rotation=0&showTitle=false&size=288467&status=done&style=none&taskId=u70a2eadf-0b86-470c-a5a8-b7d8f612ad3&title=&width=1010.9896240234375#crop=0&crop=0&crop=1&crop=1&id=WVQYU&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
实现优先级:

1. 生产者：

```java
package com.atguigu.rabbitmq.one;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.AMQP;
import com.rabbitmq.client.Channel;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/11/28 22:15
 * 生产者 ：发消息
 */
public class Producer {
    //队列名称
    private static final String QUEUE_NAME = "hello1";

    //发消息
    public static void main(String[] args) throws IOException, TimeoutException {
        //创建一个连接工厂
//        ConnectionFactory factory = new ConnectionFactory();
//        //设置工厂ip  连接rabbitmq的队列
//        factory.setHost("59.110.171.189");
//        //用户名
//        factory.setUsername("admin");
//        //密码
//        factory.setPassword("123");
//        //创建连接
//        Connection connection = factory.newConnection();
//        //获取信道
//        Channel channel = connection.createChannel();
        Channel channel = RabbitMqUtils.getChannel();
        /**
         * 生成一个队列
         * 参数；1.队列名称
         *      2.队列里面的消息是否持久化（磁盘），默认消息存储在内存中（不持久化false）
         *      3.该队列是否只供一个消费者进行消费，是否消息独有，true只允许一个消费者进行消费，默认是false（可以多个消费者消费）
         4. 是否自动删除，最后一个消费者断开连接后，该队列是否自动删除，true自动删除，false不自动删除
         5.其他参数（延迟消息......）
         */
        Map<String, Object> arguments = new HashMap<>();
        //官方允许是0-255之间。此处设置10. 允许优先级范围为0-10   不要设置过大   浪费CPU与内存
        arguments.put("x-max-priority", 10);
        channel.queueDeclare(QUEUE_NAME, true, false, false, arguments);
        //发消息
        for (int i = 0; i < 11; i++) {
            String message = "info" + i;
            if (i == 5) {
                //设置优先级
                AMQP.BasicProperties properties = new AMQP.BasicProperties().builder().priority(5).build();
                channel.basicPublish("", QUEUE_NAME, properties, message.getBytes());
            } else {
                channel.basicPublish("", QUEUE_NAME, null, message.getBytes());
            }
        }
        /*
         * 发送一个消息
         * 1. 发送到哪个交换机
         * 2. 路由的key值是哪个，本次是队列的名称
         * 3. 其他参数信息
         * 4. 发送消息的消息体
         */
        System.out.println("消息发送完毕");
    }
}
```

启动生产者：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638584428018-a99005d9-2193-463c-9f45-3f72656510ca.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=245&id=u9109bfc5&margin=%5Bobject%20Object%5D&name=image.png&originHeight=245&originWidth=673&originalType=binary&ratio=1&rotation=0&showTitle=false&size=24479&status=done&style=none&taskId=u0a4a6f5a-f03f-4ab3-8fcc-d9bdc327aad&title=&width=673#crop=0&crop=0&crop=1&crop=1&id=shKB3&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### ![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638584267331-0bf02c8d-6536-43a8-aa18-ee5f4ed82255.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=500&id=AvLAP&margin=%5Bobject%20Object%5D&name=image.png&originHeight=500&originWidth=1065&originalType=binary&ratio=1&rotation=0&showTitle=false&size=74831&status=done&style=none&taskId=u77c77f80-cfec-453b-bc9f-f82bf26b07c&title=&width=1065#crop=0&crop=0&crop=1&crop=1&id=cIQXz&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

2. 消费者 :

```java
package com.atguigu.rabbitmq.one;

import com.atguigu.rabbitmq.utils.RabbitMqUtils;
import com.rabbitmq.client.*;

import java.io.IOException;
import java.util.Arrays;
import java.util.concurrent.TimeoutException;

/**
 * @author LiFang
 * @version 1.0
 * @since 2021/11/29 15:04
 * 消费者:接收消息
 */
public class Consumer {
    //队列名称
    public static final String QUEUE_NAME = "hello1";

    //接收消息
    public static void main(String[] args) throws IOException, TimeoutException {
        //创建连接工厂
//        ConnectionFactory factory = new ConnectionFactory();
//        factory.setHost("59.110.171.189");
//        factory.setUsername("admin");
//        factory.setPassword("123");
//        Connection connection = factory.newConnection();
//        Channel channel = connection.createChannel();
        Channel channel = RabbitMqUtils.getChannel();
        //声明 接收消息(成功后的回调)
        DeliverCallback deliverCallback = (consumerTag, message) -> {
            System.out.println(new String(message.getBody()));
        };
        //取消消息时的回调
        CancelCallback cancelCallback = consumerTag -> {
            System.out.println("消息消费被中断");
        };
        /*
         * 消费者 消费消息
         * 1.消费哪个队列
         * 2. 消费成功之后是否要自动应答，true代表自动应答,false代表手动应答。
         * 3. 消费者未成功消费的回调。
         * 4. 消费者取消消费的回调
         */
        channel.basicConsume(QUEUE_NAME, true, deliverCallback, cancelCallback);
    }
}
```

启动消费者，
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638584610103-d784c402-b9b7-4321-80d9-c4b95990f410.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=346&id=u91a8ee8e&margin=%5Bobject%20Object%5D&name=image.png&originHeight=346&originWidth=652&originalType=binary&ratio=1&rotation=0&showTitle=false&size=36450&status=done&style=none&taskId=u90a3da53-d612-4152-b8b6-157c3e789ca&title=&width=652#crop=0&crop=0&crop=1&crop=1&id=UEHzd&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 惰性队列

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638584657059-9bf42f28-e7a0-4c4f-8a39-c56038bd0071.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=425&id=ud4e3da7e&margin=%5Bobject%20Object%5D&name=image.png&originHeight=425&originWidth=993&originalType=binary&ratio=1&rotation=0&showTitle=false&size=597255&status=done&style=none&taskId=u2ff8ea80-3715-4c63-a718-4d71e1b8488&title=&width=993#crop=0&crop=0&crop=1&crop=1&id=wMAkZ&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638584904322-348e89b5-e2f2-4df0-ba11-7540a061f849.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=613&id=u9cab5578&margin=%5Bobject%20Object%5D&name=image.png&originHeight=613&originWidth=1175&originalType=binary&ratio=1&rotation=0&showTitle=false&size=404748&status=done&style=none&taskId=uc0905b86-a7ec-4a0f-8a69-356a47ad688&title=&width=1175#crop=0&crop=0&crop=1&crop=1&id=NaNR3&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
惰性队列执行性能不太好，因此默认情况下不使用惰性队列，而使用正常队列。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638585096408-ecb74216-dfa9-41e3-b7bd-bd5236b2c1da.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=431&id=u4ab29e59&margin=%5Bobject%20Object%5D&name=image.png&originHeight=431&originWidth=967&originalType=binary&ratio=1&rotation=0&showTitle=false&size=466179&status=done&style=none&taskId=ub1da4c7a-e46a-44f7-9b2f-e5129f4a839&title=&width=967#crop=0&crop=0&crop=1&crop=1&id=ZtuGu&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638585305462-e73859d4-5121-406a-b308-57cede7f1bac.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=413&id=uf8c1b8a8&margin=%5Bobject%20Object%5D&name=image.png&originHeight=413&originWidth=966&originalType=binary&ratio=1&rotation=0&showTitle=false&size=247424&status=done&style=none&taskId=ua29dd158-1851-4974-bd9b-3c01a9c0ea5&title=&width=966#crop=0&crop=0&crop=1&crop=1&id=wFSJu&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

- 惰性队列从**磁盘**上读取消息，因此消费消息比较慢，但是内存消耗较小，在内存中只存储一些索引。一旦需要消费这些消息时，惰性队列会通过内存中的索引，去读取磁盘中相应的消息，到内存，再消费消息。
- 正常队列从**内存**中读取消息，因此消费消息比较快，但是内存消耗较大。

## rabbitmq 集群

### 集群原理

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638586666884-b99e8e77-81ef-4547-a9cd-1dcd00e86009.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=501&id=u84ce9d05&margin=%5Bobject%20Object%5D&name=image.png&originHeight=501&originWidth=1025&originalType=binary&ratio=1&rotation=0&showTitle=false&size=171726&status=done&style=none&taskId=ud7aa0990-8e0c-4e31-9dd1-c6d20007401&title=&width=1025#crop=0&crop=0&crop=1&crop=1&id=hjXVB&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 镜像队列（备份）

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638587610363-c97ef89e-768e-4278-a087-89f20e211145.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=348&id=ue8695270&margin=%5Bobject%20Object%5D&name=image.png&originHeight=348&originWidth=981&originalType=binary&ratio=1&rotation=0&showTitle=false&size=453959&status=done&style=none&taskId=ue9f78068-c45e-4cc9-a3e0-595ae6c7337&title=&width=981#crop=0&crop=0&crop=1&crop=1&id=FTNYI&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

### 高可用负载均衡

若节点 1 宕机了，生产者需要连接节点 2 或节点 3。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638588031855-ab97c0f3-9861-4222-b593-0a4dbfbf566d.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=754&id=u0c60fb59&margin=%5Bobject%20Object%5D&name=image.png&originHeight=754&originWidth=1028&originalType=binary&ratio=1&rotation=0&showTitle=false&size=344345&status=done&style=none&taskId=uaef85042-099b-42a3-8caf-268a89b7438&title=&width=1028#crop=0&crop=0&crop=1&crop=1&id=XmCHx&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
出现问题：生产者无法变更 rabbitmq 的 ip，此时需要借助外力 Haproxy。

#### Haproxy 实现高可用 负载均衡（高并发）

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638588332155-384a9066-f6ed-434c-bd8d-a08678795b99.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=177&id=u91155287&margin=%5Bobject%20Object%5D&name=image.png&originHeight=177&originWidth=973&originalType=binary&ratio=1&rotation=0&showTitle=false&size=240431&status=done&style=none&taskId=u9a4dff8d-f824-447c-b845-2962ddc0650&title=&width=973#crop=0&crop=0&crop=1&crop=1&id=BHuXj&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638588403571-837d2496-d169-4b00-aa3c-4459e5dfd616.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=644&id=u63b0c105&margin=%5Bobject%20Object%5D&name=image.png&originHeight=644&originWidth=740&originalType=binary&ratio=1&rotation=0&showTitle=false&size=224363&status=done&style=none&taskId=u400f5630-901e-4db7-8556-6d72a1f206a&title=&width=740#crop=0&crop=0&crop=1&crop=1&id=FRrD8&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638588495639-57e1823e-e317-48f1-bd99-4a64ab26b8b3.png#clientId=ueb126df1-e3fc-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=711&id=uefaa64c3&margin=%5Bobject%20Object%5D&name=image.png&originHeight=711&originWidth=860&originalType=binary&ratio=1&rotation=0&showTitle=false&size=371827&status=done&style=none&taskId=u8f30ca6f-4949-4c9d-899d-b31600baa56&title=&width=860#crop=0&crop=0&crop=1&crop=1&id=K5Fpn&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 联合交换机

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638600972390-f8eabb13-fdba-432b-8b93-c4798757e13e.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=660&id=u1565c7a2&margin=%5Bobject%20Object%5D&name=image.png&originHeight=660&originWidth=1136&originalType=binary&ratio=1&rotation=0&showTitle=false&size=882067&status=done&style=none&taskId=u40ae3ed4-1bbc-4baa-b912-40f55e8b353&title=&width=1136#crop=0&crop=0&crop=1&crop=1&id=FkHCS&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638601768985-91857261-fe17-4687-bc9f-f8d9daf1a364.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=524&id=uafeaba48&margin=%5Bobject%20Object%5D&name=image.png&originHeight=524&originWidth=1115&originalType=binary&ratio=1&rotation=0&showTitle=false&size=307899&status=done&style=none&taskId=u4499a665-a618-4138-a2f2-5bdf1dbaca0&title=&width=1115#crop=0&crop=0&crop=1&crop=1&id=FgJli&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638601930969-0c445ecb-7e66-43cd-a7d1-3aa8c76f884d.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=581&id=u6d4c749b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=581&originWidth=505&originalType=binary&ratio=1&rotation=0&showTitle=false&size=221677&status=done&style=none&taskId=uf8d981fd-837f-4eb6-83f6-a7deba0a018&title=&width=505#crop=0&crop=0&crop=1&crop=1&id=NxTl9&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638602088334-f76d8ba1-5c6d-4280-87c8-b7d58d42f902.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=506&id=u4b7146f5&margin=%5Bobject%20Object%5D&name=image.png&originHeight=506&originWidth=976&originalType=binary&ratio=1&rotation=0&showTitle=false&size=158537&status=done&style=none&taskId=u64d80530-7388-4c12-9d3b-48d90765e0b&title=&width=976#crop=0&crop=0&crop=1&crop=1&id=oVYwK&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638602110103-8ee2df46-7982-4b08-a6c8-e4d9c701b69f.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=666&id=u65df8122&margin=%5Bobject%20Object%5D&name=image.png&originHeight=666&originWidth=933&originalType=binary&ratio=1&rotation=0&showTitle=false&size=302115&status=done&style=none&taskId=u970ef30c-4b50-4327-928e-6bf0cdbc242&title=&width=933#crop=0&crop=0&crop=1&crop=1&id=A9wRm&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## 联邦队列

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638602602857-2efc1842-e9c7-409e-a302-2b4c63e92027.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=833&id=u3d500d40&margin=%5Bobject%20Object%5D&name=image.png&originHeight=833&originWidth=1312&originalType=binary&ratio=1&rotation=0&showTitle=false&size=553687&status=done&style=none&taskId=u77ecfe28-0a6d-4318-bc8e-c80d6183ecc&title=&width=1312#crop=0&crop=0&crop=1&crop=1&id=qvMwP&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
两个不同地区数据同步。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638603240478-ba4a3a39-d3dc-41b3-9ee9-c8d9f2718ff9.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=551&id=u0dc6d91b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=551&originWidth=1149&originalType=binary&ratio=1&rotation=0&showTitle=false&size=244288&status=done&style=none&taskId=u65c1251d-b002-4909-ae1d-f27aa9d85ee&title=&width=1149#crop=0&crop=0&crop=1&crop=1&id=Rmak1&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)

## Shovel

![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638603352779-28d006e0-d330-4802-935c-040341c1ca8d.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=324&id=uc852da4a&margin=%5Bobject%20Object%5D&name=image.png&originHeight=324&originWidth=1287&originalType=binary&ratio=1&rotation=0&showTitle=false&size=568699&status=done&style=none&taskId=u2b770501-53fa-4cbc-a428-000590e2c17&title=&width=1287#crop=0&crop=0&crop=1&crop=1&id=fxL0i&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638603460089-03466d04-df20-4ab2-8968-f1b5ef5905ca.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=409&id=ua502f49e&margin=%5Bobject%20Object%5D&name=image.png&originHeight=409&originWidth=871&originalType=binary&ratio=1&rotation=0&showTitle=false&size=188661&status=done&style=none&taskId=u48a08d45-4dad-40e0-9723-55db3e3ef79&title=&width=871#crop=0&crop=0&crop=1&crop=1&id=lh1tz&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638603378352-15aca4d9-af9b-48c1-b796-60a86b637ebd.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=667&id=uec9ad770&margin=%5Bobject%20Object%5D&name=image.png&originHeight=667&originWidth=864&originalType=binary&ratio=1&rotation=0&showTitle=false&size=266940&status=done&style=none&taskId=u8acd6a6e-3ed2-4306-8639-2eeb16612c3&title=&width=864#crop=0&crop=0&crop=1&crop=1&id=jpTqS&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638603594801-6bd296a5-c23b-418f-a94e-5261833d5605.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=592&id=u903663bb&margin=%5Bobject%20Object%5D&name=image.png&originHeight=592&originWidth=994&originalType=binary&ratio=1&rotation=0&showTitle=false&size=194438&status=done&style=none&taskId=ud10d2c55-8f5b-4b88-b096-8942402c361&title=&width=994#crop=0&crop=0&crop=1&crop=1&id=oSJ3T&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2324645/1638603639753-9ae10564-7bad-4528-afd2-867c58d1f413.png#clientId=u1823549f-f362-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=121&id=u71e6fa9c&margin=%5Bobject%20Object%5D&name=image.png&originHeight=121&originWidth=1169&originalType=binary&ratio=1&rotation=0&showTitle=false&size=88867&status=done&style=none&taskId=u55070310-f786-4b38-98ce-55db2f75ca1&title=&width=1169#crop=0&crop=0&crop=1&crop=1&id=Gjcgc&originalType=binary&ratio=1&rotation=0&showTitle=false&status=done&style=none&title=)
