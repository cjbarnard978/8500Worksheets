04/02/2025
"women" %in% c("women", "defense", "war")
splitfiles <-read.csv("metadata.csv")
#split file_name into 3 columns: month, year, vol #
remove txt first 
library(tools)
ymvol <- splitfiles %>% mutate(filenamenoext = file_path_sans_ext(splitfiles$file_name)) %>% separate(filenamenoext, c("year", "month", "volume number")) 
??separate
splitfiles <-read.csv("metadata.csv")
splitfiles <- splitfiles %>% select(-year, -month, -volume) 
splitfiles <- splitfiles %>% mutate(filenamenoext = file_path_sans_ext(file_name)) 
library(tidyr)
splitfiles <- splitfiles %>% separate(filenamenoext, into = c("year", "month", "volume number") sep = "-", fill = "right")