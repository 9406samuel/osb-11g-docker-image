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
# Useful tools installation
RUN locale-gen en_US.UTF-8 &&\
    apt-get -q update &&\
    #Installing wget, unzip, maven, git and vim
    apt-get install -y wget &&\
    apt-get install -y unzip &&\
    apt-get install -y maven &&\
    apt-get install -y git &&\
    apt-get install -y vim &&\
    #Installing ssh and jre-jdk 7
    DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openssh-server &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openjdk-7-jre &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openjdk-7-jdk &&\
    #apt-get -q autoremove &&\
    #apt-get -q clean -y &&\
    rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set user to access via sshd
#RUN useradd -G root,sudo -m -d /home/weblogic -s /bin/sh weblogic &&\
#    echo "weblogic:welcome1" | chpasswd

# Set root password
RUN echo "root:root" | chpasswd

# Add user so that container does not run as root 
RUN useradd -m -d /home/weblogic weblogic &&\
    echo "weblogic:welcome1" | chpasswd &&\
    usermod -s /bin/bash weblogic &&\
    usermod -aG sudo,root weblogic

#weblogic installation
RUN mkdir /root/Oracle && \
    chmod a+xr /root/Oracle

#Copy wls-silent.xml and osb installation sources inside the container
COPY wls-silent.xml ./
COPY osb11_sources ./

RUN chmod a+xr wls-silent.xml

RUN /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java -jar wls1036_generic.jar -mode=silent -silent_xml=wls-silent.xml && \ 
    rm wls1036_generic.jar wls-silent.xml

ENV PATH $PATH:/root/Oracle/Middleware/oracle_common/common/bin

ENV CONFIG_JVM_ARGS '-Djava.security.egd=file:/dev/./urandom'

#Copy create-wls-domain.py file inside the container
COPY create-wls-domain.py ./

RUN mv create-wls-domain.py /root/Oracle &&\
    chmod +x /root/Oracle/create-wls-domain.py &&\
    mv oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip /root/Oracle/Middleware

WORKDIR /root/Oracle/Middleware

RUN /root/Oracle/Middleware/wlserver_10.3/common/bin/wlst.sh -skipWLSModuleScanning /root/Oracle/create-wls-domain.py

# Expose Node Manager default port, default http/https ports for admin console and sshd default port
EXPOSE 7001 5556 22 

ENV PATH $PATH:/root/Oracle/Middleware/wlserver_10.3/common/bin:/root/Oracle/Middleware/user_projects/domains/base_domain/bin

#Install OEPE
RUN chmod a+xr oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip && \
    mkdir /root/Oracle/Middleware/OEPE && \
    unzip oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip -d /root/Oracle/Middleware/OEPE && \
    rm oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip

#Install Oracle Service Bus
COPY osb-silent.rsp ./
COPY oraInst.loc ./
COPY install_osb.sh ./

RUN chmod a+xr install_osb.sh &&\
    unzip ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip &&\
    chmod -R 770 Disk1 Disk2 && chown -R weblogic /root &&\
    Disk1/stage/Response/createCentralInventory.sh /root/Oracle/Middleware/oraInventory weblogic

#TODO: create .m2 folder in /home/weblogic and set .m2 folder directory in /etc/maven/settings.xml equal to /home/weblogic
#TODO: set proxy settings in the same file.

# Default command
CMD ["/usr/sbin/sshd", "-D"]
