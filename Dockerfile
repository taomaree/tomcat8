FROM ubuntu:18.04 as builder

ENV JAVA_VERSION=8 \
    JAVA_UPDATE=192 \
    JAVA_BUILD=12 \
    JAVA_PATH=750e1c8617c5452694857ad95c3ee230 \
    JAVA_HOME="/usr/java/latest" \
    TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.5.35 \
    CATALINA_HOME=/app/tomcat

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl wget unzip && \
    mkdir -p $JAVA_HOME  $CATALINA_HOME && \
    wget -P /usr/java --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/server-jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" && \
    wget -P /app/tomcat "https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"
        && \
    tar xzfv "/usr/java/server-jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" -C /usr/java && \
    tar zxfv apache-tomcat-${TOMCAT}.tar.gz --strip-components=1 -C /app/tomcat && \
    mv "/usr/java/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}" /usr/java/latest
   

FROM ubuntu:18.04

ENV TZ=Asia/Shanghai DEBIAN_FRONTEND=noninteractive TOMCAT_MAJOR=8 TOMCAT_VERSION=8.5.35 TOMCAT_URIENCODING='UTF-8' \
    CATALINA_HOME=/app/tomcat  JAVA_HOME=/usr/java/latest  PATH=$CATALINA_HOME/bin:$PATH:$JAVA_HOME/bin

RUN groupmod -g 99 nogroup && usermod -u 99 -g 99 nobody && useradd -u 8080 -o java \
    && echo $TZ > /etc/timezone \
    && mkdir -p ~/.pip && echo [global] > ~/.pip/pip.conf && echo "index-url = https://pypi.mirrors.ustc.edu.cn/simple" >> ~/.pip/pip.conf \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl wget apt-transport-https \
    && sed -i 's@ .*.ubuntu.com@ https://mirrors.ustc.edu.cn@g' /etc/apt/sources.list \
    && echo registry=http://npmreg.mirrors.ustc.edu.cn/ > ~/.npmrc \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common ca-certificates \
     curl wget net-tools jq iputils-ping iputils-arping socat netcat telnet dnsutils bind9utils traceroute mtr tzdata vim \
     ttf-dejavu bsdiff   \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* \ 
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.35/bin/apache-tomcat-8.5.35.tar.gz
    && tar zxfv apache-tomcat-${TOMCAT}.tar.gz --strip-components=1 -C /app/tomcat

CMD ["catalina.sh", "run"]
