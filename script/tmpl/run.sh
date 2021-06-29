#!/bin/sh
#
# java runner.©2020-2021 by Quinn.Zhang (angviza@gmail.com)
# Usage:
#
# 1. Put this script somewhere in your project
#
#
#
#*require app jar path
#~optional app main class,if not has mainfest,must set
APP_MAINCLASS=
#~optional app params for main args
APP_PARAM=
#~optional app lib jar path
APP_LIBS=
#*require
JAVA_HOME=/data/services/commons/jdk/11.0.10
#~optional
JAVA_OPTS=
# JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8 -server -XX:+UseG1GC -XX:MaxGCPauseMillis=500 -XX:+AggressiveOpts -Xms1g -Xmx1g -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=logs/heap.dump"

# JAVA_OPTS="$JAVA_OPTS -Dio.netty.tryReflectionSetAccessible=true --add-exports=java.base/jdk.internal.misc=ALL-UNNAMED --add-exports=java.base/sun.nio.ch=ALL-UNNAMED --add-exports=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-exports=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-exports=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --illegal-access=permit"
# project jar file dir
BIN=bin
psid=0
#
#get curr dir
# ┌───────────────────────CURR DIR────────────────────────────┐
PWD="$0"
while [ -h "$PWD" ]; do # resolve $SOURCE until the file is no longer a symlink
   DIR="$(cd -P "$(dirname "$PWD")" && pwd)"
   PWD="$(readlink "$PWD")"
   [[ $PWD != /* ]] && PWD="$DIR/$PWD" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$(cd -P "$(dirname "$PWD")" && pwd)"
# └────────────────────── CURR CURR ──────────────────────────┘
#
# ┌───────────────────────SCAN LIBS────────────────────────────┐

if [ -z $APP_MAINCLASS ]; then
   CLASSPATH="$DIR/$BIN/$(ls -lt $BIN | awk '{if ($9) printf("%s\n",$9)}' | head -n 1)"
   op="jar"
else
   for i in $APP_LIBS/*.jar; do
      CLASSPATH="$CLASSPATH":$i
   done

   for i in $DIR/bin/*.jar; do
      CLASSPATH="$CLASSPATH":$i
   done
   op=classpath
fi

# └──────────────────────  END SCAN  ──────────────────────────┘
#
# ┌───────────────────────WATCH────────────────────────────┐
# Usage
# add:   watch
# rm :   watch rm
#
watch() {
   echo ""
   #./crontadm.sh ${1:-add} "* * * * * ? /data/scripts/watch1.sh $DIR"
}
# └──────────────────────END WATCH──────────────────────────┘

run() {
   nohup $JAVA_HOME/bin/java $JAVA_OPTS -$op $CLASSPATH $APP_MAINCLASS $APP_PARAM >app.log 2>&1 &
}
test() {
   checkpid
}
checkpid() {
   javaps=$(ps -ef | grep -F "$CLASSPATH" | grep -v grep | awk '{print $2}')
   psid=${javaps:-0}
   if [ $psid -ne 0 ]; then
      printc "\033[1;36m✔\033[0m $APP_MAINCLASS is running! (pid=$psid)"
   else
      printc "\033[1;31m✘\033[0m $APP_MAINCLASS is \033[1;31;36mnot running ☠"
   fi
}

start() {
   checkpid
   if [ $psid -eq 0 ]; then
      printc "\033[5;36mStarting $APP_MAINCLASS ..."
      run
      checkpid
      if [ $psid -ne 0 ]; then
         watch
      else
         echo "[Failed]"
      fi
   fi
}

stop() {
   checkpid

   if [ $psid -ne 0 ]; then
      printc "\033[6;31mStopping $APP_MAINCLASS ...(pid=$psid) "
      kill $psid
      if [ $? -eq 0 ]; then
         echo "[OK]"
      else
         echo "[Failed]"
      fi
      watch rm
      sleep 1s
      checkpid
      if [ $psid -ne 0 ]; then
         stop
      fi
   fi
}

status() {
   checkpid
}
printc() {
   echo -e "${@:1}\033[0m"
}
printd() {
   printc "\033[1;36m" "$(echo ${@:1})"
}
info() {
   printc "\033[1;31;42m" "System Information:"
   printc "\033[1;36m****************************"
   printc "$(head -n 1 /etc/issue)"
   printc "$(uname -a)"
   printc "JAVA_HOME=$JAVA_HOME"
   printc "$($JAVA_HOME/bin/java -version)"
   printc "APP_HOME=$DIR"
   printc "APP_MAINCLASS=\033[5;31;46m$APP_MAINCLASS"
   printc "\033[1;36m****************************"
}

log() {
   tail -100f app.log
}

case "$1" in
start)
   start
   ;;
stop)
   stop
   ;;
restart)
   stop
   start
   ;;
status)
   status
   ;;
info)
   info
   ;;
log)
   log
   ;;
update)
   update
   ;;
test)
   test
   ;;
*)
   echo "Usage: $0 {start|stop|restart|status|info|log}"
   exit 1
   ;;
esac
exit 0
