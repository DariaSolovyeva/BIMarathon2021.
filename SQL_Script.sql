-- Add Duplicate row in fact_table
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

-- Deleting duplicates from table: fact_table using the ROW_NUMBER () function
delete from fact_table where Fact_id in (
select Fact_id from (select Fact_id, ROW_NUMBER()
OVER (partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit,
		   HighConfidenceLimit, Location_id, Topic_id, DataValueType_id,
                   StratificationCategory_id order by DataValue) as Duplicates
from fact_table) as temp_table 
where Duplicates>1
);

-- Double checking for duplicates after running the delete script using Common Table Expression
WITH CTE as 
(
select*, ROW_NUMBER() OVER (partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit,
			                 HighConfidenceLimit, Location_id, Topic_id, DataValueType_id,
                                         StratificationCategory_id order by DataValue) as Duplicates
from fact_table
)
select * from CTE
where Duplicates >1;

-- Double checking for duplicates after running the delete script using ROW_NUMBER() function
select * from (select*, ROW_NUMBER() OVER (partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit,
				                        HighConfidenceLimit, Location_id, Topic_id, DataValueType_id,
                                                        StratificationCategory_id order by DataValue) as Duplicates
from fact_table) as temp_table
where Duplicates>1;

-- Using CASE WHEN to find the Impact on Gestation (Risk of termination of pregnancy from the influence of various factors
select  distinct DataValue, q.Question, s.Stratification1 ,case
             when  Question ='Alcohol use before pregnancy' then ' High risk'
             when Question = 'Cigarette smoking before pregnancy' then 'Medium risk'
             when Question = 'Preventive dental care before pregnancy' then 'Little risk'
	     when Question = 'Folic acid supplementation' then 'Prevents risk'
             else 'Normal'
             end as ImpactOnGestation
from fact_table t
join dim_stratification_category s on t.StratificationCategory_id = s.StratificationCategory_pkid
join dim_topic tp on t.Topic_id = tp.Topic_pkid
join dim_question q on tp.Topic_pkid = q.Question_pkid;
             
-- USING DISTINCT function to find the unique values for the Question
select distinct Question from dim_question;

-- Update columns in fact table and SET NULL VALUE
update fact_table set HighConfidenceLimit = NULL where Fact_id = 22;
update fact_table set HighConfidenceLimit = NULL where Fact_id = 23;
update fact_table set HighConfidenceLimit = NULL where Fact_id = 24;

-- Mapping NULL value with the 'No value' in table: fact_table with a COALESCE function
select*, coalesce(LowConfidenceLimit, 'No value') as LowConfidenceLimit
from fact_table;

-- Mapping NULLIF function to map the 'No data available' column DatavalueFootnote in table 
select*, nullif(DatavalueFootnote, 'No data available') as NullLowConfident
from fact_table t
join dim_topic d on t.Topic_id = d.Topic_pkid
order by NullLowConfident;

-- Using GREATEST function to map the LowConfidenceLimit
select*, 
greatest(0.20, LowConfidenceLimit) as LowConfidenceLimit
from fact_table;

/* Using Common Table Expression to find plot to comparison of Diabetes among women aged 18-44 years for 
different states having sun (DataValue) <5000 */

with CTE_1 as (
select Topic from dim_topic
where Topic = 'Diabetes'
),

CTE_2 as (
select Question
from dim_question
where Question = 'Diabetes prevalence among women aged 18-44 years'
),

CTE_3 as (
select sum(DataValue)<5000 as sumDataValue
from fact_table
where date_format(str_to_date(YearStart, '%d/%m/%y'), '%y') between '19' and '20'
)
select Topic,
       DataValue,
       Question
from fact_table
where Topic in (select Topic from CTE_1)
and Question in (select question from CTE_2)
and DataValue < (select sumDataValue from CTE_3);







