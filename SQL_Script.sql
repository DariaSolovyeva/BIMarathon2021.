select version();
drop table temp_table;
-- Creating database, dims and facts; upload from temp table (csv file)
create database chronic_disease_inddb;
use chronic_disease_inddb;

create table temp_table
( 	YearStart varchar(50),
	YearEnd varchar(50),
        LocationDesc varchar(255),
	DataSource varchar(500),
	Topic varchar(500),
	Question TEXT,
	DataValueUnit varchar(255),
	DataValueType varchar(255),
	DataValue text,
	DataValueAlt text,
	DatavalueFootnote varchar(255),
	LowConfidenceLimit  text,
	HighConfidenceLimit text,
	StratificationCategory1 varchar(50),
	Stratification1 varchar(255),
	GeoLocation varchar(255),
	LocationID int,
	TopicID varchar(50),
	QuestionID varchar(50),
	DataValueTypeID varchar(50),
	StratificationCategoryID1 varchar(50)
    );
    
    select * from temp_table;
    truncate temp_table; -- delete only data
  
create table dim_location(
	location_pkid int not null auto_increment,
        location_id int,
	locationDesc varchar(255),
	geolocation varchar(255),
        primary key (location_pkid)
);
-- uploading data from temp_table to location table
insert ignore into dim_location(location_id, locationDesc, geolocation)
select distinct LocationID, locationDesc, geolocation from temp_table;
--
select * from dim_location;
drop table dim_location;

-- create Dimention table: datavalue
create table dim_datavalue (
	DataValueType_pkid int not null auto_increment,
        DataValueTypeID varchar(255),
	DataValueType varchar(255),
        DataValueUnit varchar(255),
        primary key(DataValueType_pkid)
  );

  -- uploading data from temp_table to dim_datavalue table
insert ignore into dim_datavalue (DataValueTypeID, DataValueType, DataValueUnit)
select distinct DataValueTypeID, DataValueType, DataValueUnit from temp_table;
select * from dim_datavalue;

-- create Dimention table: stratification_category
create table dim_stratification_category(
	StratificationCategory_pkid int not null auto_increment,
        StratificationCategoryID1 varchar(50), 
	StratificationCategory1 varchar(50),
	Stratification1 varchar(255),
    primary key (StratificationCategory_pkid)
    );
    
-- uploading data from temp_table to stratification_category table
insert ignore into dim_stratification_category(StratificationCategoryID1, StratificationCategory1, Stratification1)
select distinct StratificationCategoryID1, StratificationCategory1, Stratification1 from temp_table;  

select * from dim_stratification_category;

-- create Dimention table: question
create table dim_question(
	Question_pkid int not null auto_increment,
        QuestionID varchar(50),
	Question text,
        primary key(Question_pkid)
 );
 select * from dim_question;
-- uploading data from temp_table to question table
insert ignore into dim_question (QuestionID, Question)
select distinct QuestionID, Question from temp_table;

  create table dim_topic(
	Topic_pkid int not null auto_increment,
        TopicID varchar(50),
        Topic varchar(500),
	DataSource varchar(500),
	DatavalueFootnote varchar(255),
	QuestionID int,
        primary key (Topic_pkid),
        FOREIGN KEY (QuestionID) REFERENCES dim_question (Question_pkid) ON DELETE SET NULL
    );
    
INSERT INTO dim_topic (TopicID, Topic, DataSource, DatavalueFootnote, QuestionID)
SELECT DISTINCT
	  tmp.TopicID
    , tmp.Topic
    , tmp.DataSource
    , tmp.DatavalueFootnote
    , q.Question_pkid
FROM temp_table tmp
JOIN dim_question q ON q.QuestionID = tmp.QuestionID
;
select * from dim_topic;

select  DataSource, count(DataSource) from dim_topic
group by DataSource;

-- create Fact table: fact_table
 create table fact_table (
	Fact_id int not null auto_increment,
        YearStart varchar(50),
	YearEnd varchar(50),
	DataValue text,
	DataValueAlt text,
	LowConfidenceLimit text,
	HighConfidenceLimit text,
        Location_id int,
        Topic_id int,
	DataValueType_id int,
        StratificationCategory_id int,
        primary key(Fact_id),
        foreign key (DataValueType_id) references dim_datavalue (DataValueType_pkid) on delete set null,
        foreign key (Location_id) references dim_location (location_pkid) on delete set null,
        foreign key (Topic_id) references dim_topic (Topic_pkid) on delete set null,
         foreign key (StratificationCategory_id) references dim_stratification_category (StratificationCategory_pkid) on delete set null
    );
    
INSERT INTO fact_table (YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit, HighConfidenceLimit, Location_id,
							 Topic_id, DataValueType_id, StratificationCategory_id)
select distinct
    t.YearStart,
    t.YearEnd,
    t.DataValue,
    t.DataValueAlt,
    t.LowConfidenceLimit,
    t.HighConfidenceLimit,
    l.location_pkid,
    tp.Topic_pkid,
    d.DataValueType_pkid,
    s.StratificationCategory_pkid
from temp_table t
join dim_location l on l.location_id = t.LocationID
join dim_topic tp on tp.TopicID = t.TopicID
join dim_datavalue d on d.DataValueTypeID = t.DataValueTypeID
join dim_stratification_category s on s.StratificationCategoryID1 = t.StratificationCategoryID1;

-- creating duplicates in fact_table
insert into fact_table
     values(2382686, '2017', '2017','11','11', '10.7', '11.3', 1, 1, 2,1);

-- Finding duplicates in table: method 1 - HAVING
select YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit, HighConfidenceLimit, Location_id,
	   Topic_id, DataValueType_id, StratificationCategory_id , count(*) as Duplicates
from fact_table
group by 1,2,3,4,5,6,7,8,9,10
having count(*)>1;

-- Finding duplicates in table: method 1 - Common Table Expression (CTE)
WITH CTE as
(
select *
	,ROW_NUMBER() OVER (
		partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit,
					 HighConfidenceLimit, Location_id, Topic_id, DataValueType_id, 
					 StratificationCategory_id order by DataValue) Duplicates
from fact_table
) 
select * from CTE
where Duplicates > 1;

-- Method 3. Finding duplicates in table: fact_table using ROW_NUMBER () function
select * 
from (
		select *
        ,ROW_NUMBER() OVER (partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit, 
                                                        HighConfidenceLimit, Location_id, Topic_id, DataValueType_id,
                                                        StratificationCategory_id order by DataValue) as Duplicates
from fact_table) as temp_table
where Duplicates>1;

-- Removing duplicates from table: fact_table using the ROW_NUMBER () function
delete from fact_table
where Fact_id in (
		    select Fact_id 
                    from (select Fact_id
				 ,ROW_NUMBER() OVER (partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit,
				 HighConfidenceLimit, Location_id, Topic_id, DataValueType_id,
                                 StratificationCategory_id order by DataValue) as Duplicates
from fact_table) as temp_table 
where Duplicates>1
);

-- Double check for duplicates after removing
WITH CTE as 
(
select *
	, ROW_NUMBER() OVER (partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit,
				          HighConfidenceLimit, Location_id, Topic_id, DataValueType_id,
                                          StratificationCategory_id order by DataValue) as Duplicates
from fact_table
)
select * from CTE
where Duplicates >1;

-- Double checking for duplicates after running the delete script using ROW_NUMBER() function
select * 
from (select *,
			ROW_NUMBER() OVER (partition by YearStart, YearEnd, DataValue, DataValueAlt, LowConfidenceLimit,
				                        HighConfidenceLimit, Location_id, Topic_id, DataValueType_id,
                                                        StratificationCategory_id order by DataValue) as Duplicates
from fact_table) as temp_table
where Duplicates>1;

select avg(DataValue) as sumDataValue
from fact_table;

-- Using CASE WHEN to find the Impact on Gestation (Risk of termination of pregnancy from the influence of various factors
select  distinct DataValue, q.Question, s.Stratification1 ,case
             when Question IN ('Alcohol use before pregnancy',
	                       'Cigarette smoking before pregnancy'
                               'Preventive dental care before pregnancy') then ' Risk'
	     when Question = 'Folic acid supplementation' then 'Prevents risk'
             else 'Normal'
             end as ImpactOnGestation
from fact_table t
join dim_stratification_category s on t.StratificationCategory_id = s.StratificationCategory_pkid
join dim_topic tp on t.Topic_id = tp.Topic_pkid
join dim_question q on tp.Topic_pkid = q.Question_pkid
where s.Stratification1 = 'Female';
             
-- USING DISTINCT function to find the unique values for the Question
select distinct Question from dim_question;

-- Update columns in fact table and SET NULL VALUE
update fact_table 
set HighConfidenceLimit = NULL 
where Fact_id = 22;

update fact_table 
set HighConfidenceLimit = NULL 
where Fact_id = 23;
update fact_table
set HighConfidenceLimit = NULL 
where Fact_id = 24;

-- Mapping NULL value with the 'No value' - COALESCE function
select *
,coalesce(LowConfidenceLimit, 'No value') as LowConfidenceLimit
from fact_table;

-- Mapping NULLIF function to map the 'No data available' column DatavalueFootnote in table 
select *
, nullif(DatavalueFootnote, 'No data available') as NullLowConfident
from fact_table t
join dim_topic d on t.Topic_id = d.Topic_pkid
order by NullLowConfident;

-- Using GREATEST function to map the LowConfidenceLimit
select*, 
greatest(0.20, LowConfidenceLimit) as LowConfidenceLimit
from fact_table;

use chronic_disease_inddb
/* Using Common Table Expression to find plot to comparison of Diabetes among women aged 18-44 years for 
different states having sum (DataValue) <5000 */
;
select
       l.location_id,
       date_format(str_to_date(YearStart, '%m/%d/%y'), '%m/%d/%y') as 'Date',
       sum(t.DataValue)
from fact_table t
join dim_location l on t.Location_id = l.location_pkid
join dim_topic tp on t.Topic_id = tp.Topic_pkid
join dim_question q on tp.Topic_pkid = q.Question_pkid
where q.Question = 'Diabetes prevalence among women aged 18-44 years'
and l.locationDesc in ('California', 'Washington') 
group by YearStart, l.location_id
having sum(DataValue)>50000
order by DataValue;

-- Window function 
select DataValueAlt,
	   Topic, 
	   row_number() over ( order by DataValueAlt desc) row_n,
	   rank() over ( order by DataValueAlt desc) rank_f,
	   dense_rank() over (order by DataValueAlt desc) dense_f
from fact_table t
join dim_topic tp on t.Topic_id = tp.Topic_pkid;

-- Calculate a running total: using a window funcrion with sum()
select Fact_id, DataValueAlt, sum(DataValueAlt) over (order by Fact_id) as c
from fact_table t
join dim_topic tp on t.Topic_id = tp.Topic_pkid;
       


       






       




















