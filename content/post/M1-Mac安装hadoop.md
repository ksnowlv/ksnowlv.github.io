---
title: "M1 Mac安装hadoop"
date: 2023-12-01T16:29:29+08:00
lastmod: 2023-12-01T16:29:29+08:00
keywords: ["Mac", "hadoop", "大数据"]
tags: ["Mac", "hadoop", "大数据"]
categories: ["Mac", "hadoop", "大数据"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->


## hadoop安装


### 1.JDK安装

官网[jdk](https://www.oracle.com/hk/java/technologies/downloads/#java8-mac)
下载java， 最好是安装1.8版本的jdk。

#### 验证java版本

安装完成后，使用java -version验证下版本。如果多个版本，使用/usr/libexec/java_home -V显示所有已安装的版本

```terminal
(base) lvwei@lvweideMacBook-Pro ~ % java -version
openjdk version "1.8.0_382"
OpenJDK Runtime Environment Corretto-8.382.05.1 (build 1.8.0_382-b05)
OpenJDK 64-Bit Server VM Corretto-8.382.05.1 (build 25.382-b05, mixed mode)
(base) lvwei@lvweideMacBook-Pro ~ % /usr/libexec/java_home -V
Matching Java Virtual Machines (3):
    1.8.391.13 (arm64) "Oracle Corporation" - "Java" /Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
    1.8.0_391 (arm64) "Oracle Corporation" - "Java SE 8" /Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home
    1.8.0_382 (arm64) "Amazon" - "Amazon Corretto 8" /Users/lvwei/Library/Java/JavaVirtualMachines/corretto-1.8.0_382/Contents/Home
/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home

```

#### 配置java_home


打开.bash_profile文件，配置java_home环境变量

```terminal
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH:.
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.
```

重启终端, 通过echo $JAVA_HOME显示java位置

```terminal
(base) lvwei@lvweideMacBook-Pro ~ % echo $JAVA_HOME
/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home
```

### 2.SSH免密设置

打开系统偏好设置,找到“远程登陆”， 如果没有hadoop系统用户，则添加。

![image](/images/post/M1-Mac安装hadoop/ssh_setting_1.jpg)

![image](/images/post/M1-Mac安装hadoop/ssh_setting_2.jpg)


**ssh localhost**验证

打开终端，依次输入各命令进行验证

```terminal
(base) lvwei@lvweideMacBook-Pro ~ % 
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
Generating public/private rsa key pair.
/Users/lvwei/.ssh/id_rsa already exists.
Overwrite (y/n)? n
(base) lvwei@lvweideMacBook-Pro ~ % cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
(base) lvwei@lvweideMacBook-Pro ~ % chmod 0600 ~/.ssh/id_rsa.pub
(base) lvwei@lvweideMacBook-Pro ~ % ssh localhost
Last login: Fri Dec  1 16:37:01 2023
/Users/lvwei/.zprofile:18: command no
```

### 3.hadoop下载

#### 1.hadoop下载

从[hadoop官网](https://hadoop.apache.org/releases.html)

![image](/images/post/M1-Mac安装hadoop/hadoop_download.jpg)

![image](/images/post/M1-Mac安装hadoop/hadoop_download_url.jpg)

#### 2.hadoop目录配置

把hadoop-3.3.6解压后，配置到根目录下(users/用户名/hadoop-3.3.6),我的目录为：/Users/lvwei/hadoop-3.3.6

#### 3..zprofile配置

```python
# Hadoop
export HADOOP_HOME=/Users/lvwei/hadoop-3.3.6/
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/nativ"
————————————————

#原文链接：https://blog.csdn.net/xiaoqingqing521/article/details/133770612

```

### 4.hadoop配置文件

* 4.1 hadoop-env.sh

配置java_home环境

```python
# export JAVA_HOME=
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home
```

* 4.2 core-site.sh

```python
<configuration>

  <property>
      <name>hadoop.tmp.dir</name>
      <value>/Users/lvwei/hdfs/tmp/</value>
  </property>
  <property>
      <name>fs.default.name</name>
      <value>hdfs://127.0.0.1:9000</value>
  </property>

</configuration>
```

* 4.3 hdfs-site.xml

```python
<configuration>

  <property>
      <name>dfs.data.dir</name>
      <value>/Users/lvwei/hdfs/namenode</value>
  </property>
  
  <property>
      <name>dfs.data.dir</name>
      <value>/Users/lvwei/hdfs/datanode</value>
  </property>

  <property>
      <name>dfs.replication</name>
      <value>1</value>
  </property>

</configuration>

```

![img.png](/images/post/M1-Mac安装hadoop/hadoop_hdfs_setting.png)

* 4.4 mapred-site.xml

```python
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
```

* 4.5 yarn-site.xml
```python
<configuration>

<!-- Site specific YARN configuration properties -->
<property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>127.0.0.1</value>
  </property>
  <property>
    <name>yarn.acl.enable</name>
    <value>0</value>
  </property>
  <property>
    <name>yarn.nodemanager.env-whitelist</name>
    <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PERPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
  </property>

  
</configuration>
```

### 5.hadoop hdfs格式化

```terminal
(base) lvwei@lvweideMacBook-Pro bin % ./hdfs namenode -format
WARNING: /Users/lvwei/hadoop-3.3.6//logs does not exist. Creating.
2023-12-01 16:27:05,991 INFO namenode.NameNode: STARTUP_MSG: 
/************************************************************
STARTUP_MSG: Starting NameNode
STARTUP_MSG:   host = lvweideMacBook-Pro.local/127.0.0.1
STARTUP_MSG:   args = [-format]
STARTUP_MSG:   version = 3.3.6
STARTUP_MSG:   classpath = /Users/lvwei/hadoop-3.3.6//etc/hadoop:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jaxb-impl-2.2.3-1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/curator-client-5.2.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/reload4j-1.2.22.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jackson-core-2.12.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-buffer-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-io-2.8.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/hadoop-annotations-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-native-epoll-4.1.89.Final-linux-x86_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-configuration2-2.8.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/slf4j-api-1.7.36.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-classes-kqueue-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerby-xdr-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/failureaccess-1.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/checker-qual-2.5.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jersey-servlet-1.19.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/hadoop-auth-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jetty-servlet-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/woodstox-core-5.4.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/curator-framework-5.2.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/httpcore-4.4.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/snappy-java-1.1.8.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-logging-1.1.3.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-native-kqueue-4.1.89.Final-osx-x86_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerby-pkix-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/avro-1.7.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/dnsjava-2.1.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-udt-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jetty-security-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-resolver-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jersey-json-1.20.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-net-3.9.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/javax.servlet-api-3.1.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jersey-server-1.19.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerb-server-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/hadoop-shaded-guava-1.1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-handler-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-cli-1.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/guava-27.0-jre.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-handler-ssl-ocsp-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-native-unix-common-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/protobuf-java-2.5.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/gson-2.9.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jcip-annotations-1.0-1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerby-asn1-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-classes-epoll-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jetty-http-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jsr311-api-1.1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/stax2-api-4.2.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-memcache-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerb-identity-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-socks-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerby-config-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerb-util-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jetty-xml-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-stomp-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/zookeeper-3.6.3.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jaxb-api-2.2.11.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jakarta.activation-api-1.2.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jackson-core-asl-1.9.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jetty-webapp-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-compress-1.21.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/metrics-core-3.2.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jsp-api-2.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerb-crypto-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jersey-core-1.19.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-common-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerb-admin-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-resolver-dns-native-macos-4.1.89.Final-osx-aarch_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/audience-annotations-0.5.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-xml-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-dns-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-native-kqueue-4.1.89.Final-osx-aarch_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/j2objc-annotations-1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jul-to-slf4j-1.7.36.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/paranamer-2.3.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerb-client-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jetty-util-ajax-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-http-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-collections-3.2.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-codec-1.15.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jettison-1.5.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-redis-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-native-epoll-4.1.89.Final-linux-aarch_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/token-provider-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/curator-recipes-5.2.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-beanutils-1.9.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerb-common-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-resolver-dns-native-macos-4.1.89.Final-osx-x86_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-resolver-dns-classes-macos-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-resolver-dns-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerb-simplekdc-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jackson-annotations-2.12.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jsch-0.1.55.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-haproxy-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-http2-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jackson-databind-2.12.7.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/re2j-1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-all-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-smtp-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-lang3-3.12.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerb-core-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/nimbus-jose-jwt-9.8.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/httpclient-4.5.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jetty-util-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jetty-server-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-rxtx-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/animal-sniffer-annotations-1.17.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-handler-proxy-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jetty-io-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/kerby-util-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jsr305-3.0.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/jackson-mapper-asl-1.9.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-math3-3.1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-daemon-1.0.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/hadoop-shaded-protobuf_3_7-1.1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-mqtt-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-transport-sctp-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/commons-text-1.10.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/netty-codec-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/lib/zookeeper-jute-3.6.3.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/hadoop-common-3.3.6-tests.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/hadoop-nfs-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/hadoop-common-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/hadoop-registry-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/common/hadoop-kms-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jaxb-impl-2.2.3-1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/curator-client-5.2.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/reload4j-1.2.22.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jackson-core-2.12.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-buffer-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-io-2.8.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/hadoop-annotations-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-native-epoll-4.1.89.Final-linux-x86_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-configuration2-2.8.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-classes-kqueue-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerby-xdr-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/failureaccess-1.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/checker-qual-2.5.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jersey-servlet-1.19.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/hadoop-auth-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jetty-servlet-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/woodstox-core-5.4.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/curator-framework-5.2.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/httpcore-4.4.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/snappy-java-1.1.8.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-logging-1.1.3.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-native-kqueue-4.1.89.Final-osx-x86_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerby-pkix-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/avro-1.7.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/dnsjava-2.1.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-udt-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kotlin-stdlib-common-1.4.10.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jetty-security-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-resolver-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jersey-json-1.20.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-net-3.9.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/javax.servlet-api-3.1.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jersey-server-1.19.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerb-server-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/hadoop-shaded-guava-1.1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-handler-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-cli-1.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/guava-27.0-jre.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-handler-ssl-ocsp-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-native-unix-common-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/protobuf-java-2.5.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/gson-2.9.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jcip-annotations-1.0-1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerby-asn1-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kotlin-stdlib-1.4.10.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-classes-epoll-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jetty-http-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jsr311-api-1.1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/stax2-api-4.2.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-memcache-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerb-identity-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-socks-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerby-config-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerb-util-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jetty-xml-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-stomp-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/zookeeper-3.6.3.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jaxb-api-2.2.11.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/json-simple-1.1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jakarta.activation-api-1.2.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jackson-core-asl-1.9.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jetty-webapp-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-compress-1.21.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/metrics-core-3.2.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerb-crypto-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jersey-core-1.19.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-common-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerb-admin-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-resolver-dns-native-macos-4.1.89.Final-osx-aarch_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/audience-annotations-0.5.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-xml-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-dns-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-native-kqueue-4.1.89.Final-osx-aarch_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/j2objc-annotations-1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/paranamer-2.3.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerb-client-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jetty-util-ajax-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-http-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-collections-3.2.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-codec-1.15.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-3.10.6.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jettison-1.5.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-redis-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-native-epoll-4.1.89.Final-linux-aarch_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/token-provider-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/curator-recipes-5.2.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-beanutils-1.9.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerb-common-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-resolver-dns-native-macos-4.1.89.Final-osx-x86_64.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-resolver-dns-classes-macos-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-resolver-dns-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerb-simplekdc-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jackson-annotations-2.12.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jsch-0.1.55.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-haproxy-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-http2-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/okio-2.8.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jackson-databind-2.12.7.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/re2j-1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-all-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-smtp-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/HikariCP-java7-2.4.12.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-lang3-3.12.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerb-core-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/nimbus-jose-jwt-9.8.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/httpclient-4.5.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jetty-util-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jetty-server-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-rxtx-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/animal-sniffer-annotations-1.17.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-handler-proxy-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/okhttp-4.9.3.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/leveldbjni-all-1.8.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jetty-io-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/kerby-util-1.0.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jsr305-3.0.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/jackson-mapper-asl-1.9.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-math3-3.1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-daemon-1.0.13.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/hadoop-shaded-protobuf_3_7-1.1.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-mqtt-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-transport-sctp-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/commons-text-1.10.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/netty-codec-4.1.89.Final.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/lib/zookeeper-jute-3.6.3.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-3.3.6-tests.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-client-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-native-client-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-rbf-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-nfs-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-native-client-3.3.6-tests.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-rbf-3.3.6-tests.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-httpfs-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/hdfs/hadoop-hdfs-client-3.3.6-tests.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-common-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-shuffle-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-hs-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-core-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-uploader-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-3.3.6-tests.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-app-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-nativetask-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/mapreduce/hadoop-mapreduce-client-hs-plugins-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/javax.websocket-api-1.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jakarta.xml.bind-api-2.3.2.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jackson-jaxrs-base-2.12.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/bcprov-jdk15on-1.68.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/aopalliance-1.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jetty-plus-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/java-util-1.9.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/javax-websocket-server-impl-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/snakeyaml-2.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/bcpkix-jdk15on-1.68.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jetty-jndi-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jackson-jaxrs-json-provider-2.12.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/geronimo-jcache_1.0_spec-1.0-alpha-1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/objenesis-2.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jline-3.9.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/websocket-server-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/asm-commons-9.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/javax-websocket-client-impl-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/fst-2.50.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/guice-servlet-4.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jetty-client-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/mssql-jdbc-6.2.1.jre7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/asm-tree-9.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/websocket-servlet-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/websocket-api-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jersey-client-1.19.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/javax.websocket-client-api-1.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/ehcache-3.3.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/websocket-common-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jna-5.2.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/json-io-2.5.1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jersey-guice-1.19.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/guice-4.0.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jackson-module-jaxb-annotations-2.12.7.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/websocket-client-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/javax.inject-1.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/swagger-annotations-1.5.4.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/lib/jetty-annotations-9.4.51.v20230217.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-services-core-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-applications-mawo-core-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-server-router-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-server-common-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-server-resourcemanager-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-services-api-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-client-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-common-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-server-nodemanager-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-server-web-proxy-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-server-tests-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-api-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-registry-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-server-sharedcachemanager-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-applications-distributedshell-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-server-timeline-pluginstorage-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-applications-unmanaged-am-launcher-3.3.6.jar:/Users/lvwei/hadoop-3.3.6//share/hadoop/yarn/hadoop-yarn-server-applicationhistoryservice-3.3.6.jar
STARTUP_MSG:   build = https://github.com/apache/hadoop.git -r 1be78238728da9266a4f88195058f08fd012bf9c; compiled by 'ubuntu' on 2023-06-18T08:22Z
STARTUP_MSG:   java = 1.8.0_391
************************************************************/
2023-12-01 16:27:06,008 INFO namenode.NameNode: registered UNIX signal handlers for [TERM, HUP, INT]
2023-12-01 16:27:06,058 INFO namenode.NameNode: createNameNode [-format]
2023-12-01 16:27:06,169 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
2023-12-01 16:27:06,429 INFO namenode.NameNode: Formatting using clusterid: CID-3c5a3774-4ffd-4c23-9eb8-7236178561f9
2023-12-01 16:27:06,449 INFO namenode.FSEditLog: Edit logging is async:true
2023-12-01 16:27:06,466 INFO namenode.FSNamesystem: KeyProvider: null
2023-12-01 16:27:06,467 INFO namenode.FSNamesystem: fsLock is fair: true
2023-12-01 16:27:06,467 INFO namenode.FSNamesystem: Detailed lock hold time metrics enabled: false
2023-12-01 16:27:06,492 INFO namenode.FSNamesystem: fsOwner                = lvwei (auth:SIMPLE)
2023-12-01 16:27:06,492 INFO namenode.FSNamesystem: supergroup             = supergroup
2023-12-01 16:27:06,492 INFO namenode.FSNamesystem: isPermissionEnabled    = true
2023-12-01 16:27:06,492 INFO namenode.FSNamesystem: isStoragePolicyEnabled = true
2023-12-01 16:27:06,493 INFO namenode.FSNamesystem: HA Enabled: false
2023-12-01 16:27:06,522 INFO common.Util: dfs.datanode.fileio.profiling.sampling.percentage set to 0. Disabling file IO profiling
2023-12-01 16:27:06,614 INFO blockmanagement.DatanodeManager: dfs.block.invalidate.limit : configured=1000, counted=60, effected=1000
2023-12-01 16:27:06,614 INFO blockmanagement.DatanodeManager: dfs.namenode.datanode.registration.ip-hostname-check=true
2023-12-01 16:27:06,617 INFO blockmanagement.BlockManager: dfs.namenode.startup.delay.block.deletion.sec is set to 000:00:00:00.000
2023-12-01 16:27:06,617 INFO blockmanagement.BlockManager: The block deletion will start around 2023 十二月 01 16:27:06
2023-12-01 16:27:06,617 INFO util.GSet: Computing capacity for map BlocksMap
2023-12-01 16:27:06,618 INFO util.GSet: VM type       = 64-bit
2023-12-01 16:27:06,618 INFO util.GSet: 2.0% max memory 3.6 GB = 72.8 MB
2023-12-01 16:27:06,618 INFO util.GSet: capacity      = 2^23 = 8388608 entries
2023-12-01 16:27:06,622 INFO blockmanagement.BlockManager: Storage policy satisfier is disabled
2023-12-01 16:27:06,622 INFO blockmanagement.BlockManager: dfs.block.access.token.enable = false
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManagerSafeMode: dfs.namenode.safemode.threshold-pct = 0.999
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManagerSafeMode: dfs.namenode.safemode.min.datanodes = 0
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManagerSafeMode: dfs.namenode.safemode.extension = 30000
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManager: defaultReplication         = 1
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManager: maxReplication             = 512
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManager: minReplication             = 1
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManager: maxReplicationStreams      = 2
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManager: redundancyRecheckInterval  = 3000ms
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManager: encryptDataTransfer        = false
2023-12-01 16:27:06,626 INFO blockmanagement.BlockManager: maxNumBlocksToLog          = 1000
2023-12-01 16:27:06,704 INFO namenode.FSDirectory: GLOBAL serial map: bits=29 maxEntries=536870911
2023-12-01 16:27:06,704 INFO namenode.FSDirectory: USER serial map: bits=24 maxEntries=16777215
2023-12-01 16:27:06,704 INFO namenode.FSDirectory: GROUP serial map: bits=24 maxEntries=16777215
2023-12-01 16:27:06,704 INFO namenode.FSDirectory: XATTR serial map: bits=24 maxEntries=16777215
2023-12-01 16:27:06,711 INFO util.GSet: Computing capacity for map INodeMap
2023-12-01 16:27:06,711 INFO util.GSet: VM type       = 64-bit
2023-12-01 16:27:06,711 INFO util.GSet: 1.0% max memory 3.6 GB = 36.4 MB
2023-12-01 16:27:06,711 INFO util.GSet: capacity      = 2^22 = 4194304 entries
2023-12-01 16:27:06,712 INFO namenode.FSDirectory: ACLs enabled? true
2023-12-01 16:27:06,712 INFO namenode.FSDirectory: POSIX ACL inheritance enabled? true
2023-12-01 16:27:06,712 INFO namenode.FSDirectory: XAttrs enabled? true
2023-12-01 16:27:06,712 INFO namenode.NameNode: Caching file names occurring more than 10 times
2023-12-01 16:27:06,715 INFO snapshot.SnapshotManager: Loaded config captureOpenFiles: false, skipCaptureAccessTimeOnlyChange: false, snapshotDiffAllowSnapRootDescendant: true, maxSnapshotLimit: 65536
2023-12-01 16:27:06,716 INFO snapshot.SnapshotManager: SkipList is disabled
2023-12-01 16:27:06,718 INFO util.GSet: Computing capacity for map cachedBlocks
2023-12-01 16:27:06,718 INFO util.GSet: VM type       = 64-bit
2023-12-01 16:27:06,718 INFO util.GSet: 0.25% max memory 3.6 GB = 9.1 MB
2023-12-01 16:27:06,718 INFO util.GSet: capacity      = 2^20 = 1048576 entries
2023-12-01 16:27:06,784 INFO metrics.TopMetrics: NNTop conf: dfs.namenode.top.window.num.buckets = 10
2023-12-01 16:27:06,784 INFO metrics.TopMetrics: NNTop conf: dfs.namenode.top.num.users = 10
2023-12-01 16:27:06,784 INFO metrics.TopMetrics: NNTop conf: dfs.namenode.top.windows.minutes = 1,5,25
2023-12-01 16:27:06,786 INFO namenode.FSNamesystem: Retry cache on namenode is enabled
2023-12-01 16:27:06,786 INFO namenode.FSNamesystem: Retry cache will use 0.03 of total heap and retry cache entry expiry time is 600000 millis
2023-12-01 16:27:06,788 INFO util.GSet: Computing capacity for map NameNodeRetryCache
2023-12-01 16:27:06,788 INFO util.GSet: VM type       = 64-bit
2023-12-01 16:27:06,789 INFO util.GSet: 0.029999999329447746% max memory 3.6 GB = 1.1 MB
2023-12-01 16:27:06,789 INFO util.GSet: capacity      = 2^17 = 131072 entries
2023-12-01 16:27:06,801 INFO namenode.FSImage: Allocated new BlockPoolId: BP-297451916-127.0.0.1-1701419226798
2023-12-01 16:27:06,808 INFO common.Storage: Storage directory /Users/lvwei/hdfs/tmp/dfs/name has been successfully formatted.
2023-12-01 16:27:06,823 INFO namenode.FSImageFormatProtobuf: Saving image file /Users/lvwei/hdfs/tmp/dfs/name/current/fsimage.ckpt_0000000000000000000 using no compression
2023-12-01 16:27:06,886 INFO namenode.FSImageFormatProtobuf: Image file /Users/lvwei/hdfs/tmp/dfs/name/current/fsimage.ckpt_0000000000000000000 of size 400 bytes saved in 0 seconds .
2023-12-01 16:27:06,894 INFO namenode.NNStorageRetentionManager: Going to retain 1 images with txid >= 0
2023-12-01 16:27:06,907 INFO namenode.FSNamesystem: Stopping services started for active state
2023-12-01 16:27:06,907 INFO namenode.FSNamesystem: Stopping services started for standby state
2023-12-01 16:27:06,909 INFO namenode.FSImage: FSImageSaver clean checkpoint: txid=0 when meet shutdown.
2023-12-01 16:27:06,909 INFO namenode.NameNode: SHUTDOWN_MSG: 
/************************************************************
SHUTDOWN_MSG: Shutting down NameNode at lvweideMacBook-Pro.local/127.0.0.1
************************************************************/
(base) 
```

SHUTDOWN_MSG: Shutting down NameNode at lvweideMacBook-Pro.local/127.0.0.1 表明hadoop已格式化


### 6.hadoop启动

打开终端，切换到hadoop-3.3.6/sbin目录,启动hadoop服务
```terminal
(base) lvwei@lvweideMacBook-Pro sbin % start-all.sh
WARNING: Attempting to start all Apache Hadoop daemons as lvwei in 10 seconds.
WARNING: This is not a recommended production deployment configuration.
WARNING: Use CTRL-C to abort.
Starting namenodes on [localhost]
Starting datanodes
Starting secondary namenodes [lvweideMacBook-Pro.local]
2023-12-04 17:19:56,553 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Starting resourcemanager
Starting nodemanagers

(base) lvwei@lvweideMacBook-Pro sbin % jps
70019 
868 ResourceManager
564 SecondaryNameNode
1381 NodeManager
22534 Jps
310 DataNode
96585 
99468 NameNode

```

resourcemanager和nodemanagers已启动成功




### 7.hadoop启动验证

浏览器打开http://localhost:9870网页

![image](/images/post/M1-Mac安装hadoop/hadoop_overview1.png)

![image](/images/post/M1-Mac安装hadoop/hadoop_overview2.png)

