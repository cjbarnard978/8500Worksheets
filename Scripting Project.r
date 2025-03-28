Scripting Project
library(internetarchive)
library(dplyr)
ia_list_fields()

NLS_query <- c("contributor" = "National Library of Scotland", "language" = "iri")
ia_search(NLS_query, num_results = 50)

ats_query <- c("publisher" = "american tract society", "year" = "1864")
ia_search(ats_query, num_results = 20)
#this is the example model from opensci-I couldn't figure out why my code wasn't running so I copied this in
#this ran and demonstrated that I had the syntax in ia_search wrong! 

NLS_query <- c("contributor" = "National Library of Scotland", "language" = "iri")
ia_search(NLS_query, num_results = 50)

#this pulled results! Now let's try to download
NLSdirectory <- tempdir() 
ia_search(NLS_query, num_results = 50) %>% ia_get_items() %>% ia_files() %>% filter(type == "txt") %>% group_by(id) %>% ia_download(dir = NLSdirectory, overwrite = FALSE) %>% glimpse()
#can't see the directory in R? I think I skipped a step? They're stored somewhere VERY weird-I did skip a step: I forgot to pull my metadata

NLS_query <- c("contributor" = "National Library of Scotland", "language" = "iri")
ia_search(NLS_query, num_results = 50)

NLS_metadata <- ia_search(NLS_query, num_results = 97) %>% ia_get_items() %>% ia_metadata  %>% filter(field == "title") %>% select(value)
as_tibble(NLS_metadata)

#because filtering wasn't doing what I wanted it to do necessarily, Amber and Mandolyn both advised to switch to pivoting and selecting 
#there's a lot of degraded or outdated code in this package-it wanted me to create a tibble because the dataframe code doesn't work, so I put my ia_search code into as_tibble
NLSdirectory <- tempdir() 
ia_search(NLS_query, num_results = 50) %>% ia_get_items() %>% ia_files() %>% filter(type == "txt") %>% group_by(id) %>% ia_download(dir = NLSdirectory, overwrite = FALSE) %>% glimpse()
#there is no weird file path-there's just a specific code to find the files: list.files(directoryname) that Mandolyn found! 
list.files(NLSdirectory)
#I went back in and removed the filter from my code after this-I want to see the full metadata tibble before I try to write my loop.
#The full metadata tibble is a COMPLETE nightmare that I think it would take me all summer to fix correctly. 
#But I did verify that it all downloaded, then went back in and filtered for title and language. 
#The goal of my loop is to write one that separates out .txt files that have both English and Irish text.
#this is me trying something
ia_metadata("NLS_query")
#yeah okay this didn't work
#I'm having an issue with my filter so reinitiated tidyverse 
#I think I did this wrong so I'm "starting over" aka not just mindlessly pulling stuff from the internet archive

NLS_query <- c("contributor" = "National Library of Scotland", "language" = "iri")
ia_search(NLS_query, num_results = 97)
translationdf = data.frame()
for (i in length(NLS_metadata$title))
    if ("language" == "iri" & "language" == "eng")
        next
    if("language" == "iri" | "language" == "eng")
        break
    print(title)

NLS_query <- c("contributor" = "National Library of Scotland", "language" = "iri")
ia_search(NLS_query, num_results = 97)
NLS_metadata <- ia_search(NLS_query, num_results = 97) %>% ia_get_items() %>% ia_metadata %>% select(value)
as_tibble(NLS_metadata)
metadata.filtered <- NLS_metadata %>% pivot_wider (names_from = field, values_from = value)
#this took a very long time to figure out and Mandolyn came through with the solution for dataframes with one column
NLS_metadata
colnames(NLS_metadata) <- "title"
for (i in length(NLS_metadata$title)) {
    if ("language" == "eng") {
    print(NLS_metadata$title) 
     } else if ("language" != "eng") {
    print(NULL)
     }
}
#and this is where Amber reminded me that copilot exists
#error: unexpected else in "    else"-let's ask copilot: it's a syntax error
#copilot says to store in a dataframe which I was thinking about anyway
#here's how it says to do it 
for (i in seq_along(NLS_metadata$title)) {
    if (language)
}
#STARTING OVER FROM THE BEGINNING 

x