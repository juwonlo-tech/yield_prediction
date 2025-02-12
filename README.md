# yield_prediction
Analysis and Prediction Models for crop yield in 101 countries using R 

## Peek into the Dataset
<img width="814" alt="Screenshot 2025-01-25 at 6 06 27 PM" src="https://github.com/user-attachments/assets/28fec5ba-bcfa-4c1b-a033-d00fa8a1bea9" />

### Statistical Summary of the Data
<img width="646" alt="Screenshot 2025-01-25 at 4 43 30 PM" src="https://github.com/user-attachments/assets/e30d3726-c2a1-4a75-8b97-c43e73773fe6" />

Numerical Features:
- Year: The data spans years 1990 to 2013
- hg.ha_yield: The average crop production yield is 77053 hectograms per hectare, the least yield is 50 hectograms per hectare and the highest is 501412 hectograms per hectare.
- average_rain_fall_mm_per_year: The average rainfall per year is approximately 1149 mm/year, with the least rainfall being 51 mm/year and the highest is 3240 mm/year.
- pesticides_tonnes: The average pesticides used in tonnes is 37077 tonnes, with the minimum being 0 and maximum as 367778 tonnes. 
- avg_temp: The lowest average temperature recorded was 1.30 and the highest was 30.65.

## Cleaned Data Overview
The data cleaning process involved removing the index column, renaming columns for clarity, reviewing data, and checking for missing value.
<img width="814" alt="Screenshot 2025-01-25 at 5 56 06 PM" src="https://github.com/user-attachments/assets/1e50c931-6035-49a5-9e04-f16d4a3a9b5e" />

## Correlation Heatmap
A copy of the dataset was made and the categorical values were encoded for correlation analysis.
The correlation between the variables is visualized below:
<img width="930" alt="Screenshot 2025-01-25 at 5 51 23 PM" src="https://github.com/user-attachments/assets/8f2da9d5-3204-44d1-aaad-eb87c9c589e3" />

Strong negative correlations observed between Country and rainfall, as well as Country and pesticide use. 
There is also negative correlation between crop and yield. There is positive correlation between average rainfall and average temperature.


# Data Analysis

## What is the frequency of values in each category?

<img width="977" alt="Screenshot 2025-01-28 at 12 08 20 PM" src="https://github.com/user-attachments/assets/1ed8bc6b-d313-4808-9a1c-736b2dd69b4c" />

<img width="977" alt="Screenshot 2025-01-28 at 12 08 48 PM" src="https://github.com/user-attachments/assets/17f63072-2a89-4a6b-8d67-57042ffd7545" />

<img width="926" alt="Screenshot 2025-01-25 at 4 58 39 PM" src="https://github.com/user-attachments/assets/8dbbbef8-4e29-4019-baba-4f4465732453" />

<img width="977" alt="Screenshot 2025-01-28 at 12 09 19 PM" src="https://github.com/user-attachments/assets/0dd557c0-ee17-47fb-8729-96332fcc156e" />

<img width="926" alt="Screenshot 2025-01-25 at 4 59 26 PM" src="https://github.com/user-attachments/assets/52a8282f-d1ff-4240-acdd-32cfd88f80c2" />

<img width="977" alt="Screenshot 2025-01-28 at 12 09 47 PM" src="https://github.com/user-attachments/assets/36181a01-fdab-4174-8eaa-33de1a5996c7" />


## Where are the hottest and coldest countries in the data?
<img width="920" alt="Screenshot 2025-01-27 at 11 10 42 PM" src="https://github.com/user-attachments/assets/7cc7c06e-7616-4310-a70f-7266822e2876" />


## Which country used the most and least pesticides in their production?
<img width="952" alt="Screenshot 2025-01-28 at 11 41 37 AM" src="https://github.com/user-attachments/assets/a342dd6d-d232-4b2c-a7a1-7f313165acbd" />


## What does the rainfall distribution look like?
<img width="952" alt="Screenshot 2025-01-28 at 11 40 50 AM" src="https://github.com/user-attachments/assets/6ce697cf-4351-469a-a43c-2775c69e4e44" />


## Which countries produced the most and least produces?
<img width="952" alt="Screenshot 2025-01-28 at 11 40 24 AM" src="https://github.com/user-attachments/assets/3134f6e5-2ed2-4648-bfbb-bd3506ef4330" />


## How does Pesticide Use Affect Yield in Various Countries?
<img width="935" alt="Screenshot 2025-01-25 at 5 09 37 PM" src="https://github.com/user-attachments/assets/9c07c6c6-fa4a-4bc8-be80-96342dd30e4c" />
Brazil, India, Mexico, and Japan use a lot of pesticides but India is the country where the yield is significantly improved probably by pesticides.


## What is the relationship between Pesticide Use Affect Yield?
<img width="732" alt="Screenshot 2025-01-25 at 5 11 27 PM" src="https://github.com/user-attachments/assets/3ed6f78a-f457-402f-97ba-f0f96c16c696" />
From this, it can be concluded that there is a moderate but positive relationship between pesticide use and crop yield in the countries. 
However, the correlation is not perfect (0.727445967182818), so there may be other factors at play (e.g., climate, soil quality, farming practices, etc.) influencing crop yield besides just pesticide use.


## Which Crop Uses the Most and Least Pesticides?
<img width="925" alt="Screenshot 2025-01-25 at 5 13 20 PM" src="https://github.com/user-attachments/assets/1a500064-79d6-446a-b481-37771a6121c6" />
Yams averagely require the largest quantity of pesticides, while plantains and others require the least.


## What is the Volume of Crops Produced? 
<img width="920" alt="Screenshot 2025-01-27 at 11 18 48 PM" src="https://github.com/user-attachments/assets/119e2c11-6b7f-4297-91e8-654c08c1cadd" />
Potatoes, Cassava, and Sweet potatoes are the crops with the highest yield.


## Which Temperature Improves Yield for Crops?
<img width="931" alt="Screenshot 2025-01-25 at 5 16 57 PM" src="https://github.com/user-attachments/assets/6cb47cc4-776d-460f-a233-767bf21e3bdd" />
Cassava, Yams, and Plantains and others grow at temperatures above 15 degrees while other crops grow across temperatures.


## Where is the Best Country for Each Crop?

<img width="451" alt="Screenshot 2025-01-25 at 5 18 26 PM" src="https://github.com/user-attachments/assets/c67af243-0808-4891-9325-0bda1b6f16d2" />

<img width="927" alt="Screenshot 2025-01-25 at 5 19 07 PM" src="https://github.com/user-attachments/assets/b4a42a58-3a7b-41bb-a185-34acce5144e2" />


## Time Series Analysis (Temp, Pesticides, Rainfall, Yield Over Years)

<img width="930" alt="Screenshot 2025-01-25 at 5 20 02 PM" src="https://github.com/user-attachments/assets/d3d4af12-bee2-4304-8c0d-579eaab7961a" />

<img width="930" alt="Screenshot 2025-01-25 at 5 20 23 PM" src="https://github.com/user-attachments/assets/14ebc0d7-302d-498d-96c4-cb7342ff5457" />


# Regression Models to Predict Yield
I partitioned the data into labels and features and split the data into train and test data (70:30). The features were avg_temp, pesticides_tonnes, average_rain_fall_mm_per_year.
I then performed data modelling on the train data using random forest model, decision tree model, and xgboost model.
I used the developed model to predict the test data and evaluated the result of the models.

### Result of the evaluation 
1. RandomForest Result- RMSE: 84207.0498 | Accuracy: -9.4936% | MAE: 65317.4606 | R²: 0.0082 
2. DecisionTree Result-  RMSE: 82054.3951 |  Accuracy: -6.6945% | MAE: 63095.6052 | R²: 0.0583 
3. XGBoost Result- RMSE: 80164.3187 |  Accuracy: -4.2369% | MAE: 62251.7015 | R²: 0.1012

The XGBoost model performs the best across all evaluation metrics (lowest RMSE and MAE, highest R², and least negative accuracy). It is the best choice among the three models.

The XGBoost model can therefore be deployed to predict the yield of crops based on temperature, pesticides use, and volume of rainfall.

The full script is available on: https://github.com/juwonlo-tech/yield_prediction/blob/main/Yield_Pred.R







