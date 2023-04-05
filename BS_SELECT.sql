-- 1. JOB ���̺��� ��� ������ ��ȸ

SELECT *
FROM JOB;

-- 2. JOB ���̺��� ���� �̸� ��ȸ

SELECT JOB_NAME AS ����
FROM JOB;

-- 3. DEPARTMENT ���̺��� ��� ���� ��ȸ

SELECT *
FROM DEPARTMENT;

-- 4. EMPLOYEE ���̺��� �����, �̸���, ��ȭ��ȣ, ����� ��ȸ

SELECT EMP_NAME AS �����, EMAIL AS �̸���, PHONE AS ��ȭ��ȣ, HIRE_DATE AS �����
FROM EMPLOYEE;

-- 5. EMPLOYEE ���̺��� �����, �����, ���� ��ȸ

SELECT HIRE_DATE AS �����, EMP_NAME AS �����, SALARY AS ����
FROM EMPLOYEE;

-- 6.  EMPLOYEE ���̺��� �����, ����, �Ѽ��ɾ�(���ʽ�����), �Ǽ��ɾ�(�Ѽ��ɾ� - (����*���� 3%)) ��ȸ

SELECT EMP_NAME AS �����,
        SALARY * 12 AS ����,
        ((SALARY * 12) + ((SALARY * 12) * NVL(BONUS, 0))) AS �Ѽ��ɾ�,
        ((SALARY * 12) + ((SALARY * 12) * NVL(BONUS, 0))) - ABS((SALARY * 12) * 0.03) AS �Ǽ��ɾ�
FROM EMPLOYEE;

-- 7. EMPLOYEE ���̺��� SAL_LEVEL�� S1�� �����, ����, �����, ��ȭ��ȣ ��ȸ

SELECT EMP_NAME AS �����, SALARY AS ����, HIRE_DATE AS �����, PHONE AS ��ȭ��ȣ
FROM EMPLOYEE
WHERE SAL_LEVEL = 'S1';

-- 8. EMPLOYEE ���̺��� �Ǽ��ɾ�(6�� ����)�� 5õ���� �̻��� �����, ����, �Ǽ��ɾ�, ����� ��ȸ

SELECT EMP_NAME AS �����, SALARY AS ����,
          ((SALARY * 12) + ((SALARY * 12) * NVL(BONUS, 0))) - ABS((SALARY * 12) * 0.03) AS �Ǽ��ɾ�,
          HIRE_DATE AS �����
FROM EMPLOYEE
WHERE ((SALARY * 12) + ((SALARY * 12) * NVL(BONUS, 0))) - ABS((SALARY * 12) * 0.03) >= 50000000;

-- 9. EMPLOYEE ���̺� ������ 4,000,000���̻� �̰� JOB_CODE�� J2�� ����� ��ü ���� ��ȸ

SELECT *
FROM EMPLOYEE
WHERE SALARY >= 4000000 AND JOB_CODE = 'J2';

-- 10. EMPLOYEE ���̺� DEPT_CODE�� D9�̰ų� D5�� ��� �� ������� 02�� 1�� 1�Ϻ��� ���� ����� �����, �μ��ڵ�, ����� ��ȸ

SELECT EMP_NAME AS �����, DEPT_CODE AS �μ��ڵ�, HIRE_DATE AS �����
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9') AND HIRE_DATE < '02/01/01';

-- 11. EMPLOYEE ���̺� ������� 90/01/01 ~ 01/01/01�� ����� ��ü ������ ��ȸ

SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- 12. EMPLOYEE ���̺��� �̸� ���� '��'���� ������ ����� �̸� ��ȸ

SELECT EMP_NAME AS �����
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��';

-- 13. EMPLOYEE ���̺��� ��ȭ��ȣ ó�� 3�ڸ��� 010�� �ƴ� ����� �̸�, ��ȭ��ȣ�� ��ȸ

SELECT EMP_NAME AS �����, PHONE AS ��ȭ��ȣ
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';

-- 14. EMPLOYEE ���̺��� �����ּ� '_'�� ���� 4���̸鼭 DEPT_CODE�� D9 �Ǵ� D6�̰�,
-- ������� 90/01/01 ~ 00/12/01�̰�, �޿��� 270�� �̻��� ����� ��ü�� ��ȸ

SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '____\_%' ESCAPE '\'
          AND DEPT_CODE IN ('D6', 'D9')
          AND HIRE_DATE BETWEEN '90/01/01' AND '00/12/01'
          AND SALARY >= 2700000;

-- 15. EMPLOYEE ���̺��� ������ ������ �ֹι�ȣ�� �̿��Ͽ� ����, ����, ���� ��ȸ

SELECT SUBSTR(EMP_NO, 1, 2) AS ����, SUBSTR(EMP_NO, 3, 2) AS ����, SUBSTR(EMP_NO, 5, 2) AS ����
FROM EMPLOYEE;

-- 16. EMPLOYEE ���̺��� �����, �ֹι�ȣ ��ȸ (��, �ֹι�ȣ�� ������ϸ� ���̰� �ϰ�, '-' ���� ���� '*'�� �ٲٱ�)

SELECT EMP_NAME AS �����, REPLACE(EMP_NO, SUBSTR(EMP_NO, 8), '*******') AS �ֹι�ȣ
FROM EMPLOYEE;

-- 17. EMPLOYEE ���̺��� �����, �Ի���-����, ����-�Ի��� ��ȸ
-- *�⵵�� ���� �ϼ��� �ٸ� �� ����, ���� : (��, �� ��Ī�� �ٹ��ϼ�1, �ٹ��ϼ�2�� �ǵ��� �ϰ� ��� ����(����), ����� �ǵ��� ó��)

SELECT EMP_NAME AS �����, ABS(FLOOR(HIRE_DATE - SYSDATE)) AS "�ٹ��ϼ�(�Ի��� - ����)", FLOOR(SYSDATE - HIRE_DATE) AS "�ٹ��ϼ�(���� - �Ի���)" 
FROM EMPLOYEE;

-- 18. EMPLOYEE ���̺��� �����ȣ�� Ȧ���� �������� ���� ��� ��ȸ

SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) != 0;

-- 19.  EMPLOYEE ���̺��� �ٹ� ����� 25�� �̻��� ���� ���� ��ȸ

SELECT *
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >= 25;

-- 20. EMPLOYEE ���̺��� �����, �޿� ��ȸ (��, �޿��� '\9,000,000' �������� ǥ��)

SELECT EMP_NAME AS �����, TO_CHAR(SALARY, 'L999,999,999') AS �޿�
FROM EMPLOYEE;

-- 21.  EMPLOYEE ���̺��� �����, �μ��ڵ�, �������, ����(��) ��ȸ
-- (��, ��������� �ֹι�ȣ���� �����ؼ� 00�� 00�� 00�Ϸ� ��µǰ� �ϸ� ���̴� �ֹι�ȣ���� ����ؼ� ��¥�����ͷ� ��ȯ�� ���� ���)

SELECT EMP_NAME AS �����,
          DEPT_CODE AS �μ��ڵ�,
          TO_NUMBER(SUBSTR(EMP_NO, 1, 2)) || '��' || ' ' || SUBSTR(EMP_NO, 3, 2) || '��' || ' ' || SUBSTR(EMP_NO,5,2) || '��' AS �������,
          EXTRACT (YEAR FROM SYSDATE) - EXTRACT (YEAR FROM TO_DATE(SUBSTR (EMP_NO, 1, 2),'RR')) AS ����
FROM EMPLOYEE;

-- 22. EMPLOYEE ���̺��� �μ��ڵ尡 D5, D6, D9�� ����� ��ȸ�ϵ� D5�� �ѹ���, D6�� ��ȹ��, D9�� �����η�ó�� (��, �μ��ڵ� ������������ ����)

SELECT EMP_ID AS �������̵�, EMP_NAME AS �̸�, DEPT_CODE AS �μ��ڵ�, 
           CASE
                WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
                WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
                WHEN DEPT_CODE = 'D9' THEN '������'
            END AS �μ�
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9');

-- 23. EMPLOYEE���̺��� ����� 201���� �����, �ֹι�ȣ ���ڸ�, �ֹι�ȣ ���ڸ�, �ֹι�ȣ ���ڸ��� ���ڸ��� �� ��ȸ

SELECT EMP_NAME AS �����, SUBSTR(EMP_NO, 1, 6) AS "�ֹι�ȣ ���ڸ�", SUBSTR(EMP_NO, 8) AS "�ֹι�ȣ ���ڸ�",
          SUBSTR(EMP_NO, 1, 6) + SUBSTR(EMP_NO, 8) AS "�ֹι�ȣ �� ���ڸ� ��"
FROM EMPLOYEE
WHERE EMP_ID = '201';

-- 24. EMPLOYEE ���̺��� �μ��ڵ尡 D5�� ������ ���ʽ� ���� ���� �� ��ȸ

SELECT SUM((SALARY * 12) + (NVL(SALARY * BONUS, 0) * 12)) AS "D5 �μ� ���� ��"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

SELECT *
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2001;

-- 25. EMPLOYEE���̺��� �������� �Ի��Ϸκ��� �⵵�� ������ �� �⵵�� �Ի� �ο��� ��ȸ, ��ü ���� ��, 2001��, 2002��, 2003��, 2004��

SELECT COUNT(*) AS ��ü����,
          COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2001 THEN 1 END) AS "2001��",
          COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2002 THEN 1 END) AS "2002��",
          COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2003 THEN 1 END) AS "2003��",
          COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2004 THEN 1 END) AS "2004��"
FROM EMPLOYEE;