# Chronic Disease Indicators (CDI) Project

The Chronic Disease Indicators system is an electronic repository of current and historical data and provides data on over 200 indicators. Using the system will result in enhanced chronic disease surveillance, better-informed policymaking, and facilitation of chronic disease program evaluation by state/territory and large health departments.
CDI increased to 124 indicators in the following 18 topic groups: alcohol; arthritis; asthma; cancer; cardiovascular disease; chronic kidney disease; chronic obstructive pulmonary disease; diabetes; immunization; nutrition, physical activity, and weight status; oral health; tobacco; overarching conditions; and new topic areas that include disability, mental health, older adults, reproductive health, and school health.

My goal for this project is to conduct Data Cleaning and Exploratory Data Analysis for the Chronic Disease Indicators (CDI). 
Data set is found here:https://chronicdata.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators-CDI-/g4ie-h725 

## Sources and Code Used
#### Data Source: https://chronicdata.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators-CDI-/g4ie-h725 


### Goal:
* #### Display the top 10 US chronic diseases on a bar plot (count of top 10 topics U.S Chronic Deseases);
* #### To evaluate the increase in chances of Chronic Kidney Disease;
* #### The role of gender and ethnicity differences in diabetes health ouctomes.

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
