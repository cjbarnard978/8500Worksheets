02/19 practice 



almshouse_admissions[,3]
yearadmitted <-almshouse_admissions[3]
almshouse_admissions[8]
yeardischarged <-almshouse_admissions[8]

(yeardischarged-yearadmitted)
(almshouse_admissions$YearDischarged-almshouse_admissions$Year.Admitted)

library(DigitalMethodsData)
data(gayguides)
gayguides[5]
ibrary(DigitalMethodsData)
data(BostonWomenVoters)
for (ag in 1:length(BostonWomenVoters$Age)) {
  if(!is.na(BostonWomenVoters$[ag]) && BostonWomenVoters$Age[ag] == 21)  
  if (BostonWomenVoters$Age[ag] == 21) {
    print(BostonWomenVoters$Name[ag])
  }
}

state population question !!!!
data(statepopulation)

for (i in 1:nrow(statepopulations)) {
    if (is.na(statepopulations$X1800[i])) {
        next
    }
    if (statepopulations$X1800[i] > 250000) {
        next
    }
    if (statepopulations$X1800[i] <200000) {
        next
    }
    print(statepopulations$X1800[i])
}

is.na(BostonWomenVoters$Age[50])


historyStudents <- function(studentname, class) {
  statement <- paste("Hello ", studentname, ". Welcome to ", class, "!", sept="")
  statement
}
historyStudents("Cecilia", "HIST8500")
Write a function that takes admit.year: needs to subset the data so that there's a new dataset called subset_data that contains entries that contain admit year that is passed to the function 
Calculate the difference between year discharged and year admitted 
Print each row in the console-statement that says "Found a stay. Last Name, First name, who was admitted in X year, and their stay lasted Y years"  

 

Library(DigitalMethodsData)
data(almshouse_admissions)

length.of.admission <- function(admit.year) {
    subset.data <- almshouse_admissions$Year.Admitted[admit.year]
    difference.calculation <- almshouse_admissions$YearDischarged[admit.year] - almshouse_admissions$Year.Admitted[admit.year]
    print(paste("Found a stay,", almshouse_admissions$First.Name, almshouse_admissions$Last.Name, ", admitted in", almshouse_admissions$Year.Admitted, ". Their stay lasted", difference.calculation, ","))
}

length.of.admission(1796)

length.of.adm