library(dplyr)
library(tidyr)

################################################################################
# Activities
################################################################################

# Read in the activity labels
activity_labels <- read.delim("activity_labels.txt", sep=" ", header = FALSE)
names(activity_labels) = c("ActivityId", "Activity")

# Convert them to a table
activity_labels <- tbl_df(activity_labels)

################################################################################
# Features
################################################################################

# Read in the feature key / decodes
features <- read.delim("features.txt", sep=" ", header = FALSE)
names(features) <- c("FeatureId", "Feature")

# Convert them to a table
features <- tbl_df(features)

# There are columns that have duplicate names.  None of them are for mean or for
# standard deviation measurements so we'll remove them.
duplicated_feature_names <- duplicated(features$Feature)
features <- features[!duplicated_feature_names,]

################################################################################
# Process data sets to combine them
################################################################################

process.data.sets <- function(subject_file, measure_file, activity_file) {
    
    subjects <- read.delim(subject_file, sep=" ", header = FALSE)
    names(subjects) <- c("SubjectId")
    subjects <- tbl_df(subjects)
    
    column_widths <- vector(mode="integer", length=561)
    column_widths <- column_widths + 16
    
    measurements <- read.fwf(
        measure_file,
        widths=column_widths,
        header = FALSE,
        buffersize = 100)
    measurements <- tbl_df(measurements)
    # Remove those measurement columns that have duplicate names
    measurements <- measurements[,!duplicated_feature_names]
    # Set column names to the feature decodes
    names(measurements) <- features$Feature
    # Keep only the mean and standard deviation measures
    measurements <- select(measurements, contains("mean()"), contains("std()"))
    
    activities <- read.delim(activity_file, sep=" ", header = FALSE)
    names(activities) = c("ActivityId")
    activities <- tbl_df(activities)
    
    final_data_set <- subjects %>%
        merge(activities, by=0, all=TRUE) %>%
        select(-Row.names) %>%
        merge(measurements, by=0, all=TRUE) %>%
        select(-Row.names)
    
    final_data_set
}

# Create the combined data set
combined_data_set <-
    rbind_list(
        process.data.sets(
            "test/subject_test.txt",
            "test/x_test.txt",
            "test/y_test.txt"),
        process.data.sets(
            "train/subject_train.txt",
            "train/x_train.txt",
            "train/y_train.txt"))


################################################################################
# TIDY up the data
################################################################################

# Each measure's mean and stdev is scattered across two columns, make each row
# an observation instead. Change measures to characters so they may be arranged.
pivoted_data_set <-
    combined_data_set %>%
    gather(Measure, Value, -SubjectId, -ActivityId) %>%
    mutate(Measure = as.character(Measure))

# Create averages for each measure
summarized_data_set <-
    summarize(
        group_by(pivoted_data_set, SubjectId, ActivityId, Measure),
        Avg = mean(Value))

# Create the final, tidy data set
tidy_data_set <-
    ungroup(summarized_data_set) %>%
    inner_join(activity_labels, by=c("ActivityId"="ActivityId")) %>%
    select(SubjectId, Activity, Measure, Avg) %>%
    arrange(SubjectId, Activity, Measure)

# Write out the result
write.table(tidy_data_set, file="getdata-008-submission.txt", row.name=FALSE)