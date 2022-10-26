1. ������ �Լ�
2. �׷��Լ�
3. ��Ÿ �Լ�

# ������ �Լ�
[1] ������ �Լ�
[2] ������ �Լ�
[3] ��¥�� �Լ�
[4] ��ȯ �Լ�
[5] �Ϲ� �Լ�

# [1] ������ �Լ�
select lower('HAPPY BIRTHDAY'), UPPER('Happy Birthday') FROM DUAL;

--select * from dual;
--1��1���� ���� ���� ���̺�
select 9*7 from dual;

# initcap(): ù���ڸ� �빮�ڷ� ��ȯ
select deptno, dname, initcap(dname), initcap(loc) from dept;

# concat(����1, ����2) : 2�� �̻��� ���ڸ� �������ش�.
select concat('abc','1234') from dual;

--[����] ��� ���̺��� SCOTT�� ���,�̸�,������(�ҹ��ڷ�),�μ���ȣ��
--		����ϼ���.
select empno, ename, lower(job), deptno
from emp where ename =upper('scott');
--	 ��ǰ ���̺��� �ǸŰ��� ȭ�鿡 ������ �� �ݾ��� ������ �Բ� 
--	 �ٿ��� ����ϼ���.
select products_name, output_price||'��', concat(output_price,'��') "�ǸŰ�"
from products;
--	 
--	 �����̺��� �� �̸��� ���̸� �ϳ��� �÷����� ����� ������� ȭ�鿡
--	       �����ּ���.
select concat(name, age) from member;

--# substr(����,i,len) : ���� i �ε����� ������ len ���� ���̸�ŭ�� ������ ��ȯ��
--i�� ����ϰ��: �տ������� �ε����� ã��
--�����ϰ�� : �ڿ������� ã��
select substr('ABCDEFG', 3, 4), SUBSTR('ABCDEFG',-3,2) FROM DUAL;
SELECT SUBSTR('991203-1012369', 8), SUBSTR('991203-1012369', -7) FROM DUAL;

--# LENGTH(����) : ���ڿ� ���� ��ȯ

SELECT LENGTH('991203-1012369') FROM DUAL;

--[����]
--	��� ���̺��� ù���ڰ� 'K'���� ũ�� 'Y'���� ���� �����
--	  ���,�̸�,����,�޿��� ����ϼ���. �� �̸������� �����ϼ���.
SELECT EMPNO, ENAME, JOB, SAL
FROM EMP
WHERE SUBSTR(ENAME,1,1) > 'K' AND SUBSTR(ENAME,1,1) <'Y';

--	������̺��� �μ��� 20���� ����� ���,�̸�,�̸��ڸ���,
--	�޿�,�޿��� �ڸ����� ����ϼ���.
SELECT EMPNO, ENAME, LENGTH(ENAME), SAL, LENGTH(SAL)
FROM EMP
WHERE DEPTNO=20;

--	������̺��� ����̸� �� 6�ڸ� �̻��� �����ϴ� ������̸��� 
--	�̸��ڸ����� �����ּ���.

SELECT ENAME, LENGTH(ENAME) FROM EMP
WHERE LENGTH(ENAME) >=6;

#LPAD/RPAD
--LPAD(�÷�,����1, ����2): ���ڰ��� ���ʺ��� ä���.
--RPAD(�÷�,����1, ����2): ���ڰ��� �����ʺ��� ä���.
SELECT ENAME, LPAD(ENAME,15,' '), SAL, LPAD(SAL,10,' ') FROM EMP
WHERE DEPTNO=10;

SELECT DNAME, RPAD(DNAME,15,'#') FROM DEPT;

#LTRIM/RTRIM
LTRIM(����1, ����2): ����1�� ���� ����2�� ���� �ܾ ������ 
                �� ���ڸ� ������ ���������� ��ȯ��
                
SELECT LTRIM('TTTHELLO TEST','T'), RTRIM('TTTHELLO TEST','T') FROM DUAL;
SELECT RTRIM(LTRIM('  HELLO ORACLE  ')) A FROM DUAL;

#REPLACE(�÷�, ����1, ����2): �÷����� ����1�� �ش��ϴ� ���ڸ� ����2�� ��ü�Ѵ�

SELECT REPLACE('ORACLE TEST','TEST','HI') FROM DUAL;

--������̺��� ������ �� ������ 'A'�� �����ϰ�
--�޿��� ������ 1�� �����Ͽ� ����ϼ���.
SELECT JOB, LTRIM(JOB,'A'),  SAL, LTRIM(SAL,1) FROM EMP;
--������̺��� 10�� �μ��� ����� ���� ������ �� ������'T'��
--	�����ϰ� �޿��� ������ 0�� �����Ͽ� ����ϼ���.
SELECT JOB, RTRIM(JOB,'T'), SAL, RTRIM(SAL,0) FROM EMP;

--������̺� JOB���� 'A'�� '$'�� �ٲپ� ����ϼ���.
SELECT JOB, REPLACE(JOB,'A','$') FROM EMP;

-- �� ���̺��� ������ �ش��ϴ� �÷����� ���� ������ �л��� ������ ���
--	 ���л����� ������ ��µǰ� �ϼ���.
SELECT JOB, REPLACE(JOB,'�л�','���л�') FROM MEMBER;

-- �� ���̺� �ּҿ��� ����ø� ����Ư���÷� �����ϼ���.
-- ==> UPDATE �� ����غ���
SELECT NAME,ADDR FROM MEMBER;

UPDATE MEMBER SET ADDR = REPLACE(ADDR,'�����','����Ư����'); 

ROLLBACK;

# [2] ������ �Լ�
# ROUND(��), ROUND(��,�ڸ���): �ݿø� �Լ�
�ڸ����� ����� �Ҽ��ڸ���, 
�ڸ����� ������ �����ڸ��� �ݿø��Ѵ�
SELECT ROUND(4567.567),ROUND(4567.567, 0), ROUND(4567.567, 2),
ROUND(4567.567, -2) FROM DUAL;

#TRUNC() : ������
SELECT FLOOR(4567.567),TRUNC(4567.567),TRUNC(4567.567,0),TRUNC(4567.567, 2),
TRUNC(4567.567,-2) FROM DUAL;

#MOD(��1, ��2) : ���������� ��ȯ
--�� ���̺��� ȸ���̸�, ���ϸ���,����, ���ϸ����� ���̷� �������� �ݿø��Ͽ� ����ϼ���
SELECT NAME, MILEAGE, AGE, MILEAGE/AGE,ROUND(MILEAGE/AGE, 1) FROM MEMBER;
--��ǰ ���̺��� ��ǰ ������� ��� �������� ���� ��ۺ� ���Ͽ� ����ϼ���.
SELECT PRODUCTS_NAME, TRANS_COST, TRUNC(TRANS_COST,-3) FROM PRODUCTS;
--������̺��� �μ���ȣ�� 10�� ����� �޿��� 	30���� ���� �������� ����ϼ���.
SELECT DEPTNO, ENAME, SAL, TRUNC(SAL/30), MOD(SAL,30) FROM EMP
WHERE DEPTNO=10;

# CHR(), ASCII()
SELECT CHR(65), ASCII('A') FROM DUAL;

# ABS(��): ���밪�� ���ϴ� �Լ�
SELECT NAME, AGE, AGE-40, ABS(AGE-40) FROM MEMBER;

#CEIL(��): �ø���
#FLOOR(��): ������

SELECT CEIL(123.001), FLOOR(123.001) FROM DUAL;

#POWER()
#SQRT()
#SIGN()
SELECT POWER(2,7), SQRT(64), SQRT(133) FROM DUAL;

SELECT AGE-40, SIGN(AGE-40) FROM MEMBER;

[3] ��¥�� �Լ�
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;
��¥ + ���� : �ϼ��� ��¥�� ����
SELECT SYSDATE +3 "3�� ��", SYSDATE -2 "��Ʋ��" FROM DUAL;

���� ����ð����� 2�ð� �� �ð��� ����غ�����

SELECT SYSTIMESTAMP, TO_CHAR(SYSTIMESTAMP + 2/24,'YY/MM/DD HH24:MI:SS') "�� �ð� ��" FROM DUAL;

--������̺��� ��������� �ٹ� �ϼ��� �� �� �����ΰ��� ����ϼ���.
--	�� �ٹ��ϼ��� ���� ��������� ����ϼ���.

select concat(round((sysdate-hiredate)/7),'��'),
concat(floor(mod(sysdate-hiredate,7)),'��') from emp;


SELECT HIREDATE, SYSDATE, TRUNC(SYSDATE-HIREDATE), 
TRUNC((SYSDATE-HIREDATE)/7) WEEKS, TRUNC(MOD((SYSDATE-HIREDATE),7)) DAYS FROM EMP;

# MONTHS_BETWEEN(DATE1, DATE2) :��¥1�� ��¥2 ������ ������ �����

SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('22-07-26','YY-MM-DD')) FROM EMP;

# ADD_MONTHS(DATE, N) : ���ڿ� N������ ����
SELECT ADD_MONTHS(SYSDATE, 2), ADD_MONTHS(SYSDATE,-2) FROM DUAL;

# LAST_DAY(D) : ���� ������ ��¥�� ��ȯ�� (���/���� �ڵ� �����)
SELECT LAST_DAY('22-02-01'), LAST_DAY('20-02-01'), LAST_DAY(SYSDATE) FROM DUAL;

-- �� ���̺��� �� ���� �Ⱓ�� ���� ���� ȸ���̶�� �����Ͽ� ������� ��������
-- ���� ȸ���� ���� ������ �����ּ���.

SELECT NAME, REG_DATE, ADD_MONTHS(REG_DATE, 2) "���� ������" FROM MEMBER;

SELECT SYSDATE FROM DUAL;
-- %Y-%M-%D
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL;

SELECT TO_CHAR(SYSDATE,'CC YEAR-MONTH-DDD DAY') FROM DUAL;

[4] ��ȯ �Լ�
TO_CHAR()
TO_DATE()
TO_NUMBER()

# TO_CHAR(��¥) : ��¥������ ���ڿ��� ��ȯ�Ѵ�
  TO_CHAR(����) : ���������� ���ڿ��� ��ȯ�Ѵ�
  
  TO_CHAR(D,�������) 
  SELECT TO_CHAR(SYSDATE), TO_CHAR(SYSDATE, 'YY-MM-DD HH12:MI:SS') FROM DUAL;

-- �����̺��� ������ڸ� 0000-00-00 �� ���·� ����ϼ���.
SELECT NAME,TO_CHAR(REG_DATE, 'YYYY-MM-DD') FROM MEMBER;
 --	 
--	 �����̺� �ִ� �� ���� �� ��Ͽ����� 2013���� 
--	 ���� ������ �����ּ���.
SELECT * FROM MEMBER WHERE TO_CHAR(REG_DATE,'YYYY')='2013';
	 
--	 �����̺� �ִ� �� ���� �� ������ڰ� 2013�� 5��1�Ϻ��� 
--	 ���� ������ ����ϼ���. 
--	 ��, ����� ������ ��, ���� ���̵��� �մϴ�.
SELECT NAME, TO_CHAR(REG_DATE,'YYYY-MM') FROM MEMBER 
WHERE TO_CHAR(REG_DATE,'YYYY-MM-DD')>'2013-05-01';

TO_CHAR(N, �������) : �������� ���ڿ��� ��ȯ

SELECT TO_CHAR(100000,'999,999'), TO_CHAR(100000,'$999G999') FROM DUAL;
--  ��ǰ ���̺��� ��ǰ�� ���� �ݾ��� ���� ǥ�� ������� ǥ���ϼ���.
--	  õ�ڸ� ���� , �� ǥ���մϴ�.
SELECT PRODUCTS_NAME, INPUT_PRICE, TO_CHAR(INPUT_PRICE,'999,999,999') "���ް���" FROM PRODUCTS;

--	  ��ǰ ���̺��� ��ǰ�� �ǸŰ��� ����ϵ� ��ȭ�� ǥ���� �� ����ϴ� �����
--	  ����Ͽ� ����ϼ���.[��: \10,000]
SELECT PRODUCTS_NAME,OUTPUT_PRICE, TO_CHAR(OUTPUT_PRICE,'L999G999G999') FROM PRODUCTS;

# TO_DATE(STR, �������): ���ڿ��� ��¥�������� ��ȯ�Ѵ�
SELECT TO_DATE('20221128', 'YYYYMMDD') +2 FROM DUAL;

SELECT * FROM MEMBER
WHERE REG_DATE > TO_DATE('20130601','YYYYMMDD');

# TO_NUMBER(STR,�������): ���ڿ��� ������������ ��ȯ�Ѵ�
SELECT TO_NUMBER('10,000','99,999') * 2 FROM DUAL;

--'$8,590' ==> ���ڷ� ��ȯ�غ�����

select to_number('$8,590','$999g999')+10 from dual;

SELECT TO_CHAR(-23,'999S'), TO_CHAR(-23,'99D99') FROM DUAL;

SELECT TO_CHAR(-23,'99.9'), TO_CHAR(-23,'99.99EEEE') FROM DUAL;


