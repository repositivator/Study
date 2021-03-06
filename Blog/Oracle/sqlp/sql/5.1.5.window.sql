CREATE TABLE eq_mes
(
    sn NUMBER,
    status CHAR(1),
    value NUMBER,
    CONSTRAINT EQ_MES_PK PRIMARY KEY (sn)
);
INSERT INTO EQ_MES VALUES (1, 'A', 123);
INSERT INTO EQ_MES VALUES (2, NULL, 242);
INSERT INTO EQ_MES VALUES (3, NULL, 513);
INSERT INTO EQ_MES VALUES (4, 'C', 559);
INSERT INTO EQ_MES VALUES (5, NULL, 276);
INSERT INTO EQ_MES VALUES (6, 'B', 242);
INSERT INTO EQ_MES VALUES (7, NULL, 098);
INSERT INTO EQ_MES VALUES (8, NULL, 128);   
INSERT INTO EQ_MES VALUES (9, 'A', 427);
INSERT INTO EQ_MES VALUES (10, NULL, 37);

SELECT * FROM EQ_MES;

SELECT a.SN,
       NVL(a.STATUS, (SELECT b.STATUS 
                        FROM EQ_MES b 
                       WHERE b.SN  = (SELECT MAX(SN) 
                                        FROM EQ_MES c 
                                       WHERE c.SN < a.SN 
                                         AND c.STATUS IS NOT NULL))) STATUS,
       a.VALUE
  FROM EQ_MES a;


SELECT a.SN,
       NVL(a.STATUS, (SELECT /*+ index_desc(b EQ_MES_PK) */ b.STATUS 
                        FROM EQ_MES b 
                       WHERE b.SN  < a.SN
                         AND b.STATUS IS NOT NULL
                         AND ROWNUM <= 1)) STATUS,
       a.VALUE
  FROM EQ_MES a;
  
SELECT SN,
       LAST_VALUE(STATUS IGNORE NULLS) OVER (ORDER BY SN ROWS BETWEEN UNBOUNDED PRECEDING AND  CURRENT ROW) STATUS,
       VALUE
  FROM EQ_MES
 ORDER BY SN;
