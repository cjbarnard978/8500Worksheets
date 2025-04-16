Word Embedded Model: Library of Christian Classics


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

#Let's try with this english specific corpus. Library of Christian Classics is a collection of primary sources relating to theology
#It collects sermons, homilies, etc. This corpus includes the volume on Alexandrian Christianity, both volumes on St. Augustine,
#and the volume on Western Asceticism. In other works, early Christian thought and monastic life. 
#I want to see what they're saying about women, heresy, and magic. Is it positive or negative? Does it make a regional or spatial argument?
#How is heresy connected to women? Is it connected?

if(!file.exists("rec.txt")) prep_word2vec(origin = "Lib.Christian.Classics.Texts", destination = "rec.txt", lowercase = TRUE, bundle_ngrams = 1)

if (!file.exists("rec.bin")) {
    model <- train_word2vec("rec.txt", "rec.bin", vectors = 150, threads = 3, window = 12, iter = 5, negative_samples = 0)
} else {
    model <- read.vectors("rec.bin")
}
model %>% closest_to("heresy")
#The same error message: error in vapply(x, asJSON, character(nrow(c)), collapse = FALSE, complex = complex, : values must be length 4070,
#but FUN(X[[4]]) result is length 4071
#Let's ask the robot: tells me to remove rec.bin and reload it. 
file.remove("rec.bin")
#This didn't work, but I went through the corpus manually and found some weird, corrupted txt files that I deleted
#I also cleared my environment completely. Still throwing an error. Copilot: change T to True 
#Trying this code that copilot generated-maybe it's because it's an IA corpus? 
prep_word2vec(origin = "Lib.Christian.Classics.Texts", destination = "rec.txt", lowercase = TRUE, bundle_ngrams = 1)
model <- train_word2vec("rec.txt", "rec.bin", vectors = 150, threads = 3, window = 12, iter = 5, negative_samples = 0)
model %>% closest_to("heresy")
#My theory is that because this is a corpus I scraped and tidied myself, the files ALL existed
#and thus I didn't need to run the loop because I know all the files existed. 
model %>% closest_to(c("heresy", "woman", "magic", "witch"))
WEMselectedwords <- model %>% closest_to(c("heresy", "woman", "magic", "witch"), n = 25)

womenLCCT <- model[[c("women", "heresy"), average = F]]
womenLCCT2 <- model[2:100, ] %>% cosineSimilarity(womenLCCT, womenLCCT)
womenLCCT2 <- womenLCCT2[
    rank(-womenLCCT2[, 1]) < 10 |
        rank(-womenLCCT2[ 2]) < 10
]
plot(womenLCCT2, type = "n") 
text(womenLCCT2, labels = rownames(womenLCCT2))
library(ggplot2)
#I'm asking the robot why my visualization is blank-I reduced the model ratio to see if that helped but no change
#Lots of solutions so we'll go one by one 
print(womenLCCT2) #this is not empty 
#the next solution is to adjust the limits of x and y. 
plot(womenLCCT2, type = "n", xlim = c(-1,1), ylim = c(-1,1)) #copilot recommended this and then 0.5
text(womenLCCT2, labels = rownames(womenLCCT2)) #I want to change the rownames but I need the visual first
plot(womenLCCT2, type = "n", xlim = c(-.5, 0.5), ylim = c(-.5, .5))
text(womenLCCT2, labels = rownames(womenLCCT2))
#still blank-checking the cosine similarity matrix next
dim(womenLCCT2) # this says NULL? 
#I tried to change it and it didn't work. Asked the robot to debug the cosine similarity
dim(model[1:100,])
dim(womenLCCT)
head(model[1:100, ])
head(womenLCCT)
#checked all of these per robot and they're all fine. Next we check the "model object"
#and make sure the word vectors are actually IN the model 
"women" %in% rownames(model)
"heresy" %in% rownames(model)
#Both work 
model[["women"]]
model[["heresy"]]
#they're both in the model 
str(womenLCCT)
head(womenLCCT)
#This all works too. Debugging now using copilot code 
result <- cosineSimilarity(model[1:100, ], womenLCCT)
str(result)
#I have NO idea why this isn't running.
#Error: Error in vapply(x, asJSON, character(nrow(x)), collapse = FALSE, complex = complex,  : 
  values must be length 2,
 but FUN(X[[4]]) result is length 3
#womenLCCT has 2 words and 150 vectors-let's change the matrix to 2
??cosineSimilarity
try typing womenLCCT into cosine twice