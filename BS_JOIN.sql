-- 1. 70��� ��(1970~1979) �� �����̸鼭 ������ ����� �̸��� �ֹι�ȣ, �μ� ��, ���� ��ȸ
SELECT EMP_NAME AS �����, EMP_NO AS �ֹι�ȣ, DEPT_TITLE AS �μ���, JOB_CODE AS ����
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE SUBSTR(EMP_NO, 1, 2) BETWEEN 70 AND 79
           AND SUBSTR(EMP_NO, 8, 1) = 2
           AND EMP_NAME LIKE '��%'; 

