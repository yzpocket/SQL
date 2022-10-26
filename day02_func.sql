1. 단일행 함수
2. 그룹함수
3. 기타 함수

# 단일행 함수
[1] 문자형 함수
[2] 숫자형 함수
[3] 날짜형 함수
[4] 변환 함수
[5] 일반 함수


-------

##[1] 문자형 함수

#lower() 소문자
#upper() 대문자
select lower('HAPPY BIRTHDAY'), upper('Happy Birthday') from dual;

--select * from dual;
--1행 1열을 갖는 더미 테이블 마치 로그확인처럼 테스트 확인하려고 하는것.
select 9*7 from dual;


#initcap() : 첫문자만 대문자로 변환해주는 함수.
select deptno, dname, initcap(dname), loc, initcap(loc) from dept;


#concat(변수1,변수2) : 2개 이상의 문자를 결합해준다.
select concat('abc','1234') from dual;
select 'abc'+'1234' from dual; -- 안되서 concat을 써야함.

--[문제] 사원 테이블에서 SCOTT의 사번,이름,담당업무(소문자로),부서번호를
--		출력하세요.
select * from emp;
select empno,ename,lower(job),deptno from emp where ename = upper('scott');

--	 상품 테이블에서 판매가를 화면에 보여줄 때 금액의 단위를 함께 
--	 붙여서 출력하세요.
select products_name, concat(output_price,'원') "판매가" from products;

--	 고객테이블에서 고객 이름과 나이를 하나의 컬럼으로 만들어 결과값을 화면에
--	       보여주세요.
select concat(name,age) from member;



#substr(변수,i,length) : 문자 i 인덱스로 시작한 length 문자 길이 만큼의 변수를 반환함.
i가 양수일 경우 : 앞에서부터 인덱스를 찾음
i가 음수일 경우 : 뒤에서부터 찾음.
select substr('ABCDEFG',3,4) , substr('ABCDEFG',-3,2) from dual;
select substr('991010-10101012',8) from dual;
select substr('991010-10101012',-8) from dual;

#length(변수) : 문자열의 길이 반환

select length('938291-1029311') from dual;



[문제]
	사원 테이블에서 첫글자가 'K'보다 크고 'Y'보다 작은 사원의
	  사번,이름,업무,급여를 출력하세요. 단 이름순으로 정렬하세요.

select * from emp
where substr(ename,1,1)  > 'K' and substr(ename,1,1) <'Y';

	사원테이블에서 부서가 20번인 사원의 사번,이름,이름자릿수,
	급여,급여의 자릿수를 출력하세요.
	
	select empno,ename,length(ename),sal,length(sal)
    from emp
    where deptno=20;
	사원테이블의 사원이름 중 6자리 이상을 차지하는 사원의이름과 
	이름자릿수를 보여주세요.
    

#LPAD / RPAD
    lpad(컬럼, 변수1, 변수2) : 문자값을 왼쪽부터 채운다.
    rpad(컬럼, 변수1, 변수2) : 문자값을 오른쪽부터 채운다.
select ename, lpad(ename,15,'  '),sal,lpad(sal,10,'*') from emp
where deptno=10;

select rpad(dname,15,'#')from dept;



#LTRIM/RTRIM
LTRIM(변수1, 변수2) : 변수1의 값 중 변수2와 같은 단어가 있으면 그 문자를 삭제한 나머지 값을 반환함.

select LTRIM('TTTHELLO TESTTTT','T'), RTRIM('HHHHELLO TESTH','H')from dual;
select rtrim(ltrim('    hello oracle   '))  from dual;


#REPLACE(컬럼, 변수1,변수2) : 변수1을 변수2로 변경.
select replace('oracle test','test','hi')from dual;

사원테이블에서 담당업무 중 좌측에 'A'를 삭제하고
급여중 좌측의 1을 삭제하여 출력하세요.
select * from emp;
select ltrim(job,'A'), ltrim(sal,'1') from emp;
사원테이블에서 10번 부서의 사원에 대해 담당업무 중 우측에'T'를
	삭제하고 급여중 우측의 0을 삭제하여 출력하세요.
select rtrim(job,'T'), rtrim(sal, 0) from emp;
사원테이블 JOB에서 'A'를 '$'로 바꾸어 출력하세요.
select replace(job,'A','$') from emp;


고객 테이블의 직업에 해당하는 컬럼에서 직업 정보가 학생인 정보를 모두
	 대학생으로 변경해 출력되게 하세요.
select replace(job,'학생','대학생') job from member;

 고객 테이블 주소에서 서울시를 서울특별시로 수정하세요.
 select name,addr from member;
 select replace(addr,'서울시','서울특별시') 주소 from member;
 
 update member set addr = replace(addr,'서울시','서울특별시');
 
 
 #[2] 숫자형 함수
 #ROUND(값), ROUND(값,자리수) : 반올림 함수
 select round(4567.567), round(4567.567,0), round(45667.567,2), round(4567.567,-2) from dual;
 
 #TRUNC() : 절삭함 버림. 
 	- TRUNC(값) 또는 TRUNC(X,Y) : 버림을 담당하는 함수. 	  ROUND함수와 사용방법은 같다. 



#CEIL(값): 올림 함수	
	SELECT CEIL(123.12) FROM DUAL;
#FLOOR(값): 내림 함수
	SELECT FLOOR(123.12) FROM DUAL;
 # MOD
	- MOD(값1, 값2) : 나머지 값을 돌려주는 함수
 
 	사원테이블에서 부서번호가 10인 사원의 급여를 
	30으로 나눈 나머지를 출력하세요.
    	SELECT SAL, MOD(SAL,30) FROM EMP WHERE DEPTNO=10

#ABS(값)
	 :선택된 값의 절대값을 보여주는 함수. 
	   음수값이 있는 컬럼 값을 양수로 나타내고자 할 때 사용.
	  select name, age, age-40, abs(age-40) from member;
      
      
      
      
      # 날짜 함수
오러클은 세기,년,월,일,시,분,초를 내부 숫자(7BYTE)형식으로
날짜를 지정한다.

-날짜 연산
	--------------------------------------------------
	연산				결과		설명
	--------------------------------------------------
	1) DATE + NUMBER 	DATE		일수를 날짜에 더함
	2) DATE - NUMBER 	DATE		일수를 날짜에 뺌
	3) DATE - DATE						일수	
	4) DATE + NUMBER/24   	DATE		시간을 날자에 더함
	--------------------------------------------------
	[실습]
	사원테이블에서 현재까지의 근무 일수가 몇 주 몇일인가를 출력하세요.
	단 근무일수가 많은 사람순으로 출려하세요.
	
	먼저) DATE- DATE를 하면 일수가 나온다.
	SELECT HIREDATE,SYSDATE,(SYSDATE-HIREDATE) FROM EMP;

	SELECT ENAME,SYSDATE,HIREDATE,SYSDATE-HIREDATE "TOTAY DAYS",
	TRUNC((SYSDATE-HIREDATE)/7) WEEKS, 
	ROUND(MOD((SYSDATE-HIREDATE),7)) DAYS 
	FROM EMP
	ORDER BY SYSDATE-HIREDATE DESC;



	--------------------------------------------------
	함수				사용목적
	--------------------------------------------------
	MONTHS_BETWEEN	        두 날짜사이의 월수를 계산
	ADD_MONTHS		월을 날짜에 더함
	LAST_DAY		월의 마지막 날을 구함
	SYSDATE			오러클이 설치되어 있는 서버의 
					현재 날짜와 시간을 반환
	--------------------------------------------------
    
    
    
    MONTHS_BETWEEN	
	- 날짜와 날짜 사이의 월수를 계산한다.
	- MONTHS_BETWEEN(DATE1,DATE2)
	- 결과는 음수 또는 양수가 될 수 있다.
	- 결과의 정수 부분은 월을, 소수 부분은 일을 나타낸다.

	SELECT MONTHS_BETWEEN(SYSDATE,HIREDATE) FROM EMP;


ADD_MONTHS
	- 정해진 컬럼이나 날짜형 변수에 원하는 개월을 더하고자 할 때 사용
	- ADD_MONTHS(D,X)
	- 결과값: 날짜 D에 X월 만큼 더한 날짜를 리턴한다. 여기서 X는 정수이고,
	   만약 결과값의 월이 D
	   의 월보다 날짜 수가 적다면 결과값의 월의 마지막 일이 리턴된다.

	  select add_months('08/09/11',2) from dual;==>08/11/11
	  SELECT ADD_MONTHS('08/11/11',2) FROM DUAL ==> 09/01/11
	  _
	 select add_months('08/01/31',1) from dual;==>08/02/29
	 select add_months(sysdate,-1) from dual;

	 select hiredate,add_months(hiredate,-10) from emp

	  고객 테이블이 두 달의 기간을 가진 유료 회원이라는 가정하에 등록일을 기준으로
	   유료 회원인 고객의 정보를 보여주세요.
	   select name, reg_date, add_months(reg_date,2) as expire from member;

LAST_DAY
	- 월의 마지막 날짜를 구할 대 사용하는 함수(윤년,평년은 자동으로 계산함)
	   일정 관리 프로그램이나 다이어리 등을 만들 때 1월 ~12월까지의 마지막 일자를 
	   LAST_DAY 함수를 이용하여 구하면 쉽게 달력프로그램을 만들 수 있다.
	- LAST_DAY(D)
	- 결과값: D가 포한되어 있는 월의 마지막 날짜 값을 리턴
	 select last_day('03/12/11') from dual==>03/12/31

	 사원테이블에서 입사한 달의 근무일수를 계산하여 출력하되,
	 토요일과 일요일도 근무일수에 포함하는 것으로 하자.

	select ename, hiredate, last_day(hiredate) last,
	last_day(hiredate)-hiredate days from emp
	order by days desc;
	

--SYSDATE
--	- 현재 시간을 DATE타입으로 출력하는 함수.
--	- SYSDATE
--	- 결과값: 현재 로컬 데이터베이스의 날짜와 시간값을 리턴한다.
	select to_char(sysdate,'yyyy-mm-dd hh:mi:ss') from dual;
	select to_char(sysdate,'cc year-month-ddd day') from dual

	 -cc, scc : 세기
	 -yyyy, year, yyy, yy : 연도
	 -iyyy, iy, i : ISO 년을 의미
	 -month,mon, mm: 월
	 -ww, w : 주
	 -ddd, dd: 일 [ddd->1년의 날짜, dd->1개월의 날짜, d->1주일의 날짜]
	 -hh, hh24, hh12: 시간
	 -day, dy, d: 그주의 시작 일자
	 -mi : 분
	 -ss : 초

3. 변환함수

TO_CHAR(날짜)
	- 문자가 아닌 자료형의 값을 문자형으로 변환시키는 함수
	- TO_CHAR(날짜) 함수는 DATE타입을 문자로 바꾼다.
	- TO_CHAR(D, 출력형식)
	- 결과값: DATE형인 D를 출력형식에 맞는 VARCHAR2 로 변환하여 리턴.
	      출력형식이 없을 경우에는 기본이 되는 날짜형을 문자형으로 변환하여 리턴.

	  select to_char(sysdate) from dual;
	  select to_char(sysdate,'yyyy-mm-dd hh12:mi:ss') from dual;

	 고객테이블의 등록일자를 0000-00-00 의 형태로 출력하세요.
	 select name, to_char(reg_date,'yyyy-mm-dd') from member;
	 
	 고객테이블에 있는 고객 정보 중 등록연도가 2003년인 
	 고객의 정보를 보여주세요.
	 select userid,name,age, job, to_char(reg_date,'yyyy-mm-dd') as d 
	 from member where to_char(reg_date,'yyyy') = '2003';

	 고객테이블에 있는 고객 정보 중 등록일자가 2003년 5월1일보다 
	 늦은 정보를 출력하세요. 
	 단, 고객등록 정보는 년, 월만 보이도록 합니다.
	 select userid,name,age, job, to_char(reg_date,'yyyy-mm-dd') as d 
	 from member where reg_date >='2003-05-01';

 

TO_DATE
	- TO_CHAR(날짜)와 상반된 기능을 갖는다. 즉, 문자 데이터를 강제로 
	   날짜형 데이터로 변환시키는 것.
	   TO_CHAR(날짜)는 출력을 위해 사용하는 함수이며, 
	   TO_DATE 는
	   프로그램 내부에서 날짜를 계산하거나 비교하기 위해 
	   날짜형 데이터로 변환하는데 사용되는 함수이다.
	- TO_DATE(변수, 출력형식)
	- 결과값: CHAR나 VARCHAR2 형식의 변수를 날짜형 데이터
			DATE로 변환하여 값을 리턴
	      만일 출력형식이 없다면 세션의 기본 날짜 출력형식을 사용해야 한다.

	 68] select to_date('20080601','yyyymmdd') as d from dual;
	 69] select sysdate - to_date('20080601','YYYYMMDD') from dual;
	 ...sysdate와 문자값을 - 연산할 수 없으므로 Date타입으로 변경하여 연산하는 예제.
	 70] 고객테이블의 고객 정보 중 등록일자가 2003년 6월1일 이후 등록한 고객의 정보를
	      보여 주세요.
	 select name,reg_date from member
	 where reg_date > to_date('20030601','YYYYMMDD')

TO_CHAR(숫자)
	- TO_CHAR(X, 출력형식)
	- 결과값: 숫자형인 X를 오른쪽의 출력 형식에 맞는 varchar2로 
		     변환하여 리턴.
	 71] select to_char(10000,'99,999') from dual;
	 72] select to_char(10000,'$99G999') from dual==> $10,000
	 ...G는 지정된 위치에서 그룹 구분 문자를 리턴한다.