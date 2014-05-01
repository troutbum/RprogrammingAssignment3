# best() finds the best hospital in a state for a given condition
# It takes two arguments: the 2-character abbreviated name of a state and an outcome name

best <- function(state, outcome) {
        
        ## Check that state and outcome are valid 
        ##
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
        
        ## Read outcome data
        ##
        alldata <- read.csv("outcome-of-care-measures.csv",     # Data import problem resolved
                            colClasses = "character",           # by coercing to "character"
                            stringsAsFactors=FALSE)             # (prevent creation of levels)
        statedata <- alldata[alldata$State == state,]           # subset all rows for selected state
        
        # Convert to numeric, non-numeric data coerced to NAs
        statedata[,j] <- suppressWarnings(as.numeric(statedata[,j]))
            
        # Condense data to just hospital and mortality rate
        datacol <- as.numeric(subset(statedata)[,j])                             # extract mortality rate column
        namecol <- as.character(subset(statedata)[,"Hospital.Name"])    # extract hospital name column
        subDF <- cbind(namecol,datacol)                                # create df with just 2 columns
        
        # remove NA rows
        cleanDF <- na.omit(subDF)
        
        # add code to check for minimum thresholds?
        #mydata$v1[mydata$v1=="Not Available"] <- NA
        #rows <- nrow(statedata)
        #statedata[[1,j]]
        
        # Sorted by rate, hospital name
        
        
        #library(plyr)
        #z <- arrange(cleanDF, datacol, namecol)
        
        cleanDF[, 2] <- as.numeric(cleanDF[, 2])
        sortedDF <- cleanDF[ order(cleanDF[,2], cleanDF[,1]), ] 
        
        # z <- cleanDF[with(cleanDF, order(datacol, namecol)), ]
        
        # dd[ order(-dd[,4], dd[,1]), ]
      
        #sortedDF <- cleanDF[order([,2], [,1]),] 
        
        ## Return hospital name in that state with lowest 30-day death rate
        ## 
        best_hospital <- as.character(sortedDF[1,1])
        return(best_hospital)
}

# unused example code
# rate <- min(statedata[,j])                              # determine lowest mortality
# i <- which.min(statedata[,j])                           # which row?
# best_hospital <- as.character(statedata[i,"Hospital.Name"])



