FROM ubuntu:18.04

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    JAVA_VERSION=8 \
    JAVA_UPDATE=192 \
    JAVA_BUILD=12 \
    JAVA_PATH=750e1c8617c5452694857ad95c3ee230 \
    JAVA_HOME="/usr/java/latest" \
    TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.5.35 \
    CATALINA_HOME=/app/tomcat \
    PATH="$PATH:${JAVA_HOME}/bin:${CATALINA_HOME}/bin" \
    TOMCAT_URIENCODING='UTF-8' 
    
RUN set -eux; groupmod -g 99 nogroup && usermod -u 99 -g 99 nobody && useradd -u 8080 -o java ; \
    test -z $TZ && echo $TZ > /etc/timezone ;\
    mkdir -p ~/.pip && echo [global] > ~/.pip/pip.conf && echo "index-url = https://pypi.mirrors.ustc.edu.cn/simple" >> ~/.pip/pip.conf ; \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl wget apt-transport-https ; \
    sed -i 's@ .*.ubuntu.com@ https://mirrors.ustc.edu.cn@g' /etc/apt/sources.list ; \
    echo registry=http://npmreg.mirrors.ustc.edu.cn/ > ~/.npmrc ; \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common ca-certificates \
     curl wget net-tools jq iputils-ping iputils-arping socat netcat telnet dnsutils bind9utils traceroute mtr tzdata vim-tiny ttf-dejavu bsdiff ;  \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* ; \ 
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime ; \
    mkdir -p $JAVA_HOME  $CATALINA_HOME  ; \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        -c "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/server-jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" ; \
    wget -O apache-tomcat-$TOMCAT_VERSION.tar.gz -c "https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz" ; \
    wget -c https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz ; \
    tar xzfv "server-jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" --strip-components=1 -C $JAVA_HOME ; \
    tar zxfv apache-tomcat-$TOMCAT_VERSION.tar.gz --strip-components=1 -C $CATALINA_HOME ; \
    rm -rf  server-jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz apache-tomcat-$TOMCAT_VERSION.tar.gz ;

ADD server.xml $CATALINA_HOME/conf/
ADD setenv.sh  $CATALINA_HOME/bin/

EXPOSE 8080

CMD ["catalina.sh", "run"]
