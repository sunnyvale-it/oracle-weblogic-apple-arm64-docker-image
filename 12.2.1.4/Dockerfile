FROM oraclelinux:8

RUN yum install -y tar vi

ENV ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    FMW_JAR="fmw_12.2.1.4.0_wls_quick_slim.jar" \
    JDK_PKG="jdk-8u202-linux-arm64-vfp-hflt.tar.gz" \
    JAVA_HOME="/u01/jdk1.8.0_202" \
    PATH=/u01/jdk1.8.0_202/bin:$PATH:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin \
    MW_HOME=/u01/oracle/app/middleware \
    WLS_HOME=/u01/oracle/app/middleware/wlserver \
    WL_HOME=/u01/oracle/app/middleware/wlserver 

RUN mkdir /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle && \
    chown oracle:oracle -R /u01 && \
    chmod -R 775 /u01



COPY --chown=oracle:oracle $JDK_PKG $FMW_JAR install.file oraInst.loc /u01/

USER oracle

RUN mkdir -p /u01/oracle/app/middleware && \
    mkdir -p /u01/oracle/app/config/domains && \
    mkdir -p /u01/oracle/app/config/applications

WORKDIR /u01

RUN tar xf $JDK_PKG

RUN ${JAVA_HOME}/bin/java -jar /u01/$FMW_JAR -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc /u01/jdk1.8.0_202 -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server" && \
    test $? -eq 0 && chmod -R g+r /u01/oracle || (cat /tmp/OraInstall*/install*.log && exit 1)
    # rm /u01/$FMW_JAR /u01/$FMW_PKG /u01/install.file && \
    # rm -rf /u01/oracle/cfgtoollogs