-- 1. ������а�(�а��ڵ� 002) �л����� �й�, �̸�, ���г⵵�� ���г⵵�� ���� ������ ���

SELECT STUDENT_NO AS �й�, STUDENT_NAME AS �̸�, ENTRANCE_DATE AS ���г⵵
FROM TB_STUDENT
ORDER BY ENTRANCE_DATE;

-- 2. �� ���б� ���� �� �̸��� �����ڰ� �ƴ� ���� �Ѹ��� ã��,
-- �� ������ �̸�, �ֹι�ȣ�� ���

SELECT PROFESSOR_NAME AS �̸�, PROFESSOR_SSN AS �ֹι�ȣ
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3;

-- 3. �� ���б� ���� �������� �̸�, ���̸� ���
-- ��, ���̰� ���� ������ ���, ���� �� 2000�� �� �� ����ڴ� ������ ���̴� �� ���̷� ����Ѵ�.

SELECT PROFESSOR_NAME AS "���� �̸�", 
        FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(TO_NUMBER(SUBSTR(PROFESSOR_SSN, 1, 2)) +
        CASE
                WHEN SUBSTR(PROFESSOR_SSN, 8, 1) IN (1, 2) THEN 1900
                WHEN SUBSTR(PROFESSOR_SSN, 8, 1) IN (3, 4) THEN 2000
        END || SUBSTR(PROFESSOR_SSN, 3, 4), 'RR/MM/DD')) / 12) AS ����
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1';

-- 4. �������� �̸� �� ���� ������ �̸��� ��� (���� 2������ ������ ���ٰ� ����)

SELECT SUBSTR(PROFESSOR_NAME, 2, 3) AS �̸�
FROM TB_PROFESSOR;

-- 5. �� ���б��� ����� �����ڸ� ã�� ���(��, 19�쿡 �����ϸ� ����� ���� ���� ������ ����)

SELECT STUDENT_NO AS �й�, STUDENT_NAME AS �л��̸�
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN, 1, 6))) > 19;

-- 6. 2020�� ũ���������� ���� �������� ���

SELECT TO_CHAR(TO_DATE('20201225'), 'DAY') AS "���������̴�?"
FROM DUAL;

-- 7. TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE('49/10/11', 'YY/MM/DD') �� ���� �� �� �� �� �� ���� �ǹ� �ϴ���
-- �� TO_DATE('99/10/11', 'RR/MM/DD'), TO_DATE('49/10/11', 'RR/MM/DD') �� ���� �� �� �� �� �� ���� �ǹ� �ϴ��� ���
-- ���� �⵵�� ���� �� �ڸ��� ���� ���� ����, ���� ����, ���� ���⸦ ǥ��

SELECT TO_DATE('99/10/11', 'YY/MM/DD') AS "99/10/11", TO_DATE('49/10/11', 'YY/MM/DD') AS "49/10/11",
          TO_DATE('99/10/11', 'RR/MM/DD') AS "RR/10/11", TO_DATE('49/10/11', 'RR/MM/DD') AS "RR/10/11"
FROM DUAL;

-- 8. �� ���б��� 2000�⵵ ���� �����ڵ��� �й��� A�� �����Ѵ�.
-- 2000�⵵ ���� �й��� ���� �л����� �й��� �̸� ���

SELECT STUDENT_NO AS �й�, STUDENT_NAME AS �̸�
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%';

-- 9. �й��� A517178�� �ѾƸ� �л��� ���� �� ������ ���
-- ��, ������ �ݿø��Ͽ� �Ҽ��� ���� ���ڸ������� ǥ��

SELECT ROUND(AVG(POINT), 1) AS ����
FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO)
WHERE STUDENT_NO = 'A517178';

-- 10. �а��� �л� ���� ���Ͽ� '�а���ȣ' '�л���' ������ ����� ����� ���

SELECT DEPARTMENT_NO AS �а���ȣ, COUNT(DEPARTMENT_NO) AS �л���
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO ORDER BY DEPARTMENT_NO;

-- 11. ���������� �������� ���� �л� ���� �� ������ ���

SELECT COUNT(*) AS �л���
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- 12. �й��� A112113�� ���� �л��� �⵵ �� ������ ���� ���
-- ��, ������ �ݿø��Ͽ� �Ҽ��� ���� �� �ڸ��� ǥ��

SELECT SUBSTR(TERM_NO, 1, 4) AS �⵵, ROUND(AVG(POINT), 1) AS ����
FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO)
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO, 1, 4) ORDER BY 1;

-- 13. �а��� ���л� ���� �ľ��ϰ��� �Ѵ�. �а��ڵ�, ���л� ���� ���

SELECT DEPARTMENT_NO �а��ڵ�, COUNT(CASE WHEN ABSENCE_YN = 'Y' THEN 1 END) "���л� �ο�"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO ORDER BY 1;

-- 14. �� ���б��� �ٴϴ� �������� �л����� ã�� ���

SELECT STUDENT_NAME AS �����̸�, COUNT(*) AS "�����̸� �ο�"
FROM TB_STUDENT
HAVING COUNT(*) > 1
GROUP BY STUDENT_NAME ORDER BY 1;

-- 15. �й��� A112113�� ���� �л��� �⵵, �б� �� ������ �⵵ �� ���� ����, �� ������ ���
-- ��, ������ �Ҽ��� 1�ڸ������� �ݿø��ϱ�

SELECT NVL(SUBSTR(TERM_NO, 1, 4), '����') AS �⵵, NVL(SUBSTR(TERM_NO, 5, 2), '���') AS �б� , ROUND(AVG(POINT), 1) AS ����
FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO)
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2));