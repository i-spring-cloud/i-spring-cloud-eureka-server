#!/usr/bin/env bash
mvn clean package
scp target/i-spring-cloud-eureka-server-1.0.0.jar ssh root@116.62.56.67:/home/icloud/build