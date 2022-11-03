DROP INDEX PK_MEMBER;

/* 회원 */
DROP TABLE MEMBER 
	CASCADE CONSTRAINTS;

/* 회원 */
CREATE TABLE MEMBER (
	idx NUMBER(8) NOT NULL, /* 회원번호 */
	name VARCHAR2(30) NOT NULL, /* 이름 */
	userid VARCHAR2(20) NOT NULL, /* 아이디 */
	pwd VARCHAR2(16) NOT NULL, /* 비밀번호 */
	hp1 CHAR(3) NOT NULL, /* 연락처1 */
	hp2 CHAR(4) NOT NULL, /* 연락처2 */
	hp3 CHAR(4) NOT NULL, /* 연락처3 */
	post CHAR(5), /* 우편번호 */
	addr1 VARCHAR2(100), /* 주소1 */
	addr2 VARCHAR2(100), /* 주소2 */
	indate DATE, /* 가입일 */
	milage NUMBER(8), /* 적립금 */
	status NUMBER(2) /* 회원상태 */
);

COMMENT ON TABLE MEMBER IS '회원';

COMMENT ON COLUMN MEMBER.idx IS '회원번호';

COMMENT ON COLUMN MEMBER.name IS '이름';

COMMENT ON COLUMN MEMBER.userid IS '아이디';

COMMENT ON COLUMN MEMBER.pwd IS '비밀번호';

COMMENT ON COLUMN MEMBER.hp1 IS '연락처1';

COMMENT ON COLUMN MEMBER.hp2 IS '연락처2';

COMMENT ON COLUMN MEMBER.hp3 IS '연락처3';

COMMENT ON COLUMN MEMBER.post IS '우편번호';

COMMENT ON COLUMN MEMBER.addr1 IS '주소1';

COMMENT ON COLUMN MEMBER.addr2 IS '주소2';

COMMENT ON COLUMN MEMBER.indate IS '가입일';

COMMENT ON COLUMN MEMBER.milage IS '적립금';

COMMENT ON COLUMN MEMBER.status IS '회원상태';

CREATE UNIQUE INDEX PK_MEMBER
	ON MEMBER (
		idx ASC
	);

ALTER TABLE MEMBER
	ADD
		CONSTRAINT PK_MEMBER
		PRIMARY KEY (
			idx
		);
        
        
        
select * from member;