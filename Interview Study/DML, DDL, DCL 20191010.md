# 데이터 정의어 (`DDL : Data Definition Language` )

> 테이블과 같은 데이터 구조를 정의하는 데 사용하는 명령어
>
> 스키마, 도메인, 테이블, 뷰, 인덱스를 정의하거나 변경 또는 삭제할 때 사용

- CREATE : 생성

- ALTER : 변경

- DROP : 삭제

- RENAME : 이름 변경

- TRUNCATE : 테이블에서 데이터를 제거 (취소 불가)

  

# 데이터 조작어 (`DML : Data Manipulation Language`)

> 정의된 DB에 입력된 레코드를 조회, 수정, 삭제할 때 사용

* SELECT (RETRIEVE) : 조회, 검색
* INSERT : 삽입
* UPDATE : 수정
* DELETE : 삭제



# 데이터 제어어 (`DCL : Data Control Language`)

> DB에 접근하거나 객체를 사용하도록 권한을 주고 회수하는 명령어

* GRANT : 특정 작업에 대한 수행 권한 부여
* REVOKE : 수행 권한 회수
* COMMIT : 트랜잭션의 작업이 정상적으로 완료되었음을 알려줌
* ROLLBACK : 트랜잭션의 작업이 비정상적으로 종료되었을 때 원래의 상태로 복구