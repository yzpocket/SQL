drop table board;

-- 단순형 게시판(파일첨부 기능)
create table board(
	num number(8) primary key, -- 글번호
	userid varchar2(30) not null, -- 작성자 아이디
	subject varchar2(200), -- 제목
	content varchar2(2000), -- 글 내용
	wdate timestamp default systimestamp, -- 작성일
	filename varchar2(300), -- 첨부 파일명 
	filesize number(8) -- 첨부 파일 크기
);

drop sequence board_seq;

create sequence board_seq
start with 1
increment by 1
nocache;


----------MvcWeb

select * from board;
select num, filename, filesize from board;

---------- 페이징 처리 -----
--모든 페이지 살펴보고
select * from board order by num desc;
--rownum으로 구분해야 한다. (글번호인 num으로는 안된다. 빈부분이 생기기 때문에.)
select rownum rn, board.* from board order by num desc; -- 이러면 rownum과 num이 섞인다.
select rownum rn, a.* from (select * from board order by num desc) a; -- 서브쿼리로 묶어서 정렬해야 한다.

select rownum rn, a.* from (select * from board order by num desc) a
where rn between 1 and 5;-- 구간을 정할 때 rn을 못찾는 문제가 생긴다

-- 한번 더 서브쿼리로 묶으면 rn으로 아래처럼 구간 범위를 지정 할 수 있다.
----[서브쿼리를 활용해서 추려낸 최종 select문]
select * from (
select a.*,rownum rn from (select * from board order by num desc) a)
where rn between 6 and 10;
----------------------------------
--cpage에서는 1과 5가 start, end로 변수로 변경되어야 한다.
cpage/pagesize/start/end
1       /5             /1      /5
2       /5             /6      /10
3       /5             /11     /15
4       /5             /16     /20
... 이와같은 규칙이 생겨남

end= cpage*pagesize;
start= end-(pageSize-1);