select * from memo;
desc memo;

drop table memo;
create sequence memo_seq
start with 3
increment by 1
nocache;

----------
--day02
select * from memo;


--day03
select * from emp;
drop table emp;
rollback;

