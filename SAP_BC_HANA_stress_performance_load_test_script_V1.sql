############################################################
# 2017.07.27
############################################################
#!/bin/sh

#hdbsql -i 00 -u dash -p Serp1234
#
#create table test_connection (id number(10), c_time timestamp)
#create table test_connection (id number(10), name varchar(10), c_time timestamp)
#
#drop table test_connection
#
#create sequence test_connect_seq start with 1 increment by 1 maxvalue 100000 cycle
#drop sequence test_connect_seq
#alter sequence test_connect_seq restart with 1 ;
#
#insert into test_connection values (test_connect_seq.nextval, current_timestamp)
#insert into test_connection values (test_connect_seq.nextval, XXXXXXX, current_timestamp)
#
#select count(*) from test_connection
#select * from test_connection

############################################################

COUNT=1000
COLUMN=5
INT_COUNT=100

############################################################
# vi create_test_table.sh
#
# CREATE_TABLE : Column 3개짜리 Table 생성 (Table명 $SEQ로 생성)
# CREATE_TABLE2 : Column 2개짜리 Table 생성 (Table명 $SEQ로 생성)
#                 Alter로 5개 이하의 Name 추가 (name을 $SEQ로 생성)
# for 문에 for 문으로 처리하므로 중복으로 create, alter drop 되게됨 (단순오류 발생)

CREATE_TABLE ()
{
for x in `seq 1 $COUNT`
do
   echo "$x"
   echo - hdbsql -i 00 -u dash -p Serp1234 -o create_test_table.log -x -a "create table test_connection_$x (id number(10), name varchar(20), c_time timestamp)"
          #hdbsql -i 00 -u dash -p Serp1234 -o create_test_table.log -x -a "create table test_connection_$x (id number(10), name varchar(20), c_time timestamp)"

done
}

CREATE_TABLE2 ()
{
for L in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
         echo - hdbsql -i 00 -u dash -p Serp1234 -o create_test_table.log -x -a "create table test1_connection_${L}_${x} (id number(10), c_time timestamp)"
                hdbsql -i 00 -u dash -p Serp1234 -o create_test_table.log -x -a "create table test1_connection_${L}_${x} (id number(10), c_time timestamp)"
      for y in `seq 1 $x`
      do
         echo - hdbsql -i 00 -u dash -p Serp1234 -o create_test_table.log -x -a "alter table test1_connection_${L}_${x} add (name_$y varchar(20))"
                hdbsql -i 00 -u dash -p Serp1234 -o create_test_table.log -x -a "alter table test1_connection_${L}_${x} add (name_$y varchar(20))"
      done
   done
done
}

############################################################
# vi drop_test_table.sh

DROP_TABLE ()
{
for x in `seq 1 $COUNT`
do
   hdbsql -i 00 -u dash -p Serp1234 -o drop_test_table.log -x -a "drop table test_connection_$x"
done
}

DROP_TABLE2 ()
{
for L in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
      hdbsql -i 00 -u dash -p Serp1234 -o drop_test_table.log -x -a "drop table test1_connection_${L}_${x}"
   done
done
}

############################################################
# Sequence 생성

CREATE_SEQ ()
{
for z in `seq 1 $COUNT`
do
   echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o create_sequence.log -x -a "create sequence test_connect_seq_$z start with 1 increment by 1 maxvalue 100000 cycle"
            hdbsql -i 00 -u dash -p Serp1234 -o create_sequence.log -x -a "create sequence test_connect_seq_$z start with 1 increment by 1 maxvalue 100000 cycle"
done
}

CREATE_SEQ2 ()
{
for z in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
echo "SEQ2"
      echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o create_sequence.log -x -a "create sequence test_connect_seq_${z}_${x} start with 1 increment by 1 maxvalue 100000 cycle"
               hdbsql -i 00 -u dash -p Serp1234 -o create_sequence.log -x -a "create sequence test_connect_seq_${z}_${x} start with 1 increment by 1 maxvalue 100000 cycle"
   done
done
}

############################################################
# Sequence 삭제

DROP_SEQ2 ()
{
for z in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
echo "SEQ2"
      echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o create_sequence.log -x -a "drop sequence test_connect_seq_${z}_${x}"
               hdbsql -i 00 -u dash -p Serp1234 -o create_sequence.log -x -a "drop sequence test_connect_seq_${z}_${x}"
   done
done
}

############################################################
# vi insert_test_table.sh
#
# INSERT_BULK : 1번 Table 에 SELECT INSERT 수행 & RANDOM insert 수행 (for * for)
# INSERT_TABLE : 1번 Table 에 RANDOM insert 수행 (for * for),
#                추가로 RANDOM INSERT 와 SELECT INSERT 수행
# INSERT_TABLE2 : 1번 Table에 INSERT 구문을 SQL 파일로 생성하여 수행
# INSERT_TABLE3 : 2번 Table에 각 NAME 컬럼까지 INSERT 수행

INSERT_BULK ()
{
for z in `seq 1 $COUNT`
do
   RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
   echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert2_test_table.log -x -a "insert into test_connection_$X select top $Y * from test_connection_$x"
            hdbsql -i 00 -u dash -p Serp1234 -o insert2_test_table.log -x -a "insert into test_connection_$X select top $Y * from test_connection_$x"
   for y in `seq 1 $COUNT`
   do
      echo $y
      RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
      echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_$z values (test_connect_seq_$z.nextval, '$RAN_CHAR', current_timestamp)"
               hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_$z values (test_connect_seq_$z.nextval, '$RAN_CHAR', current_timestamp)"
   done
done
}

INSERT_TABLE ()
{
for z in `seq 1 $COUNT`
do
   RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
   echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_$z values (test_connect_seq_$z.nextval, '$RAN_CHAR', current_timestamp)"
            hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_$z values (test_connect_seq_$z.nextval, '$RAN_CHAR', current_timestamp)"
   for y in `seq 1 $COUNT`
   do
      echo $y
      RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
      echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_$z values (test_connect_seq_$z.nextval, '$RAN_CHAR', current_timestamp)"
               hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_$z values (test_connect_seq_$z.nextval, '$RAN_CHAR', current_timestamp)"
   done
done

for z in `seq 1 $COUNT`
do
   RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
   x=`shuf -i 1-$COUNT -n 1`
   y=`shuf -i 1-$COUNT -n 1`
   X=`shuf -i 1-$COUNT -n 1`
   Y=`shuf -i 1-$COUNT -n 1`
   echo $X $Y
   echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_$x values ($y, '$RAN_CHAR', current_timestamp)"
            hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_$x values ($y, '$RAN_CHAR', current_timestamp)"
   echo 2 - hdbsql -i 00 -u dash -p Serp1234 -o insert2_test_table.log -x -a "insert into test_connection_$X select top $Y * from test_connection_$x"
            hdbsql -i 00 -u dash -p Serp1234 -o insert2_test_table.log -x -a "insert into test_connection_$X select top $Y * from test_connection_$x"
   echo 3 - hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "insert into test_connection_$Y select top $X * from test_connection_$X"
            hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "insert into test_connection_$Y select top $X * from test_connection_$X"
done
}

INSERT_TABLE2 ()
{
for CounT in `seq 1 $INT_COUNT`
do
   for L in `seq 1 $COUNT`
   do
      for x in `seq 1 $COLUMN`
      do
         id_v=`shuf -i 1-$COUNT -n 1`
         echo "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval" >> insert_test1_connection_${L}_${x}.sql
         echo ",current_timestamp" >> insert_test1_connection_${L}_${x}.sql
         for y in `seq 1 $x`
         do
                 RAN_v=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
                 echo ",'$RAN_v'" >> insert_test1_connection_${L}_${x}.sql
         done
         echo ")" >> insert_test1_connection_${L}_${x}.sql
      done
      echo insert_test1_connection_${L}_${x}.sql
   done
done

for L in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
      echo - hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a -I insert_test1_connection_${L}_${x}.sql
             hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a -I insert_test1_connection_${L}_${x}.sql
      echo - rm insert_test1_connection_${L}_${x}.sql
             rm insert_test1_connection_${L}_${x}.sql
   done
done
}

INSERT_TABLE3 ()
{
for L in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
      if [ $x = 1 ]
      then
         for CounT in `seq 1 $INT_COUNT`
         do
            RAN_CHAR1=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1')"
                     hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1')"
         done
      elif [ $x = 2 ]
      then
         for CounT in `seq 1 $INT_COUNT`
         do
            RAN_CHAR1=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR2=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1', '$RAN_CHAR2')"
                     hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1', '$RAN_CHAR2')"
         done
      elif [ $x = 3 ]
      then
         for CounT in `seq 1 $INT_COUNT`
         do
            RAN_CHAR1=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR2=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR3=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1', '$RAN_CHAR2', '$RAN_CHAR3')"
                     hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1', '$RAN_CHAR2', '$RAN_CHAR3')"
         done
      elif [ $x = 4 ]
      then
         for CounT in `seq 1 $INT_COUNT`
         do
            RAN_CHAR1=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR2=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR3=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR4=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1', '$RAN_CHAR2', '$RAN_CHAR3', '$RAN_CHAR4')"
                     hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1', '$RAN_CHAR2', '$RAN_CHAR3', '$RAN_CHAR4')"
         done
      elif [ $x = 5 ]
      then
         for CounT in `seq 1 $INT_COUNT`
         do
            RAN_CHAR1=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR2=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR3=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR4=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            RAN_CHAR5=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
            echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1', '$RAN_CHAR2', '$RAN_CHAR3', '$RAN_CHAR4', '$RAN_CHAR5')"
                     hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test1_connection_${L}_${x} values (test_connect_seq_${L}_${x}.nextval, current_timestamp, '$RAN_CHAR1', '$RAN_CHAR2', '$RAN_CHAR3', '$RAN_CHAR4', '$RAN_CHAR5')"
         done
      else
         echo "ELSE"
      fi
   done
done

#for L in `seq 1 $COUNT`
#do
#   for x in `seq 1 $COLUMN`
#   do
#      echo - hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a -I insert_test1_connection_${L}_${x}.sql
#             hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a -I insert_test1_connection_${L}_${x}.sql
#      echo - rm insert_test1_connection_${L}_${x}.sql
#            rm insert_test1_connection_${L}_${x}.sql
#   done
#done

}

############################################################
# vi update_test_table.sh

UPDATE_TABLE ()
{
For_COUNT=100000

for z in `seq 1 $For_COUNT`
do
   RAN_CHAR=`head -c 15 /dev/urandom | tr -dc 'a-zA-Z0-9'`
   x=`shuf -i 1-$COUNT -n 1`
   y=`shuf -i 1-$COUNT -n 1`
   X=`shuf -i 1-$COUNT -n 1`
   Y=`shuf -i 1-$COUNT -n 1`
   echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a "update test_connection_$x set id=$X where id=$y"
            hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a "update test_connection_$x set id=$X where id=$y"
   echo 2 - hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a "update test_connection_$X set name='$RAN_CHAR' where id=$Y"
            hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a "update test_connection_$X set name='$RAN_CHAR' where id=$Y"
   echo 3 - hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a -z "update test_connection_$y set name='$RAN_CHAR' where id=$X"
            hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a -z "update test_connection_$y set name='$RAN_CHAR' where id=$X"
   echo 4 - hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a -z "insert into test_connection_$Y select top $X * from test_connection_$X"
            hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a -z "insert into test_connection_$Y select top $X * from test_connection_$X"
   echo 5 - hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "alter table test_connection_$Y column"
            hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "alter table test_connection_$Y column"
   echo 6 - hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "alter table test_connection_$X row"
            hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "alter table test_connection_$X row"
   echo 7 - hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "delete from test_connection_$X where id < $X"
            hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "delete from test_connection_$X where id < $X"
   echo 8 - hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "delete from test_connection_$Y where id < $y"
            hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "delete from test_connection_$Y where id < $y"
   echo 9 - hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "select * from test_connection_$x as "TB1", test_connection_$y as "TB2" where TB1.id = TB2.id"
            hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "select * from test_connection_$x as "TB1", test_connection_$y as "TB2" where TB1.id = TB2.id"
done
}

UPDATE_TABLE2 ()
{
For_COUNT=100000

for z in `seq 1 $For_COUNT`
do
for L in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
      #x=`shuf -i 1-$COUNT -n 1`
      y=`shuf -i 1-$COUNT -n 1`
      X=`shuf -i 1-$COUNT -n 1`
      Y=`shuf -i 1-$COUNT -n 1`
      RAN_CHAR=`head -c 15 /dev/urandom | tr -dc 'a-zA-Z0-9'`
      echo 1 - hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a "update test1_connection_${L}_${x} set id=$X where id=$y"
               hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a "update test1_connection_${L}_${x} set id=$X where id=$y"
      echo 2 - hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a "update test1_connection_${L}_${x} set name_${x}='$RAN_CHAR' where id=$Y"
               hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a "update test1_connection_${L}_${x} set name_${x}='$RAN_CHAR' where id=$Y"
      echo 3 - hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a -z "update test1_connection_${L}_${x} set name_${x}='$RAN_CHAR' where id=$X"
               hdbsql -i 00 -u dash -p Serp1234 -o update_test_table.log -x -a -z "update test1_connection_${L}_${x} set name_${x}='$RAN_CHAR' where id=$X"
      echo 4 - hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a -z "insert into test1_connection_${L}_${x} select top $X * from test1_connection_${L}_${x}"
               hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a -z "insert into test1_connection_${L}_${x} select top $X * from test1_connection_${L}_${x}"
      echo 5 - hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "alter table test1_connection_${L}_${x} column"
               hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "alter table test1_connection_${L}_${x} column"
      echo 6 - hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "alter table test1_connection_${L}_${x} row"
               hdbsql -i 00 -u dash -p Serp1234 -o insert3_test_table.log -x -a "alter table test1_connection_${L}_${x} row"
      #echo 7 - hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "delete from test1_connection_${L}_${x} where id < $X"
               #hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "delete from test1_connection_${L}_${x} where id < $X"
      #echo 8 - hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "delete from test1_connection_${L}_${x} where id < $y"
               #hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a "delete from test1_connection_${L}_${x} where id < $y"
   done
done
done
}

UPDATE_TABLE3 ()
{
For_COUNT=100000

for z in `seq 1 $For_COUNT`
do
for L in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
      #x=`shuf -i 1-$COUNT -n 1`
      y=`shuf -i 1-$COUNT -n 1`
      X=`shuf -i 1-$COUNT -n 1`
      Y=`shuf -i 1-$COUNT -n 1`
      RAN_CHAR=`head -c 15 /dev/urandom | tr -dc 'a-zA-Z0-9'`
      echo "update test1_connection_${L}_${x} set id=$X where id=$y ;" > update_table3.sql
      echo "update test1_connection_${L}_${x} set name_${x}='$RAN_CHAR' where id=$Y ;" >> update_table3.sql
      echo "update test1_connection_${L}_${x} set name_${x}='$RAN_CHAR' where id=$X ;" >> update_table3.sql
      echo "insert into test1_connection_${L}_${x} select top $X * from test1_connection_${L}_${x} ;" >> update_table3.sql
      echo "alter table test1_connection_${L}_${x} column ;" >> update_table3.sql
      echo "alter table test1_connection_${L}_${y} row ;" >> update_table3.sql
      echo "delete from test1_connection_${L}_${x} where id < $X ;" >> update_table3.sql
      echo "delete from test1_connection_${L}_${y} where id < $Y ;" >> update_table3.sql
      echo 8 - hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a -m -z -I update_table3.sql
               hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a -m -z -I update_table3.sql
   done
done
done
}

# hdbsql -i 00 -u dash -p Serp2017 -o insert4_test_table.log -x -a "insert into test_connection_$X select * from test_connection_$Y"

############################################################

SELECT_TABLE ()
{
For_COUNT=100000

for z in `seq 1 $For_COUNT`
do
for L in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
      RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
      echo "select * from test1_connection_${L}_${x} where " > select_table.sql
      echo "name_${x} = '${RAN_CHAR}' ">> select_table.sql
         if [ ${x} > 1 ]
         then
            for y in `seq 1 ${x}`
            do
               #y=`shuf -i 1-${y} -n 1`
               if [ ${x} = ${y} ]
               then
                  break ;
               fi
               RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
               echo "and name_${y} = '${RAN_CHAR}' ">> select_table.sql
            done
         fi
      echo " ; ">> select_table.sql
      echo  - hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a -m -z -I select_table.sql
              #hdbsql -i 00 -u dash -p Serp1234 -o delete_test_table.log -x -a -m -z -I select_table.sql
      cat select_table.sql
   done
done
done
}

############################################################

JOIN_TABLE ()
{
For_COUNT=100000

for z in `seq 1 $For_COUNT`
do
for L in `seq 1 $COUNT`
do
   for x in `seq 1 $COLUMN`
   do
      RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
      x2=`shuf -i 1-${COLUMN} -n 1`
      if [ ${x} = ${x2} ]
      then
         break ;
      fi
      echo "select * from test1_connection_${L}_${x} t1, test1_connection_${L}_${x2} t2 where " > join_table.sql
      echo "t1.name_${x} = t2.name_${x2} ">> join_table.sql
         if [ ${x} > 1 ]
         then
            for y in `seq 1 ${x}`
            do
               if [ ${x} = ${y} ]
               then
                  break ;
               fi
               RAN_CHAR1=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
               RAN_CHAR2=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
               echo "and t1.name_${y} = '${RAN_CHAR1}' ">> join_table.sql
               echo "and t2.name_${y} = '${RAN_CHAR2}' ">> join_table.sql
            done
         fi
      echo " ; ">> join_table.sql
      echo  - hdbsql -i 00 -u dash -p Serp1234 -o join_test_table.log -x -a -m -z -I join_table.sql
              hdbsql -i 00 -u dash -p Serp1234 -o join_test_table.log -x -a -m -z -I join_table.sql
      cat join_table.sql
   done
done
done
}

############################################################
# insert_2billions on Column Store (실제 30억건이하로 while)

INSERT_20 ()
{

echo 1 > L_COUNT.txt

#I_COUNT=`cat L_COUNT.txt`
#L_COUNT=`expr ${I_COUNT} \* 100`
#echo ${I_COUNT}
#echo ${L_COUNT}

echo "Create Table for 20Billions ? (Y/N) "
read CR_T_20B
if [ ${CR_T_20B} = Y ]
then
   hdbsql -i 00 -u dash -p Serp1234 -o create_20_sequence.log -x -a "create sequence test_connect_seq_20Limits start with 1 increment by 1 maxvalue 3000000000 cycle"
   hdbsql -i 00 -u dash -p Serp1234 -o create_20_test_table.log -x -a "create column table test_connection_20Limits (id number(10), name varchar(20), c_time timestamp)"
fi

while [ ${L_COUNT} -le 3000000000 ]
do
   I_COUNT=`cat L_COUNT.txt`
   L_COUNT=`expr ${I_COUNT} \* 100`
   if [ ${I_COUNT} -eq 1 ]
   then
      for L in `seq 1 ${L_COUNT}`
      do
         echo for : for 1 - $L
         RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
         echo - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_20Limits values (test_connect_seq_20Limits.nextval, '$RAN_CHAR', current_timestamp)"
                hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_20Limits values (test_connect_seq_20Limits.nextval, '$RAN_CHAR', current_timestamp)"
         echo $L > L_COUNT.txt
      done
   else
      for L in `seq ${I_COUNT} ${L_COUNT}`
      do
         echo for : for 2 - $L
         RAN_CHAR=`head -c 30 /dev/urandom | tr -dc 'a-zA-Z0-9'`
         echo - hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_20Limits values (test_connect_seq_20Limits.nextval, '$RAN_CHAR', current_timestamp)"
                hdbsql -i 00 -u dash -p Serp1234 -o insert1_test_table.log -x -a "insert into test_connection_20Limits values (test_connect_seq_20Limits.nextval, '$RAN_CHAR', current_timestamp)"
         echo $L > L_COUNT.txt
      done
   fi
done


echo "Drop Table for 20Billions ? (Y/N) "
read DR_T_20B
if [ ${DR_T_20B} = Y ]
then
   hdbsql -i 00 -u dash -p Serp1234 -o create_sequence.log -x -a "drop table test_connection_20LIMITS"
   hdbsql -i 00 -u dash -p Serp1234 -o create_sequence.log -x -a "drop sequence test_connect_seq_20Limits
fi

rm L_COUNT.txt
}

############################################################
# vi loop_kill.sh

KILL_SES ()
{

printf "Input type ? [sh | update | select | update | join] : "
read TYPE
ps -eaf | grep sh | grep -v grep | grep ${TYPE}
printf "Wanna KILL? (Yes or No) : "
read Y
if [ $Y = 'y' -o $Y = 'Y' -o $Y = 'yes' -o $Y = 'Yes' ]
then
   ps -eaf | grep sh | grep -v grep | grep ${TYPE} | awk '{print "kill -9 "$2}' | sh
fi
}

############################################################
# vi loop_update.sh

if [ $# -eq 0 ]
then
   echo "Input with ARG"
   echo "--- create, create2"
   echo "--- insert, insert2"
   echo "--- drop, drop2"
   echo "--- update, update2, update2"
elif [ $# -eq 1 ]
then
   if [ $1 = 'create' ]
   then
      CREATE_TABLE
   elif [ $1 = 'seq' ]
   then
      CREATE_SEQ
   elif [ $1 = 'drop' ]
   then
      DROP_TABLE
   elif [ $1 = 'insert' ]
   then
      INSERT_TABLE
   elif [ $1 = 'update' ]
   then
      UPDATE_TABLE
   elif [ $1 = 'update2' ]
   then
      UPDATE_TABLE2
   elif [ $1 = 'update3' ]
   then
      UPDATE_TABLE3
   elif [ $1 = 'kill' ]
   then
      KILL_SES
   elif [ $1 = 'create2' ]
   then
      CREATE_TABLE2
   elif [ $1 = 'insert2' ]
   then
      INSERT_TABLE2
   elif [ $1 = 'drop2' ]
   then
      DROP_TABLE2
   elif [ $1 = 'dropseq2' ]
   then
      DROP_SEQ2
   elif [ $1 = 'seq2' ]
   then
      CREATE_SEQ2
   elif [ $1 = 'insert3' ]
   then
      INSERT_TABLE3
   elif [ $1 = 'select' ]
   then
      SELECT_TABLE
   elif [ $1 = 'join' ]
   then
      JOIN_TABLE
   elif [ $1 = '20' ]
   then
      INSERT_20
   else
      echo "ERROR"
   fi
else
   echo "ERROR"
fi

############################################################
