-- ����1
-- ��������ο� ���� ������� ����� �̸�,�μ��ڵ�,�޿��� ����Ͻÿ�.

SELECT EMP_NAME AS �����, DEPT_CODE AS �μ��ڵ�, SALARY AS �޿�
FROM EMPLOYEE
WHERE DEPT_CODE = 'D8';

-- ����2
-- ��������ο� ���� ����� �� ���� ������ ���� ����� �̸�,�μ��ڵ�,�޿��� ����Ͻÿ�

SELECT EMP_NAME AS �����, DEPT_CODE AS �μ��ڵ�, SALARY AS �޿�
FROM EMPLOYEE E
WHERE DEPT_CODE = 'D8' AND SALARY >= (SELECT MAX(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D8');

-- ����3
-- �Ŵ����� �ִ� ����߿� ������ ��ü��� ����� �Ѱ� 
-- ���,�̸�,�Ŵ��� �̸�, ������ ���Ͻÿ�. 
-- 3-1. JOIN�� �̿��Ͻÿ�

SELECT E.EMP_ID AS �����ȣ, E.EMP_NAME AS �̸�, M.EMP_NAME AS �Ŵ����̸�, E.SALARY AS ����
FROM EMPLOYEE E JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

-- 3-2. JOIN���� �ʰ�, ��Į��������(SELECT)�� �̿��ϱ�

SELECT EMP_ID AS �����ȣ, EMP_NAME AS �̸�, 
       (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS �Ŵ����̸�, SALARY AS ����
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

-- ����4
-- ���� ������ ��ձ޿����� ���ų� ���� �޿��� �޴� ������ �̸�, �����ڵ�, �޿�, �޿���� ��ȸ

SELECT EMP_NAME AS �����, DEPT_CODE AS �����ڵ�, SALARY AS �޿�, SAL_LEVEL AS �޿����
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = DEPT_ID);

-- ����5
-- �μ��� ��� �޿��� 2200000 �̻��� �μ���, ��� �޿� ��ȸ
-- ��, ��� �޿��� �Ҽ��� ����, �μ����� ���� ��� '����'ó��

SELECT NVL(DEPT_TITLE, '����') AS �μ���, FLOOR(AVG(SALARY)) AS �޿�
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON NVL(DEPT_CODE, 0) = NVL(DEPT_ID, 0)
WHERE (SELECT AVG(SALARY) FROM EMPLOYEE WHERE NVL(DEPT_CODE, 0) = NVL(DEPT_ID, 0)) >= 2200000
GROUP BY DEPT_TITLE;

-- ����6
-- ������ ���� ��պ��� ���� �޴� ���ڻ����
-- �����,���޸�,�μ���,������ �̸� ������������ ��ȸ�Ͻÿ�
-- ���� ��� => (�޿�+(�޿�*���ʽ�))*12    
-- �����,���޸�,�μ���,������ EMPLOYEE ���̺��� ���� ����� ������  

SELECT EMP_NAME AS �����, JOB_NAME AS ���޸�, DEPT_TITLE AS �μ���, (SALARY + (SALARY * NVL(BONUS, 0))) * 12 AS ����
FROM EMPLOYEE 
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
        JOIN JOB USING(JOB_CODE)
WHERE (SALARY + (SALARY * NVL(BONUS, 0))) * 12 < (SELECT AVG(SALARY) FROM EMPLOYEE WHERE NVL(DEPT_CODE, 0) = NVL(DEPT_ID, 0)) * 12
        AND SUBSTR(EMP_NO, 8, 1) = 2
ORDER BY EMP_NAME;

