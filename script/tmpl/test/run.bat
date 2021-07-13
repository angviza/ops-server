
set org=fuqiang
set prod=dev
set JMETER_HOME=D:\Services\jemeter\5.4.1

set datetimestr=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set logpath=.\logs\waste_report_%org%_sj_%datetimestr%
%JMETER_HOME%\bin\jmeter.bat -JthreadCount=1 -JtimeSeconds=60 -Jdomain=dev.idflc.cn -Jorg=%org% -Jprod=%prod% -n -t waste/sj.jmx -l "%logpath%\.jtl" -e -o %logpath%