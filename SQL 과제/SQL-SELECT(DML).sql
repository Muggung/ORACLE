-- 1. �������� ���̺�(TABLE_CLASS_TYPE)�� ������ �Է��ϱ�

INSERT INTO TB_CLASS_TYPE VALUES('01', '�����ʼ�');
INSERT INTO TB_CLASS_TYPE VALUES('02', '��������');
INSERT INTO TB_CLASS_TYPE VALUES('03', '�����ʼ�');
INSERT INTO TB_CLASS_TYPE VALUES('04', '���缱��');
INSERT INTO TB_CLASS_TYPE VALUES('05', '������');

-- 2. �� ���� �л����� ������ ���ԵǾ� �ִ� �л� ���̺� �����

CREATE TABLE TB_�л��Ϲ�����
    AS
        SELECT  STUDENT_NO AS �й�, STUDENT_NAME AS �л��̸�, STUDENT_ADDRESS AS �ּ�
        FROM TB_STUDENT;

-- 3. ������а� �л����� ������ ���Ե� �а����� ���̺� �����

CREATE TABLE TB_������а�
    AS
        SELECT STUDENT_NO AS �й�, STUDENT_NAME AS �л��̸�,
            EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RR/MM/DD')) AS ����⵵
            , PROFESSOR_NAME AS �����̸�
        FROM TB_STUDENT
            JOIN TB_PROFESSOR ON COACH_PROFESSOR_NO = PROFESSOR_NO;
            
-- 4. �� �а��� ������ 10% ������Ű��
-- ��, �Ҽ��� �ڸ����� ǥ�� X

UPDATE TB_DEPARTMENT
SET CAPACITY = FLOOR(CAPACITY + CAPACITY * 0.1);            

-- 5. 'A413042' �й��� �ڰǿ� �л��� �ּҸ� '����� ���α� ���ε� 181-21'�� ����

UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '����� ���α� ���ε� 181-21'
WHERE STUDENT_NO = 'A413042' AND STUDENT_NAME = '�ڰǿ�';

-- 6. �ֹι�ȣ ��ȣ���� ���� �л����� ���̺��� �ֹι�ȣ ���ڸ��� �������� �ʱ�� �����ߴ�.
-- �� ������ �ݿ��ϱ�

UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);

-- 7. ���а� ����� �л��� 2005�� 1�б⿡ ������ '�Ǻλ�����'������ �߸��Ǿ��ٰ� ���� ��û�� �ߴ�.
-- ��米���� Ȯ�� ��� �ش� ������ ������ 3.5�� �����ߴ�.
-- �ش� SQL�� �ۼ��ϱ�

UPDATE TB_GRADE
SET  POINT = 3.5
WHERE (STUDENT_NO,TERM_NO) = 
    (SELECT STUDENT_NO, TERM_NO FROM TB_STUDENT
        JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
        JOIN TB_GRADE USING(STUDENT_NO)
        JOIN TB_CLASS USING(DEPARTMENT_NO)
    WHERE STUDENT_NAME = '�����' AND DEPARTMENT_NAME = '���а�' AND CLASS_NAME = '�Ǻλ�����' AND TERM_NO = 200501);

-- 8. ���� ���̺�(TB_GRADE)���� ���л����� �����׸� ����

DELETE FROM (SELECT POINT, ABSENCE_YN FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO))
WHERE ABSENCE_YN = 'Y'; 