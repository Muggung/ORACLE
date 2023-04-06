-- 1. 70��� ��(1970~1979) �� �����̸鼭 ������ ����� �̸��� �ֹι�ȣ, �μ� ��, ���� ��ȸ

SELECT EMP_NAME AS �����, EMP_NO AS �ֹι�ȣ, DEPT_TITLE AS �μ���, JOB_CODE AS ����
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE SUBSTR(EMP_NO, 1, 2) BETWEEN 70 AND 79
           AND SUBSTR(EMP_NO, 8, 1) = 2
           AND EMP_NAME LIKE '��%'; 
           
-- 2. ���� �� ���� ������ ��� �ڵ�, ��� ��, ����, �μ� ��, ���� �� ��ȸ

SELECT EMP_ID AS �����ȣ, 
          EMP_NAME AS �����,
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT (YEAR FROM TO_DATE(SUBSTR (EMP_NO, 1, 2),'RR')) AS ����,
          DEPT_TITLE AS �μ���,
          JOB_NAME AS ����
FROM EMPLOYEE
         JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
         JOIN JOB USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT (YEAR FROM TO_DATE(SUBSTR (EMP_NO, 1, 2),'RR')) = 
          (SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT (YEAR FROM TO_DATE(SUBSTR (EMP_NO, 1, 2),'RR'))) FROM EMPLOYEE);
          
-- 3. �̸��� �������� ���� ����� ��� �ڵ�, ��� ��, ���� ��ȸ

SELECT EMP_ID AS �����ȣ, EMP_NAME AS �����, JOB_NAME AS ����
FROM EMPLOYEE
        JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '%��%';

-- 4. �μ��ڵ尡 D5�̰ų� D6�� ����� ��� ��, ���� ��, �μ� �ڵ�, �μ� �� ��ȸ

SELECT EMP_NAME AS �����, JOB_NAME AS ����, DEPT_CODE AS �μ��ڵ�, DEPT_TITLE AS �μ���
FROM EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE IN ('D5', 'D6');

-- 5. ���ʽ��� �޴� ����� ��� ��, �μ� ��, ���� �� ��ȸ

SELECT EMP_NAME AS �����, BONUS AS ���ʽ�, DEPT_TITLE AS �μ���, LOCAL_NAME AS ������
FROM EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE BONUS IS NOT NULL;

-- 6. ��� ��, ���� ��, �μ� ��, ���� �� ��ȸ

SELECT EMP_NAME AS �����, DEPT_TITLE AS ����, JOB_NAME AS �μ���, LOCAL_NAME AS ������
FROM EMPLOYEE
         JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
         JOIN JOB USING(JOB_CODE)
         JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
         
-- 7. �ѱ��̳� �Ϻ����� �ٹ� ���� ����� ��� ��, �μ� ��, ���� ��, ���� �� ��ȸ

SELECT EMP_NAME AS �����, JOB_NAME AS �μ���, LOCAL_NAME AS ������, NATIONAL_NAME AS ������
FROM EMPLOYEE
         JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
         JOIN JOB USING(JOB_CODE)
         JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
         JOIN NATIONAL USING(NATIONAL_CODE)
WHERE LOCAL_NAME IN ('ASIA1', 'ASIA2');

-- 8. �� ����� ���� �μ����� ���ϴ� ����� �̸� ��ȸ

SELECT E.EMP_NAME AS �����, E.DEPT_CODE AS �μ��ڵ�, M.EMP_NAME AS �����μ�
FROM EMPLOYEE E 
         JOIN EMPLOYEE M ON E.DEPT_CODE = M.DEPT_CODE
WHERE E.EMP_NAME != M.EMP_NAME;

-- 9. ���ʽ��� ���� ���� �ڵ尡 J4�̰ų� J7�� ����� �̸�, ���� ��, �޿� ��ȸ(NVL �̿�)

SELECT EMP_NAME AS �����, JOB_NAME AS ����, NVL(BONUS, SALARY) AS �޿�
FROM EMPLOYEE
         JOIN JOB USING(JOB_CODE)
WHERE JOB_CODE IN ('J4','J7');

-- 10. ���ʽ� ������ ������ ���� 5���� ���, �̸�, �μ� ��, ����, �Ի���, ���� ��ȸ

SELECT T.EMP_ID AS �����ȣ, T.EMP_NAME AS �����, JOB_NAME AS ����, T.HIRE_DATE AS �Ի���, ROWNUM AS ����
FROM(
        SELECT ROWNUM AS INNERNUM, E.*
        FROM EMPLOYEE E 
        ORDER BY (SALARY * 12) + ((SALARY * NVL(BONUS, 0)) * 12) DESC
        ) T
        JOIN JOB USING(JOB_CODE)
WHERE ROWNUM < 6;

-- 11. �μ� �� �޿� �հ谡 ��ü �޿� �� ���� 20%���� ���� �μ��� �μ� ��, �μ� �� �޿� �հ� ��ȸ
-- 11-1. JOIN�� HAVING ���
-- 11-2. �ζ��� �� ���
-- 11-3. WITH ���

WITH DDD AS (
        SELECT E.*, D.*, (SELECT SUM(SALARY) FROM EMPLOYEE) AS SUM_SALARY
        FROM EMPLOYEE E
        LEFT JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
         )

SELECT DEPT_TITLE AS �μ���, SUM(SALARY) AS �����հ�
FROM DDD
WHERE DEPT_TITLE IS NOT NULL
HAVING SUM(SALARY) > (SUM_SALARY * 0.2)
GROUP BY DEPT_TITLE, SUM_SALARY;

-- 12. �μ� ��� �μ� �� �޿� �հ� ��ȸ

SELECT DEPT_TITLE AS �μ���, SUM(SALARY)
FROM EMPLOYEE
         JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_TITLE;
         