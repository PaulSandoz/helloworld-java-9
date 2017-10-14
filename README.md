# Hello World with Java 9 and Docker

A simple maven project generated from the using `maven-archetype-quickstart`
(`org.apache.maven.archetypes:maven-archetype-quickstart:1.0`) and updated
to declare the maven compiler source and target for Java 9.

Example Docker files are also present for building Docker images
containing a JDK 9 distribution.

## Pre-requisites

To experiment download the following and place in the top-level directory:
- OpenJDK build of [JDK 9 for Linux x64](http://download.java.net/java/GA/jdk9/9/binaries/openjdk-9_linux-x64_bin.tar.gz/).
- Early-access Open JDK build of [JDK 9 for Alpine Linux](http://jdk.java.net/9/ea).

## Build Images and Run Containers

Build a Docker image with Alpine Linux and JDK 9:

    docker build -t jdk-9-alpine -f jdk-9-alpine.Dockerfile .

Build a Docker image with Debian slim and JDK 9:

    docker build -t jdk-9-debian-slim -f jdk-9-debian-slim.Dockerfile .

Run the docker image to enter into the Java REPL (jshell):

    docker run -it --rm jdk-9-debian-slim

List the Java modules in JDK 9:

    docker run -it --rm jdk-9-debian-slim java --list-modules

Build the simple Java application with a local distribution of JDK 9:

    mvnw package

Build a Docker image containing the simple Java application based of the Docker
image `jdk-9-debian-slim`:

    docker build -t helloworld-jdk-9 -f helloworld-jdk-9.Dockerfile .

Run the java dependency tool `jdeps` on the application jar file:

    docker run -it --rm helloworld-jdk-9 jdeps --list-deps /opt/helloworld/helloworld-1.0-SNAPSHOT.jar

Create a custom Java runtime that is small and only contains the `java.base` module:
(See also the script `create-minimal-java-runtime.sh`):

    docker run --rm \
      --volume $PWD:/out \
      jdk-9-debian-slim \
      jlink --module-path /opt/jdk-9/jmods \
        --verbose \
        --add-modules java.base \
        --compress 2 \
        --no-header-files \
        --output /out/target/openjdk-9-base_linux-x64

Build a Docker image containing the simple Java application based of the Docker
image `debian:slim` and the custom Java runtime previous created:

    docker build -t helloworld-jdk-9-base -f helloworld-jdk-9-base.Dockerfile .

List the modules in custom Java runtime:

    docker run -it --rm helloworld-jdk-9-base java --list-modules

Run the docker images:

    docker run -it --rm helloworld-jdk-9

    docker run -it --rm helloworld-jdk-9-base

Compare sizes:

    docker images
