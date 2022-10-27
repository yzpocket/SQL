#SUBQUERY : 
- 가이드라인 
	* 서브쿼리는 괄호로 묶어야 한다.
	* 두 종류의 비교연산자들이 서브쿼리에 사용된다.
		=,>,>=, <,ㅡ=,<>,!=
		IN, NOT IN, ANY
	* 서브쿼리는 연산자의 오른쪽에 나타나야 한다.
	* 서브쿼리는 많은 SQL명령에서 사용가능하다.
	* 서브쿼리는 ORDER BY 절을 포함할 수 없다. 

- 사원테이블에서 scott의 급여보다 많은 사원의 사원번호,이름,업무
	급여를 출력하세요.
    
select * from emp;
select sal
from emp
where ename=upper('scott');

select empno, ename, job, sal 
from emp
where sal>3000;
    
select empno, ename, job, sal 
from emp
where sal > (select sal from emp where ename=upper('scott'));

#단일행을 반환하는 서브 쿼리
문제2]사원테이블에서 급여의 평균보다 적은 사원의 사번,이름	업무,급여,부서번호를 출력하세요.
select *from emp;
select empno, ename, job, sal, deptno
from emp
where sal <(select avg(sal) from emp);

사원테이블에서 사원의 급여가 20번 부서의 최소급여
		보다 많은 부서를 출력하세요.
--select deptno
--from emp
--where (select sal from emp) <(select min(sal) from emp where deptno=20);

select deptno, min(sal)
from emp
group by deptno
having min(sal)> (select min(sal) from emp where deptno=20);

#IN
- 업무별로 최대 급여를 받는 사원의 
	 사원번호와 이름을 출력하세요.
select * from emp;
select empno, ename, sal from emp
where (job,sal)
in(
select job, max(sal)
from emp
group by job
) order by 1;

#ANY
select sal,deptno from emp order by deptno asc;
SELECT ename, sal 
FROM emp 
WHERE deptno <> 20 AND sal > ANY(SELECT sal FROM emp WHERE job='SALESMAN'); 
          --***   ANY() 는 다중 OR라고 보면 된다.  
위 문장은
전체 SAL과 업무가 'SALESMAN'인  각행의 사원  SAL와 비교하여
그 중 하나라도 큰 것이 만족하면서 (OR, OR, OR, .... true가 1개라도 있으면 true 논리합.)
부서번호가 20번이 아닌 사원의 이름과 급여를 출력하란 의미다.

#ALL
SELECT ename, sal 
FROM emp 
WHERE deptno != 20
AND sal > ALL(SELECT sal FROM emp WHERE job='SALESMAN'); 
즉 업무가 'SALESMAN'인 각 행의 사원 SAL과 비교하여
모두 만족해야됨(결과적으로 최대 급여까지 만족해야됨)보다
	많으면서 부서번호가 20번이 아닌 사원의 이름과 급여를 출력하란 의미
    
    
    
#EXISTS : EXISTS 연산자를 사용하면 서브쿼리의 데이터가 존재하는가의 
	   여부를 먼저 따져 존재하는 값들만을 결과로 반환해 준다. 
       
       --관리자 정보를 가져와 보여주세요
select empno, ename, sal from emp e
where exists(select empno from emp where e.empno = mgr);


#다중열 서브쿼리
부서별로 최소급여를 받는 사원의 사번,이름,급여,부서번호를 출력하세요
select * from emp;
select empno, ename, sal, deptno
from emp
where (deptno, sal) in
(select deptno, min(sal)
from emp
group by deptno);


84] 고객 테이블에 있는 고객 정보 중 마일리지가 
	가장 높은 금액의 고객 정보를 보여주세요.
	
select * from member;
select * 
from member
where mileage= (select max(mileage) from member);
	85] 상품 테이블에 있는 전체 상품 정보 중 상품의 판매가격이 
	    판매가격의 평균보다 큰  상품의 목록을 보여주세요. 
	    단, 평균을 구할 때와 결과를 보여줄 때의 판매 가격이
	    50만원을 넘어가는 상품은 제외시키세요.
	    
select * from products;
select *
from products
where output_price > 
(select avg(output_price)
from products where output_price<=500000)
and output_price <=500000;
	86] 상품 테이블에 있는 판매가격에서 평균가격 이상의 상품 목록을 구하되 평균을
	    구할 때 판매가격이 최대인 상품을 제외하고 평균을 구하세요.
        
select * from products
where output_price >=
(select avg(output_price) from products where output_price <>(select max(output_price)from products));


87] 상품 카테고리 테이블에서 카테고리 이름에 컴퓨터라는 단어가 포함된 카테고리에
	    속하는 상품 목록을 보여주세요.
	
select * from products;
select * from category;

select * from products
where category_fk in (select category_code from category where category_name like'%컴퓨터%');

	88] 고객 테이블에 있는 고객정보 중 직업의 종류별로 가장 나이가 많은 사람의 정보를
	    화면에 보여주세요.
        select * from member
        where (job, age) in
        (
        select job, max(age) from member
        group by job
        );
        
        
        
        * UPDATE에서의 사용
        --UPDATE  테이블명 set 컬럼명 = 값 ... where 조건~~;

	89] 고객 테이블에 있는 고객 정보 중 마일리지가 가장 높은 금액을
	     가지는 고객에게 보너스 마일리지 5000점을 더 주는 SQL을 작성하세요.
	
select * from member;
update member set mileage=mileage+5000 where mileage = (select max(mileage) from member);
rollback;
select * from member
where mileage = (select max(mileage) from member);
	90] 고객 테이블에서 마일리지가 없는 고객의 등록일자를 고객 테이블의 
	      등록일자 중 가장 뒤에 등록한 날짜에 속하는 값으로 수정하세요.
          
select * from member order by reg_date desc;
update member set reg_date = (select max(reg_date) from member) 
where mileage = 0;
rollback;


* DELETE에서의 사용
	91] 상품 테이블에 있는 상품 정보 중 공급가가 가장 큰 상품은 삭제 시키는 
	      SQL문을 작성하세요.
--DELECT from 테이블명 where 조건절;	      
select * from products;
select max(input_price)
from products;
delete from products where input_price=(select max(input_price)
from products);
rollback;
	92] 상품 테이블에서 상품 목록을 공급 업체별로 정리한 뒤,
	     각 공급업체별로 최소 판매 가격을 가진 상품을 삭제하세요.
delete from products where(ep_code_fk, output_price) in(select ep_code_fk, min(output_price) from products group by ep_code_fk);
         roll back;
         
#INSERT 에서 SUBQUERY 사용
CATEGORY 테이블을 카피해서 CATEGORY_COPY로 만들되 데이터는 없이 구조만 복사하세요
그런 뒤 CATEGORY 테이블에서 전자제품 군만 가져와서 CATEGORY_COPY에 INSERT하세요
drop table category_copy;
create table category_copy
as select * from category where 1=2;
--거짓 조건으로 폼만 복사하는 방법.
select * from category_copy;

select * from category;
select category_name
from category
where category_name = '0001%';
insert into category_copy select * from category where category_code like '0001%';
select * from category_copy;

EMP에서 EMP_COPY 테이블로 구조만 복사하기         
급여등급이 3등급에 속하는 사원정보들만 EMP_COPY에 INSERT하세요
create table emp_copy as select * from emp where 1=2;
select * from emp_copy;
select * from emp;
select * from salgrade;
insert into emp_copy
select e.* from emp e join salgrade s 
on e. sal between s.losal and s.hisal and s.grade=3;
roll back;
commit;


#FROM 절에서의 서브 쿼리 ===> INLINE VIEW 
--VIEW = 가상의 창.

EMP와 DEPT 테이블에서 업무가 MANAGER인 사원의 이름, 업무,부서명,
	근무지를 출력하세요.
    -- join으로 구현하면 아래와 같다.
select ename, job, dname, loc
from emp e join dept d
using(deptno)
where job='MANAGER';
-- subquery로 구현하면
select a.ename, job, dname, loc from 
(select * from emp where job='MANAGER') a join dept d
on a.deptno = d.deptno;




#RANK() OVER() 함수 : 랭킹을 매겨주는 함수
select ename, sal from emp
order by sal desc;

select * from (
select rank() over(order by sal desc) rnk, emp.* from emp
)
where rnk<=5;



#ROW_NUMBER() OVER() : 행번호를 매겨주는 함수
order by로 정렬된 것 "에" 행번호를 매겨야 한다.
select * from (
select rownum rn, a.* from
(select * from emp order by hiredate desc) a
)
where rn<=5;

select * from(
select row_number() Over(order by hiredate desc) rn, emp.*
from emp) where rn<=5;