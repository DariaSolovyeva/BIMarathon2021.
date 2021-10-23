- Add Duplicate row in fact_table
insert into fact_table
     values (2382686, '2017', '2017','11','11', '10.7', '11.3', 1, 1, 2,1);

-- method 1: Finding duplicates in table: fact_table using Group BY and HAVING 
select YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit, HighConfidenceLimit, Location_id,
       Topic_id, DataValueType_id, StratificationCategory_id , count(*) as Duplicates
from fact_table
group by 1,2,3,4,5,6,7,8,9,10
having count(*)>1;

-- method 2: Finding duplicates in table: fact_table using Common Table Expression (CTE)
WITH CTE as
(
select*, ROW_NUMBER() OVER (partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit,
			                 HighConfidenceLimit, Location_id, Topic_id, DataValueType_id, 
                                         StratificationCategory_id order by DataValue) Duplicates
from fact_table
) 
select * from CTE
where Duplicates >1;

-- Method 3. Finding duplicates in table: fact_table using ROW_NUMBER () function
select * from (select*, ROW_NUMBER() OVER (partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit, 
                                                        HighConfidenceLimit, Location_id, Topic_id, DataValueType_id,
                                                        StratificationCategory_id order by DataValue) as Duplicates
from fact_table) as temp_table
where Duplicates>1;


