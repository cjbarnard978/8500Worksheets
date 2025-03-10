3/05 Practice Tech table

filtering 
data(gayguides)
y <- gayguides %>% filter(Year == 1975)
print(y)

Group by and summarize for BWV data
data(BostonWomenVoters)
avg.BWV <- BostonWomenVoters %>% group_by(age, occupation) %>% summarize(mean = etc )

joined.gg <- left_join(gayguiddes, regions, by=c("state" = "State.Code"))
joined.gg <- joined.gg %>% select(-State)

filter(Year == 1975 & !(city %in% c("New York", "San Franscisco")))
filter(Year == 1975 & city != "New York" & city != "San Franscisco")

data(BostonWomenVoters)
BostonWomenVoters <-BostonWomenVoters %>% group_by(Occupation, Age) %>% summarize (count = n())
BostonWomenVoters <- BostonWomenVoters %>% group_by(Age) %>% summarize (count = n())

data(gayguides)
gg.year <- gayguides %>% filter(Year == 1975) %>% group_by(state) %>% summarize (count = n()) %>% mutate(location_density = count/1000000 * 100000) %>% select(c(state, location_density)) %>% arrange(desc(location_density))
