#!/bin/sh
############################################################
SID=E8P
sid=`echo ${SID} | tr A-Z a-z`
ADM_HOME=`cat /etc/passwd|grep ${sid}adm|awk -F: '{print $6}'`

USER_ID=system
PASSWD=*****

#echo $SID $sid $ADM_HOME $PASSWD

# SAP environment
if [ -f ${ADM_HOME}/.sapenv.sh ]; then
     . ${ADM_HOME}/.sapenv.sh
fi # SAP environment
############################################################

SQLT ()
{
if [ ${HOST_N} = 'ecc' ]; then HOST_N=shi-eccdb; fi;
if [ ${HOST_N} = 'mdg' ]; then HOST_N=shi-mdgdb; fi;
if [ ${HOST_N} = 'crm' ]; then HOST_N=shi-crmdb; fi;
if [ ${HOST_N} = 'bw' ]; then HOST_N=shi-bwdb; fi;

HOST_PORT="${HOST_N}:30015"

if [ $1 = 'create' ]
then
	RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
	hdbsql -n ${HOST_PORT} -u ${USER_ID} -p ${PASSWD} -x -a "create table test_connection_time (id number(10), name varchar(20), c_time timestamp)"
	hdbsql -n ${HOST_PORT} -u ${USER_ID} -p ${PASSWD} -x -a "insert into test_connection_time values (1, '$RAN_CHAR', current_timestamp)"
elif [ $1 = 'drop' ]
then
	hdbsql -n ${HOST_PORT} -u ${USER_ID} -p ${PASSWD} -x -a "drop table test_connection_time"
elif [ $1 = 'max' ]
then
	echo "GET Max : ? ---> None (drop & create)"
	hdbsql -n ${HOST_PORT} -u ${USER_ID} -p ${PASSWD} -o CHECK.txt -x -a "select max(id) from test_connection_time"
	cat CHECK.txt
	rm CHECK.txt
elif [ $1 = 'test' ]
then
	echo test
	hdbsql -n ${HOST_PORT} -u ${USER_ID} -p ${PASSWD} -o COUNT.txt -x -a "select max(id) from test_connection_time"
	GET_COUNT=`grep '[0-9][0-9]' COUNT.txt| sed 's/\s\s\+//g'`
	if [ $GET_COUNT > 1 ]
	then
	        COUNT=$GET_COUNT
	else
	        echo $COUNT
	fi
# insert 구문의 hdbsql 에 timeout 명령어를 활용한다면??? (id값의 차이를 쉽게...)
	while true
	do
		sleep 1
		COUNT=`expr ${COUNT} + 1`
		DATE_T=`date "+%Y-%m-%d %H:%M:%S.%3N"`
		RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
		printf "########## ${DATE_T}\n" >> test.txt
hdbsql -n ${HOST_PORT} -u ${USER_ID} -p ${PASSWD} -a -f <<EOF >> test.txt
insert into test_connection_time values (${COUNT}, '$RAN_CHAR', current_timestamp)
EOF
		#echo "--insert into test_connection_time values (${COUNT}, '$RAN_CHAR', current_timestamp)"
	done
elif [ $1 = 'check' ]
then
	echo Table check
	hdbsql -n ${HOST_PORT} -u${USER_ID} -p${PASSWD} -o CHECK.txt -x -a "select count(*) from tables where table_name = 'TEST_CONNECTION_TIME'"
	hdbsql -n ${HOST_PORT} -u${USER_ID} -p${PASSWD} -o CHECK.txt -x -a "select '#######################' from dummy"
	#hdbsql -n ${HOST_PORT} -u${USER_ID} -p${PASSWD} -o CHECK.txt -x -a "select * from test_connection_time where id = (select max(id) from test_connection_time)"
	# select * from test_connection_time where id = (select max(id) from test_connection_time)
	# ROW_NUMBER() OVER (PARTITION BY tableName ORDER BY columnOfNumbers) ROW,
	#SELECT ROW_NUMBER() OVER(ORDER BY id) AS RowNumber, columnOfNumber....

	cat CHECK.txt
	echo "";
	rm CHECK.txt
elif [ $1 = 'select' ]
then
	echo Table Select
	echo ""; echo ""; echo ""
	hdbsql -n ${HOST_PORT} -u${USER_ID} -p${PASSWD} -o ALL.txt -x -a "select * from test_connection_time"
	cat ALL.txt
	rm ALL.txt
	echo ""; echo ""; echo ""
else
	echo ""
	printf "\t# Check Script...\n"
	echo ""
fi
}

if [ $# -gt 0 ]
then
	if [ $1 = 'create' -o $1 = 'test' -o $1 = 'drop' -o $1 = 'max' -o $1 = 'test' -o $1 = 'check' -o $1 = 'select' ]
	then
		printf '\tshi-eccdb ---> ecc \n'
		printf '\tshi-mdgdb ---> mdg \n'
		printf '\tshi-crmdb ---> crm \n'
		printf '\tshi-bwdb ----> bw \n'
		echo ""
		printf "\tInput HOST : "
		sleep 1
		read HOST_N

		if [ ${HOST_N}x = 'x' ]
		then
			echo ""
			printf "\t# Error...None\n"
			exit 0
		elif [ ${HOST_N} = 'ecc' -o ${HOST_N} = 'mdg' -o ${HOST_N} = 'crm' -o ${HOST_N} = 'bw' ]
		then
			SQLT $1
		else
			echo ""
			printf "\t# Check DB Name...\n"
			echo ""
		fi
	else
	printf "\t# ERROR...\n"
	printf "\t# ... with \"1. check, 2. create, 3. test, 4. drop,\n"
	printf "\t#                     2. max\n"
	printf "\t#                     or select \n"
	fi
else
	echo ""
	printf "\t# ERROR...\n"
	printf "\t# ... with \"1. check, 2. create, 3. test, 4. drop,\n"
	printf "\t#                     2. max\n"
	printf "\t#                     or select \n"
	echo ""
fi
