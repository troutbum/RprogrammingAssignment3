best <- function(state, outcome) {
        
        outcome <- "hearts attack"
        
        # test to see if outcome is valid
        valid_outcomes <- c("heart attack", "heart failure", "pneumonia")   
        if (!(outcome %in% valid_outcomes)) {
                return("outcome not valid")
}
        
        # test to see if state 2-digit code is valid
        state <- "PI"        
        states <- read.csv("states.csv", colClasses = "character")
        valid_statecodes<- states[,"StateAbbr"]
        if (!(state %in% valid_statecodes)) print("not valid")
        
        data <- read.csv("outcome-of-care-measures.csv")  # read outcome data
        s <- split(data, state, outcome)
        
}

## Check that state and outcome are valid
## Return hospital name in that state with lowest 30-day death
## rate