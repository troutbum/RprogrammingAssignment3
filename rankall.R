# rankall(outcome, num)
#    * outcome : either "heart attack" "heart failure" "pneumonia"
#    * num : ranking to be returned, an integer or "best" or "worst"
#    * returns : a dataframe with the hospital names and 2-char state name for the given ranking (num)
#                for all 50 states and the District of Columbia

rankall <- function(outcome, num = "best") {
        
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
        
        #USstates <- read.csv("states.csv", colClasses = "character")
        #stateCodes <- USstates[,2]                                      # get state 2-char abbreviations
        
        stateCodes <-sort(c(state.abb, "DC", "GU", "PR", "VI"))         # get state 2-char abbreviations
        nStates <- length(stateCodes)                                   # number of states (54 w/ DC, GU, PR, VI)
        
        # iterate through US states and find corresponding hospital for the given ranking
        
        outputDF <- data.frame(hospital=character(),                # create dataframe for output
                               state=character(),
                               stringsAsFactors=FALSE)
        
        # Iterate through all states
        for (i in 1:nStates) {  
                
                # Set RANK based upon NUM input             
                if (is.character(num)) {                                # If NUM == a character vector          
                        if (num == "best") {                               
                                rank <- 1                               # best hospital
                        } else if (num == "worst") { 
                                rank <- as.numeric(nRanked[i])          # lookup last ranking
                        } else stop("Input char NUM is 
                                    neither 'best' nor 'worst'")
                        
                } else if (is.numeric(num)) {                           # If NUM == a numeric vector
                        rank <- as.integer(num)                                                   
                } else stop("Problem with NUM arg, neither char nor numeric")                  
                
                
                
                stateRankings <- rankings[[stateCodes[i]]]              # to make ranked list of hospitals
                stateHospital <- as.character(stateRankings[rank,1])    # pick hospital based on input NUM
                outputDF[i,"hospital"] <- stateHospital             # stuff results into data.frame
                outputDF[i,"state"] <- stateCodes[i]               
        } 
        return(outputDF)
}



