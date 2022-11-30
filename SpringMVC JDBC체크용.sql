grant all on memo to multi;
grant all on memo_seq to multi;
select * from scott.memo;




-- eXerd 에서 클래스 다이어그램 우클릭 - 특성 - DDL 로 아래와같이 DB를 구성 할 수 있음

---상위 카테고리 DDL 복붙


DROP INDEX PK_UPCATEGORY;

/* 상위카테고리 */
DROP TABLE UPCATEGORY 
	CASCADE CONSTRAINTS;

/* 상위카테고리 */
CREATE TABLE UPCATEGORY (
	UPCG_CODE NUMBER(8) NOT NULL, /* 상위카테고리코드 */
	UPCG_NAME VARCHAR2(30) NOT NULL /* 상위카테고리명 */
);

COMMENT ON TABLE UPCATEGORY IS '상위카테고리';

COMMENT ON COLUMN UPCATEGORY.UPCG_CODE IS '상위카테고리코드';

COMMENT ON COLUMN UPCATEGORY.UPCG_NAME IS '상위카테고리명';

CREATE UNIQUE INDEX PK_UPCATEGORY
	ON UPCATEGORY (
		UPCG_CODE ASC
	);

ALTER TABLE UPCATEGORY
	ADD
		CONSTRAINT PK_UPCATEGORY
		PRIMARY KEY (
			UPCG_CODE
		);
        

        
--하위 카테고리 복붙-----------------------------------------------------------------
DROP INDEX PK_DOWNCATEGORY;

/* 하위카테고리 */
DROP TABLE DOWNCATEGORY 
	CASCADE CONSTRAINTS;

/* 하위카테고리 */
CREATE TABLE DOWNCATEGORY (
	UPCG_CODE NUMBER(8) NOT NULL, /* 상위카테고리코드 */
	DOWNCG_CODE NUMBER(8) NOT NULL, /* 하위카테고리코드 */
	DOWNCG_NAME VARCHAR2(30) NOT NULL /* 하위카테고리명 */
);

COMMENT ON TABLE DOWNCATEGORY IS '하위카테고리';

COMMENT ON COLUMN DOWNCATEGORY.UPCG_CODE IS '상위카테고리코드';

COMMENT ON COLUMN DOWNCATEGORY.DOWNCG_CODE IS '하위카테고리코드';

COMMENT ON COLUMN DOWNCATEGORY.DOWNCG_NAME IS '하위카테고리명';

CREATE UNIQUE INDEX PK_DOWNCATEGORY
	ON DOWNCATEGORY (
		UPCG_CODE ASC,
		DOWNCG_CODE ASC
	);

ALTER TABLE DOWNCATEGORY
	ADD
		CONSTRAINT PK_DOWNCATEGORY
		PRIMARY KEY (
			UPCG_CODE,
			DOWNCG_CODE
		);

ALTER TABLE DOWNCATEGORY
	ADD
		CONSTRAINT FK_UPCATEGORY_TO_DOWNCATEGORY
		FOREIGN KEY (
			UPCG_CODE
		)
		REFERENCES UPCATEGORY (
			UPCG_CODE
		);
        
        
        
-- Product DB 테이블 생성 -------------------------------------------------

DROP INDEX PK_PRODUCT;

/* 상품 */
DROP TABLE PRODUCT 
	CASCADE CONSTRAINTS;

/* 상품 */
CREATE TABLE PRODUCT (
	PNUM NUMBER(8) NOT NULL, /* 상품번호 */
	DOWNCG_CODE NUMBER(8), /* 하위카테고리코드 */
	UPCG_CODE NUMBER(8), /* 상위카테고리코드 */
	PNAME VARCHAR2(50) NOT NULL, /* 상품명 */
	PIMAGE1 VARCHAR2(50), /* 이미지1 */
	PIMAGE2 VARCHAR2(50), /* 이미지2 */
	PIMAGE3 VARCHAR2(50), /* 이미지3 */
	PRICE NUMBER(8) NOT NULL, /* 상품정가 */
	SALEPRICE NUMBER(8), /* 상품판매가 */
	PQTY NUMBER(8), /* 상품수량 */
	POINT NUMBER(8), /* 포인트 */
	PSPEC VARCHAR2(20), /* 스펙 */
	PCONTENTS VARCHAR2(1000), /* 상품설명 */
	PCOMPANY VARCHAR2(50), /* 제조사 */
	PINDATE DATE /* 등록일 */
);

COMMENT ON TABLE PRODUCT IS '상품';

COMMENT ON COLUMN PRODUCT.PNUM IS '상품번호';

COMMENT ON COLUMN PRODUCT.DOWNCG_CODE IS '하위카테고리코드';

COMMENT ON COLUMN PRODUCT.UPCG_CODE IS '상위카테고리코드';

COMMENT ON COLUMN PRODUCT.PNAME IS '상품명';

COMMENT ON COLUMN PRODUCT.PIMAGE1 IS '이미지1';

COMMENT ON COLUMN PRODUCT.PIMAGE2 IS '이미지2';

COMMENT ON COLUMN PRODUCT.PIMAGE3 IS '이미지3';

COMMENT ON COLUMN PRODUCT.PRICE IS '상품정가';

COMMENT ON COLUMN PRODUCT.SALEPRICE IS '상품판매가';

COMMENT ON COLUMN PRODUCT.PQTY IS '상품수량';

COMMENT ON COLUMN PRODUCT.POINT IS '포인트';

COMMENT ON COLUMN PRODUCT.PSPEC IS '스펙';

COMMENT ON COLUMN PRODUCT.PCONTENTS IS '상품설명';

COMMENT ON COLUMN PRODUCT.PCOMPANY IS '제조사';

COMMENT ON COLUMN PRODUCT.PINDATE IS '등록일';

CREATE UNIQUE INDEX PK_PRODUCT
	ON PRODUCT (
		PNUM ASC
	);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT PK_PRODUCT
		PRIMARY KEY (
			PNUM
		);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT FK_DOWNCATEGORY_TO_PRODUCT
		FOREIGN KEY (
			UPCG_CODE,
			DOWNCG_CODE
		)
		REFERENCES DOWNCATEGORY (
			UPCG_CODE,
			DOWNCG_CODE
		);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT FK_UPCATEGORY_TO_PRODUCT
		FOREIGN KEY (
			UPCG_CODE
		)
		REFERENCES UPCATEGORY (
			UPCG_CODE
		);
        
        
        
-------------------------------
--상위 카테고리 항목추가
insert into upcategory values(upcategory_seq.nextval, '전자제품');
insert into upcategory values(upcategory_seq.nextval, '생활용품');
insert into upcategory values(upcategory_seq.nextval, '의류');
commit;
select * from upcategory;
select * from downcategory;
--전자제품 하위 추가
insert into downcategory(upcg_code, downcg_code, downcg_name) values(1, downcategory_seq.nextval, '주방가전');
insert into downcategory(upcg_code, downcg_code, downcg_name) values(1, downcategory_seq.nextval, '생활가전');

--생활용품 하위 추가
insert into downcategory(upcg_code, downcg_code, downcg_name) values(2, downcategory_seq.nextval, '휴지');
insert into downcategory(upcg_code, downcg_code, downcg_name) values(2, downcategory_seq.nextval, '세제');

--의류 하위 추가
insert into downcategory(upcg_code, downcg_code, downcg_name) values(3, downcategory_seq.nextval, '남성의류');
insert into downcategory(upcg_code, downcg_code, downcg_name) values(3, downcategory_seq.nextval, '여성의류');

commit;



--------------------

desc product;
select * from product;

alter table product modify pimage1 varchar2(200);
alter table product modify pimage2 varchar2(200);
alter table product modify pimage3 varchar2(200);

-------------- 장바구니 테이블 추가

/* 장바구니 */
DROP TABLE CART 
	CASCADE CONSTRAINTS;

/* 장바구니 */
CREATE TABLE CART (
	cartNum NUMBER(8) NOT NULL, /* 장바구니번호 */
	idx_fk NUMBER(8) NOT NULL, /* 회원번호 */
	PNUM_fk NUMBER(8) NOT NULL, /* 상품번호 */
	oqty NUMBER(8), /* 수량 */
	indate DATE /* 등록일 */
);

COMMENT ON TABLE CART IS '장바구니';

COMMENT ON COLUMN CART.cartNum IS '장바구니번호';

COMMENT ON COLUMN CART.idx_fk IS '회원번호';

COMMENT ON COLUMN CART.PNUM_fk IS '상품번호';

COMMENT ON COLUMN CART.oqty IS '수량';

COMMENT ON COLUMN CART.indate IS '등록일';

ALTER TABLE CART
	ADD
		CONSTRAINT FK_MEMBER_TO_CART
		FOREIGN KEY (
			idx_fk
		)
		REFERENCES MEMBER (
			idx
		);

ALTER TABLE CART
	ADD
		CONSTRAINT FK_PRODUCT_TO_CART
		FOREIGN KEY (
			PNUM_fk
		)
		REFERENCES PRODUCT (
			PNUM
		);


create sequence cart_seq nocache;

----------------------
--cart 들어온지 확인

select * from cart;

---------------------
--cartView에 보여줄 셀렉트문 작성

select c.*, p.pname,pimage1,price,saleprice,point, (c.oqty*p.saleprice) totalprice, (c.oqty*p.point) totalpoint
from cart c
join
product p
on c.pnum_fk = p.pnum and c.idx_fk=30;

--장바구니 총액을 위해 Viewt생성
create or replace view cartView
as
select c.*, p.pname,pimage1,price,saleprice,point, (c.oqty*p.saleprice) totalprice, (c.oqty*p.point) totalpoint
from cart c
join
product p
on c.pnum_fk = p.pnum;

select * from cartVIew;
-----------------------
-- 상/하위 카테고리명 가져오기. 
select p.*,
		 (select upCg_name from upCategory where upCg_code=p.upCg_code) upCg_name,
		 (select downCg_name from downCategory where downCg_code=p.downCg_code) downCg_name
		 from product p order by pnum desc;
         
----------로그인 유저 세션 추가되서 확인용.
select * from member;




----리뷰 게시판 테이블 추가

DROP INDEX PK_REVIEW;

/* 후기게시판 */
DROP TABLE REVIEW 
	CASCADE CONSTRAINTS;

/* 후기게시판 */
CREATE TABLE REVIEW (
	NUM NUMBER(8) primary key, /* 글번호 */
	userid varchar2(30) references member(userid),
    content varchar2(500) not null,
	SCORE NUMBER(1) not null, /* 평가점수 */
	FILENAME VARCHAR2(100) default 'noimage.png', /* 업로드파일 */
	WDATE DATE, /* 작성일 */
    pnum_fk number(8) references product(pnum)
);

drop sequence review_seq;
create sequence review_seq nocache;