create table emp_10
as
select * from emp where 1<>1;
--구조만 복사.
select * from emp_10;

insert into emp_10(empno,job,ename,hiredate,mgr,sal,comm,deptno)
values(1000,'MANAGER','TOM',sysdate,null,2000,null,10);
commit;

desc emp_10;
낫널을 줘보자.
alter table emp_10 add constraint emp_10_ename_nn not null(ename);
테이블수준에서 주는것이라 허용되지않음(not null)이라 컬럼으로줘야됨.

--컬럼을 수정하면서 not null을 수정
alter table emp_10 modify ename varchar2(20) not null;

insert into emp_10(empno,job,mgr,sal,ename)
values(1001,'SALESMAN',1000,3000,'JAMES');

select * from emp_10;


--SUBQUERY를 활용한 INSERT
insert into emp_10
select * from emp where deptno=10;

####UPDATE문
UPDATE 테이블명 SET 컬럼명1=값1, ... where 조건절;

--EMP테이블을 카피하여 EMP2테이블을 만들되 데이터와 구조를 모두 복사하세요
create table emp2
as select * from emp;
--EMP2에서 사번이 7788인 사원의 부서번호를 10번 부서로 수정하세요.
select*from emp2;
update emp2 set deptno=10 where empno=7788;

--EMP2에서 사번이 7369인 사원의 부서를 30번 부서로 급여를 3500으로 수정하세요
select*from emp2;
update emp2 set sal=3500,deptno=30 where empno=7369;
rollback;


as select * from emp;


select*from member2 order by reg_date asc;
create table member2
as select * from member;

--2] 등록된 고객 정보 중 고객의 나이를 현재 나이에서 모두 5를 더한 값으로 
--	      수정하세요.
update member2 set age=age+5;

--	 2_1] 고객 중 13/09/01이후 등록한 고객들의 마일리지를 350점씩 올려주세요.
update member2 set mileage=mileage+350 where reg_date>'13/09/01';
--3] 등록되어 있는 고객 정보 중 이름에 '김'자가 들어있는 모든 이름을 '김' 대신
--	     '최'로 변경하세요.

update member2 set name=replace(name,'김','최') where name like '김%';


##UPDATE 할 때 무결성제약조건을 신경써야 함
create table dept2
as select * from dept;
desc dept2;

dept2의 테이블의 deptno에 대해 primary key 제약조건 주기
alter table dept2 add constraint dept_deptno_pk primary key(deptno);
alter table dept2 modify deptno number(2) constraint dept_deptno_pk primary key; 
select * from user_constraints where table_name='DEPT2';

EMP2 테이블의 DEPTNO에 대해 FOREIGN KEY 제약조건을 추가하되
DEPT2의 DEPTNO를 외래키로 참조하도록 하세요

alter table emp2 add constraint emp2_deptno_fk foreign key(deptno) references dept2(deptno);
select * from user_constraints where table_name='EMP2';

update emp2 set deptno =10 where deptno=20;
SELECT * FROM emp2;
rollback;
update emp2 set deptno =50 where deptno=20;
--50번부서가없어서 부모키 50없다고 나옴. 



##DELETE문
DELETE FROM 테이블명 WHERE 조건절;

select * from dept;
-- EMP2테이블에서 사원번호가 7499인 사원의 정보를 삭제하라.
delete from emp2 where empno=7499;
--- EMP2테이블의 자료 중 부서명이 'SALES'인 사원의 정보를 삭제하라.
select * from emp2;
delete from emp2 where deptno =(select deptno from dept2 where dname = 'SALES');  
---- PRODUCTS2 를 만들어서 테스트하기
create table products2
as select * from products;
--1] 상품 테이블에 있는 상품 중 상품의 판매 가격이 10000원 이하인 상품을 모두 
--	      삭제하세요.
delete from products2 where output_price <= 10000;
--
--	2] 상품 테이블에 있는 상품 중 상품의 대분류가 도서인 상품을 삭제하세요.
select * from products2;
select * from category;
delete from products2 where category_fk = (select category_code from category where category_name like '도서' and mod(category_code,100)=0);

delete from products2;
--where 조건절이 없으면 모든 레코드가 삭제된다.
commit;





#####TCL : TRANSACTION CONTROL LANGUAGE
-COMMIT
-ROLLBACK
-SAVEPOINT(표준아님 - 오라클에만 있음)

update emp2 set ename='CHARSE' where empno=7788;
select * from emp2;

update emp2 set deptno=30 where empno=7788;

#SAVEPOINT 포인트명
--이 지점까지 저장하겠다.
savepoint point1;
--아래 잘못업데이트 한경우.
update emp2 set job='MANAGER';
--저장점 까지만 롤백하겠다.
rollback to savepoint point1;
commit;