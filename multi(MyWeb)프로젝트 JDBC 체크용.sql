--생성된 테이블 구조확인
select * from member;
desc member;

--회원번호에 사용할 시퀀스 생성
create sequence member_seq
start with 1
increment by 1
nocache;

--userid UK로변경
alter table member add constraint member_userid_uk unique(userid);

--몇몇 회원 상태 탈퇴(-2), 정지(-1)회원으로 변경
update member set status=-1 where idx=3;
update member set status=-2 where idx=7;
update member set status=9 where idx=4; --admin 4번 status9
update member set userid='admin', pwd='1234', name='관리자' where idx=4;
commit; --커밋해야 웹에서적용됨

--컬럼오타수정
alter table member rename column milage to mileage;

select idx from member where userid='hong';


-- 로그인관련 (일반, 정지회원은 로그인할수있게, 탈퇴회원은 못하게 처리해야한다) 
--오라클만 되는 표현 decode()
select member.*, decode(status,0, '활동회원', -1,'정지회원', -2,'탈퇴회원') as statusStr
from member
order by idx desc;

--MySQL에서도 되는 표현,(표준이다.)
select member.*,
case status
    when 0 then '활동회원'
    when -1 then '정지회원'
    when -2 then '탈퇴회원'
end as statusStr
from member
order by idx desc;

--system으로 접속해서 view sysnonym 생성 권한 부여.
grant create view, create synonym to multi;

--다시 multi로 접속
--status 값이 -1보다 큰 회원들만 모아서 memberView를 생성하자.
create or replace view memberView
as
select member.*, decode(status,0,'활동회원',-1,'정지회원',-2, '탈퇴회원',9,'관리자') statusStr
from member where status > -2;

select * from memberView order by idx desc;