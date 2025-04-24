library(tidyverse)
library(tidytext)
library(readtext)
irishlangtexts <- readtext(paste(getwd(), "/IrishLangDirectory/*.txt", sep=""))

tokenizedirishlang <- irishlangtexts %>% unnest_tokens(word, text)
tokenizedirishlang <- tokenizedirishlang %>% anti_join(stop_words)
Irishlangfiltered <- tokenizedirishlang %>% filter(word %in% c("beetle", "worm", "dearg a dol", "wyrm"))
filteredIteProject <- Irishlangfiltered %>% count(word, doc_id) %>% arrange(desc(n))