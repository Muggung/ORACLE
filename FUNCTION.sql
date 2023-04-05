-- 1. ������� �̸��� , �̸��� ���̸� ����Ͻÿ�

SELECT EMP_NAME AS ������, EMAIL AS �̸���, LENGTH(EMAIL)
FROM EMPLOYEE;

-- 2. 60��뿡 �¾ ������� ���, ���ʽ� ���� ����Ͻÿ�. �׶� ���ʽ� ���� null�� ��쿡�� 0 �̶�� ��� �ǰ� ����ÿ�

SELECT EMP_NAME AS ������, EXTRACT(YEAR FROM HIRE_DATE) AS ���, NVL(BONUS, 0) AS ���ʽ�
FROM EMPLOYEE;

-- 3. '010' �ڵ��� ��ȣ�� ���� �ʴ� ����� ���� ����Ͻÿ� (�ڿ� ������ ���� ���̽ÿ�)

SELECT COUNT(CASE WHEN PHONE NOT LIKE '010%' THEN 1 END) || '��' AS ������
FROM EMPLOYEE;

-- 4. ������� �Ի����� ����Ͻÿ� (��, YYYY�� MM�� �������� ���)

SELECT EMP_NAME AS ������, EXTRACT(YEAR FROM HIRE_DATE) || '�� ' || EXTRACT(MONTH FROM HIRE_DATE) || '��' AS �Ի���
FROM EMPLOYEE;

-- 5. ������� �ֹι�ȣ�� ��ȸ�Ͻÿ� (��, �ֹι�ȣ 9��° �ڸ����� �������� '*' ���ڷ� ä������� �Ͻÿ�)

SELECT EMP_NAME AS ������, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') AS �ֹι�ȣ
FROM EMPLOYEE;

-- 6. ������, �����ڵ�, ����(��) ��ȸ (��, ������ ��57,000,000 ���� ǥ�õǰ� ��)

SELECT EMP_NAME AS ������, JOB_CODE AS �����ڵ�, TO_CHAR(SALARY * 12 + (SALARY * NVL(BONUS, 0)) * 12, 'L900,000,000') AS "����(��)"
FROM EMPLOYEE;

-- 7. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� �����߿� ��ȸ��, ��� ����� �μ��ڵ� �Ի���

SELECT EMP_NO AS ������ȣ, EMP_NAME AS ������, DEPT_CODE AS �μ��ڵ�, HIRE_DATE AS �Ի���
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;

-- 8. ������, �Ի���, ���ñ����� �ٹ��ϼ� ��ȸ (* �ָ��� ���� , �Ҽ��� �Ʒ��� ����)

SELECT EMP_NAME AS ������, HIRE_DATE AS �Ի���, FLOOR(SYSDATE - HIRE_DATE) AS �ٹ��ϼ�
FROM EMPLOYEE;

-- 9. �������� �Ի��Ϸ� ���� �⵵�� ������, �� �⵵�� �Ի��ο����� ���Ͻÿ�.
-- �Ʒ��� �⵵�� �Ի��� �ο����� ��ȸ�Ͻÿ�. ���������� ��ü�������� ���Ͻÿ�. (DECODE, SUM ���)

SELECT COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 1998, 1)) || '��' AS "1998��",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 1999, 1)) || '��' AS "1999��",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2000, 1)) || '��' AS "2000��",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2001, 1)) || '��' AS "2001��",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2002, 1)) || '��' AS "2002��",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2003, 1)) || '��' AS "2003��",
          COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2004, 1)) || '��' AS "2004��",
          COUNT(*) || '��' AS ��ü����
FROM EMPLOYEE;

-- 10. ������, �μ����� ����ϼ���, �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.
-- ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ�ϰ�, �μ��ڵ� �������� �������� ������.

SELECT EMP_NAME AS ������,
          CASE
                WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
                WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
                WHEN DEPT_CODE = 'D9' THEN '������' 
          END AS �μ���
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY DEPT_CODE;

-- 11. EMPLOYEE ���̺��� ������ J1�� �����ϰ�, ���޺� ����� �� ��ձ޿��� ����ϼ���.

SELECT DEPT_CODE AS ����, COUNT(DEPT_CODE) || '��' AS �����, FLOOR(AVG(SALARY)) || '��' AS ��ձ޿�
FROM EMPLOYEE
WHERE DEPT_CODE NOT LIKE 'J1'
GROUP BY DEPT_CODE;

-- 12. EMPLOYEE���̺��� ������ J1�� �����ϰ�,  �Ի�⵵�� �ο����� ��ȸ�ؼ�, �Ի�� �������� �������� �����ϼ���.

SELECT EXTRACT(YEAR FROM HIRE_DATE) AS �Ի�⵵, COUNT(*) AS �����
FROM EMPLOYEE
WHERE DEPT_CODE NOT LIKE 'J1'
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
ORDER BY EXTRACT(YEAR FROM HIRE_DATE);

-- 13. EMPLOYEE ���̺��� EMP_NO�� 8��° �ڸ��� 1, 3 �̸� '��', 2, 4 �̸� '��'�� ����� ��ȸ�ϰ�,
-- ������ �޿��� ���(����ó��), �޿��� �հ�, �ο����� ��ȸ�� �� �ο����� ���������� ���� �Ͻÿ�

SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��') AS ����,
          FLOOR(AVG(SALARY)) AS ���,
          SUM(SALARY) AS "�޿� ��",
          COUNT(*) AS �ο���
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��')
ORDER BY COUNT(*) DESC;

-- 14. �μ��� �ο��� 3���� ���� �μ��� �ο����� ����ϼ���.

SELECT DEPT_CODE AS �μ��ڵ�, COUNT(DEPT_CODE) AS �ο��� 
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(DEPT_CODE) > 3;

-- 15. �μ��� ���޺� �ο����� 3���̻��� ������ �μ��ڵ�, �����ڵ�, �ο����� ����ϼ���.

SELECT DEPT_CODE AS �μ��ڵ�, JOB_CODE AS �����ڵ�, COUNT(*) AS �ο���
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
HAVING COUNT(DEPT_CODE) >= 3 AND COUNT(JOB_CODE) >= 3;

-- 16. �Ŵ����� �����ϴ� ����� 2���̻��� �Ŵ������̵�� �����ϴ� ������� ����ϼ���.

SELECT E.MANAGER_ID AS "�Ŵ������̵�", COUNT(*) AS �����
FROM EMPLOYEE E JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID
GROUP BY E.MANAGER_ID, M.EMP_ID
HAVING COUNT(E.MANAGER_ID)  >= 2;

-- 17. �μ���� �������� ����ϼ���. DEPARTMENT, LOCATION ���̺� �̿�

SELECT DEPT_TITLE AS �μ���, LOCAL_NAME AS ������
FROM DEPARTMENT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

-- 18. ������� �������� ����ϼ���. LOCATION, NATION ���̺�

SELECT L.LOCAL_NAME AS ������, N.NATIONAL_NAME AS ������ 
FROM LOCATION L JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;

-- 19. ������� �������� ����ϼ���. LOCATION, NATION ���̺��� �����ϵ� USING�� ����Ұ�.

SELECT LOCAL_NAME AS ������, NATIONAL_NAME AS ������ 
FROM LOCATION JOIN NATIONAL USING(NATIONAL_CODE);