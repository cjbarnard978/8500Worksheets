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
