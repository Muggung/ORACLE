CREATE USER SCOTT IDENTIFIED BY TIGER DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
GRANT CONNECT, RESOURCE TO SCOTT;

-------------------------------------------------------------------------------------------------------------------------

-- 1. JOB���̺��� JOB_NAME�� ������ ��µǵ��� �Ͻÿ�
SELECT JOB_NAME
FROM JOB;

-- 2. DEPARTMENT���̺��� ���� ��ü�� ����ϴ� SELECT���� �ۼ��Ͻÿ�
SELECT *
FROM DEPARTMENT;

-- 3. EMPLOYEE ���̺��� �̸�(EMP_NAME), �̸���(EMAIL), ��ȭ��ȣ(PHONE), �����(HIRE_DATE)�� ����Ͻÿ�
SELECT EMP_NAME AS �̸�, EMAIL AS �̸���, PHONE AS ��ȭ��ȣ, HIRE_DATE AS �����
FROM EMPLOYEE;

-- 4. EMPLOYEE ���̺��� �����(HIRE_DATE) �̸�(EMP_NAME), ����(SALARY)�� ����Ͻÿ�
SELECT HIRE_DATE || EMP_NAME AS "����� �̸�", SALARY AS ����
FROM EMPLOYEE;

-- 5. EMPLOYEE ���̺��� ����(SALARY)�� 2,500,000���̻��� ����� EMP_NAME �� SAL_LEVEL�� ����Ͻÿ� 
SELECT EMP_NAME AS �̸�, SAL_LEVEL AS �޿����
FROM EMPLOYEE
WHERE SALARY >= 2500000;

-- 6. EMPLOYEE ���̺��� ����(SALARY)�� 350���� �̻��̸鼭 JOB_CODE�� 'J3' �� ����� �̸�(EMP_NAME)�� ��ȭ��ȣ(PHONE)�� ����Ͻÿ�
SELECT EMP_NAME AS �̸�, PHONE AS ��ȭ��ȣ
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND JOB_CODE = 'J3';

-- 7. EMPLOYEE ���̺��� �̸�, ����, �Ѽ��ɾ�(���ʽ�����), �Ǽ��ɾ�(�� ���ɾ�-(����*���� 3%))�� ��µǵ��� �Ͻÿ�
SELECT EMP_NAME AS �̸�,
          SALARY * 12 AS ����, (SALARY + (SALARY * NVL(BONUS, 0))) * 12 AS "�� ���ɾ�(���ʽ�����)",
          ((SALARY + (SALARY * NVL(BONUS, 0))) * 12) - (SALARY * 0.03) AS "�� ���ɾ�"
FROM EMPLOYEE;

-- 8. EMPLOYEE ���̺��� �̸�, �ٹ� �ϼ�(�Ի����� �����ΰ�)�� ����غ��ÿ�. (��¥�� ������갡����.)
SELECT EMP_NAME AS �̸�, FLOOR(SYSDATE - HIRE_DATE) AS "�ٹ� �ϼ�", '��'
FROM EMPLOYEE;

-- 9. EMPLOYEE ���̺��� 20�� �̻� �ټ����� �̸�,����,���ʽ����� ����Ͻÿ�
SELECT EMP_NAME AS �̸�, TO_CHAR(SALARY, '999,999,999') AS ����, NVL(BONUS, 0) AS ���ʽ�
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >= 20;

-- 10. EMPLOYEE ���̺��� ������� 90/01/01 ~ 01/01/01 �� ����� ��ü ������ ����Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- 11. �̸��� '��'�� ���� ����� ��� ����ϼ���.
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��%';

-- 12. EMPLOYEE ���̺��� �̸� ���� ������ ������ ����� �̸��� ����Ͻÿ�
SELECT EMP_NAME AS �̸�
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��';

-- 13. EMPLOYEE ���̺��� ��ȭ��ȣ ó�� 3�ڸ��� 010�� �ƴ� ����� �̸�, ��ȭ��ȣ�� ����Ͻÿ�
SELECT EMP_NAME AS �̸�, PHONE AS ��ȭ��ȣ
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';

-- 14. EMPLOYEE ���̺��� �����ּ� '_'�� ���� 4���̸鼭, 
--      DEPT_CODE�� D9 �Ǵ� D6�̰� ������� 90/01/01 ~ 00/12/01�̸鼭,
--      ������ 270�����̻��� ����� ��ü ������ ����Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '____\_%' ESCAPE '\' AND
        DEPT_CODE IN ('D9', 'D6') AND
        HIRE_DATE BETWEEN '90/01/01' AND
        '00/12/01' AND SALARY >= 2700000;

-- 15. �μ� ��ġ�� ���� �ʾ����� ���ʽ��� �����ϴ� ���� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

-- 16. �����ڵ� ���� �μ� ��ġ�� ���� ���� ���� �̸� ��ȸ
SELECT EMP_NAME
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;