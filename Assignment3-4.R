## R Programming - April 2014
## Programming Assignment 3 (Part 4)
##
## Ranking hospitals in all states
##

source("rankall.R")
head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)

# Write a function called rankall() that takes two arguments: an outcome name 
# (outcome) and a hospital ranking (num). The function reads the 
# outcome-of-care-measures.csv file and returns a 2-column data frame containing
# the hospital in each state that has the ranking specified in num.

# For example the function call rankall("heart attack", "best") would return a
# data frame containing the names of the hospitals that are the best in their
# respective states for 30-day heart attack death rates. The function should
# return a value for every state (some may be NA).

# The first column in the data frame is named hospital, which contains the
# hospital name, and the second column is named state, which contains the
# 2-character abbreviation for the state name. Hospitals that do not have data
# on a particular outcome should be excluded from the set of hospitals when
# deciding the rankings.

# Handling ties. The rankall function should handle ties in the 30-day mortality
# rates in the same way that the rankhospital function handles ties. The
# function should use the following template.

# rankall <- function(outcome, num = "best") {
        ## Read outcome data
        ## Check that state and outcome are valid
        ## For each state, find the hospital of the given rank 
        ## Return a data frame with the hospital names and the 
        ## (abbreviated) state name
# }



# NOTE: For the purpose of this part of the assignment (and for efficiency),
# your function should NOT call the rankhospital function from the previous
# section. The function should check the validity of its arguments. If an
# invalid outcome value is passed to rankall, the function should throw an error
# via the stop function with the exact message “invalid outcome”. The num
# variable can take values “best”, “worst”, or an integer indicating the ranking
# (smaller numbers are better). If the number given by num is larger than the
# number of hospitals in that state, then the function should return NA.

# Save your code for this function to a file named rankall.R. Use the submit
# script provided to submit your solution to this part. There are 3 tests that
# need to be passed for this part of the assignment.

