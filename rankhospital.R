# rankhospital(state, outcome, num) takes three arguments:
#    * state : 2-character abbreviated name of a state
#    * outcome : either "heart attack" "heart failure" "pneumonia"
#    * num : ranking of a hospital in that state for that outcome
#    * returns : a character vector with the name of the hospital that has the
#      ranking specified by the num argument.

rankhospital <- function(state, outcome, num = "best") {
        
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
                            colClasses = "character")           # by coercing to "character"                    
        statedata <- alldata[alldata$State == state,]           # subset all rows for selected state
        
        # Convert to numeric, non-numeric data (e.g. 'Not Available') coerced to NAs
        statedata[,j] <- suppressWarnings(as.numeric(statedata[,j]))
     
        # Condense data to just hospital and mortality rate
        datacol <- as.numeric(subset(statedata)[,j])                    # extract mortality rate column 
        namecol <- as.character(subset(statedata)[,"Hospital.Name"])    # extract hospital name column
        
        # !!! Must use this CBIND.DATA.FRAME to add columns of numeric and character columns!!!
        #subDF <- cbind(namecol,datacol)                                
        subDF <- cbind.data.frame(namecol,datacol)                      
        
        # remove NA rows
        cleanDF <- na.omit(subDF)
        
        # Sorted by rate, hospital name
        sortedDF <- cleanDF[ order(cleanDF[,2], cleanDF[,1]), ] 
        rankings <- nrow(sortedDF)                              # calculate number of ranked hospitals
        
        # If NUM == a character vector
        #
        # Return hospital name (character vector) that has the ranking specified by the num argument.  
        #
        if (is.character(num)) {
                
                if (num == "best") {
                        hospitalName <- as.character(sortedDF[1,1])             # return top of list
                        return(hospitalName)
                }           
                if (num == "worst") {
                        hospitalName <- as.character(sortedDF[rankings,1])    # return bottom of list
                        return(hospitalName)
                }
                else {
                        return("invalid input characters in num argument")
                }           
        }
        
        # If NUM == a numeric vector then
        #
        # Return hospital name (character vector) that has the ranking specified by the num argument.  
        #
        if (is.numeric(num)) {
                
                # test to see if num arg is valid             
                rank <- as.integer(num)                                 # convert input arg to integer    
               
                if (rank > rankings) {                                  # exceeds number of rankings
                        return("NA") 
                }
                
                hospitalName <- as.character(sortedDF[rank,1])         # return based on requested ranking
                return(hospitalName)
                
        }  
         
        # should not end up here with valid NUM input
        #
        else {
                return(":::ERROR:::invalid input for NUM")
        }
      
}

## unused but useful example code
#
# rate <- min(statedata[,j])                              # determine lowest mortality
# i <- which.min(statedata[,j])                           # which row?
# best_hospital <- as.character(statedata[i,"Hospital.Name"])



