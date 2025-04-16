Word Embedded Model: NLS Parish Register Collection 


library(wordVectors)
library(tidytext)
if(!file.exists("rec.txt")) prep_word2vec(origin = "NLSParishRegisterTexts", destination = "rec.txt", lowercase = T, bundle_ngrams = 1)

if(!file.exists("rec.bin")) {
    model <- train_word2vec("rec.txt", "rec.bin", vectors = 150, threads = 3, window = 12, iter = 5, negative_samples = 0)
} else {
    model <- read.vectors("rec.bin")
}
#here's where the latin comes in
#heresy = haeresis, haeretice, haereticus (this is more like "heretic")
#magic = magicus, magice, magia 
#woman = mulier
#girl = puella
#court = crimen alicui, criminalis

model %>% closest_to("haeresis")
model %>% closest_to("haeretice")
model %>% closest_to("puella")

#the word2vec model does not generate good data using a corpus that is in any way bilingual-these parish registers
#have English prefaces 
#Let's try something that's theological AND in English. 
library("internetarchive")
library("tidyverse")
MedTheologyQuery <- c(title = "Library of Christian Classics")
ia_search(MedTheologyQuery, num_results = 20) %>% ia_get_items() %>% ia_metadata() %>% filter(field == "title" | field == "publicdate")
Lib.Christian.Classics.Meta <- as.data.frame(ia_search(MedTheologyQuery, num_results = 20) %>% ia_get_items() %>% ia_metadata() %>% filter(field == "title" | field == "publicdate"))
Lib.Christian.Classics.Meta <- Lib.Christian.Classics.Meta %>% pivot_wider(names_from = field, values_from = value)
dir.create("Lib.Christian.Classics.Texts")
ia_search(MedTheologyQuery, num_results = 11) %>% ia_get_items %>% ia_files %>% filter(type == "txt") %>% group_by(id) %>% ia_download(dir = "Lib.Christian.Classics.Texts", overwrite = FALSE,) %>% glimpse()

#Let's try with this english specific corpus

if(!file.exists("rec.txt")) prep_word2vec(origin = "Lib.Christian.Classics.Texts", destination = "rec.txt", lowercase = T, bundle_ngrams = 1)

if (!file.exists("rec.bin")) {
    model <- train_word2vec("rec.txt", "rec.bin", vectors = 150, threads = 3, window = 12, iter = 5, negative_samples = 0)
} else {
    model <- read.vectors("rec.bin")
}
model %>% closest_to("heresy")
#The same error message: error in vapply(x, asJSON, character(nrow(c)), collapse = FALSE, complex = complex, : values must be length 4070,
#but FUN(X[[4]]) result is length 4071
#Let's ask the robot 
