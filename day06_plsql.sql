--day06_plsql.sql

set serveroutput on --이걸 해줘야 dbms_output이 활성화된다. 접속시마다.


/*
#######[1]프로시저 익명 블럭########
-선언부
-실행부
-예외처리부
-end;
-/
*/
declare
    --선언부에서는 변수 선언을 할 수 있다.
    --변수명 자료유형;
    i_msg varchar2(100);
begin
    --실행부에는 sql문 또는 pl/sql문이 올 수 있다.
    --오라클 대입연산자는 =가아니라 :=다.
    i_msg := 'HELLO ORACLE';
    --syso같은것.
    dbms_output.put_line(i_msg);
end;
/


--#######[2]이름을 갖는 프로시저########
create or replace procedure print_time
is
    --선언부
    vtime1 timestamp;
    vtime2 timestamp;
begin
    --실행부
    --날짜 + 숫자 : 일수를 더함      |    날짜+숫자/24 : 시간을 더함
    --문자 결합 연산자 sql에선 ||
    select systimestamp - 1/24 into vtime1 from dual;
    select systimestamp + 2/24 into vtime2 from dual;
    dbms_output.put_line('한 시간 전: ' || vtime1);
    dbms_output.put_line('두 시간 후: ' || vtime2);
end;
/

--위 컴파일된 프로시저 실행 방법
execute print_time;

select systimestamp from dual;


--#######[2]이름을 갖는 프로시저 2 ########

--###  %TYPE : REFERENCE 타입, 테이블명.컬럼명%TYPE

--사번을 인파라미터로 전달하면 해당 사원의
--사번, 이름, 부서명, 담당업무를 가져와
--출력하는 프로시저를 작성해봅시다.

create or replace procedure emp_info(pno in number)
is
    vno number(4); -- 스칼라 타입
    vname emp.ename%type; --%로 타입 참조하는방법. emp 테이블의 ename컬럼과 같은 자료유형으로 참조 하겠다는 의미
    vdname dept.dname%type;
    vjob emp.job%type;
    vdno emp.deptno%type;
begin
-- select into로 가져온 데이터 변수에 할당하기
    select ename, job, deptno into vname, vjob, vdno
    from emp where empno=pno;
    select dname into vdname from dept
    where deptno=vdno;
-- dbms로 출력하기.
    dbms_output.put_line('---'||pno||'번 사원 정보---');
    dbms_output.put_line('사 원 명: '||vname);
    dbms_output.put_line('담당업무: '||vjob);
    dbms_output.put_line('부 서 명: '||vdname);
    
exception
    when no_data_found then
    dbms_output.put_line(pno||'번 사원은 존재하지 않아요.');
end;
/

execute emp_info(1234);



--### %ROWTYPE : COMPOSITE 타입, 테이블명%ROWTYPE : 테이블의 행과 같은 타입을 사용하겠다.

부서번호를 인파라미터로 주면
해당 부서의 부서명과 근무지를 출력하는 프로시저를 작성합시다

create or replace procedure rtype(pdno in dept.deptno%type)
is
vdept dept%rowtype;

begin
select dname, loc into vdept.dname, vdept.loc
from dept where deptno=pdno;

    dbms_output.put_line('부서번호: '||pdno);
    dbms_output.put_line('부 서 명: '||vdept.dname);
    dbms_output.put_line('부서위치: '||vdept.loc);
exception
    when no_data_found then
    dbms_output.put_line(pdno||'번 부서는 없습니다.');
end;
/

execute rtype(50);


--### TABLE TYPE : COMPOSITE 타입 (복합데이터 타입) => 배열과 비슷함
TABLE타입에 접근하기 위한 인덱스가 있는데 BINARY_INTEGER 데이터형의 인덱스를 이용 할 수 있다
--	-구문
--	TYPE table_type_name IS TABLE OF
--	{column_type | variable%TYPE| table.column%TYPE} [NOT NULL]
--	[INDEX BY BINARY_INTEGER];
--	identifier table_type_name;
--
--	table_type_name : 테이블형의 이름
--	column_type	     : 스칼라 데이터형
--	identifier	     : 전체 pl/sql 테이블을 나타내는 식별자의 이름


사원들의 업무 정보를 담을 테이블 타입의 변수를 선언하고
사원들의 업무 정보를 저장하기
반복문으로 업무 정보 출력하기.

create or replace procedure table_type(pdno in emp.deptno%type)
is
    --테이블 선언(마치 배열같은것이다)
    type ename_table is table of emp.ename%type
    index by binary_integer; --"정수형의 인덱스를 쓰겟다."
     --테이블 선언2(마치 배열같은것이다)
    type job_table is table of emp.job%type
    index by binary_integer;
    --변수선언
    ename_tab ename_table;
    --job변수도 추가
    job_tab job_table;
    
    i binary_integer :=0; 
begin
    --반복문 돌면서
    for k in (select ename, job from emp where deptno=pdno) loop
        i := i+1;
        --테이블 변수에 가져온 값들을 저장하자.
        ename_tab(i) :=k.ename;
        --job도 저장 추가
        job_tab(i) :=k.job;
    end loop;
    
    --반복문 돌면서 테이블 타입에 저장된 값을 출력하자.
    for j in 1..i loop --1~i라는 뜻
        dbms_output.put_line(ename_tab(j) || ' : ' || job_tab(j)); --job출력도 추가.
    end loop;
end;
/
execute table_type(30);





--### RECORD TYPE => C의 구조체, JAVA의 클래스와 비슷함

상품번호를 입력하면 해당상품의 상품명, 판매가, 제조사를 출력하는 프로시저를 작성하세요
--여기부터 end까지 드래그해서 실행
accept pnum prompt '조회할 상품번호를 입력하세요'
--pnum 을 사용할 때는 &pnum 변수 선언할때 number타입을 잊지않도록.

declare
    --java클래스 선언하듯이 record 자료유형 선언.
    type prod_record_type is record(
        vpname products.products_name%type,
        vprice products.output_price%type,
        vcomp products.company%type
    );
    --record 타입의 변수 선언
    prod_rec prod_record_type;
    vpnum number := &pnum;
begin
    --실행부에는 sql문 또는 pl/sql문이 올 수 있다.
    select products_name, output_price, company
    into prod_rec --위정보를 prod_rec에 담는다.
    from products
    where pnum=vpnum; --창입력번호랑, 넘버랑 같은것을.
    --syso같은것.
    dbms_output.put_line(vpnum||'번 상품 정보 ----');
    dbms_output.put_line('상품명: '|| prod_rec.vpname);--레코드.컬럼명 으로 내보낸다.
    dbms_output.put_line('제조사: '|| prod_rec.vcomp);
    dbms_output.put_line('가   격: '|| ltrim( to_char(prod_rec.vprice,'999,999,999'))||'원');
end;
/



--###  NON-PL/SQL변수 = 바인드 변수

--프로시저 내부에서 바인드 변수를 참조하려면
--바인드 변수 앞에 콜론(:)을 참조 접두어로 기술한다.
variable myvar number

declare
begin
:myvar :=700;
end;
/
print myvar



--### 프로시져 파라미터의 종류 
--[1] IN 파라미터
--[2] OUT 파라미터
--[3] IN OUT 파라미터


--### --[1] IN 파라미터

--MEMO테이블에 새로운 레코드를 INSERT하는 프로시저를 작성하세요
--작성자와 메모내용은 IN 파라미터로 받습니다.
프로시저명 : MEMO_ADD

create or replace procedure memo_add(pname in varchar2 default '아무개', pmsg in memo.msg%type)
is
begin
    insert into memo(idx,name,msg,wdate)
    values(memo_seq.nextval,pname,pmsg,sysdate);
    commit;
end;
/

exec memo_add('홍길동','프로시저로 글을 쓰고 저장해봅니다.');
exec memo_add(pmsg=>'안녕');
select * from memo order by idx desc;


--### --[2] OUT 파라미터
-- OUT 파라미터를 받으려면 바인드변수가 필요함.
사번을 인 파라미터로 전달하면 해당 사원의 이름을 아웃 파라미터로
내보내는 프로시저를 작성하세요

create or replace procedure emp_find(pno in emp.empno%type, oname out emp.ename%type)
is
begin
    select ename into oname
    from emp
    where empno=pno;
end;
/
실행방법:
바인드 변수 선언
프로시저를 실행 할 때 바인드 변수를 아웃파라미터의 매개변수로 전달.
바인드 변수값을 출력.
var gname varchar2(20);
exec emp_find(7788, :gname);
print gname;



부서번호를 인파라미터로 받고 급여 인상률도 인파라미터로 받아서
emp테이블의 특정 부서 직원들의 급여를 인상해주는 프로시저를 작성하세요.
해당 부서의 평균 급여를 아웃파라미터로 전달하는 프로시저
create or replace procedure sal_up
(dno in dept.deptno%type, upsal in number, avgsal out number)
is
begin
    update emp set sal = sal * upsal where deptno = dno;
    
    select avg(sal) into avgsal
    from emp
    group by deptno
    having deptno = dno;
end;
/

var avgsal number;
exec sal_up(10,1.1,:avgsal);

print avgsal;


MEMO_EDIT 프로시저를 작성하세요
인파라미터 3개 받아서(글번호, 작성자, 메시지)
UPDATE문을 수행하는 프로시저
select * from memo;
create or replace procedure memo_edit
(midx in memo.idx%type, mname in memo.name%type, mmsg in memo.msg%type)
is
begin
    update memo set msg = mmsg where idx = midx;

end;
/

exec memo_edit(3,'홍홍서','프로시저로 수정된 메시지');

print avgsal;