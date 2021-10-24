# Chronic Disease Indicators (CDI) Project

Recently, I’ve taken on a personal project to apply the SQL and data analyses I’ve been studying. Since I’ve an interest in population health, I decided to start by focusing on understanding a 4 year population health specific dataset I found on Kaggle. This dataset was from the US Center for Disease Control and Prevention on chronic disease indicators. In this blog series, I want to demonstrate what is in the dataset with exploration. According the the overview on Kaggle, the limited contextual information provided in this dataset notes that the indicators are collected on the state level from 2001 to 2020, and there are 124 indicators.

I imported the CSV data file into  MySQL workbench. Then I used various approaches to better understand the data within each column since there was very limited contextual information. The group of stratification 2 and 3 columns were not useful and these were removed. 

Let’s understand what each column is about. While some of the column names are relatively self-explanatory, I used ...... to better understand the unique categorical data. Here are some examples:
Topic: 13k+ rows of data are grouped into the following 17 categories. There is a corresponding column called TopicID that simply gives an abbreviated label.

Question: Within each topic, there are a number of questions. There is a corresponding column QuestionID that we’ll use. These are the 202 unique indicators that the dataset has values, and we’ll analyze this further.

DataSource: Given that we’ve so many indicators, I’m not surprised that there are 24 data sources. However, the following histogram shows that the majority of the data comes from two sources, BRFSS, which is CDC’s Behavioral Risk Factor Surveillance System, and NVSS, which is the National Vital Statistics System.




The Chronic Disease Indicators system is an electronic repository of current and historical data and provides data on over 200 indicators. Using the system will result in enhanced chronic disease surveillance, better-informed policymaking, and facilitation of chronic disease program evaluation by state/territory and large health departments.
CDI increased to 124 indicators in the following 18 topic groups: alcohol; arthritis; asthma; cancer; cardiovascular disease; chronic kidney disease; chronic obstructive pulmonary disease; diabetes; immunization; nutrition, physical activity, and weight status; oral health; tobacco; overarching conditions; and new topic areas that include disability, mental health, older adults, reproductive health, and school health.

## About the Analytical Approach:

My goal for this project is to conduct Data Cleaning and Exploratory Data Analysis for the Chronic Disease Indicators (CDI). 

The objective is to create an abstract that investigates the most common chronic diseases in the US, pointing at correlations between indicators and locality Hospital spendings, gender, etnicity. In a second step, the focus will be mantained about alcohol comsumption, comparing it to other diseases, advocating abuse prevention. For this purposes, a descriptive model is applied, upcoming insights are expressed in visualizations and dashboards enchancing the meanings of the findings and providing a straightfoward understanging of correlations, patterns and trends.
### Goal:
* #### Created a regression model for  Display the top 10 US chronic diseases on a bar plot (count of top 10 topics U.S Chronic Deseases);
* #### To evaluate the increase in chances of Chronic Kidney Disease;
* #### The role of gender and ethnicity differences in diabetes health ouctomes.

## Sources and Code Used
#### Data Source: https://chronicdata.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators-CDI-/g4ie-h725 

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
- FK_QuestionID
- FK_DataValueTypeID

## Logical Model

![Physical Data Model_  Chronic Disease Indicators ](https://user-images.githubusercontent.com/36121575/137229844-30a5bf41-6b69-44a5-b4b4-cf39a2e23f3b.jpeg)
