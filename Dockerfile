FROM centos:7

MAINTAINER Ilya Malysh <i.s.malysh@gmail.com>

RUN yum -y check-update || { rc=$?; [ "$rc" -eq 100 ] && exit 0; exit "$rc"; }
RUN yum -y update
RUN yum install -y systemd
RUN yum install -y nano
RUN yum install -y java-1.7.0-openjdk
RUN yum install -y perl-Digest-SHA
RUN yum install -y wget

#main install
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-x86_64.rpm
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-x86_64.rpm.sha512
RUN shasum -a 512 -c elasticsearch-7.15.2-x86_64.rpm.sha512
RUN rpm --install elasticsearch-7.15.2-x86_64.rpm


#main config
RUN systemctl enable elasticsearch
RUN echo 'node.name: node-1' | tee -a /etc/elasticsearch/elasticsearch.yml
RUN echo 'network.host: 0.0.0.0' | tee -a /etc/elasticsearch/elasticsearch.yml
RUN echo 'discovery.seed_hosts: ["127.0.0.1"]' | tee -a /etc/elasticsearch/elasticsearch.yml
RUN echo 'cluster.initial_master_nodes: ["node-1"]' | tee -a /etc/elasticsearch/elasticsearch.yml

EXPOSE 9200 9300
