# README file for Coursera Johns Hopkins Getting and Cleaning Data Project
## Week 4 Peer Reviewed Project Assignment
## Author: Jason Carlson
## Date: 13-August-2020


# Description of How the Script Works


The R script, which is named `run_analysis.R`, peforms the following actions:


1. Downloads the zip file, from the web, containing the training and test datasets, if the file does not already exist in the working directory


2. Loads the activity and feature information into data tables in R


3. Assigns the training and test data to named data tables in R, while including only the records pertaining to means and standard deviations


4. Merges the activity and subject data with the training and test data


5. Combines the training and test datasets using column binding


6. Converts the subject and activity columns into factors


7. Creates a tidy dataset where the mean value of each variable is included for each subject and activity.


8. Writes the resulting data to a file named `tidy.txt`.
