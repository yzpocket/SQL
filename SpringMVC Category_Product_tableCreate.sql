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

create sequence upcategory_seq nocache;

        
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
        
create sequence downcategory_seq nocache;
        
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
        
create sequence product_seq nocache;