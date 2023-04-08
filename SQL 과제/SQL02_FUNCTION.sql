-- 1. 영어영문학과(학과코드 002) 학생들의 학번, 이름, 입학년도를 입학년도가 빠른 순으로 출력

SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 이름, ENTRANCE_DATE AS 입학년도
FROM TB_STUDENT
ORDER BY ENTRANCE_DATE;

-- 2. 춘 대학교 교수 중 이름이 세글자가 아닌 교수 한명을 찾고,
-- 그 교수의 이름, 주민번호를 출력

SELECT PROFESSOR_NAME AS 이름, PROFESSOR_SSN AS 주민번호
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3;

-- 3. 춘 대학교 남자 교수들의 이름, 나이를 출력
-- 단, 나이가 적은 순서로 출력, 교수 중 2000년 이 후 출생자는 없으며 나이는 만 나이로 계산한다.

SELECT PROFESSOR_NAME AS "교수 이름", 
        FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(TO_NUMBER(SUBSTR(PROFESSOR_SSN, 1, 2)) +
        CASE
                WHEN SUBSTR(PROFESSOR_SSN, 8, 1) IN (1, 2) THEN 1900
                WHEN SUBSTR(PROFESSOR_SSN, 8, 1) IN (3, 4) THEN 2000
        END || SUBSTR(PROFESSOR_SSN, 3, 4), 'RR/MM/DD')) / 12) AS 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1';

-- 4. 교수들의 이름 중 성을 제외한 이름만 출력 (성이 2글자인 교수는 없다고 가정)

SELECT SUBSTR(PROFESSOR_NAME, 2, 3) AS 이름
FROM TB_PROFESSOR;

-- 5. 춘 대학교의 재수생 입학자를 찾아 출력(단, 19살에 입학하면 재수를 하지 않은 것으로 간주)

SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 학생이름
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN, 1, 6))) > 19;

-- 6. 2020년 크리스마스는 무슨 요일인지 출력

SELECT TO_CHAR(TO_DATE('20201225'), 'DAY') AS "무슨요일이니?"
FROM DUAL;

-- 7. TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE('49/10/11', 'YY/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미 하는지
-- 또 TO_DATE('99/10/11', 'RR/MM/DD'), TO_DATE('49/10/11', 'RR/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미 하는지 출력
-- 현재 년도의 뒤의 두 자리에 따라 현재 세기, 다음 세기, 이전 세기를 표현

SELECT TO_DATE('99/10/11', 'YY/MM/DD') AS "99/10/11", TO_DATE('49/10/11', 'YY/MM/DD') AS "49/10/11",
          TO_DATE('99/10/11', 'RR/MM/DD') AS "RR/10/11", TO_DATE('49/10/11', 'RR/MM/DD') AS "RR/10/11"
FROM DUAL;

-- 8. 춘 대학교의 2000년도 이후 입학자들은 학번이 A로 시작한다.
-- 2000년도 이전 학번을 받은 학생들의 학번과 이름 출력

SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 이름
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%';

-- 9. 학번이 A517178인 한아름 학생의 학점 총 평점을 출력
-- 단, 점수는 반올림하여 소수점 이하 한자리까지만 표시

SELECT ROUND(AVG(POINT), 1) AS 평점
FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO)
WHERE STUDENT_NO = 'A517178';

-- 10. 학과별 학생 수를 구하여 '학과번호' '학생수' 형태의 헤더를 만들어 출력

SELECT DEPARTMENT_NO AS 학과번호, COUNT(DEPARTMENT_NO) AS 학생수
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO ORDER BY DEPARTMENT_NO;

-- 11. 지도교수를 배정받지 못한 학생 수가 몇 명인지 출력

SELECT COUNT(*) AS 학생수
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- 12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구해 출력
-- 단, 점수는 반올림하여 소수점 이하 한 자리만 표시

SELECT SUBSTR(TERM_NO, 1, 4) AS 년도, ROUND(AVG(POINT), 1) AS 평점
FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO)
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO, 1, 4) ORDER BY 1;

-- 13. 학과별 휴학생 수를 파악하고자 한다. 학과코드, 휴학생 수를 출력

SELECT DEPARTMENT_NO 학과코드, COUNT(CASE WHEN ABSENCE_YN = 'Y' THEN 1 END) "휴학생 인원"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO ORDER BY 1;

-- 14. 춘 대학교에 다니는 동명이인 학생들을 찾아 출력

SELECT STUDENT_NAME AS 동일이름, COUNT(*) AS "동일이름 인원"
FROM TB_STUDENT
HAVING COUNT(*) > 1
GROUP BY STUDENT_NAME ORDER BY 1;

-- 15. 학번이 A112113인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점, 총 평점을 출력
-- 단, 평점은 소수점 1자리까지만 반올림하기

SELECT NVL(SUBSTR(TERM_NO, 1, 4), '종합') AS 년도, NVL(SUBSTR(TERM_NO, 5, 2), '평균') AS 학기 , ROUND(AVG(POINT), 1) AS 평점
FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO)
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2));