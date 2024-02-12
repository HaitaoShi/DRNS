# Installing and loading packages
install.packages(c("readxl", "xlsx"))

library(readxl)
library(xlsx)

# Read "Sheet1" in an Excel file.
data <- read_excel("Copy of DRNS Mapping 30.6.23 no emails.xlsx", sheet = "Sheet1", skip = 1)

# # Load the workbook and get the hyperlinks from the "Reference" column
# workbook <- loadWorkbook("Copy of DRNS Mapping 30.6.23 no emails.xlsx")
# sheet <- getSheets(workbook)[["Sheet1"]]
# rows <- getRows(sheet)
# cells <- getCells(rows)

# # "Reference" is in column G 
# columnGCells <- cells[grepl("^G", names(cells))]
# hyperlinks <- sapply(columnGCells, function(cell) getHyperlink(cell)$address)

# # Adjust the length of hyperlinks to match the number of rows in data
# # Fill missing hyperlinks with NA or an empty string as needed
# hyperlinks <- if(length(hyperlinks) < nrow(data)) {
#     c(hyperlinks, rep(NA, nrow(data) - length(hyperlinks)))
# } else {
#     hyperlinks
# }

# # Add the hyperlinks to the data frame
# data$Reference_hyperlink <- hyperlinks



# Check for missing values in the data
if(any(is.na(data))) {
  print("There are missing values in the data.")
} else {
  print("There are no missing values in the data.")
}

# Find the location of missing values in the data
missing_values <- which(is.na(data), arr.ind=TRUE)
print(missing_values)

# Merge the "First name" and "Surname" columns to create a new "Name of Researcher" column.
# if "First name" is NA, then use "Surname"  

data$`Name of Researcher` <- ifelse(is.na(data$`First Name`), data$Surname, paste(data$`First Name`, data$Surname, sep = " "))
data$`Name of Researcher` <- trimws(data$`Name of Researcher`)
# Remove the "First name" and "Surname" columns
# Move the "Name of Researcher " column to the first column
data <- data[-c(1, 2)] 
data <- cbind(data[ncol(data)], data[-ncol(data)])

# # Remove the "Notes" column
# data <- subset(data, select = -Notes)




# Find "The University of Edinburgh" and change it to "University of Edinburgh" in the column "Name of Institution"
data$`Name of Institution` <- gsub("The University of Edinburgh", "University of Edinburgh", data$`Name of Institution`)

# Find "University of stirling" and change it to "University of Stirling" in the column "Name of Institution"
data$`Name of Institution` <- gsub("University of stirling", "University of Stirling", data$`Name of Institution`)



# Find "Usher Institute, University of Edinburgh" and change it to "University of Edinburgh" in the column "Name of Institution"
data$`Name of Institution` <- gsub("Usher Institute, University of Edinburgh", "University of Edinburgh", data$`Name of Institution`)


data$`Name of Institution` <- gsub("University West of Scotland", "University of the West of Scotland", data$`Name of Institution`)


# # Convert the list column 'Reference_hyperlink' to a character vector
# data$Reference_hyperlink <- sapply(data$Reference_hyperlink, toString)

# Write the data to a new CSV file.
write.csv(data, file = "Clean_data.csv", row.names = FALSE)

