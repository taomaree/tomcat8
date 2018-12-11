sed -i -r -e 's/(FINE|INFO)/OFF/g' ${CATALINA_BASE}/conf/logging.properties
sed -i -r -e 's/(1catalina.org.apache.juli.FileHandler.level|java.util.logging.ConsoleHandler.level).*/\1 = INFO/g' ${CATALINA_BASE}/conf/logging.properties
echo "adjust log level " ${CATALINA_BASE}/conf/logging.properties
echo "TOMCAT_URIENCODING " $TOMCAT_URIENCODING
echo "############################################################"


#URIEncoding="UTF-8" TOMCAT_URIENCODING='UTF-8'
test $TOMCAT_URIENCODING = 'UTF-8' && sed -i -r -e 's/URIEncoding=\S+/URIEncoding="UTF-8"/g' ${CATALINA_BASE}/conf/server.xml
test $TOMCAT_URIENCODING = 'ISO-8859-1' && sed -i -r -e 's/URIEncoding=\S+/URIEncoding="ISO-8859-1"/g' ${CATALINA_BASE}/conf/server.xml

export CATALINA_OPTS="$CATALINA_OPTS -server "
export CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=GMT+08 -XX:PermSize=512M -XX:MaxPermSize=512M -Dspring.profiles.active=pro "
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=8089 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false "

#export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseParallelGC"

#export CATALINA_OPTS="$CATALINA_OPTS -XX:+DisableExplicitGC"
