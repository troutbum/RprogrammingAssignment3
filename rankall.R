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
        datacol <- suppressWarnings(as.numeric(subset(alldata)[,j]))    # extract mortality rate column non-numeric 
        # data  (e.g. 'Not Available') coerced to NAs
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
        
        # Iterate through all states
        for (i in 1:nStates) {  
                
                # Set rank based upon NUM input
                # If NUM == a character vector
                if (is.character(num)) {                                        
                        if (num == "best") {
                                rank <- 1                               # Best hospital in rankings
                        }           
                        if (num == "worst") {                           # Last hospital in rankings
                                rank <- as.numeric(nRanked[i])
                        }
                        else {
                                return("invalid input characters in num argument")
                        }           
                }        
                # If NUM == a numeric vector
                if (is.numeric(num)) {                                          
                        rank <- as.integer(num)                                                   
                }
                
                stateRankings <- rankings[[stateCodes[i]]]              # to make ranked list of hospitals
                stateHospital <- as.character(stateRankings[rank,1])    # pick hospital based on input NUM
                outputDF[i,"HospitalName"] <- stateHospital             # stuff results into data.frame
                outputDF[i,"StateName"] <- stateCodes[i]               
        } 
        return(outputDF)
}



