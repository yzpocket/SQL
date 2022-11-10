select * from member;

desc member;

--회원번호에 사용할 시퀀스 생성
create sequence member_seq
start with 1
increment by 1
nocache;

alter table member add constraint member_userid_uk unique(userid);

update member set status=-1 where idx=3;
update member set status=-2 where idx=7;
commit;
alter table member rename column milage to mileage;



select idx from member where userid='hong';