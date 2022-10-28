#####테이블 생성과 제약조건 설정방법

#[1]테이블 생성 시 제약조건을 컬럼 수준에서 제약하는 방법
create table [스키마].테이블명(
    컬럼명 자료형 default 기본값 constraint 제약조건이름 제약조건유형
    컬럼명 ...
    ...
);
--생성 및 제약조건 설정 완료.
--스키마 : 다른계정
--[실습]
create table test_tab1(
    no number(2) constraint test_tab1_no_pk PRIMARY KEY,
    name varchar2(20)
);
desc test_tab1;


--데이터 사전에서 테이블 정보 (제약조건명도 나옴)조회
select *
from user_constraints where table_name='TEST_TAB1';


insert into test_tab1(no,name)
values(2,null);
select * from test_tab1;
commit;


#[2]테이블 생성 시 제약조건을 테이블 수준에서 제약하는 방법
create table test_tab2(
    no number(2),
    name varchar2(20),
    constraint test_tab2_no_pk PRIMARY KEY (no)
);
--생성 및 제약조건 설정완료
--데이터 사전에서 조회
select *
from user_constraints where table_name='TEST_TAB2';


##[3-1]제약조건의 삭제 방법
alter table 테이블명 drop constraint 제약조건명;
alter table 테이블명 drop constraint 제약조건명 cascade; --도 가능 cascade 모든 종속적인 제약조건이 함께 삭제된다.

--test_tab2의 pk제약조건을 삭제해보자
alter table TEST_TAB2 drop constraint TEST_TAB2_NO_PK;

##[3-2]제약조건을 추가
alter table 테이블명 add contraint 제약조건명 제약조건유형 (컬럼명);
--test_tab2에 다시 pk제약조건을 추가해보자
--alter table TEST_TAB2 add constraint test_tab2_no_pk primary key (NO);
ALTER TABLE TEST_TAB2 ADD CONSTRAINT TEST_TAB2_PK PRIMARY KEY (NO);

##[3-3]제약조건 명 변경
alter table 테이블명 rename constraint old명 to new명;
alter table test_tab2 rename constraint test_tab2_pk to test_tab2_no_pk;



#####Forein Key 제약조건 설정방법
부모테이블(master)의 pk를 자식테이블(detail)에서 fk로 참조
==>주의사항 
1)FK는 detail 테이블에서 정의해야 함.
2)master 테이블에 pk, uk로 정의된 컬럼을 fk로 지정 할 수 있다.
3)컬럼의 자료형이 일치해야 한다. 크기는 일치하지않아도 되지만 권장
4)on delete cascade 옵션을 주면 master 테이블의 레코드가 삭제 될 때 detail테이블의 레코드도 같이 삭제 된다.

create table dept_tab(
    deptno number(2),
    dname varchar2(15),
    loc varchar2(15),
    constraint dept_tab_deptno_pk primary key(deptno)
);
--master테이블 생성 완료

create table emp_tab(
    empno number(4),
    ename varchar2(20),
    job varchar2(10),
    mgr number(4) constraint emp_tab_mgr_fk references emp_tab(empno),
         --컬럼 수준에서 제약조건 설정

    hiredate date,
    sal number(7,2),
    comm number(7,2),
    deptno number(2),
         --테이블 수준에서 제약조건 설정

    constraint emp_tab_deptno_fk foreign key (deptno) references dept_tab(deptno),
    constraint emp_tab_empno_pk primary key (empno)
);
--detail 테이블 생성 완료




부서정보 insert하기
10 기획부 서울
20 인사부 인천
insert into dept_tab values(10,'기획부','서울');
insert into dept_tab values(20,'인사부','인천');
select * from dept_tab;
commit;

사원번호 insert하기
insert into emp_tab(empno,ename,job,mgr,deptno)
values(1000,'홍길동','기획',null,10);

insert into emp_tab(empno,ename,job,mgr,deptno)
values(1002,'이영희','인사',null,20);
select * from emp_tab;
commit;

insert into emp_tab(empno,ename,job,mgr,deptno)
values(1003,'김순희','노무',null,20);

insert into emp_tab(empno,ename,job,mgr,deptno)
values(1004,'김길동','재무',null,20);

select * from emp_tab;
commit;


dept_tab에서 기획부를 삭제해보기
delete from dept_tab where deptno=10;
-- 자식 레코드가 있을 경우에는 부모 테이블의 레코드를 삭제 할 수 없다.

홍길동을 20번 부서로 이동하세요
update emp_tab set deptno=20 where ename='홍길동';
select * from emp_tab;

delete from dept_tab where deptno=10;
-- 자식 레코드를 없엔(홍길동은 10에서 20으로 이동됨. 이후 삭제 할 수 있다.
select * from dept_tab;
--deptno 10인 기획부가 사라졌다.



--########### 실습 게시판 과 댓글 작성 게시판 생성, pk생성 fk연결 
부모테이블
board_tab 생성
no number(8) pk
title varchar2(100),
content varchar2(1000),
wdate date 기본값 sysdate

자식테이블
reply_tab 생성
rno number(8) pk
content varchar2(300)
userid varchar2(20) not null,
no_fk number(8) fk로 주되 on delecte cascade 옵션 기술하기.
--------

create table board_tab(
    no number(8),
    userid varchar2(20) constraint board_tab_userid_nn not null,
    title varchar2(100),
    content varchar2(1000),
    wdate date default sysdate,
    constraint  board_tab_no_pk primary key(no)
);
--master테이블 생성 완료

create table reply_tab(
    rno number(8),
    content varchar2(300),
    userid varchar2(20) constraint reply_tab_userid_nn not null,
         --컬럼 수준에서 제약조건 설정
    no_fk number(8),
         --테이블 수준에서 제약조건 설정
    constraint reply_tab_rno_pk primary key (rno),
    constraint reply_tab_no_fk foreign key (no_fk) references board_tab(no) on delete cascade
);
--detail 테이블 생성 완료

select * from board_tab;
select * from reply_tab;

--데이터 사전에서 조회
select * from user_constraints where table_name='BOARD_TAB';
select * from user_constraints where table_name='REPLY_TAB';

게시판 글작성
insert into board_tab values(1,'kii',' 반가워요','안녕',sysdate);
insert into board_tab values(2,'choi','저도 반가워요','안녕2',sysdate);
select * from board_tab;

댓글 작성
insert into reply_tab values(1,'댓글1','Lee',2);
insert into reply_tab values(2,'댓글2','Lee',2);
insert into reply_tab values(3,'하이','kim',1);
select * from reply_tab;
commit;

board_tab과reply_tab을 join해서 같이 출력하세요
--[신형식] 표준 **
select b.no, b.title, b.userid, r.content, r.userid
from board_tab b join reply_tab r
on b.no = r.no_fk;

2번글 삭제해보자(on delete cascade된것)
delete from board_tab where no=2;
--위에 출력해보면 댓글까지 삭제되었다.부모글을 삭제하면 자식글까지 함께 삭제되었다 (on delete cascade옵션을 주었기 때문)






###########
---

#UNIQUE KEY

컬럼 수준에서 제약하는법.
create table uni_tab1(
    deptno number(2) constraint uni_tab1_deptno_uk unique,
    dname char(20),
    loc char(10)
);
데이터 사전에서 조회해보기 = uk는 U로 표기되어있음
select * from user_constraints where table_name='UNI_TAB1';

insert into uni_tab1 values(10,'영업부','서울');
select * from uni_tab1;
insert into uni_tab1 values(10,'영업부','서울');
한번더 입력하면 unique 위반이 뜸. 
insert into uni_tab1 values(null,'영업부','서울');
select * from uni_tab1;
null값이 허용되는 것. null값은 중복되서 들어가지만 값이 입력되면 그것은 유일해야 한다.
insert into uni_tab1 values(null,'기획부','경기');
select * from uni_tab1;
commit;

테이블수준에서 제약하는법으로 해보자
create table uni_tab2(
    deptno number(2),
    dname char(20),
    loc char(10),
    constraint uni_tab2_deptno_uk unique(deptno)
);
데이터 사전에서 조회해보기 = uk는 U로 표기되어있음
select * from user_constraints where table_name='UNI_TAB2';





#NOT NULL 제약조건 - 체크 제약조건의 일종
 -- NOT NULL은 컬럼 수준에서만 제약 할 수 있다.
create table nn_tab(
    deptno number(2) constraint nn_tab_deptno_nn not null,
    dname char(20) not null, --이렇게 해도됨.
    loc char(10)
--    constraint loc_nn not null(loc) 테이블 수준에서 안되는것 확인(o)
);
데이터 사전에서 조회해보기 = nn는 C로 표기되어있음serch_condition탭에 비면 안된다는 조건이 써져있음.
select * from user_constraints where table_name='NN_TAB';




#CHECK 제약조건
-- 행이 만족해야 하는 조건을 정의한다 check() 괄호 안에..
-- 컬럼 수준에서 제약조건 주기.
create table ck_tab(
    deptno number(2) constraint ck_tab_deptno_ck check(deptno in(10,20,30,40)),
    dname char(20)
);
데이터 사전에서 조회해보기 = ck는 C로 표기되어있음, serch_condition탭에 조건이 써져있음.
select * from user_constraints where table_name='CK_TAB';
insert into ck_tab values(50,'BAA'); -- 체크 제약조건에 만족하지않아 안된다.


-- 테이블 수준에서 제약조건 주기.
create table ck_tab2(
    deptno number(2),
    dname char(20),
    loc char(10),
    constraint ck_tab2_deptno_pk primary key (deptno),
    constraint ck_tab2_loc_ck check(loc in ('서울', '수원'))
);
데이터 사전에서 조회해보기 = ck는 C로 표기되어있음, serch_condition탭에 조건이 써져있음.
select * from user_constraints where table_name='CK_TAB2';





--실습 day_04 pdf참조.
zipcode테이블 만들기 [부모-MASTER테이블]
제약조건(주문사항)
1. ADDR 컬럼은 컬럼수준에서 NOT NULL 제약조건을 주되 제약조건이름을
명시하여 주자.
2. PRIMARY KEY제약조건은 (POST1과 POST2)를 합한 복합키로 주되
테이블 수준에서 제약조건이름을 명시하여 주자.

create table zipcode(
    post1 char(3),
    post2 char(3),
    addr varchar(60) constraint zipcode_addr_nn not null,
    constraint zipcode_post_pk primary key (post1,post2)
);

데이터 사전에서 조회해보기
select * from user_constraints where table_name='ZIPCODE';


MEMBER_TAB 테이블 만들기 [자식테이블]
제약조건(주문사항)
1. 회원의 성별 값은 ‘F’이나 ‘M’값만 들어가도록
2. 주민번호 앞자리 뒷자리를 합쳐 유일한 값이 되도록(UNIQUE)
3. 회원 ID는 PRIMARY KEY로
4. POST1과 POST2는 ZIPCODE테이블의 POST1,POST2를 참조하는 참조키 제
약조건을 준다.
create table member_tab(
    id number(4,0),
    name varchar2(10) constraint member_tab_name_nn not null,
    gender char(1),
    jumin1 char(6),
    jumin2 char(7),
    tel varchar2(15),
    post1 char(3),
    post2 char(3),
    addr varchar2(60),
    constraint member_tab_id_pk primary key (id),
    constraint member_tab_gender_ck check(gender in('F', 'M')),
    constraint member_tab_jumin_uk unique(jumin1, jumin2),
    constraint member_tab_post_fk foreign key (post1,post2) references zipcode(post1,post2)
);



-------------



#SUBQUERY를 이용한 테이블 생성
CREATE TABLE table_name [colum1[,column2,...]] AS subquery ...

사원 테이블에서 30번 부서에 근무하는 사원의 정보만 추출하여
EMP_30 테이블을 생성하여라. 단 열은 사번,이름,업무,입사일자, 급여,보너스를 포함한다.
select * from emp;
empno
ename
job
hiredate
sal
comm
deptno 30 only

create table EMP_30(eno, ename, job, hdate, sal, comm)
as select empno, ename, job, hiredate, sal, comm from emp where deptno=30;

select * from emp_30;
select * from emp where deptno=30;


[문제1]
		EMP테이블에서 부서별로 인원수,평균 급여, 급여의 합, 최소 급여,
		최대 급여를 포함하는 EMP_DEPTNO 테이블을 생성하라.
select * from emp;
create table emp_deptno(count, avgsal, sumsal, minsal, maxsal)
as select count(empno) count, round(avg(sal)) avgsal, sum(sal) sumsal, min(sal) minsal, max(sal) maxsal
from emp group by deptno;

select * from emp_deptno;
	[문제2]	EMP테이블에서 사번,이름,업무,입사일자,부서번호만 포함하는
		EMP_TEMP 테이블을 생성하는데 자료는 포함하지 않고 구조만
		생성하여라
        
create table emp_temp
as select empno,ename,job,hiredate,deptno
from emp where 1=2;

select * from emp_temp;



####DDL
--CREATE, DROP, ALTER, RENAME, TRUNCATE
create table temp(
    no number(4)
);
drop table temp;
desc temp;
## 컬럼을  추가 / 변경 / 삭제
--alter table 테이블명 add 추가할컬럼정보 [default 값]
--alter table 테이블명 modify 변경할컬럼정보
--alter table test rename column no to num --컬럼명 변경
-- ALTER TABLE 테이블명 DROP (column 삭제할 컬럼명)


--##추가하기 실습
-- temp 테이블에 name 컬럼을 추가하세요
-- temp 테이블에 indate 컬럼을 추가, 기본값을 sysdate 추가하세요
alter table temp add name varchar2(20) not null;
alter table temp add indate date default sysdate;

products 테이블에 prod_desc 컬럼을 추가하되 not null 제약조건을 주세요.
select * from products;
alter table products add prod_desc varchar2(1000);
select * from products;

--##수정하기 실습
temp테이블의 no 컬럼의 자료형을 char(4)로 수정하세요
alter table temp modify no char(4);
desc temp;

temp테이블의 no 컬럼명을 num으로 변경하세요
alter table temp rename column no to num;

--##삭제하기 실습
temlp테이블의 indate 컬럼을 삭제하세요.
alter table temp drop column indate;

products 테이블에 prod_desc 컬럼을 삭제
alter table products drop column prod_desc;
desc products;


temp 테이블에 num 컬럼에 pk 제약조건 추가
alter table temp add constraint temp_num_pk primary key(num);
desc temp;
select * from user_constraints where table_name='TEMP';

insert into temp values(1,'aaa');
delete from temp;

select * from temp;

###제약조건 비활성화 해보기
alter table 테이블명 disable constraint 제약조건명
-- temp의 pk제약조건을 비활성화 시키세요;
alter table temp disable constraint temp_num_pk;
select * from user_constraints where table_name='TEMP';
--status에 diabled로 바뀜.


###제약조건 활성화 해보기
alter table 테이블명 enable constraint 제약조건명
temp의 pk제약조건을 다시활성화 시키세요;
alter table temp enable constraint temp_num_pk;
--status에 enabled로 바뀜.
