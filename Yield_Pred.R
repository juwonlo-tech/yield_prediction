# Load required libraries
library(tidyverse)
library(reshape2)  # For melting correlation matrices
library(RColorBrewer)  # For color palettes
library(GGally)  # For pair plots
library(caret) # For streamlining the model training
library(randomForest) # For Random Forest Regression modelling
library(rpart)# For Decision Tree Regression modelling
library(xgboost) # For XGBoost Regression modelling

# Load data
data <- read.csv("/Users/juwonlo/My r stuff/crop_yield.csv")

# Explore data
View(data)
str(data)

# The dataset contains 28,242 rows and 8 columns, 6 of which are numeric.

# Rename columns for clarity
names(data)[names(data) == 'Item'] <- 'Crop'
names(data)[names(data) == 'Area'] <- 'Country'

# Summary statistics of the dataset
summary(data)

# Numerical Features- 
# Year: The data spans years 1990 to 2013
# hg.ha_yield: The average crop production yield is 77053 hectograms per hectare, the least yield is 50 hectograms per hectare and the highest is 501412 hectograms per hectare.
# average_rain_fall_mm_per_year: The average rainfall per year is approximately 1149 mm/year, with the least rainfall being 51 mm/year and the highest is 3240 mm/year.
# pesticides_tonnes: The average pesticides used in tonnes is 37077 tonnes, with the minimum being 0 and maximum as 367778 tonnes. 
# avg_temp: The lowest average temperature recorded was 1.30 and the highest was 30.65.

# Data Cleaning
# Remove the first column (assumed to be an index column not relevant for analysis)
data <- data[, -1]
# Check for missing values
colSums(is.na(data))  


# View cleaned data
head(data)

# Create copy of data for encoding
data_copy <- data

# Encode categorical columns using label encoding
categorical_columns <- names(data_copy)[sapply(data_copy, is.character)]

# Apply label encoding
for (column in categorical_columns) {
  data_copy[[column]] <- as.numeric(factor(data_copy[[column]]))
}

# View transformed data
tail(data_copy)

# Correlation Heatmap
cor_matrix <- cor(data_copy, use = "complete.obs")  # Compute correlation matrix
cor_melted <- melt(cor_matrix)  # Melt for visualization

# Plot heatmap
ggplot(cor_melted, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
  theme_minimal() +
  labs(title = "Correlation Heatmap", x = "Variables", y = "Variables") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text.y = element_text(angle = 45, hjust = 1))

# Comment on correlations:
# Significant correlations observed between Country and rainfall and pesticide use. 
# There is also good correlation between crop and yield.

# What is the frequency of values in each  category?
# Store plots in a list
plots <- list()

for (col in colnames(data)) {
  if (is.numeric(data[[col]])) {
    plots[[col]] <- ggplot(data, aes(.data[[col]])) +
      geom_histogram(binwidth = 30, fill = "blue", color = "black", alpha = 0.7) +
      labs(title = paste("Histogram of", col), x = col, y = "Frequency") +
      theme_minimal()
  } else {
    plots[[col]] <- ggplot(data, aes(.data[[col]])) +
      geom_bar(fill = "blue", color = "black", alpha = 0.7) +
      labs(title = paste("Bar Plot of", col), x = col, y = "Frequency") +
      theme_minimal()
  }
}

# Render each plot
for (plot in plots) {
  print(plot)
}

# Pairplot (Selected Columns)
ggpairs(data, columns = 2:6,
        aes(color = factor(Crop), alpha = 0.5), cardinality_threshold = 20)

# How many countries are in the dataset?
unique_countries <- n_distinct(data$Country)
print(unique_countries)

# Summarize data by country
data_summary <- data %>%
  group_by(Country) %>%
  summarise(
    total_yield = sum(hg.ha_yield, na.rm = TRUE),
    avg_yield = mean(hg.ha_yield, na.rm = TRUE),
    total_rainfall = sum(average_rain_fall_mm_per_year, na.rm = TRUE),
    avg_rainfall = mean(average_rain_fall_mm_per_year, na.rm = TRUE),
    total_pesticides = sum(pesticides_tonnes, na.rm = TRUE),
    avg_pesticides = mean(pesticides_tonnes, na.rm = TRUE),
    average_temp = mean(avg_temp, na.rm = TRUE)  # Avg temp since it doesn't accumulate
  )

# Identify and visualize top 10 and bottom 10 countries by key variables
variables <- c("total_yield", "total_rainfall", "total_pesticides", "average_temp")

for (var in variables) {
  # Top and Bottom 10
  top_10 <- data_summary %>%
    arrange(desc(!!sym(var))) %>%
    slice_head(n = 10) %>%
    mutate(rank_type = "Top 10")
  
  bottom_10 <- data_summary %>%
    arrange(!!sym(var)) %>%
    slice_head(n = 10) %>%
    mutate(rank_type = "Bottom 10")
  
  combined <- bind_rows(top_10, bottom_10)
  
  # Plot
  plot <- ggplot(combined, aes(x = reorder(Country, !!sym(var)), y = !!sym(var), fill = rank_type)) +
    geom_bar(stat = "identity", position = "dodge") +
    coord_flip() +
    labs(
      title = paste("Top 10 and Bottom 10 Countries by", var),
      x = "Country",
      y = var
    ) +
    theme_minimal() +
    theme(legend.position = "bottom") +
    # Adding annotations for each bar
    geom_text(
      aes(label = scales::comma(!!sym(var))),  # Format numbers with commas
      position = position_dodge(width = 0.8),   # Adjust position for text alignment
      vjust = 0.5,                              # Adjust vertical alignment
      color = "black",                          # Text color
      size = 3                                   # Text size
    )
  
  
  # Print plot
  print(plot)
}

# How does Pesticide Use Affect Yield in Various Countries?
ggplot(data_summary, aes(x = total_pesticides, y = total_yield, label = Country)) +
  geom_point(color = "green", size = 3) +
  geom_text(nudge_y = 0.5, size = 3) +
  labs(
    title = "Relationship Between Pesticide Use and Crop Yield",
    x = "Pesticides (Tonnes)", # total amount of pesticides used by each country
    y = "Yield (Hg/Ha)" # total crop yield for each country
  ) +
  theme_minimal()

# Correlation Coefficient
correlation <- cor(data_summary$total_pesticides, data_summary$total_yield, use = "complete.obs")
print(paste("Correlation coefficient:", correlation))

# From this, it can be concluded that there is a moderate but positive relationship between pesticide use and crop yield in the countries. 
# However, the correlation is not perfect (0.727445967182818), so there may be other factors at play (e.g., climate, soil quality, farming practices, etc.) influencing crop yield besides just pesticide use.
# Brazil, India, Mexico, and Japan use a lot of pesticides but India is the country where the yield is significantly improved probably by pesticides.

# Linear Regression
model <- lm(total_yield ~ total_pesticides, data = data_summary)
summary(model)

# Add regression line
ggplot(data_summary, aes(x = total_pesticides, y = total_yield)) +
  geom_point(color = "green", size = 3) +
  geom_smooth(method = "lm", color = "purple", se = TRUE) +
  labs(
    title = "Linear Regression: Pesticide Use vs Yield",
    x = "Pesticides (Tonnes)",
    y = "Yield (Hg/Ha)"
  ) +
  theme_minimal()

# Which Crop Uses the Most and Least Pesticides?
crop_pesticides <- data %>%
  group_by(Crop) %>%
  summarise(avg_pesticides = mean(pesticides_tonnes, na.rm = TRUE)) %>%
  arrange(desc(avg_pesticides))

ggplot(crop_pesticides, aes(x = reorder(Crop, avg_pesticides), y = avg_pesticides)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  labs(title = "Average Pesticides Used per Crop", x = "Crop", y = "Pesticides (Tonnes)") +
  theme_minimal()

# Yams averagely require the most amount of pesticides, while plantains and others require the least.

# What is the Volume of Crops Produced? 
ggplot(data, aes(x = Crop, y = hg.ha_yield, fill = Crop)) +
  geom_boxplot() +
  labs(title = "Crop Yield Distribution by Crop", x = "Crop", y = "Yield (Hg/Ha)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Which Temperature Improves Yield for Crops?
ggplot(data, aes(x = avg_temp, y = hg.ha_yield)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  facet_wrap(~ Crop) +
  labs(title = "Temperature vs Crop Yield for Different Crops", 
       x = "Average Temperature (°C)", 
       y = "Yield (Hg/Ha)") +
  theme_minimal()

# Cassava, Yams, and Plantains and others grow at temperatures above 15 degrees while other crops grow across temperatures.

# Where is the Best Country for Each Crop?
best_country_for_crop <- data %>%
  group_by(Crop, Country) %>%
  summarise(total_yield = sum(hg.ha_yield, na.rm = TRUE)) %>%
  arrange(Crop, desc(total_yield)) %>%
  group_by(Crop) %>%
  slice_head(n = 1)  # Select the country with the highest yield for each crop

# View the best country for each crop
print(best_country_for_crop)

# Plot the results
ggplot(best_country_for_crop, aes(x = reorder(Crop, total_yield), y = total_yield, fill = Country)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Best Country for Each Crop Based on Total Yield", 
       x = "Crop", 
       y = "Total Yield (Hg/Ha)") +
  theme_minimal()

# Time Series Analysis (Temp, Pesticides, Rainfall, Yield Over Years)
yearly_trends <- data %>%
  group_by(Year) %>%
  summarise(
    avg_yield = mean(hg.ha_yield, na.rm = TRUE),
    avg_pesticides = mean(pesticides_tonnes, na.rm = TRUE),
    avg_temp = mean(avg_temp, na.rm = TRUE),
    avg_rainfall = mean(average_rain_fall_mm_per_year, na.rm = TRUE)
  )

ggplot(yearly_trends, aes(x = Year)) +
  geom_line(aes(y = avg_yield, color = "Yield")) +
  geom_line(aes(y = avg_pesticides, color = "Pesticides")) +
  geom_line(aes(y = avg_temp, color = "Temperature")) +
  geom_line(aes(y = avg_rainfall, color = "Rainfall")) +
  labs(title = "Yearly Trends: Yield, Pesticides, Temperature, and Rainfall", x = "Year", y = "Values") +
  scale_color_manual(values = c("blue", "red", "green", "orange")) +
  theme_minimal()

yearly_trends_combined <- yearly_trends %>%
  pivot_longer(cols = c(avg_yield, avg_pesticides, avg_temp, avg_rainfall), 
               names_to = "Variable", 
               values_to = "Value")

ggplot(yearly_trends_combined, aes(x = Year, y = Value, color = Variable)) +
  geom_line() +
  facet_wrap(~ Variable, scales = "free_y") +  # Each plot will have its own y-axis scale
  labs(title = "Yearly Trends: Yield, Pesticides, Temperature, and Rainfall", x = "Year", y = "Values") +
  scale_color_manual(values = c("blue", "red", "green", "orange")) +
  theme_minimal()


# Regression Models to Predict Yield

# Train-Test Split
set.seed(123)
train_index <- createDataPartition(data$hg.ha_yield, p = 0.7, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

# Train a random forest model
rf_model <- randomForest(hg.ha_yield ~ avg_temp + pesticides_tonnes + average_rain_fall_mm_per_year, data = train_data)
print(rf_model)

# Predict and evaluate
predictions <- predict(rf_model, test_data)

# Evaluation/ Calculate Metrics
# RMSE
RMSE <- sqrt(mean((test_data$hg.ha_yield - predictions)^2))
print(paste("RMSE:", RMSE))
# Accuracy
mean_actual <- mean(test_data$hg.ha_yield)
accuracy <- 100 * (1 - (RMSE / mean_actual))
print(paste("Accuracy:", accuracy, "%"))
# Mean Absolute Error (MAE)
MAE <- mean(abs(test_data$hg.ha_yield - predictions))
print(paste("MAE:", MAE))
# R²
SSE <- sum((test_data$hg.ha_yield - predictions)^2) # Sum of Squared Errors
SST <- sum((test_data$hg.ha_yield - mean(test_data$hg.ha_yield))^2) # Total Sum of Squares
R2 <- 1 - (SSE / SST)
print(paste("R²:", R2))

# RandomForest Result
# RMSE: 84207.0498 | Accuracy: -9.4936% | MAE: 65317.4606 | R²: 0.0082 

# Train a decision tree model
dt_model <- rpart(hg.ha_yield ~ avg_temp + pesticides_tonnes + average_rain_fall_mm_per_year, data = train_data)
print(summary(dt_model))

# Predict and evaluate
predictions <- predict(dt_model, test_data)
# RMSE
RMSE <- sqrt(mean((test_data$hg.ha_yield - predictions)^2))
print(paste("RMSE:", RMSE))
# Accuracy
mean_actual <- mean(test_data$hg.ha_yield)
accuracy <- 100 * (1 - (RMSE / mean_actual))
print(paste("Accuracy:", accuracy, "%"))
# Mean Absolute Error (MAE)
MAE <- mean(abs(test_data$hg.ha_yield - predictions))
print(paste("MAE:", MAE))
# R²
SSE <- sum((test_data$hg.ha_yield - predictions)^2) # Sum of Squared Errors
SST <- sum((test_data$hg.ha_yield - mean(test_data$hg.ha_yield))^2) # Total Sum of Squares
R2 <- 1 - (SSE / SST)
print(paste("R²:", R2))

# DecisionTree Result
# RMSE: 82054.3951 |  Accuracy: -6.6945% | MAE: 63095.6052 | R²: 0.0583 


# Train an xgboost model
# Prepare data for xgboost
train_matrix <- model.matrix(hg.ha_yield ~ avg_temp + pesticides_tonnes + average_rain_fall_mm_per_year - 1, data = train_data)
test_matrix <- model.matrix(hg.ha_yield ~ avg_temp + pesticides_tonnes + average_rain_fall_mm_per_year - 1, data = test_data)

dtrain <- xgb.DMatrix(data = train_matrix, label = train_data$hg.ha_yield)
dtest <- xgb.DMatrix(data = test_matrix, label = test_data$hg.ha_yield)

xgb_model <- xgboost(data = dtrain, max.depth = 3, nrounds = 100, objective = "reg:squarederror", verbose = 0)
print(xgb_model)

# Predict and evaluate
predictions <- predict(xgb_model, dtest)
# avg_temp + pesticides_tonnes + average_rain_fall_mm_per_year, data = train_data)
# RMSE
RMSE <- sqrt(mean((test_data$hg.ha_yield - predictions)^2))
print(paste("RMSE:", RMSE))
# Accuracy
mean_actual <- mean(test_data$hg.ha_yield)
accuracy <- 100 * (1 - (RMSE / mean_actual))
print(paste("Accuracy:", accuracy, "%"))
# Mean Absolute Error (MAE)
MAE <- mean(abs(test_data$hg.ha_yield - predictions))
print(paste("MAE:", MAE))
# R²
SSE <- sum((test_data$hg.ha_yield - predictions)^2) # Sum of Squared Errors
SST <- sum((test_data$hg.ha_yield - mean(test_data$hg.ha_yield))^2) # Total Sum of Squares
R2 <- 1 - (SSE / SST)
print(paste("R²:", R2))

# XGBoost Result
# RMSE: 80164.3187 |  Accuracy: -4.2369% | MAE: 62251.7015 | R²: 0.1012 


# Random Forest (RMSE: 83,460.94): This model performs reasonably well but has the highest RMSE among the three.
# Decision Tree (RMSE: 81,870.75): Slightly better than the Random Forest, as it has a lower RMSE.
# XGBoost (RMSE: 79,425.15): XGBoost has the lowest RMSE, meaning it is the most accurate model among the three for predicting hg.ha_yield on your dataset.
