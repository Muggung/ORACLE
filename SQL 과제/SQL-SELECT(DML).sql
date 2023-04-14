-- 1. 과목유형 테이블(TABLE_CLASS_TYPE)에 데이터 입력하기

INSERT INTO TB_CLASS_TYPE VALUES('01', '전공필수');
INSERT INTO TB_CLASS_TYPE VALUES('02', '전공선택');
INSERT INTO TB_CLASS_TYPE VALUES('03', '교양필수');
INSERT INTO TB_CLASS_TYPE VALUES('04', '교양선택');
INSERT INTO TB_CLASS_TYPE VALUES('05', '논문지도');

-- 2. 춘 대학 학생들의 정보가 포함되어 있는 학생 테이블 만들기

CREATE TABLE TB_학생일반정보
    AS
        SELECT  STUDENT_NO AS 학번, STUDENT_NAME AS 학생이름, STUDENT_ADDRESS AS 주소
        FROM TB_STUDENT;

-- 3. 국어국문학과 학생들의 정보만 포함된 학과정보 테이블 만들기

CREATE TABLE TB_국어국문학과
    AS
        SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 학생이름,
            EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RR/MM/DD')) AS 출생년도
            , PROFESSOR_NAME AS 교수이름
        FROM TB_STUDENT
            JOIN TB_PROFESSOR ON COACH_PROFESSOR_NO = PROFESSOR_NO;
            
-- 4. 각 학과의 정원을 10% 증가시키기
-- 단, 소수점 자릿수는 표현 X

UPDATE TB_DEPARTMENT
SET CAPACITY = FLOOR(CAPACITY + CAPACITY * 0.1);            

-- 5. 'A413042' 학번인 박건우 학생의 주소를 '서울시 종로구 숭인동 181-21'로 변경

UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NO = 'A413042' AND STUDENT_NAME = '박건우';

-- 6. 주민번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 결정했다.
-- 위 내용을 반영하기

UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);

-- 7. 의학과 김명훈 학생은 2005년 1학기에 수강한 '피부생리학'점수가 잘못되었다고 정정 요청을 했다.
-- 담당교수의 확인 결과 해당 과목의 학점을 3.5로 변경했다.
-- 해당 SQL문 작성하기

UPDATE TB_GRADE
SET  POINT = 3.5
WHERE (STUDENT_NO,TERM_NO) = 
    (SELECT STUDENT_NO, TERM_NO FROM TB_STUDENT
        JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
        JOIN TB_GRADE USING(STUDENT_NO)
        JOIN TB_CLASS USING(DEPARTMENT_NO)
    WHERE STUDENT_NAME = '김명훈' AND DEPARTMENT_NAME = '의학과' AND CLASS_NAME = '피부생리학' AND TERM_NO = 200501);

-- 8. 성적 테이블(TB_GRADE)에서 휴학생들의 성적항목 제거

DELETE FROM (SELECT POINT, ABSENCE_YN FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO))
WHERE ABSENCE_YN = 'Y'; 