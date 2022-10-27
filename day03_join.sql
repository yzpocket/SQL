-- day03_join.sql


select * from dept;
select * from emp;
--[구형식]
부서 테이블과 사원 테이블을 조인해보자.
select d.deptno, d.dname, e.deptno, e.ename, job, sal
from dept d, emp e
where d.deptno = e.deptno;
--select 쪽에서 조인했는데 양쪽에 같이 있는(PK,FK)를 가진 컬럼명은 출처를 정확해 dept.dpeptno 처럼 써줘야 한다. 생략하면 오류.
-- from 에서 dept 를 d 로 명명해줘서 나머지 d.으로 써줘도 된다.

--[신형식] 표준 **
select d.*, e.*
from dept d join emp e
on d.deptno = e.deptno;



SALESMAN의 (emp에 있음)사원번호,이름,급여,(dept에 있음)부서명,근무지를 출력하여라.
select * from emp;
select * from dept;

select e.empno,e.ename,e.sal, dname, loc
from emp e, dept d
where e.job = 'SALESMAN' and e.deptno=d.deptno;

select empno, ename, sal, job, dname, loc
from emp e join dept d
on e.deptno=d.deptno
where e.job='SALESMAN';

서로 연관이 있는 카테고리 테이블과 상품 테이블을 이용하여 각 상품별로 카테고리
  이름과 상품 이름을 함께 보여주세요.
          select * from products;
          select * from category;
          select products_name, category_name
          from category c join products p
          on c.category_code=p.category_fk;
          
카테고리 테이블과 상품 테이블을 조인하여 화면에 출력하되 상품의 정보 중
제조업체가 삼성인 상품의 정보만 추출하여 카테고리 이름과 상품이름, 상품가격
제조사 등의 정보를 화면에 보여주세요.
select category_name, products_name, output_price, company
from category c join products p
on c.category_code = p.category_fk and p.company='삼성';
각 상품별로 카테고리 및 상품명, 가격을 출력하세요. 단 카테고리가 'TV'인 것은 
제외하고 나머지 정보는 상품의 가격이 저렴한 순으로 정렬하세요
select category_name, products_name, output_price
from category c join products p
on c.category_name <> 'TV' and c.category_code = p.category_fk order by 3;


select d.dname, e.ename
from dept d join emp e
using(deptno);

# NON-EQUIJOIN
조인 조건이 EQUAL(=)이 아닌 다른 연산기호로 만들어지는 경우

emp와 salgrade를 조인 할 경우
emp의 sal ==> salgrade의 losal ~hisal 사이에 있음
select * from salgrade;

select empno, ename, sal, grade, losal, hisal
from emp e join salgrade s
on e.sal between s.losal and s.hisal;


--[실습]
97] 공급업체 테이블과 상품 테이블을 조인하여 공급업체 이름, 상품명,
		공급가를 표시하되 상품의 공급가가 100000원 이상의 상품 정보
		만 표시하세요. 단, 여기서는 공급업체A와 공급업체B가 모두 표시
		되도록 해야 합니다.
        
select * from supply_comp;
select * from products;

select sc.ep_name, p.products_name, p.input_price
from supply_comp sc join products p
on (sc.ep_name='공급업체A' or sc.ep_name='공급업체B' )and p.input_price > 100000;

#CARTESIAN PRODUCT : 되는데로 모두 나와버리는것.. 조인 조건을 잘해야 한다.
select d.*, e.*
from dept d, emp e;

select d.*, e.*
from dept d, emp e
where d.deptno=e.deptno;
-- deptno 40번이 있는데 안보인다. 값이 없어서. 이럴때 사용하는것이
#OUTER JOIN : (+)EQUAL 조건에 만족하지 않는 데이터가 있더라도 NULL로 설정하여 출력해줌.
--*(구방식)
select d.deptno, dname, ename, job
from dept d, emp e
where d.deptno = e.deptno (+) order by 1 asc;
--*(명시적 조인절 일 경우) 신방식
[1]LEFT OUTER JOIN : 왼쪽 테이블을 기준으로 출력
[2]RIGHT OUTER JOIN: 오른쪽 테이블을 기준으로 출력
[3]FULL OUTER JOIN: 양쪽 테이블을 기준으로 출력
select * from dept;
--[1]LEFT OUTER JOIN
select distinct(e.deptno), d.deptno
from dept d left outer join emp e
on d.deptno=e.deptno order by 2 asc;

--[2]RIGHT OUTER JOIIN
select distinct(e.deptno), d.deptno
from dept d right outer join emp e
on d.deptno=e.deptno order by 2 asc;

--[3]FULL OUTER JOIN
select distinct(e.deptno), d.deptno
from dept d full outer join emp e
on d.deptno=e.deptno order by 2 asc;

문제98] products상품테이블의 모든 상품을 공급업체supply_comp, 공급업체코드, 상품이름, 
          상품공급가, 상품 판매가 순서로 출력하되 공급업체가 없는
          상품도 출력하세요(상품을 기준으로).
select * from products;          
select * from supply_comp;          
select s.ep_name, s.ep_code, p.products_name, p.input_price, p.output_price
from supply_comp s right outer join products p
on s.ep_code=p.ep_code_fk order by ep_code asc; 

	문제99] 상품테이블의 모든 상품을 공급업체, 카테고리명, 상품명, 상품판매가
		순서로 출력하세요. 단, 공급업체나 상품 카테고리가 없는 상품도
		출력합니다.
select *from products;
select * from category;
select * from supply_comp;          
3개의 조인
select s.ep_name, c.category_name, output_price
from products p
left outer join category c 
on p.category_fk=c.category_code 
left outer join supply_comp s
on p.ep_code_fk=s.ep_code;


#SELF JOIN
각 사원의 정보를 출력하되 사원들의 관리자 이름도 함께 보여주세요

select * from emp;
select e.empno, e.ename, m.empno, m.ename "MANAGER"
from emp e join emp m
on e.mgr = m.empno;

[문제] emp테이블에서 "누구의 관리자는 누구이다"는 내용을 출력하세요.
select e.empno, e.ename, m.empno, m.ename "MANAGER", e.ename||'의 관리자는'||m.ename||'입니다.'
from emp e join emp m
on e.mgr = m.empno;



#SET OPERATOR
- 종류
	---------------------------------------------------------------
	종류		:	설명
	---------------------------------------------------------------
	UNION		:각 결과의 합(합집합: 중복되는 값은 한번 출력)
	---------------------------------------------------------------
	UNION ALL	:각 결과의 합(합집합)
	---------------------------------------------------------------
	INTERSECT	:각 결과의 중복되는 부분만 출력(교집합)
	---------------------------------------------------------------
	MINUS		: 첫번째 결과에서 두번째 결과를 뺌(차집합)
	---------------------------------------------------------------
#UNION : 합집합
select deptno from dept union
select deptno from emp;

#UNION ALL : 합집합
select deptno from dept union all
select deptno from emp;

#INTERSECT : 교집합
select deptno from dept intersect
select deptno from emp;

#MINUS : 교집합
select deptno from dept minus
select deptno from emp;


1. emp테이블에서 모든 사원에 대한 이름,부서번호,부서명을 출력하는 
   문장을 작성하세요.
select * from emp;
select * from dept;
select emp.ename, emp.deptno, dept.dname
from emp join dept
on emp.deptno=dept.deptno;

2. emp테이블에서 NEW YORK에서 근무하고 있는 사원에 대하여 이름,업무,급여,
    부서명을 출력하는 SELECT문을 작성하세요.
select ename, job, sal, dname, loc
from emp e join dept d
on e.deptno = d.deptno and d.loc='NEW YORK';

3. EMP테이블에서 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력하는
    SELECT문을 작성하세요.
    
select ename, dname, loc, comm
from dept d join emp e
on d.deptno = e.deptno and comm is not null; 



5. 아래의 결과를 출력하는 문장을 작성하에요(관리자가 없는 King을 포함하여
	모든 사원을 출력)

	---------------------------------------------
	Emplyee		Emp#		Manager	Mgr#
	---------------------------------------------
	KING		    7839
	BLAKE		7698		KING		7839
	CKARK		7782		KING		7839
	.....
	---------------------------------------------
    
    select * from emp;
    select e.ename as Emplyee, e.empno as "Emp#", m.ename as Manager, m.empno as "Mgr#"
    from emp e left outer join emp m
    on e.mgr=m.empno
    order by 3 desc;
    
    select e.ename as Emplyee, e.empno as "Emp#", m.ename as Manager, m.empno as "Mgr#"
    from emp e, emp m
    where e.mgr = m.empno(+)
    order by 3 desc;