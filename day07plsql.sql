--day07_plsql.sql

set serveroutput on --이걸 해줘야 dbms_output이 활성화된다. 접속시마다.


--########## IN OUT PARAMETER
--프로시저가 읽고 쓰는 작업을 동시에 할 수 있는 파라미터
create or replace procedure inout_test( --파라미터 부분.
    a1 in number,
    a2 in varchar2,
    a3 in out varchar2,
    a4 out varchar2
    )
is
    msg varchar2(30) :=' '; --변수부분
begin
    dbms_output.put_line('--------------');
    dbms_output.put_line('프로시저 시작 전');
    dbms_output.put_line('--------------');
    dbms_output.put_line('a1: ' || a1);
    dbms_output.put_line('a2: ' || a2);
    dbms_output.put_line('a3: ' || a3); 
    dbms_output.put_line('a4: ' || a4); 
    a3 :='프로시저 외부에서 이 값을 받을 수 있을까요?';
    msg :='SUCCESS';
    a4 :=msg;
    dbms_output.put_line('--------------');
    dbms_output.put_line('프로시저 시작 후');
    dbms_output.put_line('--------------');
    dbms_output.put_line('a1: ' || a1);
    dbms_output.put_line('a2: ' || a2);
    dbms_output.put_line('a3: ' || a3);
    dbms_output.put_line('a4: ' || a4); 
end;
/

variable c varchar2(100);
variable d varchar2(100);

exec inout_test(5000,'안녕', :c, :d);

print d
print c






--########## IF 제어문
IF ~ THEN ~~;
ELSIF ~ THEN ~~;
...
ELSE ~~;
END IF;

--사번을 인파라미터로 전달하면 사원의 부서번호에 따라 소속된 부서명을 문자열로 출력하는 프로시져
--10 회계부서
--20 연구부서
--30 영업부서
--40 운영부서

create or replace procedure dept_find(pno in emp.empno%type)
is
vdno emp.deptno%type;
vename emp.ename%type;
vdname varchar2(20); --부서명 담을 변수.
begin
    select deptno, ename into vdno, vename
    from emp
    where empno=pno;
        IF vdno = 10 THEN vdname :=  '회계부서';
        ELSIF vdno = 20 THEN vdname :=  '연구부서';
        ELSIF vdno = 30 THEN vdname :=  '영업부서';
        ELSIF vdno = 40 THEN vdname :=  '운영부서';
        ELSE vdname :=  '미등록 부서';
        END IF;
    dbms_output.put_line(vename || '님은 ' || vdno || '번 ' || vdname || '에 있습니다.');
end;
/
exec dept_find(7339);


--사원명을 인파라미터로 전달
--해당 사원의 연봉을 계산해서 출력하는 프로시저를 작성
--연봉은 comm이 null인경우와 null이 아닌 경우를 나눠서 계산하세요.
--ename, sal, comm, sal*12를 출력하세요.

create or replace procedure emp_sal(pname in emp.ename%type)
is
vsal emp.sal%type;
vcomm emp.comm%type;
total number(8); -- 연봉 담을 변수.
begin
    select sal, comm into vsal, vcomm
    from emp
    where ename=upper(pname);
        if vcomm is null then 
            total := vsal * 12;
        else 
            total := (vsal * 12) + vcomm;
        end if;
    dbms_output.put_line(pname || ' ----- ');
    dbms_output.put_line('월급여 : ' || vsal);
    dbms_output.put_line('보너스 : ' || vcomm);
    dbms_output.put_line('연   봉 : ' || total);
    exception
    when no_data_found then
    dbms_output.put_line(pname || '님은 없습니다.');
    when too_many_rows then
    dbms_output.put_line(pname || '님 데이터가 2건 이상입니다.');
end;
/
exec emp_sal('king'); -- 1건인땐 잘출력됨
exec emp_sal('sdking'); -- 없는 이름일때 exception 메시지

select * from emp;
insert into emp(empno,job,ename,sal,comm)
values(8000, 'ANALYST', 'TOM', 1000, 2000);
commit; -- tom을 2건이상으로 만듬.
exec emp_sal('tom'); --2건이상일때 exception 메시지 출력하게



--########## FOR LOOP 반복문
--FOR I IN 시작값..종료값 LOOP
--    실행문
--END LOOP;

declare
vsum number(4) :=0;
begin
    --1부터 10까지의 합
    for i in 1..10 loop
        dbms_output.put_line(i);
        vsum := vsum+i;
    end loop;
    dbms_output.put_line('까지의 합' || vsum);
end;
/

--JOB을 인파라미터로 전달하면 해당 업무를 수행하는 사람들의 정보
--사번, 사원명, 부서번호, 부서명,업무를 출력하세요
--for loop를 이용해서 풀되 서브쿼리 이용.
select * from emp;
select * from dept;
select empno, ename, deptno, job, (select dname from dept where deptno = emp.deptno)dname
from emp
where job='MANAGER'; -- 원하는 정보들만 나오는지 확인 후 for loop로 복사. manager만 변수 pjob으로 변경처리.

create or replace procedure emp_job(pjob in emp.job%type)
is
begin
    for e in (select empno, ename, deptno, job, (select dname from dept where deptno = emp.deptno)dname
                                                                            from emp
                                                                            where job=PJOB) loop
        dbms_output.put_line(e.empno || lpad(e.ename, 10, ' ') || lpad(e.deptno, 8, ' ') || lpad(e.job, 12, ' ')|| lpad(e.dname,12,' '));
    end loop;
end;
/
exec emp_job('MANAGER');
exec emp_job('ANALYST');



######## 반복문 중 건너뛰기 continue
1~100까지의 숫자 중 짝수만 출력하기
CONTINUE WHEN 조건;

declare
begin
    for k in 1..100 loop
        continue when mod(k,2)=1;
        dbms_output.put_line(k);
    end loop;
end;
/


#######LOOP 무한반복 및 탈출문
LOOP
	실행문장;
EXIT [WHEN 조건문]
END LOOP;

emp테이블에 사원정보를 등록하되 loop문을 이용해서 등록해 봅시다.

declare
vcnt number(3) :=100;
begin
    loop
        insert into emp(empno, ename, hiredate)
        values(vcnt+8000,'NONAME' || vcnt, sysdate);
        vcnt := vcnt+1;
        exit when vcnt > 105; --exit 탈출 105번되면 탈출.
    end loop;
        dbms_output.put_line(vcnt-100||'건의 데이터 입력 완료');
end;
/

select * from emp;
rollback;



####### WHILE LOOP 문
--WHILE 조건 LOOP
--      실행문
--      [EXIT WHEN 조건;]
--      [CONTINUE WHEN 조건;]
--      END LOOP;


declare
vcnt number(3) :=0;
begin
    while vcnt < 10 loop
        vcnt := vcnt+2;
        continue when vcnt=4;
        dbms_output.put_line(vcnt);
    end loop;
end;
/




####### CASE 문
CASE 비교기준
    WHEN 값1 THEN 실행문;
    WHEN 값2 THEN 실행문;
    ...
    ELSE
    실행문
END CASE;

--평균점수를 인파라미터로 전달하면 학점을 출력하는 프로시저를 작성하세요
--100~90 : A
--81 => B
--77 => C
--60점대 => D
--나머지 => F

create or replace procedure grade_avg(score in number) 
is
grade char(1) :='F';
begin
    case 
        when score >= 90 then grade := 'A';
        when score >=80 then grade := 'B';
        when score >=70 then grade := 'C';
        when score >=60 then grade := 'D';
        else grade := 'F';
    end case;
    dbms_output.put_line(score|| '점 ' || grade || '학점');
end;
/
exec grade_avg(79);


CREATE OR REPLACE PROCEDURE GRADE_AVG (SCORE IN NUMBER)
IS
BEGIN
    CASE FLOOR(SCORE/10)
        WHEN 10 THEN DBMS_OUTPUT.PUT_LINE('A');
        WHEN 9 THEN DBMS_OUTPUT.PUT_LINE('A');
        WHEN 8 THEN DBMS_OUTPUT.PUT_LINE('B');
        WHEN 7 THEN DBMS_OUTPUT.PUT_LINE('C');
        WHEN 6 THEN DBMS_OUTPUT.PUT_LINE('D');
        ELSE 
        DBMS_OUTPUT.PUT_LINE('F');
    END CASE;
END;
/










---------------------PL_SQL실습02.txt----------------------

--###### 암시적 커서

create or replace procedure implicit_cursor
(pno in emp.empno%type)
is
vsal emp.sal%type;
update_row number;
begin
    select sal into vsal
    from emp where empno = pno;
    if sql%found then --검색된 데이터가 있다면 (암시적 커서의 속성을 이용)
        dbms_output.put_line(pno || '번 사원의 월 급여는 ' || vsal || '입니다. 10% 인상 예정입니다.');
    end if;
    
    update emp set sal=sal*1.1 where empno=pno;
    update_row := sql%rowcount;
    dbms_output.put_line(update_row || '명의 사원이 급여가 인상되었어요.');
    select sal into vsal
    from emp where empno = pno;
        if sql%found then --검색된 데이터가 있다면
        dbms_output.put_line(pno || '번 사원의 인상된 월 급여는 ' || vsal || '입니다.');
    end if;
end;
/

exec implicit_cursor(7788);
rollback;




--###### 명시적 커서
--커서 선언
--커서 OPEN
--반복문 돌면서
--    커서에 FETCH한다
--커서CLOSE

create or replace procedure emp_all
is
    vno emp.empno%type;
    vname emp.ename%type;
    vdate emp.hiredate%type;
--커서 선언
    cursor emp_cr is 
    select empno, ename, hiredate
    from emp order by 1 asc;
begin
    --커서 오픈
    open emp_cr;
    --꺼내는(fetch) 작업
    loop
        fetch emp_cr into vno, vname, vdate;
        exit when emp_cr%notfound; --반복문돌다가 더이상 데이터 없으면 루프문 빠져나가겠다.
        dbms_output.put_line(vno || lpad(vname,12, ' ') || lpad(vdate,12,' '));
    end loop;
    --커서 닫기
    close emp_cr;
end;
/

exec emp_all;


실습] 부서별 사원수, 평균급여, 최대급여, 최소급여를 가져와 출력하는 프로시져를 작성
    select deptno, count(empno) cnt, avg(sal) avg_sal, max(sal) max_sal, min(sal) min_sal from emp group by deptno having deptno is not null order by 1 asc;
create or replace procedure dept_stat
is
    vdno emp.deptno%type;
    vcnt number;
    vavg number;
    vmax number;
    vmin number;
--커서 선언
    cursor cr is 
        select deptno, count(empno) cnt, round(avg(sal)) avg_sal, max(sal) max_sal, min(sal) min_sal
        from emp
        group by deptno
        having deptno is not null
        order by 1 asc;

begin
    --FOR 루프에서 커서를 이용하면 별도로 OPEN,FETCH,CLOSE 할 필요가 없다.
    --FOR루프만 자동으로 관리한다.,
    for k in cr loop
        dbms_output.put_line(k.deptno || lpad(k.cnt,10, ' ') || lpad(k.avg_sal,10, ' ') || lpad(k.max_sal,10, ' ') || lpad(k.min_sal,10, ' '));
    end loop;
end;
/

exec dept_stat;





##SUBQUERY

부서테이블의 모든 정보를 가져와 출력하는 프로시저를 작성하되
FOR LOOP이용하기
select * from dept;

create or replace procedure dept_all
is
begin
    FOR k IN (select * from dept order by deptno) LOOP
    dbms_output.put_line(k.deptno || lpad(k.dname,12, ' ') || lpad(k.loc,12,' '));
    END LOOP;
end;
/
exec dept_all;



##### EXCEPTION 미리 정의된 예외 처리하기
select * from member;
member 테이블의 userid 컬럼에 unique 제약 조건을 추가하되 제약조건 이름을 주어 추가하자.

ALTER TABLE member ADD CONSTRAINT member_userid_uk unique (userid);
select * from user_constraints where table_name='MEMBER';

create sequence member_seq
start with 11
increment by 1
nocache;
select*from member;
member테이블에 새로운 레코드를 추가하는 프로시저를 작성하되
인파라미터로 회원이름, 유저아이디, 비밀번호,나이, 직업, 주소를 주고
해당 데이터를 insert하는 프로시저를 작성

create or replace procedure member_add
(
pname in member.name%type,
pid in member.userid%type,
pwd in member.passwd%type,
page in member.age%type,
pjob in member.job%type,
paddr in member.addr%type
)
is
vname member.name%type;
vuid member.userid%type;
begin
    insert into member(num,userid,name,passwd,age,job,addr,reg_date)
    values(member_seq.nextval, pid, pname, pwd, page, pjob, paddr, sysdate);
    if sql%rowcount>0 then
        dbms_output.put_line('회원가입 완료');
    end if;
    select name, userid into vname, vuid
    from member where name=pname;
    dbms_output.put_line(pname || '님 ' || vuid ||'아이디로 등록되었습니다.');
    
    exception
    when dup_val_on_index then
    dbms_output.put_line('등록하려는 아이디는 이미 등록되어 있어요');
    when too_many_rows then
    dbms_output.put_line(pname || '님 데이터는 2건 이상 있습니다.');
    when others then
    dbms_output.put_line('기타 예상치 못했던 예외 발생: ' ||sqlerrm ||sqlcode);

end;
/

exec member_add('김추가', 'KIM', '123', 22, '학생', '서울 마포구');

select * from member order by reg_date desc;








---------------------PL_SQL실습03.txt----------------------
#사용자 정의 예외(User-Defined Exceptions)    만들고 발생 시키기

select count(*) from emp
group by deptno;

부서 인원이 5명 미만이면 사용자정의 예외를 만들어 발생시키자.

create or replace procedure user_except
(pdno in dept.deptno%type)
is
--1. 예외 선언(정의하는 단계) 이름 익셉션(타입)
    my_define_error exception;
    vcnt number;
begin
    select count(empno) into vcnt
    from emp where deptno = pdno;
    --2. 예외를 발생시키기 => raise 문을 이용
    if vcnt <5 then
        raise my_define_error; --선언한 에러를 발생시키자.
    end if;
    dbms_output.put_line(pdno || '번 부서 인원은 ' || vcnt || '명 입니다.');
    --3. 예외 처리 단계
    exception
        when my_define_error then --선언한 에러가 발생되었다면
            raise_application_error(-20001, '부서 인원이 5명 미만인 부서는 안돼요');
end;
/
select * from dept;
exec user_except(20);



######## FUNCTION : 실행환경에 반드시 하나의 값을 RETURN 해야 한다.
--리턴이 프로시져와 다른점임.

--사원명을 입력하면 해당 사원이 소속된 부서명을 반환하는 함수를 작성하세요
create or replace function get_dname(pname in emp.ename%type)
--반환해줄 데이터 유형을 지정해줘야 한다.
return varchar2
is
vdno emp.deptno%type;
vdname dept.dname%type;
begin
    select deptno into vdno from emp
    where ename=pname;
    select dname into vdname from dept
    where deptno = vdno;
    return vdname; -- 값을 반환한다. (이것이 function 특징)
    
    exception
    when no_data_found then
    dbms_output.put_line(pname || '사원은 없습니다.');
    return sqlerrm;
    when too_many_rows then
    dbms_output.put_line(pname || '사원 데이터가 2건 이상입니다.');
    return sqlerrm;

end;
/

var gname varchar2;
exec :gname :=get_dname('KING')
print gname