-- 1. 학생이름과 주소지를 표시하기 단, 이름으로 오름차순 정렬 표시

SELECT STUDENT_NAME AS 학생이름, STUDENT_ADDRESS AS 주소지
FROM TB_STUDENT
ORDER BY STUDENT_NAME;

-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 출력

SELECT STUDENT_NAME AS 학생이름, STUDENT_SSN AS 주민번호
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY STUDENT_SSN DESC;

-- 3. 주소지가 강원도, 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름, 학번, 주소를 오름차순으로 출력

SELECT STUDENT_NAME AS 학생이름, STUDENT_NO AS 학번, STUDENT_ADDRESS AS "거주지 주소"
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%' AND STUDENT_ADDRESS LIKE '경기도%' OR STUDENT_ADDRESS LIKE '강원도%' 
ORDER BY 학생이름, 학번, "거주지 주소";

-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 출력

SELECT PROFESSOR_NAME AS 교수명, PROFESSOR_SSN AS 주민번호
FROM TB_PROFESSOR JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '법학과'
ORDER BY PROFESSOR_SSN;

-- 5. 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회해
-- 학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 출력

SELECT STUDENT_NO AS 학번, POINT AS 학점
FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO)
WHERE TERM_NO = '200402' AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO;

-- 6. 학생번호, 학생이름, 학과명을 학생이름으로 오름차순으로 정렬

SELECT STUDENT_NO AS 학생번호, STUDENT_NAME AS 학생명, DEPARTMENT_NAME AS 학과명
FROM TB_STUDENT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME;

-- 7. 춘 대학의 과목이름과 학과이름을 출력

SELECT CLASS_NAME AS 과목명, DEPARTMENT_NAME AS 학과명
FROM TB_CLASS JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);

-- 8. 과목별 교수이름 출력

SELECT CLASS_NAME AS 과목명, PROFESSOR_NAME AS 교수명
FROM TB_CLASS
    JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
    JOIN TB_PROFESSOR USING (PROFESSOR_NO);

-- 9. 8번 결과 중 '인문사회' 계열에 속한 과목의 교수 이름을 찾아 출력

SELECT CLASS_NAME AS 과목명, PROFESSOR_NAME AS 교수명
FROM TB_CLASS
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
    JOIN TB_PROFESSOR USING (PROFESSOR_NO)
WHERE CATEGORY = '인문사회'
ORDER BY PROFESSOR_NAME;

-- 10. '음악학과' 학생들의 평점을 구해, 학번, 학생명, 전체 평점을 출력

SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 학생명, TRUNC(AVG(POINT), 1) AS 학점
FROM TB_STUDENT 
    JOIN TB_GRADE USING (STUDENT_NO)
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '음악학과'
GROUP BY STUDENT_NO, STUDENT_NAME;

-- 11. 학번이 'A313047'인 학생의 학과이름, 학생이름, 지도교수이름을 출력

SELECT DEPARTMENT_NAME AS 학과명, STUDENT_NAME AS 학생명, PROFESSOR_NAME AS 지도교수명
FROM TB_DEPARTMENT
    JOIN TB_STUDENT USING(DEPARTMENT_NO)
    JOIN TB_PROFESSOR ON COACH_PROFESSOR_NO = PROFESSOR_NO
WHERE STUDENT_NO = 'A313047';

-- 12 . 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기이름 표시

SELECT STUDENT_NAME AS 학생명, TERM_NO AS 수강학기
FROM TB_CLASS
    JOIN TB_GRADE USING(CLASS_NO)
    JOIN TB_STUDENT USING(STUDENT_NO)
WHERE CLASS_NAME = '인간관계론' AND SUBSTR(TERM_NO, 1, 4) = '2007';

-- 13. 예체능 계열 과목 중 과목 담당교수를 한명도 배정받지 못한 과목명과 학과명 출력

SELECT CLASS_NAME AS 과목명, DEPARTMENT_NAME AS 학과명
FROM TB_CLASS 
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
    LEFT JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
WHERE PROFESSOR_NO IS NULL AND CATEGORY = '예체능';

-- 14. 춘 대학 서반아어학과 학생들의 지도 교수를 게시하고자 한다.
-- 학생명과 지도교수명을 찾고 지도교수가 없는 학생은 '지도교수 미지정'으로 표시해서 출력
-- 이 때, 고학번 학생이 먼저 표시되도록 한다.

SELECT STUDENT_NAME AS 학생이름, NVL(PROFESSOR_NAME, '지도교수 미지정') AS 지도교수
FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
    LEFT JOIN TB_PROFESSOR ON COACH_PROFESSOR_NO = PROFESSOR_NO
WHERE DEPARTMENT_NAME = '서반아어학과';

-- 15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 학번, 이름, 학과, 이름, 평점 출력

SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 이름, DEPARTMENT_NAME AS 학과명, TRUNC(AVG(POINT),1) AS 학점
FROM TB_STUDENT
    JOIN TB_GRADE USING (STUDENT_NO)
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING TRUNC(AVG(POINT),1) >= 4.0;

-- 16. 환경조경학과 전공과목들의 과목별 평점을 출력

SELECT CLASS_NO AS 과목번호, CLASS_NAME AS 과목명, TRUNC(AVG(POINT), 8) AS 학점
FROM TB_CLASS
    JOIN TB_GRADE USING(CLASS_NO)
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '환경조경학과' AND CLASS_TYPE LIKE '전공%'
GROUP BY CLASS_NO, CLASS_NAME;

-- 17. 춘 대학을 다니는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력

SELECT STUDENT_NAME AS 학생명, STUDENT_ADDRESS AS 주소
FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO FROM TB_STUDENT WHERE STUDENT_NAME = '최경희');

    
-- 18. 국어국문학과에서 총 평점이 가장 높은 학생명, 학번을 표시

SELECT STUDENT_NAME AS 학생명, STUDENT_NO AS 학번
FROM (SELECT STUDENT_NAME, STUDENT_NO
        FROM TB_STUDENT
            JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
            JOIN TB_GRADE USING(STUDENT_NO)
        WHERE DEPARTMENT_NAME = '국어국문학과'
        GROUP BY STUDENT_NO, STUDENT_NAME
        ORDER BY AVG(POINT) DESC)
WHERE ROWNUM = 1;

-- 19. 춘 대학의 '환경조경학과'가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 출력

SELECT DEPARTMENT_NAME AS 학과명, ROUND(AVG(POINT),1) AS 전공평점
FROM TB_DEPARTMENT
        JOIN TB_CLASS USING(DEPARTMENT_NO)
        JOIN TB_GRADE USING(CLASS_NO)
WHERE CATEGORY = '자연과학' AND CLASS_TYPE LIKE '전공%'
GROUP BY DEPARTMENT_NAME
ORDER BY DEPARTMENT_NAME;
