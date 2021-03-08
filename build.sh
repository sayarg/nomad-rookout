#!/bin/bash
set -v

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_281.jdk/Contents/Home

#curl -L "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.rookout&a=rook&v=LATEST" -o rook.jar

rm -rf classes
mkdir -p classes

javac -g src/rookout/examples/HelloWorld.java -d classes

jar cvf hello-world.jar -C classes .


