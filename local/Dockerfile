# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.

FROM ubuntu:trusty
MAINTAINER Samuel Cabezas <santonioct@gmail.com>

USER root

# In case you need proxy
RUN echo 'Acquire::http::Proxy "http://sacabezasti:C%40bezas9406@10.200.105.145:80";' >> /etc/apt/apt.conf

#In case some proxy settings are missing
#RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
#export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80"

# Add locales after locale-gen as needed
# Upgrade packages on image
# sshd preparation and installation
RUN locale-gen en_US.UTF-8 &&\
    apt-get -q update &&\
    apt-get install -y wget &&\
    apt-get install -y unzip &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openssh-server &&\
    apt-get -q autoremove &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

#Download only script
#RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
#export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
#wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B-NEimEr29WddlFEbmhqTUVOZm8' -O gdown.pl

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
#RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
#export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
#perl gdown.pl 'https://docs.google.com/uc?export=download&id=0B9tw6taHl_5RSnpVZzZFZjh0ZWM' 'wls1036_generic.jar'

RUN mkdir /root/Oracle && \
    chmod a+xr /root/Oracle

#Copy wls-silent.xml and file inside the container
COPY wls-silent.xml ./

COPY osb11_sources ./

RUN chmod a+xr wls-silent.xml

RUN /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java -jar wls1036_generic.jar -mode=silent -silent_xml=wls-silent.xml && \ 
    rm wls1036_generic.jar wls-silent.xml

ENV PATH $PATH:/root/Oracle/Middleware/oracle_common/common/bin

ENV CONFIG_JVM_ARGS '-Djava.security.egd=file:/dev/./urandom'

#Download create domain script
#RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
#export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
#wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B-NEimEr29WdQThnYjVnRmUwd2c' -O create-wls-domain.py

#Copy create-wls-domain.py file inside the container
COPY create-wls-domain.py ./

RUN mv create-wls-domain.py /root/Oracle && \
    chmod +x /root/Oracle/create-wls-domain.py

RUN mv oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip /root/Oracle/Middleware

WORKDIR /root/Oracle/Middleware

RUN /root/Oracle/Middleware/wlserver_10.3/common/bin/wlst.sh -skipWLSModuleScanning /root/Oracle/create-wls-domain.py

# Expose Node Manager default port, default http/https ports for admin console and sshd default port
EXPOSE 7001 5556 22 

ENV PATH $PATH:/root/Oracle/Middleware/wlserver_10.3/common/bin:/root/Oracle/Middleware/user_projects/domains/base_domain/bin

#Download OEPE Indigo
#RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
 #  export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
  # wget download.oracle.com/otn_software/oepe/indigo/oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip -O oepe-indigo-11.1.1.8.0-linux.zip

#Install OEPE
RUN chmod a+xr oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip && \
    mkdir /root/Oracle/Middleware/OEPE && \
    unzip oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip -d /root/Oracle/Middleware/OEPE && \
    rm oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip

#Install Oracle Service Bus
#RUN export http_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
#export https_proxy="http://sacabezasti:C%40bezas9406@10.200.105.145:80" && \
#perl gdown.pl 'https://docs.google.com/uc?export=download&id=0B9tw6taHl_5RelhSSUQtdXhpMzQ' 'OSB.zip'

COPY osb-silent.rsp ./

COPY oraInst.loc ./

RUN unzip ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip && chmod -R 777 Disk1 Disk2 && chown -R weblogic /root

RUN Disk1/stage/Response/createCentralInventory.sh /root/Oracle/Middleware/oraInventory weblogic

COPY install_osb.sh ./

RUN chmod a+xr install_osb.sh

#USER weblogic

#RUN ./install_osb.sh

#RUN Disk1/runInstaller -debug -silent -response osb-silent.rsp -jreLoc /usr/lib/jvm/java-7-openjdk-amd64/jre

#RUN Disk1/runInstaller -ignoreSysPrereqs -novalidation -debug -silent -response /root/Oracle/Middleware/osb-silent.rsp -jreLoc /usr/lib/jvm/java-7-openjdk-amd64/jre

#RUN Disk1/runInstaller -jreLoc /usr/lib/jvm/java-7-openjdk-amd64/jre -silent -response osb-silent.rsp -invPtrLoc oraInst.loc

# Default command
#CMD ["/usr/sbin/sshd", "-D"]
CMD ["/usr/sbin/sshd", "-D"]

