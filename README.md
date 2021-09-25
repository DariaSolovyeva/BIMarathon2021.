# BIMarathon2021.

## Chronic Disease Indicators (CDI)

The Chronic Disease Indicators system is an electronic repository of current and historical data and provides data on over 200 indicators. Using the system will result in enhanced chronic disease surveillance, better-informed policymaking, and facilitation of chronic disease program evaluation by state/territory and large health departments.
CDI increased to 124 indicators in the following 18 topic groups: alcohol; arthritis; asthma; cancer; cardiovascular disease; chronic kidney disease; chronic obstructive pulmonary disease; diabetes; immunization; nutrition, physical activity, and weight status; oral health; tobacco; overarching conditions; and new topic areas that include disability, mental health, older adults, reproductive health, and school health.

My goal for this project is to conduct Data Cleaning and Exploratory Data Analysis for the Chronic Disease Indicators (CDI). 
Data set is found here:https://chronicdata.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators-CDI-/g4ie-h725 

### Goal:
* #### Display the top 10 US chronic diseases on a bar plot (count of top 10 topics U.S Chronic Deseases);
* #### To evaluate the increase in chances of Chronic Kidney Disease;
* #### The role of gender and ethnicity differences in diabetes health ouctomes.

### Dimensions: 
* Location (LocationID, LocationDesc, LocationAbbr, GeoLocation)
* Response (
* Gender_Race (StratificationCategoryID1, StratificationID1, StratificationCategory1, Stratification1)
* Topic (TopicID, Topic, DataSource)
* Question (QuestionID, Question)

### Facts:
#### DateValue 
- DataValueTypeID
- DataValue
- DataValueAlt
- DataValueUnit 
- DataValueType
- DataValueFootnoteSymbol
- DatavalueFootnote
- LowConfidenceLimit
- HighConfidenceLimit 
- Location_FK
- Response_FK
- Gender_Race_FK
- Topic_FK
- Question_FK
- Date

