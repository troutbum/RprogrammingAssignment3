# rankall(outcome, num)
#    * outcome : either "heart attack" "heart failure" "pneumonia"
#    * num : ranking to be returned, an integer or "best" or "worst"
#    * returns : a dataframe with the hospital names and 2-char state name for the given ranking (num)
#                for all 50 states and the District of Columbia

rankall <- function(outcome, num) {
        
        ## Check that outcome arg is valid 
        ##
        valid_outcomes <- c("heart attack", "heart failure", "pneumonia")  
        if (!(outcome %in% valid_outcomes)) {
                stop("invalid outcome")
        }           
        
        # set j to the correct column in the input data table
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
     
        # Condense data to just hospital, mortality rate and state
        datacol <- as.numeric(subset(alldata)[,j])                      # extract mortality rate column 
        namecol <- as.character(subset(alldata)[,"Hospital.Name"])      # extract hospital name column
        statecol <- as.character(subset(alldata)[,"State"])             # extract State name                
        
        # !!! Must use this CBIND.DATA.FRAME to add columns of numeric and character columns!!!                              
        subDF <- cbind.data.frame(namecol,datacol,statecol)                      
        
        # remove NA rows
        cleanDF <- na.omit(subDF)
        
        # Split data by state and then 
        # Apply sort (mortality rate, hospital name) to split
        #
        splitData <- split(cleanDF, cleanDF$statecol)                   # data split by state        
        rankings <- lapply(splitData, function(cleanDF) 
                cleanDF[ order(cleanDF[,2], cleanDF[,1]), ]  )          # complete set of rankings by state
        
        nRanked <- lapply(rankings, function(cleanDF) nrow(cleanDF))    # number of ranked hospitals per state
        
        # Read in US States table and coerce State codes
        USstates <- read.csv("states.csv", colClasses = "character")
        stateCodes <- USstates[,2]                                      # get state 2-char abbreviations
        nStates <- length(stateCodes)                                   # number of states (54 w/ DC, GU, PR, VI)
        
        # iterate through US states and find corresponding hospital for the given ranking
        
        rank <- 1
        
        outputDF <- data.frame(HospitalName=character(),                # create dataframe for output
                               StateName=character(),
                               stringsAsFactors=FALSE) 
        
        for (i in 1:nStates) {                                          # iterate through each state
                stateRankings <- rankings[[stateCodes[i]]]              # to make ranked list of hospitals
                stateHospital <- as.character(stateRankings[rank,1])    # pick hospital based on input NUM
                outputDF[i,"HospitalName"] <- stateHospital             # stuff results into data.frame
                outputDF[i,"StateName"] <- stateCodes[i]               
        }

        
        
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



