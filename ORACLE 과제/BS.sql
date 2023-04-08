CREATE USER SCOTT IDENTIFIED BY TIGER DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
GRANT CONNECT, RESOURCE TO SCOTT;

-------------------------------------------------------------------------------------------------------------------------

-- 1. JOB테이블에서 JOB_NAME의 정보만 출력되도록 하시오
SELECT JOB_NAME
FROM JOB;

-- 2. DEPARTMENT테이블의 내용 전체를 출력하는 SELECT문을 작성하시오
SELECT *
FROM DEPARTMENT;

-- 3. EMPLOYEE 테이블에서 이름(EMP_NAME), 이메일(EMAIL), 전화번호(PHONE), 고용일(HIRE_DATE)만 출력하시오
SELECT EMP_NAME AS 이름, EMAIL AS 이메일, PHONE AS 전화번호, HIRE_DATE AS 고용일
FROM EMPLOYEE;

-- 4. EMPLOYEE 테이블에서 고용일(HIRE_DATE) 이름(EMP_NAME), 월급(SALARY)을 출력하시오
SELECT HIRE_DATE || EMP_NAME AS "고용일 이름", SALARY AS 월급
FROM EMPLOYEE;

-- 5. EMPLOYEE 테이블에서 월급(SALARY)이 2,500,000원이상인 사람의 EMP_NAME 과 SAL_LEVEL을 출력하시오 
SELECT EMP_NAME AS 이름, SAL_LEVEL AS 급여등급
FROM EMPLOYEE
WHERE SALARY >= 2500000;

-- 6. EMPLOYEE 테이블에서 월급(SALARY)이 350만원 이상이면서 JOB_CODE가 'J3' 인 사람의 이름(EMP_NAME)과 전화번호(PHONE)를 출력하시오
SELECT EMP_NAME AS 이름, PHONE AS 전화번호
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND JOB_CODE = 'J3';

-- 7. EMPLOYEE 테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총 수령액-(월급*세금 3%))가 출력되도록 하시오
SELECT EMP_NAME AS 이름,
          SALARY * 12 AS 연봉, (SALARY + (SALARY * NVL(BONUS, 0))) * 12 AS "총 수령액(보너스포함)",
          ((SALARY + (SALARY * NVL(BONUS, 0))) * 12) - (SALARY * 0.03) AS "실 수령액"
FROM EMPLOYEE;

-- 8. EMPLOYEE 테이블에서 이름, 근무 일수(입사한지 몇일인가)를 출력해보시오. (날짜도 산술연산가능함.)
SELECT EMP_NAME AS 이름, FLOOR(SYSDATE - HIRE_DATE) AS "근무 일수", '일'
FROM EMPLOYEE;

-- 9. EMPLOYEE 테이블에서 20년 이상 근속자의 이름,월급,보너스율를 출력하시오
SELECT EMP_NAME AS 이름, TO_CHAR(SALARY, '999,999,999') AS 월급, NVL(BONUS, 0) AS 보너스
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >= 20;

-- 10. EMPLOYEE 테이블에서 고용일이 90/01/01 ~ 01/01/01 인 사원의 전체 내용을 출력하시오
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- 11. 이름에 '이'가 들어가는 사원을 모두 출력하세요.
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%이%';

-- 12. EMPLOYEE 테이블에서 이름 끝이 연으로 끝나는 사원의 이름을 출력하시오
SELECT EMP_NAME AS 이름
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

-- 13. EMPLOYEE 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 출력하시오
SELECT EMP_NAME AS 이름, PHONE AS 전화번호
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';

-- 14. EMPLOYEE 테이블에서 메일주소 '_'의 앞이 4자이면서, 
--      DEPT_CODE가 D9 또는 D6이고 고용일이 90/01/01 ~ 00/12/01이면서,
--      월급이 270만원이상인 사원의 전체 정보를 출력하시오
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '____\_%' ESCAPE '\' AND
        DEPT_CODE IN ('D9', 'D6') AND
        HIRE_DATE BETWEEN '90/01/01' AND
        '00/12/01' AND SALARY >= 2700000;

-- 15. 부서 배치를 받지 않았지만 보너스를 지급하는 직원 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

-- 16. 관리자도 없고 부서 배치도 받지 않은 직원 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;