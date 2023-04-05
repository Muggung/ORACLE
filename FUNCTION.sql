-- 1. 직원명과 이메일 , 이메일 길이를 출력하시오

SELECT EMP_NAME AS 직원명, EMAIL AS 이메일, LENGTH(EMAIL)
FROM EMPLOYEE;

-- 2. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오. 그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오

SELECT EMP_NAME AS 직원명, EXTRACT(YEAR FROM HIRE_DATE) AS 년생, NVL(BONUS, 0) AS 보너스
FROM EMPLOYEE;

-- 3. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)

SELECT COUNT(CASE WHEN PHONE NOT LIKE '010%' THEN 1 END) || '명' AS 직원수
FROM EMPLOYEE;

-- 4. 직원명과 입사년월을 출력하시오 (단, YYYY년 MM월 형식으로 출력)

SELECT EMP_NAME AS 직원명, EXTRACT(YEAR FROM HIRE_DATE) || '년 ' || EXTRACT(MONTH FROM HIRE_DATE) || '월' AS 입사년월
FROM EMPLOYEE;

-- 5. 직원명과 주민번호를 조회하시오 (단, 주민번호 9번째 자리부터 끝까지는 '*' 문자로 채워서출력 하시오)

SELECT EMP_NAME AS 직원명, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') AS 주민번호
FROM EMPLOYEE;

-- 6. 직원명, 직급코드, 연봉(원) 조회 (단, 연봉은 ￦57,000,000 으로 표시되게 함)

SELECT EMP_NAME AS 직원명, JOB_CODE AS 직급코드, TO_CHAR(SALARY * 12 + (SALARY * NVL(BONUS, 0)) * 12, 'L900,000,000') AS "연봉(원)"
FROM EMPLOYEE;

-- 7. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함, 사번 사원명 부서코드 입사일

SELECT EMP_NO AS 직원번호, EMP_NAME AS 직원명, DEPT_CODE AS 부서코드, HIRE_DATE AS 입사일
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;

-- 8. 직원명, 입사일, 오늘까지의 근무일수 조회 (* 주말도 포함 , 소수점 아래는 버림)

SELECT EMP_NAME AS 직원명, HIRE_DATE AS 입사일, FLOOR(SYSDATE - HIRE_DATE) AS 근무일수
FROM EMPLOYEE;

-- 9. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
-- 아래의 년도에 입사한 인원수를 조회하시오. 마지막으로 전체직원수도 구하시오. (DECODE, SUM 사용)

SELECT COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 1998, 1)) || '명' AS "1998년",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 1999, 1)) || '명' AS "1999년",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2000, 1)) || '명' AS "2000년",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2001, 1)) || '명' AS "2001년",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2002, 1)) || '명' AS "2002년",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2003, 1)) || '명' AS "2003년",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2004, 1)) || '명' AS "2004년",
          COUNT(*) || '명' AS 전체직원
FROM EMPLOYEE;

-- 10. 사원명과, 부서명을 출력하세요, 부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.
-- 단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.

SELECT EMP_NAME AS 직원명,
          CASE
                WHEN DEPT_CODE = 'D5' THEN '총무부'
                WHEN DEPT_CODE = 'D6' THEN '기획부'
                WHEN DEPT_CODE = 'D9' THEN '영업부' 
          END AS 부서명
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY DEPT_CODE;

-- 11. EMPLOYEE 테이블에서 직급이 J1을 제외하고, 직급별 사원수 및 평균급여를 출력하세요.

SELECT DEPT_CODE AS 직급, COUNT(DEPT_CODE) || '명' AS 사원수, FLOOR(AVG(SALARY)) || '원' AS 평균급여
FROM EMPLOYEE
WHERE DEPT_CODE NOT LIKE 'J1'
GROUP BY DEPT_CODE;

-- 12. EMPLOYEE테이블에서 직급이 J1을 제외하고,  입사년도별 인원수를 조회해서, 입사년 기준으로 오름차순 정렬하세요.

SELECT EXTRACT(YEAR FROM HIRE_DATE) AS 입사년도, COUNT(*) AS 사원수
FROM EMPLOYEE
WHERE DEPT_CODE NOT LIKE 'J1'
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
ORDER BY EXTRACT(YEAR FROM HIRE_DATE);

-- 13. EMPLOYEE 테이블에서 EMP_NO의 8번째 자리가 1, 3 이면 '남', 2, 4 이면 '여'로 결과를 조회하고,
-- 성별별 급여의 평균(정수처리), 급여의 합계, 인원수를 조회한 뒤 인원수로 내림차순을 정렬 하시오

SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS 성별,
          FLOOR(AVG(SALARY)) AS 평균,
          SUM(SALARY) AS "급여 합",
          COUNT(*) AS 인원수
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')
ORDER BY COUNT(*) DESC;

-- 14. 부서별 인원이 3명보다 많은 부서와 인원수를 출력하세요.

SELECT DEPT_CODE AS 부서코드, COUNT(DEPT_CODE) AS 인원수 
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(DEPT_CODE) > 3;

-- 15. 부서별 직급별 인원수가 3명이상인 직급의 부서코드, 직급코드, 인원수를 출력하세요.

SELECT DEPT_CODE AS 부서코드, JOB_CODE AS 직급코드, COUNT(*) AS 인원수
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
HAVING COUNT(DEPT_CODE) >= 3 AND COUNT(JOB_CODE) >= 3;

-- 16. 매니져가 관리하는 사원이 2명이상인 매니져아이디와 관리하는 사원수를 출력하세요.

SELECT E.MANAGER_ID AS "매니저아이디", COUNT(*) AS 사원수
FROM EMPLOYEE E JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID
GROUP BY E.MANAGER_ID, M.EMP_ID
HAVING COUNT(E.MANAGER_ID)  >= 2;

-- 17. 부서명과 지역명을 출력하세요. DEPARTMENT, LOCATION 테이블 이용

SELECT DEPT_TITLE AS 부서명, LOCAL_NAME AS 지역명
FROM DEPARTMENT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

-- 18. 지역명과 국가명을 출력하세요. LOCATION, NATION 테이블

SELECT L.LOCAL_NAME AS 지역명, N.NATIONAL_NAME AS 국가명 
FROM LOCATION L JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;

-- 19. 지역명과 국가명을 출력하세요. LOCATION, NATION 테이블을 조인하되 USING을 사용할것.

SELECT LOCAL_NAME AS 지역명, NATIONAL_NAME AS 국가명 
FROM LOCATION JOIN NATIONAL USING(NATIONAL_CODE);