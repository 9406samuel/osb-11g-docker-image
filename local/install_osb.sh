#!/bin/bash

/root/Oracle/Middleware/Disk1/runInstaller -ignoreSysPrereqs -novalidation -debug -silent -response /root/Oracle/Middleware/osb-silent.rsp -jreLoc /usr/lib/jvm/java-7-openjdk-amd64/jre

sleep 550

cd /root/Oracle/Middleware && rm -rf Disk1 Disk2 ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip oraInst.loc osb-silent.rsp ../create-wls-domain.py
