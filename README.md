# How to run Oracle WebLogic Server on Apple M1 (arm64) processor family, without x86 emulation

Although considered not compatible on Apple M1 (arm64) CPU architecture by Oracle itself, WebLogic DOES work on ARM-based processor family (installer a part). 

In this repo we will try to document the procedure we followed, at Sunnyvale, to have WebLogic running on the MacBook Pro with M1 processor; hoping this will help other JavaEE developer equipped with Apple M1 processor or with any other ARM-based PC.

This procedure reference WebLogic 12.2.1.4 (which it has been tested against) but can be use as a starting point to obtain the same for WebLogic 14.x.

## Disclaimer

The source code contained in this repo as well as this WebLogic installation procedure and its usage, do not belong to and are not supported/endorsed by Oracle or any of its subsidiaries.

## Create the arm64 WebLogic base image

The arm64 WebLogic base image creation is split in two phases:

- get prerequisite softwares
- build the image

### Get an arm64 JDK tar.gz distribution

An arm64 JDK tar.gz distribution can be obtained from Oracle website at https://www.oracle.com/java/technologies/downloads/.

Be aware that JDK version must be compatible with the WebLogic version you want to use, ie: WebLogic 12.2.1.4 requires JDK version 8.

__Pay attention to download the ARM version of the Oracle JDK__

Having downloaded the arm64 JDK tar.gz distribution, put the archive in the current folder.

### Get WebLogic software

Unfortunately, the WebLogic installer does not support the arm64 architecture, so we can not rely on it to install WebLogic on an Oracle Linux base image.

Having said this, the right thing to do is to obtain an already-installed WebLogic installation directory; we can get it from a standard WebLogic baseimage for the x86 architecture.

The command below starts an x86 WebLogic 12.2.1.4 container and copy the installation directory in the current path of host machine.

```console
$ docker run \
    --platform linux/amd64 \
    -v $(pwd):/mnt/tmp \
    --rm \
    -ti \
    container-registry.oracle.com/middleware/weblogic:12.2.1.4 \
    cp -r /u01/oracle /mnt/tmp
```

This may take a while due to the x86 instructionset emulation, just wait for the container to complete its job.

### Build the arm64 WebLogic base image

To build the WebLogic base image for arm64 architecture, run the following command. In the example below, we are building a WLS 12.2.1.4 base image with Oracle JDK package jdk-8u202-linux-arm64-vfp-hflt.tar.gz

```console
$ docker build \
    --build-arg JDK_PKG=jdk-8u202-linux-arm64-vfp-hflt.tar.gz \
    -t sunnyvaleit/oracle-weblogic:12.2.1.4-java8 \
    .
```

## Run an arm64 WebLogic container

Since this documentation is not meant to substitute the Oracle official one but just to provide a way to build an arm64 WebLogic base image, the way you can run a container for local JavaEE development is better described by Oracle itself, for example following those two tutorials:

- Using the **WebLogic arm64 image** as a base, you may want to [create the Domain Home in Image WebLogic image](https://github.com/oracle/docker-images/tree/main/OracleWebLogic/samples/12213-domain-home-in-image) (this will create a domain starting from your WebLogic installation)
- Then, using the **Domain Home in Image WebLogic image** as a base, you may want to [create the Application Deployment WebLogic image](https://github.com/oracle/docker-images/tree/main/OracleWebLogic/samples/12213-deploy-application) (this will use your domain to deploy an application within)

By running a container of **Application Deployment WebLogic image**, you finally have a running arm64-native WebLogic instance locally with your application deployed.