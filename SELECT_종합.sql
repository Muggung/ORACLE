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
-- 1. JOIN�� �̿��Ͻÿ�

SELECT E.EMP_ID AS �����ȣ, E.EMP_NAME AS �̸�, M.EMP_NAME AS �Ŵ����̸�, E.SALARY AS ����
FROM EMPLOYEE E JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

-- 2. JOIN���� �ʰ�, ��Į��������(SELECT)�� �̿��ϱ�

SELECT EMP_ID AS �����ȣ, EMP_NAME AS �̸�, 
       (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS �Ŵ����̸�, SALARY AS ����
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);