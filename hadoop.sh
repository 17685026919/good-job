#!/bin/bash
#********************************************************************

#一键安装与配置Hadoop（Ubuntu18.04）
#Author：田小明
#blogs:	http://www.txm.cool
#email: 921941787@qq.com
#github: https://github.com/TdreamT/hadoop.git

#********************************************************************
#!/bin/bash

echo -n "请输入用户名: "
read name

#1.Jdk与Hadoop的解压和安装

tar -zxvf /home/$name/jdk-8u261-linux-x64.tar.gz
tar -zxvf /home/$name/hadoop-2.8.5.tar.gz
sudo update-alternatives --install /usr/bin/java java /home/$name/jdk1.8.0_261/bin/java 100
sudo update-alternatives --install /usr/bin/javac javac /home/$name/jdk1.8.0_261/bin/javac 100

#2.配置环境变量（.bashrc文件）

echo "#java
export JAVA_HOME=/home/$name/jdk1.8.0_261
export JRE_HOME=\$JAVA_HOME/jre
export CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib
export PATH=\$PATH:\$JAVA_HOME/bin

#hadoop
export HADOOP_HOME=/home/$name/hadoop-2.8.5
export HADOOP_INSTALL=\$HADOOP_HOME
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=\$HADOOP_HOME/lib/native"
export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin" >> /home/$name/.bashrc

#3.修改Hadoop配置文件

#创建hadoop数据储存目录
mkdir /home/$name/hadoop-2.8.5/hadooptmpdata
mkdir -p /home/$name/hadoop-2.8.5/hdfs/namenode
mkdir -p /home/$name/hadoop-2.8.5/hdfs/datanode


#文件一（hadoop-env.sh）
echo "export JAVA_HOME=/home/$name/jdk1.8.0_261
export HADOOP_CONF_DIR=\${HADOOP_CONF_DIR:-"/home/$name/hadoop-2.8.5/etc/hadoop"}" >> /home/$name/hadoop-2.8.5/etc/hadoop/hadoop-env.sh

#文件二（hdfs-site.xml）
echo "<configuration>
<property>
<name>dfs.replication</name>
<value>1</value>

<name>dfs.name.dir</name>
<value>file:///home/$name/hadoop-2.8.5/hdfs/namenode</value>

<name>dfs.data.dir</name>
<value>file:///home/$name/hadoop-2.8.5/hdfs/datanode</value>
</property>
</configuration>" > /home/$name/hadoop-2.8.5/etc/hadoop/hdfs-site.xml

#文件三（core-site.xml）
echo "<configuration>
<property>
<name>fs.defaultFS</name>
<value>hdfs://localhost:9000/</value>
</property>

<property>
<name>hadoop.tmp.dir</name>
<value>/home/$name/hadoop-2.8.5/hadooptmpdata</value>
</property>
</configuration>" > /home/$name/hadoop-2.8.5/etc/hadoop/core-site.xml

#文件四（mapred-site.xml)
mv /home/$name/hadoop-2.8.5/etc/hadoop/mapred-site.xml.template /home/$name/hadoop-2.8.5/etc/hadoop/mapred-site.xml
echo "<configuration>
<property>

<name>mapreduce.framework.name</name>
<value>yarn</value>

</property>
</configuration>" > /home/$name/hadoop-2.8.5/etc/hadoop/mapred-site.xml

#文件五(yarn-site.xml)
echo "<configuration>
<property>
<name>mapreduceyarn.nodemanager.aux-services</name>
<value>mapreduce_shuffle</value>
</property>
</configuration>" > /home/$name/hadoop-2.8.5/etc/hadoop/yarn-site.xml

#初始化
source /home/$name/.bashrc
hdfs namenode -format



