--SCD 1 SQL

MERGE INTO TGT_TABLE TGT
USING SOURCE_TABLE  SRC
ON TGT.ID = SRC.ID 

WHEN MATCHED THEN
UPDATE SET TGT.VALUE = SRC.VALUE , TGT.TIME = SRC.TIME

WHEN NOT MATCHED THEN
INSERT (ID , VALUE) 
VALUES (SRC.ID , SRC.VALUE)


--SCD 2 SQL

with cte as (
---brings only changed records----
SELECT 
  SRC.empid AS merge_key, 
       SRC.*
   FROM sourcetable AS SRC
   INNER JOIN employee TGT ON SRC.empid = TGT.empid
   WHERE TGT.activeflag = 1 AND TGT.salary <> SRC.salary (add another columns which change can occur)

   union
----brings new records and changed records as brandnew----
   select null as merge_key , 
   src.* 
   from sourcetable SRC
   LEFT JOIN employee TGT ON SRC.empid = TGT.empid AND TGT.activeflag = 1
    WHERE TGT.empid IS NULL OR TGT.salary <> SRC.salary (add another columns which change can occur)
    )

----SCD 2 EXACT CODE ----
   merge into employee e 
   using cte c 
   on c.merge_key = e.empid

--- expires changed  records---
   when matched and e.activeflag = 1 then 
   update set e.activeflag= 0 , e.enddate = getdate()

---insertes new records and changed records---
   when not matched then 
   insert (empid ,empname , salary  , activeflag, startdate , enddate )
   values (c.empid ,c.empname , c.salary , 1 , GETDATE() , '9999-12-31' );




try :
 



select * from (select * from emp order by salary desc limit 3) order by salary asc limit 1 

OUTPUT : 
F
U
L
L

with cte as 
(SELECT 1 AS pos
UNION  
SELECT pos+1 FROM cte WHERE pos < length('FULL') )
SELECT substring('FULL' , pos , 1) FROM cte 
