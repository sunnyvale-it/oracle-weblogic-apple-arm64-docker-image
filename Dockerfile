FROM oraclelinux:8

RUN yum install -y tar vi

ENV ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    FMW_JAR=fmw_12.2.1.4.0_wls_lite_generic.jar \
    JDK_PKG="jdk-8u202-linux-arm64-vfp-hflt.tar.gz" \
    JAVA_HOME=/u01/jdk1.8.0_202 \
    PATH=${JAVA_HOME}/bin:$PATH:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin

RUN mkdir /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle && \
    chown oracle:root -R /u01 && \
    chmod -R 775 /u01

COPY --chown=oracle:root $JDK_PKG $FMW_JAR install.file oraInst.loc /u01/

WORKDIR /u01

RUN tar xf $JDK_PKG

USER oracle

#RUN ${JAVA_HOME}/bin/java -jar /u01/$FMW_JAR -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server" && \
#   rm /u01/$FMW_JAR /u01/$FMW_PKG /u01/install.file && \
#   rm -rf /u01/oracle/cfgtoollogs