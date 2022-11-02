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

--day04

select * from memo order by idx desc;

데드락 테스트
update memo set name='송길남' where idx=22;

delete from memo where idx=28;

commit;


--day05

#모든 메모 목록을 가져오는 프로시저를 작성해서 자바와 연동해봅시다.
--자바쪽으로 던져줄 아웃 파라미터가 필요하다
--그것이 커서다.
create or replace procedure memo_all(mycr out sys_refcursor)
is
begin
    --커서 오픈
    open mycr for
    select idx, name, msg, wdate from memo
    order by idx desc;
end;
/



-----------
		//부서번호를 인파라미터로 전달하면 해당 부서에 있는
		//사원 정보(사원명ename, 업무job, 입사일hiredate)와
		//부서정보(부서명dname,근무지loc)를 가져오는 프로시저를 작성하고 

create or replace procedure emp_forjava(
pdno in emp.deptno%type,
mycr out sys_refcursor)
is
begin
    OPEN mycr for
    select ename,job,hiredate,dname,loc from
    (select * from emp where emp.deptno=pdno) A join dept D
    on A.deptno = D.deptno;
end;
/
select * from emp;