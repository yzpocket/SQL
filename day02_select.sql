-- day02_select.sql

select * from tab;

select * from emp;

select * from dept;

select * from salgrade;



select empno,ename, sal from emp;
select empno,ename, sal, sal+500 from emp;
select empno,ename, sal, sal+500 as SAL_UP from emp;
select empno,ename, sal, sal+500 as SAL_UP, comm from emp;
--1개라도 null값이 있어서 연산이 null로되버림
select empno,ename, sal, sal+500 as SAL_UP, sal*12+comm from emp;
--그래서이것을 사용

--NVL(n1,n2)  : n1이 null이면 n2를 대입
select empno,ename, sal, sal+500 as SAL_UP, sal*12+NVL(comm, 0) from emp;
--AS안쓰려면 " " 로 감싸거나 띄워쓰기 없이 그냥 생략 가능.
select empno,ename, sal, sal+500 as SAL_UP, sal*12+NVL(comm, 0) "1 year sal" from emp;

--NVL2(expr, n1, n2) : exprdㅣ null이 아닐경우 n1반환, null일 경우 n2반환
select empno,ename, mgr from emp;
select empno,ename, NVL2(mgr,'관리자 있음','관리자 없음') "관리자 여부" from emp;




--**문자열 결합 :  ||
select ename || ' is a ' || job as "EMPLYEE INFO" from emp;

--문제] EMP테이블에서 이름과 연봉을 "KING: 1 YEAR SALARY = 60000"	형식으로 출력하라.
select ename || ' : 1 Year Salary = ' || to_char(sal*12+nvl(comm,0)) as "이름과 연봉" from emp;
--nvl이 들어가면 to_char를 써서 오류 해결





--**중복행 제거 : DISTINCT
select job from emp;
select distinct job from emp;

--문제] 부서별로 담당하는 업무를 한번씩 (중복을제거해서) 출력하세요.
select deptno, job from emp order by deptno asc;
select distinct deptno, job from emp order by deptno asc;

select distinct name, job from member;
select unique name,job from member;
-- [문제]
--	 1] EMP테이블에서 중복되지 않는 부서번호를 출력하세요.
select distinct deptno from emp order by deptno;
--	 2] MEMBER테이블에서 회원의 이름과 나이 직업을 보여주세요.
select * from member;
select name, age, job from member;
--	 3] CATEGORY 테이블에 저장된 모든 내용을 보여주세요.
select * from category;
--	 4] MEMBER테이블에서 회원의 이름과 적립된 마일리지를 보여주되,
select name, mileage, mileage*13 as MILE_UP from member;
--	      마일리지에 13을 곱한 결과를 "MILE_UP"이라는 별칭으로 함께 보여주세요.


-- 특정 행 검색 - where절과 조건 사용해서 조건을 부여 할 수 있다.
--문제]emp에서 급여가 3000이상인 사원의 사번, 이름, 업무, 급여를 출력하세요.
select empno, ename, job, sal from emp where sal>=3000;


--문제]EMP테이블에서 담당업무가 MANAGER인 사원의
--정보를 사원번호,이름,업무,급여,부서번호로 출력하세요.
select * from emp;
select empno,ename,job,sal,deptno from emp where job = 'manager';
--값 (literal)은 대소문자를 구분한다.
select empno,ename,job,sal,deptno from emp where job = 'MANAGER';
select empno,ename,job,sal,deptno from emp where job = upper('manager');

--문제]EMP테이블에서 1982년 1월1일 이후에 입사한 사원의 
--사원번호,성명,업무,급여,입사일자를 출력하세요
select * from emp;
--literal의 포맷에 맞춰서 조건을 주면 잘 검색 된다. 대소문자나 특수문자 등등 표기 통일.
select empno, ename,job,sal,hiredate from emp where hiredate>'82/01/01';




#SQL연산자
- WHERE  조건절에서 자료를 검색할 때 조건을 달기 위해 사용하는 구문.

	1) =		: 같은가?	 WHERE name='홍길동'
	2)<		: 작은가?	WHERE age < 30
	3) <=	: 작거나 같은가
	4) >		: 큰가?
	5)>=		: 크거나 같은가?
	6)<>		: 같지 않은가?  != 과 같은 의미. 
			  where name <> '홍길동' -> 이름이 홍길동이 아닌 데이터
	7)!=		: 같지 않은가?  <>과 같은 의미.
	8)like	: 값의 일부를 이용하여 데이터의 정보와 일치하는지를 묻는 연산자.
			  where name like '%길%'  -> 이름 중 '길' 자를 포함된 
			  데이터가 있는지 검색.
	9) BETWEEN a AND b : a와 b 사이에 있는가(a,b값 포함)
				- 작은 값을 앞에 기술하고 큰 값을 뒤에 기술해야 함
	10) NOT BETWEEN a AND b : a와 b사이에 있지 않다.(a,b값 포함하지 않음) 
	11) IN (list) : list값 중 어느 하나와 일치하는가
	12) NOT IN (list) : list값과 일치하지 않는가.




--	[실습]
--	emp테이블에서 급여가 1300에서 1500사이의 사원의 이름,업무,급여,
--	부서번호를 출력하세요.
select * from emp;
select ename,job,sal,deptno from emp where sal between 1300 and 1500;
--이것과 아래는 같은 표현이다.
select ename,job,sal,deptno from emp where sal>=1300 and sal<=1500;
-- java의 &&가 AND라 보면 됨.

--	[실습]
--    emp테이블에서 사원번호가 7902,7788,7566인 사원의 사원번호,
--	이름,업무,급여,입사일자를 출력하세요.
select * from emp;
select ename, job, sal, hiredate from emp where empno in(7902,7788,7566) ;
--이것과 아래는 같은 표현이다.
select ename, job, sal, hiredate from emp where empno=7902 or empno=7788 or empno=7566 ;
-- java의 ||가 OR라 보면 됨

--[실습]
--	10번 부서가 아닌 사원의 이름,업무,부서번호를 출력하세요
select * from emp;
select ename, job, deptno from emp where deptno not in(10) order by deptno;


--[실습]
--emp테이블에서 업무가 SALESMAN 이거나 PRESIDENT인
--	사원의 사원번호,이름,업무,급여를 출력하세요.
select * from emp;
select empno,ename,job,sal from emp where job in(upper('salesman'),upper('president'));
select empno,ename,job,sal from emp where job = 'SALESMAN' or job= 'PRESIDENT';

--	커미션(COMM)이 300이거나 500이거나 1400인 사원정보를 출력하세요
select empno,ename,job,sal from emp where comm in(300,500,1400);
--	커미션이 300,500,1400이 아닌 사원의 정보를 출력하세요
select empno,ename,job,sal from emp where comm not in(300,500,1400);
--****커미션이 null인 사원의 정보를 출력하세요
select empno,ename,job,sal from emp where comm is null;
--****null값의 비교는 is null, is not null로 비교한다.





# LIKE연산자

	검색 문자열값에 대한 와일드 카드 검색을 위해 사용

	  where name like '%길%'  -> 이름 중 '길' 자를 포함된 데이터가 있는지 검색.
	'%'는 문자가 없거나 하나 이상의 문자를(0개 이상의 문자)
	'_'는 하나의 문자와 대치된다.(1개의 문자)

	- WHERE 컬럼명 LIKE '조건'
	- WHERE 컬럼명 LIKE '%조건'
	- WHERE 컬럼명 LIKE '조건%'
	- WHERE 컬럼명 LIKE '%조건%'
    
    
    
    
    --	실습] EMP테이블에서 이름이 S로 시작되는 사람의 정보를 보여주세요.
select * from emp where ename like'S%';
    --	실습] EMP테이블에서 이름이 S로 끝나는 사람의 정보를 보여주세요.
select * from emp where ename like'%S';
--	-이름 중 S자가 들어가는 사람의 정보를 보여주세요.
select * from emp where ename like '%S%';
--	- 이름의 두번 째에 O자가 들어가는 사람의 정보를 보여주세요.
select * from emp where ename like '_O%';

-- EMP테이블에서 입사일자가 82년도에 입사한 사원의 사번,이름,업무, 입사일자를 출력하세요.
select * from emp;
select empno,ename,job,hiredate from emp where hiredate like '82/%';
--세션 접속 중에만 날짜 포맷 변경하기. 실행 후 ->포맷에 맞춰서 조건 포맷도 바꿔야함.
alter session set nls_date_format='yyyy-mm-dd';
select empno,ename,job,hiredate from emp where hiredate like '%82-%';
alter session set nls_date_format='dd-mon-yy';
select empno,ename,job,hiredate from emp where hiredate like '%-82';
alter session set nls_date_format='yy/mm/dd';
select empno,ename,job,hiredate from emp where hiredate like '82/%';


-- member테이블에서 고객 테이블 가운데 성이 김씨인 사람의 정보를 보여주세요.
select * from member;
select * from member where name like '김%';
-- 고객 테이블 가운데 '강북' 포함된 정보를 보여주세요.
select * from member where addr like '%강북%';

-- 카테고리 테이블 가운데 category_code가 0000로 끝는 상품정보를 보여주세요.
select * from category;
select * from category where category_code like '%0000';
select * from products where category_fk like '%0000';







# 논리 연산자
	1) AND : 양쪽 조건이 TRUE이면 TRUE를 반환
	2) OR  : 양쪽 조건 중 하나라도 TRUE이면 TRUE반환
	3) NOT : 이후의 조건이 FALSE이면 TRUE를 반환.
    
    
--    [실습]
--	- EMP테이블에서 급여가 1100이상이고 JOB이 MANAGER인 사원의
--	사번,이름,업무,급여를 출력하세요.
select empno,ename,job,sal from emp where sal>=1100 and job='MANAGER';

--	- EMP테이블에서 급여가 1100이상이거나 JOB이 MANAGER인 사원의
--	사번,이름,업무,급여를 출력하세요.
select empno,ename,job,sal  from emp where sal>=1100 or job='MANAGER';

--    	- EMP테이블에서 JOB이 MANAGER,CLERK,ANALYST가 아닌
--	  사원의 사번,이름,업무,급여를 출력하세요.
select empno,ename,job,sal from emp where job <>'MANAGER' and job <>'CLERK' and job <>'ANALYST' ;
select empno,ename,job,sal from emp where job not in('MANAGER','CLERK','ANALYST') ;




--[문제]
--	- EMP테이블에서 급여가 1000이상 1500이하가 아닌 사원의 정보
select * from emp where sal not between 1000 and 1500;

--        - EMP테이블에서 이름에 'S'자가 들어가지 않은 사람의 이름을 모두
--	  출력하세요.
select * from emp where ename not like'%S%';

--	- 사원테이블에서 업무가 PRESIDENT이고 급여가 1500이상이거나
--	   업무가 SALESMAN인 사원의 사번,이름,업무,급여를 출력하세요.
select empno,ename,job,sal from emp where job in('PRESIDENT','SALESMAN') and sal>=1500;
--우선 연산순위 고려
select empno,ename,job,sal from emp where job= 'PRESIDENT' and sal>=1500 or job ='SALESMAN';
select empno,ename,job,sal from emp where job= 'PRESIDENT' and (sal>=1500 or job ='SALESMAN');





# ORDER BY 절

	- 자료를 정렬하여 나타낼 때 필요한 구문.
	- 오름차순 ASC
	- 내림차순 DESC 
	  두 가지 방식이 있다.
	- ORDER BY절을 사용할 때는 SELECT구문의 가장 마지막에 위치

	만약 사용자가 데이터가 나타나는 순서를 지정하지 않으면 
	기본적으로 데이터는 테이블에 입력되어 있는 순서대로 표시되지만, 
	같은 SELELCT문에 대하여 Oracle Server에서 처음의 검색결과와 다음의 
	검색결과를 항상 똑같이 보여주는 것은 아니다. 
	따라서 사용자가 검색한 데이터를 특정순서로 지정하여보고 싶으면 
	ORDER BY절을기술하여야 한다. 

	NULL값은 오름차순에서 제일 나중에, 내림차순에선 제일 먼저 옴


--1] 상품 테이블에서 판매 가격이 저렴한 순서대로 상품을 정렬해서 
--    보여주세요.
select * from products order by output_price asc;

--2] 고객 테이블의 정보를 이름의 가나다 순으로 정렬해서 보여주세요.
--      단, 이름이 같을 경우에는 나이가 많은 순서대로 보여주세요.
select * from member order by name asc, age desc;

--
--3] 상품 테이블에서 배송비의 내림차순으로 정렬하되, 
--	    같은 배송비가 있는 경우에는
--		마일리지의 내림차순으로 정렬하여 보여주세요.
select * from products order by trans_cost desc, mileage desc;
--
--4]사원테이블이서 입사일이 1981 2월20일 ~ 1981 5월1일 사이에
--	    입사한 사원의 이름,업무 입사일을 출력하되, 입사일 순으로 출력하세요.
select ename,job,hiredate from emp
where to_char(hiredate, 'yy/mm/dd') between '81/02/20' and '81/05/01';
--5] 사원테이블에서 부서번호가 10,20인 사원의 이름,부서번호,업무를 출력하되
--	    이름 순으로 정렬하시오.
select ename,deptno,job from emp where deptno in(10, 20) order by ename asc;



--6] 사원테이블에서 보너스가 급여보다 10%가 많은 사원의 이름,급여,보너스
--    를 출력하세요.

select ename, sal, comm from emp where comm>(sal*1.1) ;

--7] 사원테이블에서 업무가 CLERK이거나 ANALYST이고
--     급여가 1000,3000,5000이 아닌 모든 사원의 정보를 
select * from emp
where job in('CLERK','ANALYST') and sal not in (1000,3000,5000);

--8] 사원테이블에서 이름에 L이 두자가 있고 부서가 30이거나
--    또는 관리자가 7782번인 사원의 정보를 출력하세요.

select * from emp
where ename like '%LL%' and deptno = 30 or mgr =7782;

