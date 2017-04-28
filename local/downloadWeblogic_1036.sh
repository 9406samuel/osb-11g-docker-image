#!/bin/bash
if [ -z "$ORACLE_USER" ]
then
  exit 0
fi

v_usuario_oracle="$ORACLE_USER"
v_contrasenya_oracle=$ORACLE_PASSWORD
v_cookie=/tmp/$$_cookie
v_OEPE_cookie=/tmp/$$_cookie
v_download=http://download.oracle.com/otn/nt/middleware/11g/wls/1036/wls1036_generic.jar
v_OEPE_download=http://download.oracle.com/otn_software/oepe/indigo/oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip

# Weblogic download
v_Site2pstoreToken=`curl -x http://sacabezasti:C%40bezas9406@10.200.105.145:80 -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101 Firefox/45.0" -L $v_download | grep site2pstoretoken | awk -Fsite2pstoretoken {'print $2'}|awk -F\= {'print  $2'}|awk -F\" {'print $2'}`

curl -x http://sacabezasti:C%40bezas9406@10.200.105.145:80 -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0"  \
-d 'ssousername='$v_usuario_oracle'&password='$v_contrasenya_oracle'&site2pstoretoken='$v_Site2pstoreToken \
-o /dev/null \
https://login.oracle.com/sso/auth -c $v_cookie

echo '.oracle.com	TRUE	/	FALSE	0	oraclelicense	accept-dbindex-cookie' >> $v_cookie

curl -x http://sacabezasti:C%40bezas9406@10.200.105.145:80 -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0" \
-b $v_cookie \
-OL $v_download

# OEPE download
v_OEPE_Site2pstoreToken=`curl -x http://sacabezasti:C%40bezas9406@10.200.105.145:80 -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101 Firefox/45.0" -L $v_OEPE_download | grep site2pstoretoken | awk -Fsite2pstoretoken {'print $2'}|awk -F\= {'print  $2'}|awk -F\" {'print $2'}`

curl -x http://sacabezasti:C%40bezas9406@10.200.105.145:80 -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0"  \
-d 'ssousername='$v_usuario_oracle'&password='$v_contrasenya_oracle'&site2pstoretoken='$v_OEPE_Site2pstoreToken \
-o /dev/null \
https://login.oracle.com/sso/auth -c $v_OEPE_cookie

echo '.oracle.com       TRUE    /       FALSE   0       oraclelicense   accept-dbindex-cookie' >> $v_OEPE_cookie

curl -x http://sacabezasti:C%40bezas9406@10.200.105.145:80 -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0" \
-b $v_OEPE_cookie \
-OL $v_OEPE_download
