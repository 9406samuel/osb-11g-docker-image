Primera versión del Dockerfile. Se debe tener una carpeta en el directorio raiz llamada "osb11_sources" el cual debe contener los instaladores de weblogic, OEPE y OSB 11g.
- osb_sources
  - oepe-indigo-all-in-one-11.1.1.8.0.201110211138-linux-gtk-x86_64.zip
  - ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip
  - wls1036_generic.jar

comando a ejecutar una vez creado y corriendo el contenedor. Pues se debe ejecutar un script para instalar el OSB y despues hacer commit de ese contenedor:
* su - weblogic -c /root/Oracle/Middleware/install_osb.sh
