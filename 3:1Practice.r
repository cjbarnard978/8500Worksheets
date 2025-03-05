3/1 Practice
library(tidyverse)
library(DigitalMethodsData)

data(gayguides)
select.mgg <- gayguides %>% select(title, city, state) %>% filter(state == "NY")

mgg.address <- gayguides %>% mutate(full_address = paste(city, state, sep =", "))

mgg.sort <- gayguides %>% arrange(desc(city))

mgg.city <- gayguides %>% group_by(city) %>% summarize(count = n())
data <- read.csv("farm-ownership-data-1925-35 (2).csv")

select.farmdata <- data$farms.full.owners + data$farms.part.owners 

totalowners <- data %>% mutate(total.owners =paste(data$farms.full.owners + data$farms.part.owners))


farmdatafinal<- totalowners %>% group_by(county, state, total.owners) %>% filter(year == 1925) %>% arrange(total.owners)

