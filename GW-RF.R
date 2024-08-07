install.packages("SpatialML")
install.packages("sf")
start_time <- Sys.time()
library(SpatialML)
library(ranger)
library(sf)

# Specify the file path and name
# Big Dataset - does not run
# Split 1
#file_path_train <- "pth"
#file_path_test <- "pth"
# Split 2
#file_path_train <- "pth"
#file_path_test <- "pth"
# Split 3
#file_path_train <- "pth"
#file_path_test <- "pth"

#Small Dataset
# Split 1
file_path_test <- "pth"
file_path_train <- "pth"

# Split 2
#file_path_test <- "pth"
#file_path_train <- "pth"

# Split 3
#file_path_test <- "pth"
#file_path_train <- "pth"

# Read the CSV file with semicolon separator
train.df <- read.csv(file_path_train, header = TRUE, sep = ";", dec = ".")
head(train.df)

test.df <- read.csv(file_path_test, header = TRUE, sep = ";", dec = ".")
head(test.df)

set.seed(123)

# Need to separate the coordinates for feeding it into the functions
traincoords <- subset(train.df, select = -c(
    MedHouseVa,MedIncome,MedianAge,Population,Households,roomsperHH,bedroomHH))
head(traincoords)

train.df <- subset(train.df, select = -c(lat,lon))
str(train.df)

results = rf.mtry.optim(MedHouseVa ~ MedIncome + MedianAge + Population 
                        + Households + roomsperHH + bedroomHH, 
                        dataset = train.df)

# Bandwidth was taken from the GWR Python script
bwe <- grf.bw(formula =  MedHouseVa ~ MedIncome + MedianAge + Population 
              + Households + roomsperHH + bedroomHH, 
              dataset = train.df, 
              kernel = "adaptive", 
              coords =  traincoords, 
              bw.min = 40,
              bw.max = 100,
              step = 10,
              trees = 1,
              mtry = 3)

traincoords <- traincoords[, c("lon", "lat")]

grf1 <- grf(MedHouseVa ~ MedIncome + MedianAge + Population 
            + Households + roomsperHH + bedroomHH, dframe=train.df, 
           bw=75, kernel="adaptive", coords=traincoords, mtry=2)

predict <- predict.grf(grf1, test.df, x.var.name="lon", y.var.name="lat")
str(test.df)

# Extract the predicted and actual values
predicted <- predict
actual <- test.df$MedHouseVa

print(predicted)
print(actual)

# Calculate residuals
residuals <- actual - predicted
head(residuals)
# Save all columns from the test data, including residuals, to a CSV file
output_data <- cbind(
  test.df,
  MedHouseVa_Predicted = predicted,
  Residuals = residuals
)

output_file_path <- "pth"
write.csv(output_data, file = output_file_path, row.names = FALSE)


# Calculate R2
r2 <- cor(predicted, actual)^2

# Calculate MAE
mae <- mean(abs(predicted - actual))

# Calculate RMSE
rmse <- sqrt(mean((predicted - actual)^2))

# Print the evaluation metrics
print(paste("R2:", r2))
print(paste("MAE:", mae))
print(paste("RMSE:", rmse))

end_time <- Sys.time()
elapsed_time <- end_time - start_time
print(paste("Script execution time: ", elapsed_time))