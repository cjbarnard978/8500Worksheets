library(tidyverse)
library(tidytext)
library(readtext)
library(widyr)
library(SnowballC)

rec <- readtext(paste(getwd(), "/txt/*.txt", sep = ""))
install.packages("tidytext")
install.packages("readtext")
install.packages("widyr")
install.packages("SnowballC")
View(rec)
metadata <- read.csv("metadata.csv", sep = ",", header = TRUE)
View(metadata)
recjoin <- full_join(rec, metadata, join_by("doc_id" == "file_name"))
tidy_rec <- recjoin %>% unnest_tokens(word, text)
View(tidy_rec)
tidy_rec <- recjoin %>% unnest_tokens(bigram, text, token = "ngrams", n=2)
View(tidy_rec)
print(stop_words, n=25)
custom_stopwords <- stop_words %>% add_row(word = "Recreation", lexicon=NA)

tidy_rec <- tidy_rec %>% anti_join(custom_stopwords, by = "word")

rec_words <- tidy_rec %>% count(word, sort = TRUE)
print(desc(rec_words), n= 25)
View(rec_words) 

wwd <- tidy_rec %>% filter(word %in% c("women", "defense", "war")) %>% count(year, word)

#TF_IDF: counts per document per word
TFIDF <- tidy_rec %>% count(doc_id, word, sort=TRUE)
TFIDF <- TFIDF %>% bind_tf_idf(word, doc_id, n) %>% arrange(desc(tf_idf))