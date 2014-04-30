# best() finds the best hospital in a state
# It takes two arguments: the 2-character abbreviated name of a state and an outcome name

best <- function(state, outcome) {
        
        # test to see if state 2-digit code arg is valid
        usstates <- read.csv("states.csv", colClasses = "character")
        valid_statecodes<- usstates[,"StateAbbr"]
        if (!(state %in% valid_statecodes)) {
                stop("invalid state")
        }
        
        # test to see if outcome arg is valid 
        valid_outcomes <- c("heart attack", "heart failure", "pneumonia")  
        if (!(outcome %in% valid_outcomes)) {
                stop("invalid outcome")
        }
        
        if (outcome == "heart attack") {
                j <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
        } else if (outcome == "heart failure") {
                j <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
        } else if (outcome == "pneumonia") {
                j <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
        } else {
                stop("Error in outcome case statement")
        }
        
    
        alldata <- read.csv("outcome-of-care-measures.csv")     # read complete data file
        statedata <- alldata[alldata$State == state,]           # subset all rows for selected state        
        statedata[,j] <- as.numeric(statedata[,j])              # convert to numeric data type
        
        
        
        rate <- min(statedata[,j])                              # determine lowest mortality
        i <- which.min(statedata[,j])                           # which row?
        best_hospital <- as.character(statedata[i,"Hospital.Name"])
        return(best_hospital)
}



# further clean up data
datacol <- subset(statedata)[,j]                                # extract mortality rate column
namecol <- as.character(subset(statedata)[,"Hospital.Name"])    # extract hospital name column
subDF <- cbind(namecol,datacol)                                 # create df with just 2 columns

# add code to check for "not available" or minimum thresholds
#mydata$v1[mydata$v1=="Not Available"] <- NA
#rows <- nrow(statedata)
#statedata[[1,j]]

cleanDF <- na.omit(subDF)                                       # remove NA rows
sortedDF <- cleanDF[ order(cleanDF[,2], cleanDF[,1]), ]         # sort by rate, hospital name



## Check that state and outcome are valid
## Return hospital name in that state with lowest 30-day death
## rate