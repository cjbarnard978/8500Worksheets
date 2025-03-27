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
#can't see the directory in R? I think I skipped a step? They're stored somewhere VERY weird
