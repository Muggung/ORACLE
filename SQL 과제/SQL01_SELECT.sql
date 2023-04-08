-- 1. �� ������б��� �а� �̸��� �迭�� ǥ���ϱ�,
-- ��, ��� ����� '�а���', '�迭'�� ǥ���Ѵ�.

SELECT DEPARTMENT_NAME AS �а���, CATEGORY AS �迭
FROM TB_DEPARTMENT;

-- 2. �а��� �а� ������ '@@���� ������ 00�� �Դϴ�.'�� ���� ���·� ���

SELECT DEPARTMENT_NAME || '�� ������ ' || CAPACITY || '���Դϴ�.' AS "�а��� ����"
FROM TB_DEPARTMENT;

-- 3. "������а�"�� �ٴϴ� ���л� �� ���� �������� ���л��� ã�� ���

SELECT STUDENT_NAME AS �л��̸�
FROM TB_DEPARTMENT JOIN TB_STUDENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NO = '001' AND SUBSTR(STUDENT_SSN, 8, 1) = '2' AND ABSENCE_YN = 'Y';

-- 4. ���������� ���� ��� ��ü�ڵ��� ã�� �̸��� ���
-- ����� �й� : A513079 | A513090 | A513091 | A513110 | A513119

SELECT STUDENT_NAME AS �л��̸�
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079',  'A513090', 'A513091', 'A513110', 'A513119');

-- 5. ���������� 20�� �̻� 30�� ������ �а����� �а� �̸��� �迭�� ���

SELECT DEPARTMENT_NAME AS �а���, CATEGORY AS �迭
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

-- 6. �� ���б��� ������ �����ϰ� ��� �������� �Ҽ� �а��� ������. ������ �̸��� ���

SELECT PROFESSOR_NAME AS ����
FROM TB_DEPARTMENT RIGHT JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NO IS NULL;

-- 7. ������� ������ �а��� �������� ���� �л��� �ִ��� ���

SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO = ' ' OR DEPARTMENT_NO IS NULL;

-- 8. ������û, ���������� Ȯ���ؾ� �ϴµ�, ���������� � �������� ��ȸ

SELECT CLASS_NO AS ��������
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 9. �� ���п��� � �迭���� �ִ��� ��ȸ

SELECT CATEGORY AS �迭
FROM TB_DEPARTMENT
GROUP BY CATEGORY;

-- 10. 02�й� ���ֿ� �����ϴ� �л����� �й�, �̸�, �ֹι�ȣ�� ���(��, ������ ��� ����)

SELECT STUDENT_NO AS �й�, STUDENT_NAME AS �̸�, STUDENT_SSN AS �ֹι�ȣ
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '%����%' AND STUDENT_NO LIKE 'A2%' AND ABSENCE_YN = 'N';