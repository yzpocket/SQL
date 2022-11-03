---PL_SQL실습03.txt--


--#########################패키지 ##############################

여러개의 프로시저, 함수, 커서 등을 하나의 패키지로 묶어 관리 할 수 있다.
-선언부
-본문(package body)

---선언부
create or replace package empInfo as
procedure allEmp;
procedure allSal;
end empInfo;

---본문(package body)
create or replace package body empInfo as
--allEmp 프로시저 생성 1
    procedure allEmp
    is
        cursor empCr is
        select empno,ename,hiredate from emp
        order by 3;
    begin
        for k in empCr loop
            dbms_output.put_line(k.empno || lpad(k.ename,16,' ') || lpad(k.hiredate,16,' '));
        end loop;
    exception
        when others then
        dbms_output.put_line(sqlerrm||'error 발생');
    end allEmp;
    
    --allSal 프로시저 생성2
    -- allSal은 전체 급여 합계, 사원수, 급여평균, 최대급여, 최소급여를 가져와 출력하는 프로시저
    procedure allSal
    is
    begin
        dbms_output.put_line('총합' || lpad('사원수',10,' ') || lpad('평균급여',10,' ') || lpad('최대급여',10, ' ' ) || lpad('최소급여', 10, ' '));
        for k in (select sum(sal)sm, count(empno) cnt, round(avg(sal)) av, 
                     max(sal) mx, min(sal) mn from emp) loop
            dbms_output.put_line(k.sm || lpad(k.cnt,3,' ') || lpad(k.av,10,' ') || lpad(k.mx,10, ' ' ) || lpad(k.mn, 10, ' '));
        end loop;
    end allSal;
end empInfo;
/

set serveroutput on

exec empInfo.allEmp;
exec empInfo.allSal;





--####################트리거#########################
INSERT, UPDATE, DELETE 문이 실행 될 때 묵시적으로 수행되는 일종의 프로시저다.
- BEFORE : INSERT, UPDATE, DELETE문이 실행되기 전에 
	트리거가 실행됩니다. 
- AFTER : INSERT, UPDATE, DELETE문이 실행된 후 
	트리거가 실행됩니다. 

create or replace trigger trg_dept
before
update on dept
for each row
declare --변수를 써야한다면 디클레어로 선언.
msg varchar2(30);
begin
    dbms_output.put_line('변경 전 컬럼 값 : ' || :old.dname);
    dbms_output.put_line('변경 후 컬럼 값 : ' || :new.dname);
end;
/
select*from dept;
update dept set dname='운영부' where deptno=40;
--트리거 생성하면 위 dept 테이블 update문에 대한 로그? 같은걸 보여준다. insert, delete등으로 바꿀 수 있다.
rollback;

######## 개발시 방해될 때 트리거 비활성화 #######
alter trigger trg_dept disable;

######## 다시 트리거 활성화 #######
alter trigger trg_dept enable;

####### 데이터 사전에서 조회 #######
select * from user_triggers where trigger_name=upper('trg_dept');

####### 트리거 삭제 #######
drop trigger trg_dept;


--[실습] emp 테이블에 데이터가 insert 되거나 update될 경우(before)
전체 사원들의 평균 급여를 출력하는 트리거를 작성.

create or replace trigger trg_emp_avg
before
insert or update on emp
--for each row
--when :new.empno > 0 -- 이렇게 조건도 달 수 있다.
declare --변수를 써야한다면 디클레어로 선언.
avg_sal number(10);
begin
    select round(avg(sal),2) into avg_sal
    from emp;
    dbms_output.put_line('평균급여 : ' || avg_sal);
end;
/

--인서트에 되는지 확인..
insert into emp(empno,ename,deptno,sal)
values(9002,'PETER2',20,3000);
--before를 줘서 트리거에서 출력되는 인서트 전의 평균 급여이다.
rollback;

--업데이트도 되는지 확인
update emp set sal=sal*1.1 where empno=7788;
select avg(sal) from emp;
select * from emp;

##########################행트리거#########################
--트리거 실습
--입고 테이블에 상품이 입고될 경우
--상품 테이블에 상품 보유수량이 자동으로 변경되는 트리거를 작성해봅시다.

create table myproduct(
    pcode char(6) primary key,
    pname varchar2(20) not null,
    pcompany varchar2(20),
    price number(8),
    pqty number default 0
);
desc myproduct;
'A001', 'A002' 이런식으로 상품코드 생성. 시퀀스로
create sequence myproduct_seq
start with 1
increment by 1
nocache;

insert into myproduct
values('a00'||myproduct_seq.nextval, '노트북', 'A사', 800000, 10);
insert into myproduct
values('a00'||myproduct_seq.nextval, '자전거', 'B사', 100000, 20);
insert into myproduct
values('a00'||myproduct_seq.nextval, '킥보드', 'C사', 70000, 30);
commit;

select * from myproduct;
--입고 테이블
create table myinput(
    incode number primary key, --입고번호
    pcode_fk char(6) references myproduct(pcode), --입고상품코드
    indate date default sysdate, --입고일
    inqty number(6),
    inprice number (8)
);

create sequence myinput_seq nocache; --1시작1증가 생략 기본값이라

입고테이블에 상품이 들어오면 (insert)
상품 테이블의 보유 수량을 변경하는 트리거를 작성하세요. (들어온후 : after)
create or replace trigger trg_input_product
after
insert on myinput
for each row
declare 
    cnt number := :new.inqty;  --새로들어온 수량
    code char(6) := :new.pcode_fk;
begin
    update myproduct set pqty = pqty+cnt where pcode = code;
    dbms_output.put_line(code || '상품이 추가로 ' || cnt || '개 들어옴');
end;
/

select * from myproduct;
insert into myinput
values(myinput_seq.nextval, 'a002', sysdate, 8, 50000);

입고 테이블의 수량이 변경 될 경우(update 문이 실행 될 때)
상품 테이블의 수량을 수정하는 트리거를 작성하세요.
CREATE OR REPLACE TRIGGER TRG_INPUT_PRODUCT2
AFTER
INSERT ON MYINPUT
FOR EACH ROW
DECLARE 
    GAP NUMBER;
BEGIN
    GAP:=:NEW.INQTY-:OLD.INQTY;
    UPDATE MYPRODUCT SET PQTY=PQTY+GAP WHERE PCODE=:NEW.PCODE_FK;
    DBMS_OUTPUT.PUT_LINE('NEW: ' || :NEW.INQTY || ', OLD: ' || :OLD.INQTY || ', GAP : ' || GAP);
END;
/

select * from myproduct;
select * from myinput;
update myinput set inqty=10 where incode=1;
update myinput set inqty=18 where incode=2;

select * from user_triggers;
select * from user_objects where object_type='TRIGGER';



######################### 문장 트리거 #########################
EMP 테이블에 신입사원이 들어오면 (INSERT 되면) 로그 기록을 남기는 트리거
어떤 DML 문장을 실행했는지, DML이 수행된 시점의 시간, 수행한 USER 데이터를
EMP_LOG 테이블에 기록하자.

create table emp_log(
    log_code number primary key,
    user_id varchar2(30),
    log_date date default sysdate,
    behavior varchar2(20)
);
create sequence emp_log_seq nocache;

create or replace trigger trg_emp_log
before insert on emp
begin
    if (to_char(sysdate,'dy')in ('FRI','SAT','SUN')) then
        raise_application_error(-20001, '금, 토, 일에는 입력작업을 수행 할 수 없습니다.');
    else
        insert into emp_log values(emp_log_seq.nextval, user, sysdate, 'insert');
    end if;
end;
/

emp에 사번, 사원명, 급여, 부서번호를 새로 insert하세요.
insert into emp(empno, ename, sal, deptno)
values(9010,'THOMAS',3300,20);

select * from emp_log;