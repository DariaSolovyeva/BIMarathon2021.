# Chronic Disease Indicators (CDI) Project

Recently, I’ve taken on a personal project to apply the SQL and data analyses I’ve been studying. Since I’ve an interest in population health, I decided to start by focusing on understanding a 4 year population health specific dataset I found on Kaggle. This dataset was from the US Center for Disease Control and Prevention on chronic disease indicators. In this blog series, I want to demonstrate what is in the dataset with exploration. According the the overview on Kaggle, the limited contextual information provided in this dataset notes that the indicators are collected on the state level from 2001 to 2020, and there are 124 indicators.

### Data Source: 
https://chronicdata.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators-CDI-/g4ie-h725 

### Timeframe
2017 - 2020

## About the Analytical Approach:

My goal for this project is to conduct Data Cleaning and Exploratory Data Analysis for the Chronic Disease Indicators (CDI). 

The objective is to create an abstract that investigates the most common chronic diseases in the US, pointing at correlations between indicators and locality Hospital spendings, gender, etnicity. In a second step, the focus will be mantained about alcohol comsumption, comparing it to other diseases, advocating abuse prevention. For this purposes, a descriptive model is applied, upcoming insights are expressed in visualizations and dashboards enchancing the meanings of the findings and providing a straightfoward understanging of correlations, patterns and trends.
### Goal:
* #### Created a regression model for  Display the top 10 US chronic diseases on a bar plot (count of top 10 topics U.S Chronic Deseases);
* #### To evaluate the increase in chances of Chronic Kidney Disease;
* #### The role of gender and ethnicity differences in diabetes health ouctomes.
* #### What states have the highest percentage of chronic disease caused by Alchohol?

I imported the CSV data file into  MySQL workbench. Then I used various approaches to better understand the data within each column since there was very limited contextual information. The group of stratification 2 and 3 columns were not useful and these were removed. 

#### Let’s understand what each column is about. While some of the column names are relatively self-explanatory, I used  to better understand the unique categorical data. Here are some examples:
* YearStart: Identifies the year when reporting started.
* Topic: Identifies the Chronic Disease topic, 13k+ rows of data are grouped into the following 17 categories. There is a corresponding column called TopicID that simply gives an abbreviated label.
* Question: Within each topic, there are a number of questions. There is a corresponding column QuestionID that we’ll use. These are the 202 unique indicators that the dataset has values, and we’ll analyze this further.
* DataSource: Given that we’ve so many indicators, I’m not surprised that there are 24 data sources. However, the majority of the data comes from two sources, BRFSS, which is CDC’s Behavioral Risk Factor Surveillance System, and YRBSS, which is the Youth Risk Behavior Surveillance System (YRBSS) monitors six categories of health-related behaviors that contribute to the leading causes of death and disability among youth and adults.
* DataValueUnit: Values in DataValue consist of the following units, including percentages, dollar-amounts, years, and cases per thousands.
* DataValue: Identifies the actial value of the data. The responses that are in other form than number are
* DataValueAlt: Identifies the alternate data value. The responses that are in another form than numbers have been eliminated and replaced with blank values here.
* LowConfidenceLimit: Lower Confidence Interval. 
* HighConfidenceLimit: Higher Confidence Interval.
* StratificationCategory1: Identifies the sampling category of the population.
* LocationID: Location identity.
* TopicID: Short form of Chronic Disease Category.
* QuestionID: Short form of Chronic Disease Indicator.
* Data_ValueTypeID: Represents the short form of the data value type
* StratificationCategoryID1: Identifies the sampling category in short form.
* StratificationID1: Identifies the sampling sub category in short form.

The Chronic Disease Indicators system is an electronic repository of current and historical data and provides data on over 200 indicators. Using the system will result in enhanced chronic disease surveillance, better-informed policymaking, and facilitation of chronic disease program evaluation by state/territory and large health departments.
CDI increased to 124 indicators in the following 18 topic groups: alcohol; arthritis; asthma; cancer; cardiovascular disease; chronic kidney disease; chronic obstructive pulmonary disease; diabetes; immunization; nutrition, physical activity, and weight status; oral health; tobacco; overarching conditions; and new topic areas that include disability, mental health, older adults, reproductive health, and school health.

## IMPLEMETATION

### Dimensions: 
* Location_DIM (LocationID, LocationDesc, GeoLocation)
* StratificationCategory_DIM (StratificationCategoryID1, StratificationCategory1, Stratification1)
* Topic_DIM (TopicID, Topic, DataSource)  
* Question_DIM (QuestionID, Question)
* DataValueType_DIM (DataValueType_ID, DataValueType, DatavalueFootnote)

### Facts:
#### Fact_Disease
- Fact_ID
- YearStart
- YearEnd
- DataValueUnit 
- DataValue 
- DataValueAlt           
- LowConfidenceLimit       
- HighConfidenceLimit      
- FK_TopicID
- FK_StratificationCategoryID1
- FK_locationID
- FK_DataValueTypeID

## Logical Model: 

<img width="1156" alt="Screen Shot 2021-11-04 at 8 27 05 PM" src="https://user-images.githubusercontent.com/36121575/140453585-b30bffa4-d0f8-4f8c-9727-56fa68a69c40.png">

## Physical Model:
![Physical Data Model_  Chronic Disease Indicators ](https://user-images.githubusercontent.com/36121575/137229844-30a5bf41-6b69-44a5-b4b4-cf39a2e23f3b.jpeg)

## Physical Model from MySQLWorkbench:
<img width="583" alt="Screen Shot 2021-11-04 at 8 37 39 PM" src="https://user-images.githubusercontent.com/36121575/140454448-c654f265-afcb-4fc3-a9a4-73dd3f7fdccf.png">

## Conclusions and Relevance:
