coursera-getdata-008
====================

Class project submission by Chad Lavy

## Description of processing steps

The following files were utilized to create the final data set:

* _activity_labels.txt_: Provides a list of 6 activity identifiers and their corresponding labels.
* _features.txt_: Provides a list of 561 feature identifiers and their corresponding labels.
* _test/subject_test.txt_: Provides 2,947 rows of data.  Each row has a single column which contains the identifier of the subject being observed in the corresponding row of _test/X_test.txt_.
* _test/X_test.txt_: Provides 2,947 rows of data. Each row has 561 columns containing numeric measurements.  The measurements correspond in order with the features provided in _features.txt_.
* _test/y_test.txt_: Provides 2,947 rows of data.  Each row has a single column which contains the identifier of the activity being observed in the corresponding row of _test/X_test.txt_.
* _train/subject_train.txt_: Provides 7,352 rows of data.  Each row has a single column which contains the identifier of the subject being observed in the corresponding row of _train/X_train.txt_.
* _train/X_train.txt_: Provides 7,352 rows of data. Each row has 561 columns containing numeric measurements.  The measurements correspond in order with the features provided in _features.txt_.
* _train/y_train.txt_: Provides 7,352 rows of data.  Each row has a single column which contains the identifier of the activity being observed in the corresponding row of _train/X_train.txt_.

### Step 1: Read in activity labels

The activity labels were read in as-is.  No manipulation was necessary to utilize them.

### Step 2: Read in the features

When reading in the features, it was discovered that there were numerous features with duplicate names.  Since none of the duplicate features were members of the set of mean and standard deviation features requested, the duplicates were removed so that they would not interfere with further processing.

### Step 3: Process the test data

The test subject, X, and y data sets were read.

The X data set required manipulation:

1. All of the feature columns that were identified as being duplicates were removed from the X data set based on positional order.
2. Each column was assigned the appropriate name from the remaining non-duplicate features.
3. Based on the assigned column names, the number of columns was further reduced to only those features that contain "mean()" or "std()" in the name per the assignment requirements.

After the appropriate columns were isolated from the X data set, the subject, X, and y data sets were merged on a row-by-row basis to create a single data set with each row having:

* SubjectId
* ActivityId
* Feature 1
* Feature ...
* Feature n

This resulted in a data set containing 68 columns.

### Step 4: Process the train data

The train data were processed in the same manner as the test data.

### Step 5: Combine the test and train data sets

The test and train data sets were concatenated together to create a unified data set.

### Step 6: Summarize the data

To summarize the data, the data set was pivoted to have only 4 columns:

* SubjectId
* ActivityId
* Measure
* Value

This resulted in a data set with 679,734 rows and 4 columns.

The data were then grouped by SubjectId, ActivityId, and Measure before summarizing to an average of Value.

This resulted in a data set with 11,880 rows and 4 columns:

* SubjectId
* ActivityId
* Measure
* Avg

### Step 7: Tidy up the data

To create the final data set, the summary data set was joined to the descriptive activity names loaded in step 1.  The data was then sorted by SubjectId, Activity, and Measure to improve readability.  The final data set has the following columns:

* SubjectId
* Activity
* Measure
* Avg

## Code book

File name: _getdata-008-submission.txt_

Description: Contains a header row followed by 118,880 rows of data per assignment requirements that the Samsung testing and training data be combined, the measurements be reduced down to only those reporting mean or standard deviation values, and an average be taken of those measurements by subject and activity.

Columns:

* _SubjectId_
  * Type: Integer
  * Description: The identifier of the individual(person) being observed.
* _Activity_:
  * Type: Character
  * Description: The name of the activity being performed by the individual.
* _Measure_:
  * Type: Character
  * Description: The specific measurement being taken for the subject / activity.
* _Avg_:
  * Type: Numeric to 11 decimal point precision
  * Description: The average value across each observation of subject / activity / measure.
