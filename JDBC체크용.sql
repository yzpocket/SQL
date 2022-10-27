select * from memo;
desc memo;

drop table memo;
create sequence memo_seq
start with 3
increment by 1
nocache;