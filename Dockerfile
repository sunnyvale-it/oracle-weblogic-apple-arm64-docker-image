FROM oraclelinux:8

ARG WLS_VERSION=12.2.1.4
ARG JDK_PKG=jdk-8u202-linux-arm64-vfp-hflt.tar.gz
ARG JAVA_HOME=/u01/jdk1.8.0_202

RUN yum install -y tar

ENV ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    JDK_PKG=${JDK_PKG} \
    PATH=$JAVA_HOME/bin:$PATH:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin \
    MW_HOME=/u01/oracle \
    WLS_HOME=/u01/oracle/wlserver \
    WL_HOME=/u01/oracle/wlserver 

RUN mkdir /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle

COPY --chown=oracle:oracle $JDK_PKG /u01/
COPY --chown=oracle:oracle oracle /u01/oracle/

WORKDIR /u01

RUN tar xf $JDK_PKG && rm $JDK_PKG

RUN echo "export JAVA_HOME=/u01/$(ls -1 /u01 | grep j)" >> /u01/oracle/.bashrc

RUN chown oracle:oracle -R /u01 && \
    chmod -R 775 /u01

USER oracle



