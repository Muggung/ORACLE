-- 1. 4개의 테이블에 포함된 데이터 건 수를 구하는 SQL 구문을 만드는 SQL 구문 작성

SELECT COUNT(*) AS TB_BOOK FROM TB_BOOK;
SELECT COUNT(*) AS TB_BOOK_AUTOR FROM TB_BOOK_AUTHOR;
SELECT COUNT(*) AS TB_PUBLISHER FROM TB_PUBLISHER;
SELECT COUNT(*) AS TB_WRITER FROM TB_WRITER;

-- 2. 도서명이 25자 이상인 책 번호와 도서명을 조회하는 SQL 구문 작성

SELECT BOOK_NO AS 도서번호, BOOK_NM AS 도서명
FROM TB_BOOK
WHERE LENGTH(BOOK_NM) >= 25;

-- 3. 휴대폰 번호가 '019'로 시작하는 김씨 성을 가진 작가를 이름순으로 정렬했을 때,
-- 가장 먼저 표시되는 작가명, 사무실번호, 집번호, 휴대폰번호를 조회하는 SQL구문 작성

SELECT *
FROM (
    SELECT WRITER_NM AS 작가명, OFFICE_TELNO AS 사무실번호, HOME_TELNO AS 집번호, MOBILE_NO AS 휴대폰번호
    FROM TB_WRITER
    WHERE WRITER_NM LIKE '김%' AND MOBILE_NO LIKE '019%'
    ORDER BY 1)
WHERE ROWNUM = 1;

-- 4. 저작 형태가 '옮김'에 해당하는 작가들이 총 몇 명인지 계산하는 SQL구문 작성
-- 단, 결과 헤더는 '작가(명)'으로 표시할 것

SELECT COUNT(*) || '명' AS "작가"
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE = '옮김';

-- 5. 300권 이상 등록된 도서의 저작 형태 및 등록된 도서 수량을 표시하는 SQL구문 작성
-- 단, 저작형태가 등록되지 않는 경우 제외

SELECT COMPOSE_TYPE AS 도서저작형태, COUNT(*) AS "등록 수"
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IS NOT NULL
GROUP BY COMPOSE_TYPE
HAVING COUNT(*) > 300;

-- 6. 가장 최근에 발간된 최산작 이름과 발행일자, 출판사 이름을 조회하는 SQL구문 작성

SELECT BOOK_NM AS 도서명, ISSUE_DATE AS 발행일, PUBLISHER_NM AS 출판사
FROM (SELECT * FROM TB_BOOK ORDER BY ISSUE_DATE DESC)
WHERE ROWNUM = 1;

-- 7. 가장 많은 책을 쓴 작가 3명의 이름, 수량을 조회하되,
-- 많이 쓴 순서대로 표시하는 SQL구문 작성
-- 단, 동명이인 작가는 없다고 가정하고 헤더는 '작가이름', '권 수'로 표시

SELECT *
FROM (SELECT WRITER_NM AS 작가명, COUNT(*) AS "권 수" FROM TB_WRITER JOIN TB_BOOK_AUTHOR USING(WRITER_NO)
    GROUP BY WRITER_NM ORDER BY 2 DESC)
WHERE ROWNUM < 4;

-- 8. 작가 정보 테이블의 모든 등록일자 항목이 누락되어 있는 걸 발견하였다. 누락된 등록일자 값을 각 작가의
-- ‘최초 출판도서의 발행일과 동일한 날짜’로 변경시키는 SQL 구문 작성 (COMMIT 처리할 것)

UPDATE TB_WRITER T
SET REGIST_DATE = (
    SELECT MIN(ISSUE_DATE) 
    FROM TB_BOOK 
        JOIN TB_BOOK_AUTHOR USING (BOOK_NO) 
    WHERE WRITER_NO = T.WRITER_NO
    GROUP BY WRITER_NO
); 
COMMIT;

-- 9. 현재 도서저자정보 테이블은 저서와 번역서를 구분 없이 관리하고 있다.
-- 앞으로는 번역서는 따로 관리하려고 할 때, 제시된 내용에 맞게 “TB_BOOK_ TRANSLATOR” 테이블을 생성하는 SQL구문 작성
-- 단, PK 제약 조건 이름은 “PK_BOOK_TRANSLATOR”로 하고, FK 제약 조건 이름은 “FK_BOOK_TRANSLATOR_01”, “FK_BOOK_TRANSLATOR_02”로 할 것

CREATE TABLE TB_BOOK_TRANSLATOR (
    BOOK_NO VARCHAR2 (10) NOT NULL CONSTRAINT FK_BOOK_TRANSLATOR_01 REFERENCES TB_BOOK (BOOK_NO),
    WRITER_NO VARCHAR2 (10) NOT NULL CONSTRAINT FK_BOOK_TRANSLATOR_02 REFERENCES TB_WRITER (WRITER_NO),
    TRANS_LANG VARCHAR2 (60),
    CONSTRAINT PK_BOOK_TRANSLATOR PRIMARY KEY (BOOK_NO, WRITER_NO)
);

COMMENT ON COLUMN TB_BOOK_TRANSLATOR.BOOK_NO IS '도서번호'; 
COMMENT ON COLUMN TB_BOOK_TRANSLATOR.WRITER_NO IS '작가번호';
COMMENT ON COLUMN TB_BOOK_TRANSLATOR.TRANS_LANG IS '번역언어';

-- 10. 도서저작형태(COMPOSE_TYPE)가 '옮김', '역주', '편역', '공역'에 해당하는 데이터는
-- 도서저자정보 테이블에서 도서역자정보 테이블(TB_BOOK_TRANSLATOR)로 옮기는 SQL구문 작성
-- 단, “TRANS_LANG” 컬럼은 NULL로 한고 이동된 데이터는 더이상 TB_BOOK_AUTHOR 테이블에 남아 있지 않도록 삭제

INSERT INTO TB_BOOK_TRANSLATOR (BOOK_NO, WRITER_NO)
SELECT BOOK_NO, WRITER_NO
FROM TB_BOOK_AUTHOR 
WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역');

DELETE FROM TB_BOOK_AUTHOR WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역');

-- 11. 2007년도에 출판된 번역서 도서명, 번역자(역자)를 조회하는 SQL구문 작성

SELECT BOOK_NM AS 도서명, WRITER_NM AS 번역자
FROM TB_BOOK_TRANSLATOR
    JOIN TB_BOOK USING (BOOK_NO)
    JOIN TB_WRITER USING (WRITER_NO)
WHERE ISSUE_DATE LIKE '07%';

-- 12 . '11번 문제' 결과를 활용해 대상 번역서들의 출판일을 변경할 수 없게 하는 뷰를 생성하는 SQL구문 작성
-- 단, 뷰 이름은 'VW_BOOK_TRANSLATOR'로 하고, 도서명, 번역자, 출판일을 표시할 것

-- 13. 새로운 출판사(춘 출판사)와 거래 계약을 맺게 되었다. 제시된 정보를 입력하는 SQL구문 작성, (COMMIT할 것)

INSERT INTO TB_PUBLISHER VALUES ('춘 출판사', '02-6710-3737', DEFAULT);
COMMIT;

-- 14. 동명이인 작가를 찾으려 한다. 이름과 동명이인 숫자를 표시하는 SQL구문 작성

SELECT WRITER_NM AS 작가명, COUNT(*) AS "동명이인 수"
FROM TB_WRITER
GROUP BY WRITER_NM
HAVING COUNT(*) > 1;

-- 15. 도서의 저자 정보 중 저작 형태(COMPOSE_TYPE)가 누락된 데이터들이 존재한다.
-- 해당 컬럼이 NULL인 경우 '지음'으로 변경하는 SQL 구문을 작성하시오. (COMMIT할 것)

UPDATE TB_BOOK_AUTHOR
SET COMPOSE_TYPE = '지음'
WHERE COMPOSE_TYPE IS NULL;
COMMIT;

-- 16. 서울지역 작가모임을 개최하려한다. 사무실이 서울이고, 사무실번호 국번이 3자리인 작가명, 사무실번호를 표시하는 SQL구문 작성

SELECT WRITER_NM AS 작가명, OFFICE_TELNO AS 사무실번호
FROM TB_WRITER
WHERE OFFICE_TELNO LIKE '02%' AND OFFICE_TELNO LIKE '__-___-%';

-- 17. 2006년 1월 기준으로 등록된 지 31년 이상된 작가명을 이름순으로 표시하는 SQL구문 작성

SELECT WRITER_NM AS 작가명
FROM TB_WRITER
WHERE MONTHS_BETWEEN (TO_DATE('06/01', 'RR/MM'), REGIST_DATE) / 12 >= 31
ORDER BY 1;

-- 18. '황금가지' 출판사를 위한 기획전을 열려고 한다. '황금가지' 출판사에서 발행한 도서 중 
-- 재고 수량이 10권 미만인 도서명, 가격, 재고상태를 표시하는 SQL구문 작성
-- 단, 재고 수량이 5권 미만 도서는 ‘추가주문필요’, 나머지는 ‘소량보유’로 표시하고, 재고수량 많은 순, 도서명 순으로 표시

SELECT BOOK_NM AS 도서명, PRICE AS 가격,
    CASE
        WHEN STOCK_QTY < 5 THEN '추가주문필요'
        ELSE '소량보유'
    END AS 재고
FROM TB_PUBLISHER
    JOIN TB_BOOK USING (PUBLISHER_NM)
WHERE STOCK_QTY < 10 AND PUBLISHER_NM = '황금가지'
ORDER BY STOCK_QTY DESC, 1;

-- 19. '아타트롤'도서 작가와 역자를 표시하는 SQL구문 작성 (결과 헤더는 '도서명', '저자', '역자'로 표시)

SELECT BOOK_NM AS 도서명, TW.WRITER_NM AS 저자, TWR.WRITER_NM AS 역자
FROM TB_BOOK TB
    JOIN TB_BOOK_AUTHOR TBA ON TB.BOOK_NO = TBA.BOOK_NO
    JOIN TB_WRITER TW ON TBA.WRITER_NO = TW.WRITER_NO
    
    JOIN TB_BOOK_TRANSLATOR TBT ON TB.BOOK_NO = TBT.BOOK_NO
    JOIN TB_WRITER TWR ON TBT.WRITER_NO = TWR.WRITER_NO
WHERE BOOK_NM = '아타트롤'
UNION
SELECT BOOK_NM AS 도서명, WRITER_NM AS 저자, WRITER_NM AS 역자
FROM TB_WRITER 
    JOIN TB_BOOK_TRANSLATOR USING (WRITER_NO)
    JOIN TB_BOOK USING (BOOK_NO)
WHERE BOOK_NM = '아타트롤';

-- 20. 현재기준 최초 발행일로부터 만 30년이 경과되고, 재고수량이 90권 이상인 도서명, 재고수량, 가격, 20% 인하 가격을 표시하는 SQL구문 작성
-- 단, 결과 헤더는 '도서명', '재고수량', '가격(Org)', '가격(New)'처럼 표시하고
-- 재고 수량이 많은 순, 할인 가격이 높은 순, 도서명순으로 조회

SELECT BOOK_NM AS 도서명, STOCK_QTY AS 재고수량, TO_CHAR(PRICE, 'L99,999') AS "가격(Org)", TO_CHAR((PRICE - (PRICE * 0.2)), 'L99,999') AS "가격(NEW)"
FROM TB_BOOK
WHERE FLOOR(MONTHS_BETWEEN (SYSDATE, ISSUE_DATE) / 12) > 30 AND STOCK_QTY >= 90
ORDER BY 2 DESC, 3 DESC, 4 DESC, 1 DESC;
