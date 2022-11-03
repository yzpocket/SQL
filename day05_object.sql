-- day05_object.sql --
--
--############################################SEQUENCE################################################
--CREATE SEQUENCE 시퀀스명
--[INCREMENT BY n] -- 증가치
--[START WITH n] -- 시작값
--[{MAXVALUE n | NOMAXVALE}] --최대값 --nomaxvale는 제한없이
--[{MINVALUE n | NOMINVALUE}] --최소값 --nominvale은 제한없이
--[{CYCLE | NOCYCLE}] -- 최소또는 최대값에 도달한 이후 계속 반복생성 할 지 여부
--[{CACHE N | NOCACHE}] -- 메모리 캐시 디폴트 사이즈 20 
--;


SELECT MAX(DEPTNO) FROM DEPT2;
#################시퀀스 생성 ####################
CREATE SEQUENCE DEPT2_SEQ
START WITH 50
INCREMENT BY 5
MAXVALUE 95
CACHE 20
NOCYCLE;

데이터사전에서 시퀀스 조회
SELECT * FROM USER_SEQUENCES;

######################시퀀스 사용####################
NEXTVAL : 시퀀스 다음값
CURRVAL : 시퀀스 현재값

--[주의사항] nextval이 호출 되지 않은 상태에서는 currval을 호출하면 에러 발생
SELECT DEPT2_SEQ.CURRVAL FROM DUAL; --에러 

SELECT DEPT2_SEQ.NEXTVAL FROM DUAL; --시작해서 50이된다.

SELECT DEPT2_SEQ.CURRVAL FROM DUAL; --현재50이된다.

SELECT DEPT2_SEQ.NEXTVAL FROM DUAL; --55넘어간다.

SELECT DEPT2_SEQ.CURRVAL FROM DUAL; --현재55된다.

SELECT DEPT2_SEQ.NEXTVAL FROM DUAL; --60넘어간다.

SELECT DEPT2_SEQ.CURRVAL FROM DUAL; --현재60이다.

INSERT INTO DEPT2(DEPTNO, DNAME,LOC)
VALUES(DEPT2_SEQ.NEXTVAL,'SALES','SEOUL');

SELECT * FROM DEPT2;
SELECT DEPT2_SEQ.CURRVAL FROM DUAL;

--실습 
시퀀스명: TEMP_SEQ
시작값: 100부터 시작
증가치: 5만큼씩 감소
최소값은 0으로
CYCLE 옵션 주기
캐시사용 하지 않도록

CREATE SEQUENCE TEMP_SEQ
START WITH 100
INCREMENT BY -5
MAXVALUE 100
MINVALUE 0 
NOCACHE 
CYCLE;

SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME='TEMP_SEQ';

SELECT TEMP_SEQ.NEXTVAL FROM DUAL;


######################시퀀스 수정##############################
[주의사항] 시작값은 수정 할 수 없다. 시작값 수정하려면 DROP하고 다시 CREATE 한다.
ALTER SEQUENCE 시퀀스명
INCREMENT BY N
MAXVALUE N
MINVALUE N
CYCLE|NOCYCLE
CACHE N|NOCACHE;

--실습
DEPT2_SEQ를 수정하되 MAXVALUE는 1000까지
증가치 1씩 증가하도록 수정
ALTER SEQUENCE DEPT2_SEQ
--start with 10 -- 시작값은 못바꿈 에러
INCREMENT BY 1
MAXVALUE 1000;

SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME='dept2_seq';
insert into dept2 values(dept2_seq.nextval, 'TEST', 'TEST');
select * from dept2;
SELECT DEPT2_SEQ.CURRVAL FROM DUAL;


###########################시퀀스 삭제##############################
DROP SEQUENCE 시퀀스명;
DROP SEQUENCE TEMP_SEQ;



--############################################VIEW################################################

################VIEW####################
[주의사항] view를 생성하려면 create view 권한을 가져야 한다.
--system/oracle로 접속한뒤 grant create view to scott;

grant create view to scott;
 
뷰를 만드는 규칙
	CREATE VIEW 뷰이름
	AS
	SELECT 컬럼명1, 컬럼명2...
	FROM 뷰에 사용할 테이블명
	WHERE 조건
    
 EMP테이블에서 20번 부서의 모든 컬럼을 포함하는 EMP20_VIEW를 생성하라.
 create view emp20_view
 as
 select * from emp where deptno=20;
 
 select * from emp20_view;
 
 select * from user_views;
 
 desc emp20_view;
 
 ################view 삭제####################
 drop view 뷰이름;
 drop view emp20_view;
 
 ################view 수정####################
 create or replace 뷰이름;
 
 
 EMP테이블에서 30번 부서만 EMPNO를 EMP_NO로 ENAME을 NAME으로
	SAL를 SALARY로 바꾸어 EMP30_VIEW를 생성하여라.
create or replace view emp30_view
as select empno emp_no,ename name, sal salary from emp
where deptno=30;

select * from emp30_view;

create or replace view emp30_view(eno,name,salary,dno)
as select empno ,ename, sal,deptno from emp
where deptno=30;
 
 --#원테이블을 수정하면 관련된 뷰도 수정된다.
 7499사원을 emp에서 20번 부서로 이동시키세요
 update emp set deptno=20 where empno=7499;
 select * from emp;
 select * from emp30_view;
  --#뷰를 수정하면 원테이블은??
 WARD를 10번부서로
  update emp30_view set dno=10 where eno=7521;
  select * from emp30_view;
  --원테이블도 수정된다.
  rollback;

 emp와 dept 테이블을 join 해서 view를 만드세요
 emp_dept_view
create or replace view emp_dept_view
as
select e.deptno, dname, ename, job
from dept d join emp e
on e.deptno=d.deptno;
 
 select * from emp_dept_view order by 1;
 
 
 
######################WITH READ ONLY; 뷰 읽기전용 옵션 #########################
  뷰에 DML 문장을 수행 할 수 없다.
create or replace view emp10_view
as select empno,ename,job,deptno
from emp where deptno=10
with read only;
select * from emp10_view;
update emp10_view set job='SALESMAN' where empno=7782;
--읽기전용이라 업데이트가 안된다.

######################WITH CHECK OPTION; 뷰 ###################################
EMP에서 JOB이 SALESMAN인 사람들만 모아서 EMP_SALES_VIEW만들되
with check option 주기;
create or replace view emp_sales_view
as select *
from emp where job = 'SALESMAN'
with check option;
select*from emp_sales_view;
update emp_sales_view set deptno=10 where empno=7499;
==>수정 가능.
update emp_sales_view set job = 'MANAGER' where ename='WARD';
---생성 시 where절에서의 뷰 생성 조건에 영향을 미쳤던 'JOB'은 유지하여 INSERT나 UPDATE되는 것을 막는다.


#####################INLINE VIEW ##############################
from 절에서 사용된 서브쿼리를 인라인 뷰라고 한다.

EMP에서 장기 근속자 3명만 뽑아서 해외여행시키려고 한다.
select * from emp;
create view emp_old_view
as select * from emp
order by hiredate asc;

select * from emp_old_view;

select rownum, empno, ename, hiredate from emp_old_view where rownum<4;

select * from (
select rownum RN, A.* 
from (select * from emp order by hiredate asc) A
)
where RN>1 and RN<4;

select * from (
select rank() over(order by hiredate asc) rnk, emp_old_view.* from emp_old_view
)
where rnk>1 and rnk<=3;

--############################################INDEX################################################

################ INDEX####################
 - 자동생성되는 경우 : PRIMARY KEY나 UNIQUE 제약 조건을 주면 자동으로 생성된다.
 - 명시적으로 생성하는 경우 : 사용자가 특정 컬럼을 지정해서 UNIQUE INDEX 또는 NON_UNIQUE
    인덱스를 생성 할 수 있다.
    
CREATE INDEX 인덱스명 ON 테이블명(컬럼명[, 컬럼명2])
[주의사항] 인덱스는 NOT NULL인 컬럼에만 사용 가능하다.

EMP에서 사원명에 INDEX를 생성하세요
EMP_ENAME_INDEX로;
create index emp_ename_indx on emp(ename);
select * from emp where ename='SCOTT';

인덱스를 지정하면 내부적으로 해당 컬럼을 읽어서 오름 차순 정렬을 한다.
ROWID와 ENAME을 저장하기위한 저장공간을 할당 한 후 그 값을 저장한다.

데이터사전에서 조회
select * from user_objects where object_type='INDEX';
select * from user_indexes;

select * from user_ind_columns
where index_name='EMP_ENAME_INDX';

select * from user_ind_columns
where table_name='DEPT2';

상품 테이블에서 인덱스를 걸어두면 좋을 컬럼을 찾아 인덱스를 만드세요.
select * from products;
create index products_category_fk_indx on products(category_fk);
create index products_ep_code_fk_indx on products(ep_code_fk);
select * from user_indexes where table_name='PRODUCTS';

카테고리, 상품, 공급업체 join해서 출력하세요
CREATE OR REPLACE VIEW PRODUCTS_INFO_VIEW
AS
SELECT C.CATEGORY_CODE, CATEGORY_NAME, PNUM, PRODUCTS_NAME, OUTPUT_PRICE, EP_CODE_FK, EP_NAME
FROM  CATEGORY C
RIGHT OUTER JOIN PRODUCTS P
ON C.CATEGORY_CODE =P.CATEGORY_FK
LEFT OUTER JOIN SUPPLY_COMP S
ON P.EP_CODE_FK = S.EP_CODE;

SELECT * FROM PRODUCTS_INFO_VIEW
ORDER BY OUTPUT_PRICE ASC;


######################DROP INDEX 인덱스명; #########################
emp_ename_indx 인덱스를 삭제하세요
drop index emp_ename_indx;
select * from user_indexes where table_name='EMP';

######################인덱스 수정 ###################################
==>DROP 하고 다시 생성한다.


--############################################SYNONYM################################################

CREATE [PUBLIC] SYNONYM FOR 객체
- PUBLIC은 DBA만 줄 수 있다
- 동의어 생성 권한도 부여받아야만 할 수 있다.
system 계정으로 접속해서 권한을 부여해야 한다.
grant create synonym to mystar;

데이터사전에서 조회
select*from user_objects where object_type='SYNONYM'

#동의어 삭제
drop synonym 동의어명;

drop synonym note;
select * from note;
select * from mystar.note;