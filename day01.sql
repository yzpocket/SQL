-- 단문주석
/* 복문 주석
    여러 줄 주석*/
    
-- SQL(Structured Query Language)
-- 학사관리 프로그램

--학생 Entity ==> Table(Relation)
--create table 테이블명(
--컬럼명1 자료형(크기) 제약조건,
--컬럼명 2 자료형(크기 ...,
--);

CREATE TABLE STUDENT(
    NO NUMBER(4) PRIMARY KEY, -- Unique, not null이여야 한다.
    NAME VARCHAR2(30) NOT NULL,
    TEL VARCHAR2(15) NOT NULL,
    ADDR VARCHAR2(100),
    INDATE DATE DEFAULT SYSDATE,
    SCLASS VARCHAR2(50),
    SROOM NUMBER(3)
);

DESC STUDENT;

SELECT * FROM STUDENT;


--INSERT INTO 테이블명(컬럼명1, 컬럼명2, ...)
--VALUES(값1, 값2,...);
--COMMIT;

INSERT INTO STUDENT(NO, NAME, TEL, ADDR,SCLASS,SROOM)
VALUES(1,'홍길동','010-1111','서울 마포구','자바반',101);

SELECT NO,NAME,TEL,SCLASS FROM STUDENT;

SELECT * FROM STUDENT;


INSERT INTO STUDENT(NO,NAME,TEL,ADDR)
--VALUES(1,'김철수','010-0202-0020','서울 강남구');  이건 primary key라 중복되서 안됨.
VALUES(2,'김철수','010-0202-0020','서울 강남구');  
COMMIT;

SELECT NO,NAME,TEL,SCLASS FROM STUDENT;

SELECT * FROM STUDENT;

INSERT INTO STUDENT
VALUES(3,'이영희','010-1010','서울 강동구',SYSDATE,'빅데이터반',201);

ROLLBACK;
SELECT * FROM STUDENT;

INSERT INTO STUDENT(NO,NAME,TEL,ADDR,INDATE,SCLASS,SROOM)
VALUES(4,'김아무','010-0101-0101','서울 강서구',SYSDATE,'자바반',101);

INSERT INTO STUDENT(NO,NAME,TEL,ADDR,INDATE,SCLASS,SROOM)
VALUES(5,'이땡땡','010-1231-0701','서울 중구',SYSDATE,'자바반',103);

INSERT INTO STUDENT(NO,NAME,TEL,ADDR,INDATE,SCLASS,SROOM)
VALUES(6,'소고고','010-5501-1101','경기 양주시',SYSDATE,'빅데이터반',201);

INSERT INTO STUDENT(NO,NAME,TEL,ADDR,INDATE,SCLASS,SROOM)
VALUES(7,'김추추','010-7701-6501','경기 수원시',SYSDATE,'빅데이터반',201);
--커밋해서 디비에 저장.
COMMIT;
--테이블 모든 데이터 보기..
SELECT * FROM STUDENT;


--특정 반만 보고 싶을때 WHERE 
SELECT * FROM STUDENT
WHERE SCLASS='자바반';

SELECT * FROM STUDENT
WHERE SCLASS='빅데이터반';

--반 이름을 오름차순으로 모든 데이터 보여줘. 
SELECT * FROM STUDENT ORDER BY SCLASS ASC;


--중복된 데이터가 너무 많이 쓰여진다.
--반명칭을 잘못쓰거나, 방번호를 잘못 입력하는 오류가 발생 할 수 있다.
-- ->이러면 정렬에서 빠지거나 오류가 생길 수도 있다.
-- 학생정보와 반정보 테이블을 분리해서 관리 할 필요가 있다.
-- 참조(링크,대명사)같은 개념으로 Foreign Key를 구현해야 한다.


--이 테이블을 삭제하자.
--DROP TABLE 테이블명

DROP TABLE STUDENT;


--아래 조건으로 학급 테이블을 다시 만들자.
--테이블명 : SCLASS
--학급번호 : SNO NUMBER
--학급명 : SNAME VARCHAR2(30
--교실번호 : SROOM NUMBER(3)

-- NUMBER = 숫자 데이터 타입 int 비슷한거.
-- VARCHAR2 = 텍스트 데이터 타입. string 비슷한거.
-- NOT NULL = 필수 입력 조건 거는것.
CREATE TABLE SCLASS(
SNO NUMBER(4) PRIMARY KEY,
SNAME VARCHAR2(30) NOT NULL,
SROOM NUMBER(3)
);

--DESC 생성된것 정보 확인하는것.
DESC SCLASS;

--학급 정보를 3개 INSERT 하기
--10 백엔드개발자반 101
--20 빅데이터반 201
--30 융복합반 301
INSERT INTO SCLASS(SNO,SNAME,SROOM)
VALUES(10,'백엔드개발자반',101);
INSERT INTO SCLASS --(~~)이거 안쓰는 경우 위 테이블에서 정의한 데이터 순서대로.
VALUES(20,'빅데이터반',201);
INSERT INTO SCLASS(SNAME,SROOM,SNO) --순서를 바꾼경우에도
VALUES('융복합반',301,30);

COMMIT;
SELECT * FROM SCLASS;

--UPDATE 테이블명 SET 컬러명=값
--WHERE 조건절

UPDATE SCLASS SET SNAME='백엔드개발자반';
--조건절 없이 해서 모든 SNAME이 백엔드개발자반으로 변경되버렸다. 커밋하기전에 롤백으로 북구해야 한다.
ROLLBACK;

--SNO가 10인 것만 딱 명칭을 변경하자.
UPDATE SCLASS SET SNAME='웹백엔드개발자반'
WHERE SNO=10;


/*
학생 테이블명: STUDENT
    학번:NO
    이름:NAME
    연락처:TEL
    주소:ADDR
    등록일:INDATE
    학급번호:SNO_FK
*/
CREATE TABLE STUDENT(
    NO NUMBER(4) PRIMARY KEY,
    NAME VARCHAR2(30) NOT NULL,
    TEL VARCHAR2(15) NOT NULL,
    ADDR VARCHAR2(100),
    INDATE DATE DEFAULT SYSDATE,
    SNO_FK NUMBER(4) REFERENCES SCLASS (SNO)  -- 외래키 참조 설정
);

DESC STUDENT;




--일련번호를 생성해주는 객체 : SEQUENCE라고 함. mysql엔 없음.
--CREATE SEQUENCE 시퀀스명
--START WITH 시작값
--INCREMENT BY 증가치
--NOCASHE; //메모리 버퍼에다가 20개정도 미리 준비하는데 정전되거나 하면 다음에 다시 날라가서 21번부터 시작되고 그런다. 그래서 이걸 사용 안하고자 함.
CREATE SEQUENCE STUDENT_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE;





INSERT INTO STUDENT(NO,NAME,TEL,ADDR,SNO_FK)
VALUES(STUDENT_SEQ.NEXTVAL,'홍길동','1111','서울 강남구 삼성동',10);

INSERT INTO STUDENT
VALUES(STUDENT_SEQ.NEXTVAL, '김철수','2222','서울 마포구 서교동',SYSDATE,20);

SELECT * FROM STUDENT;

--10번학급 2~3명 추가
--20번학급 2~3명
--30번학급 1명 추가

INSERT INTO STUDENT
VALUES(STUDENT_SEQ.NEXTVAL,'김아무','2233','서울 동대문구',SYSDATE,10);
INSERT INTO STUDENT
VALUES(STUDENT_SEQ.NEXTVAL,'이아무','3333','서울 동작구',SYSDATE,10);
INSERT INTO STUDENT(NO,NAME,TEL,ADDR,SNO_FK)
VALUES(STUDENT_SEQ.NEXTVAL,'세길동','3333','서울 서대문구동',10);
INSERT INTO STUDENT
VALUES(STUDENT_SEQ.NEXTVAL,'송송송','4443','경기 남양주시',SYSDATE,20);
INSERT INTO STUDENT
VALUES(STUDENT_SEQ.NEXTVAL,'초초이','5553','경기 양주군 ',SYSDATE,20);
INSERT INTO STUDENT
VALUES(STUDENT_SEQ.NEXTVAL,'홍홍이','5553','제주도 ',SYSDATE,30);


SELECT * FROM STUDENT;

SELECT * FROM STUDENT ORDER BY SNO_FK ASC;

COMMIT;




--삭제하는것
--DELETE FROM 테이블명
--WHERE 조건절;

DELETE FROM STUDENT; --조건 안달면 다사라짐 조심해야함.
DELETE FROM STUDENT WHERE NO=11;

ROLLBACK;

INSERT INTO STUDENT(NO,NAME,TEL,SNO_FK)
VALUES(STUDENT_SEQ.NEXTVAL,'이상해','1235',10);






--테이블 2개를 하나로 합쳐서 보여주자
SELECT * FROM SCLASS;
SELECT * FROM STUDENT;
--JOIN 문
--SELECT 테이블1.컬럼명1, ...,테이블2.컬럼명...
--FROM 테이블명1 JOIN 테이블명2
--ON 테이블1.PK = 테이블2.FK 

SELECT STUDENT.NO, NAME, TEL, SNAME, SROOM
FROM SCLASS JOIN STUDENT
ON SCLASS.SNO = STUDENT.SNO_FK ORDER BY SNAME ASC;

UPDATE SCLASS SET SROOM = 401 WHERE SNO=20;

COMMIT;



-- 학급별 인원수 알아보기
SELECT COUNT(*) FROM STUDENT;
SELECT SNO_FK, COUNT(*) FROM STUDENT
GROUP BY SNO_FK ORDER BY SNO_FK ASC;







---------------------------------
--테이블 조회 실습

--사원 테이블 전체를 보여 주세요
SELECT * FROM EMP;


--사원 테이블에서 사번, 사원명, 급여를 가져와 보여주세요
SELECT EMPNO,ENAME,SAL FROM EMP;


-- 위랑 같은데  원래 급여에서 500을 더해서 보여주세요
SELECT EMPNO,ENAME,SAL, SAL+500 FROM EMP;
-- SAL+500이 컬럼으로 추가되어 나타납니다.

-- SAL+500이란 컬럼 명칭을 다른 것으로 바꿔보여주세요.
SELECT EMPNO,ENAME,SAL, SAL+500 AS SAL_UP FROM EMP;
-- SAL+500이 컬럼 명칭이 SAL_UP이라고 변경 되어 나타납니다.


--사원 테이블에서 사번, 사원명, 급여, 보너스(COMM),담당업무(JOB)을 가져와 출력하세요
SELECT EMPNO,ENAME,SAL,COMM,JOB FROM EMP;

--연봉을 구해보자.
--연봉 = 월급여SAL * 12 + 보너스COMM
--사원 테이블에서 사번,사원명,급여,보너스,업무, 연봉도 출력하세요.
SELECT EMPNO,ENAME,SAL,COMM,JOB,(SAL*12)+COMM AS Yearly_SAL FROM EMP;
--이상하게 COMM이 null이면 연봉도 null로 나온다. 흠 
--1개라도 null이면 연산에서 모두 null로 바꿔버린다고 한다.
--NVL(컬럼명, 값1)으로 null일 경우 값1로 치환하는 함수.
SELECT EMPNO,ENAME,SAL,COMM,JOB,(SAL*12)+NVL(COMM, 0) "연봉" FROM EMP;
--이제 null값이 포함된 것은 0으로 바꿔서 연산이 제대로 된다. 대명사 명칭에 AS빼도 된다. 또한 한글로 하고 싶으면 "쌍따옴표"로 감싼다.

--**추가로 NVL2도 있다. 해보자.
--NVL2(컬럼명, 값1, 값2)
--컬럼값이 **null이 아닐 경우 값 1**을 반환, null 이면 값2를 반환.
SELECT EMPNO,ENAME,MGR,JOB FROM EMP;
--사원 테이블에서 관리자(MGR)이 있는경우에는 1, 없으면 0을 출력하세요. 자바의 3항연산자랑 비슷한 기능
SELECT EMPNO,ENAME,NVL2(MGR, 1, 0) AS MGR2,JOB FROM EMP;