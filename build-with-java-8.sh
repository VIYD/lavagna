#!/bin/bash

#
#This file is used to switch Java version on build machine, as Jenkins uses Java 11, but maven builder requires Java 8.

# Set JAVA_HOME to Java 8
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Build with Maven
mvn clean package

# Restore JAVA_HOME to Java 11
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
