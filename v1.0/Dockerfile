# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.

FROM ubuntu:trusty
MAINTAINER Samuel Cabezas <santonioct@gmail.com>

#ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre
USER root

# In case you need proxy
RUN echo 'Acquire::http::Proxy "http://sacabezasti:C%40bezas9406@10.200.105.145:80";' >> /etc/apt/apt.conf

#In case some proxy settings are missing
RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80"

# Add locales after locale-gen as needed
# Upgrade packages on image
# sshd preparation and installation
RUN locale-gen en_US.UTF-8 &&\
    apt-get -q update &&\
    apt-get install -y wget &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openssh-server &&\
    apt-get -q autoremove &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

#Download only script
RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B-NEimEr29WddlFEbmhqTUVOZm8' -O gdown.pl

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install JRE and JDK 7 (latest edition)
RUN apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openjdk-7-jre &&\ 
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openjdk-7-jdk &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# Set user to access via sshd
RUN useradd -G root,sudo -m -d /home/weblogic -s /bin/sh weblogic &&\
    echo "weblogic:welcome1" | chpasswd

#weblogic installation

#Download weblogic 10.3.6
RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
perl gdown.pl 'https://docs.google.com/uc?export=download&id=0B-NEimEr29WdbURhaE16NElXbjA' 'wls1036_generic.jar' #&& \
#Download silence mode script
#wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B-NEimEr29WdRXNoMndCMUllMGs' -O wls-silent.xml

RUN mkdir /root/Oracle && \
    chmod a+xr /root/Oracle

#RUN export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64/jre"

COPY wls-silent.xml ./

RUN /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java -jar wls1036_generic.jar -mode=silent -silent_xml=wls-silent.xml && \ 
	rm /wls1036_generic.jar wls-silent.xml 

ENV PATH $PATH:/root/Oracle/Middleware/oracle_common/common/bin

ENV CONFIG_JVM_ARGS '-Djava.security.egd=file:/dev/./urandom'

#Download create domain script
RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B-NEimEr29WdQThnYjVnRmUwd2c' -O create-wls-domain.py

RUN mv create-wls-domain.py /root/Oracle && \
    chmod +x /root/Oracle/create-wls-domain.py

WORKDIR /root/Oracle/Middleware

RUN /root/Oracle/Middleware/wlserver_10.3/common/bin/wlst.sh -skipWLSModuleScanning /root/Oracle/create-wls-domain.py

# Expose Node Manager default port, default http/https ports for admin console and sshd default port
EXPOSE 7001 5556 22 

ENV PATH $PATH:/root/Oracle/Middleware/wlserver_10.3/common/bin:/root/Oracle/Middleware/user_projects/domains/base_domain/bin

# Default command
CMD ["/usr/sbin/sshd", "-D"]
