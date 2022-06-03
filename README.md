# How to run Oracle WebLogic Server on Apple M1 (arm64) processor family without x86 emulation

Although considered not compatible on Apple M1 (arm64) CPU architecture by Oracle itself, WebLogic DOES work on ARM-based processor family (installer a part). In this repo I'll try to document the procedure I followed to have it running on my MacBook Pro, hoping this will benefit also to other Apple M1 users.

## Disclaimer

The source code contained in this repo as well as this WebLogic installation procedure and usage, do not belong to and are not supported/endorsed by Oracle or any of its subsidiaries.

## Create the arm64 WebLogic base image

The arm64 WebLogic base image creation is split in two phases:

- get prerequisite softwares
- build the image

### Get an arm64 JDK tar.gz distribution

An arm64 JDK tar.gz distribution can be obtained from Oracle website at https://www.oracle.com/java/technologies/downloads/.

Be aware that JDK version must be compatible with the WebLogic version you want to use, ie: WebLogic 12.2.1.4 requires JDK version 8.

__Pay attention to download the ARM version of the Oracle JDK__

### Get WebLogic software

Unfortunately, the WebLogic installer does not support the arm64 architecture, so we can not rely on it to install WebLogic on an Oracle Linux base image.

Having said this, the right thing to do is to obtain an already-installed WebLogic installation directory; we can get it from a standard WebLogic baseimage for the x86 architecture.

The command below starts a WebLogic 12.2.1.4 container an copy the WebLogic installation directory in the current path.

```console
$ docker run --platform linux/amd64 -v $(pwd):/mnt/tmp --rm -ti container-registry.oracle.com/middleware/weblogic:12.2.1.4 cp -r /u01/oracle /mnt/tmp
```

This may take a while, just wait for the container to complete its job.

### Build the arm64 WebLogic base image

To build the WebLogic base image for arm64 architecture, run the following command. In the example below, we are building a WLS 12.2.1.4 base image with Oracle JDK package jdk-8u202-linux-arm64-vfp-hflt.tar.gz

```console
$ docker build --build-arg WLS_VERSION=12.2.1.4 --build-arg JDK_PKG=jdk-8u202-linux-arm64-vfp-hflt.tar.gz -t sunnyvaleit/oracle-weblogic:12.2.1.4-java8 .
```

