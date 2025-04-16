Word Vectors 04/14
library(wordVectors)
library(tidytext)
if (!file.exists("rec.txt")) {
    prep_word2vec(origin="txt", destination="Rec.txt",lowercase=T, bundle_ngrams = 1)
}
#prep a single file that has text of every file in the original corpus 
#tokenize 
if (!file.exists("rec.bin")) {
    model = train_word2vec("rec.txt", "rec.bin", vectors=150, threads=8
    window = 12, iter=5, negative_samples = 0)
} else {
    model = read.vectors("rec.bin")
}
#vectors parameter: dimensionality of representations-more vectors, more precision
#also more errors and a slower operation
#Threads: number of processors to use on your computer, 2-8 threads 
#iter/iterations parameter: how many times to read through the corpus 
#clusters are not topics 
library()
library(wordVectors)
library(tidyverse)

if (!file.exists("rec.txt")) prep_word2vec(origin = "TheWomanCitizen", destination = "rec.txt", lowercase = T, bundle_ngrams = 1)


if (!file.exists("rec.bin")) {
    model <- train_word2vec("rec.txt", "rec.bin", vectors = 150, threads = 3, window = 12, iter = 5, negative_samples = 0)
} else {
    model <- read.vectors("rec.bin")
}

## Similarity searches

model %>% closest_to("home")
model %>% closest_to("women")
model %>% closest_to("comfort")
model %>% closest_to(c("home", "women"), n = 25)


# 20 most common words with war and women
war <- model[[c("war", "women"), average = F]]
warwomen <- model[1:3000, ] %>% cosineSimilarity(war)
warwomen <- warwomen[
    rank(-warwomen[, 1]) < 20 |
        rank(-warwomen[, 2]) < 20,
]
plot(warwomen, type = "n")
text(warwomen, labels = rownames(warwomen))



# get 50 most common words to a group of terms - map those in space
war <- model[[c("war", "women", "men", "american"), average = F]]
common_similiarities_war <- model[1:3000, ] %>% cosineSimilarity(war)
common_similiarities_war[20:30, ]

high_similarities_to_women_war <- common_similiarities_war[rank(-apply(common_similiarities_war, 1, max)) < 75, ]
high_similarities_to_women_war %>%
    prcomp() %>%
    biplot(main = "Fifty wrods in a \n projection of women and war.")



# Using calculations to find words that are more used with women vs men etc.
# THIS SECTION SHOULD USE CLOSEST_TO NOT NEAREST_TO
model %>%
    nearest_to(model[["women"]]) %>%
    round(3)
model %>%
    nearest_to(model[["men"]]) %>%
    round(3)
model %>%
    nearest_to(model[["girls"]] - model[["boys"]]) %>%
    round(3)
model %>%
    nearest_to(model[[c("she", "her", "women", "woman")]] - model[[c("he", "his", "man", "men")]]) %>%
    round(3)

wowords <- model[[c("female", "females", "women", "woman", "feminine", "she", "woman's")]] %>% reject(model[[c("male", "males", "men", "man", "masculine", "he", "men's")]])

model %>% nearest_to(wowords, 100)


library(ggplot2)
gender_vector <- model[[c("feminine", "feminity", "woman", "women")]] - model[[c("masculine", "masculinity", "men", "man")]]

word_scores <- data.frame(word = rownames(model))
word_scores$gender_score <- model %>%
    cosineSimilarity(gender_vector) %>%
    as.vector()

ggplot(word_scores %>% filter(abs(gender_score) > .33)) +
    geom_bar(aes(y = gender_score, x = reorder(word, gender_score), fill = gender_score < 0), stat = "identity") +
    coord_flip() +
    scale_fill_discrete("Indicative of gender", labels = c("Feminine", "masculine")) +
    labs(title = "The words showing the strongest skew along the gender binary")









## Clustering
set.seed(10)
centers <- 150
clustering <- kmeans(model, centers = centers, iter.max = 40)

sapply(sample(1:centers, 10), function(n) {
    names(clustering$cluster[clustering$cluster == n][1:10])
})

## Dendograms
cultural_rec <- c("education", "social", "physical", "health")
term_set <- lapply(
    cultural_rec,
    function(cultural_rec) {
        nearest_words <- model %>% closest_to(model[[cultural_rec]], 20)
        nearest_words$word
    }
) %>% unlist()
subset <- model[[term_set, average = F]]
subset %>%
    cosineDist(subset) %>%
    as.dist() %>%
    hclust() %>%
    plot()
Collapse









