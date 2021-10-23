-- Method 2: Finding duplicates in table: fact_table using Common Table Expression (CTE)

WITH CTE as
(
select*, ROW_NUMBER() OVER (partition by Topic_id order by DataValue) Duplicates
from fact_table
) 
select * from CTE
where Duplicates >1;
