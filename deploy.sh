#!/usr/bin/env bash

ENV=dev

APP_NAME=i-spring-cloud-eureka-server

USER_HOME=/home/icloud

LOG_PATH=/data/logs/icloud/i-spring-cloud-eureka-server.log

JAR_FILE=${USER_HOME}/build/${APP_NAME}.jar

PROJECT_HOME=${USER_HOME}/workspace/i-spring-cloud-eureka-server

pid=0

start(){
  checkPid
  if [ ! -n "$pid" ]; then
    build
    nohup java -jar ${JAR_FILE} > /dev/null 2>&1 &
    echo "staring......"
    tail -100f ${LOG_PATH}
  else
    echo "${APP_NAME} is running PID: $pid"
  fi
}

status(){
   checkPid
   if [ ! -n "$pid" ]; then
     echo "${APP_NAME} not running"
   else
     echo "${APP_NAME} running PID: $pid"
   fi
}


checkPid(){
    pid=`ps -ef |grep ${APP_NAME} | grep -v grep | awk '{print $2}'`
}

build(){

    cd  ${PROJECT_HOME}
    echo "enter project home......"

    git pull
    echo "pull code complete......"

    mvn clean package
    echo "maven package complete......"

    rm ${USER_HOME}/build/${APP_NAME}
    echo "remove old jar package complete......"

    cp ${PROJECT_HOME}/target/i-spring-cloud-eureka-server-1.0.0.jar /home/icloud/build
    echo "copy new jar package to build directory......"
}


stop(){
    checkPid
    if [ ! -n "$pid" ]; then
     echo "${APP_NAME} not running"
    else
      echo "${APP_NAME} stop..."
      kill -9 ${pid}
    fi
}

restart(){
    stop
    sleep 1s
    start
}

case $1 in
          start) start;;
          stop)  stop;;
          restart)  restart;;
          status)  status;;
              *)  echo "require start|stop|restart|status"  ;;
esac