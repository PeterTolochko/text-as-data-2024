


uk <- fread("filename.csv")

# general set up and selection English language model
library(udpipe)
udmodel_uk <- udpipe_download_model(language = "english")
udmodel_uk <- udpipe_load_model(file = udmodel_uk$file_model)

# annotation
udi_uk <- udpipe_annotate(udmodel_uk, x = uk$all_text_orig_lang, doc_id = uk$sample_ID) # all_text_orig_lang is your text column, sample_ID is your id columns
udi_uk <- as.data.frame(udi_uk)



# Select specific POS tags (in this example it is "nouns", check out the upos column and the documentation of udpipe to find out about the meaning of other POS tags.)

# select only nouns and adjectives
udi_uk_pos <- subset(udi_uk, upos %in% c("NOUN"))

library(dplyr)
udi_uk_lemma <- udi_uk_pos %>% 
  group_by(doc_id) %>% 
  mutate(lemma_pos = paste0(lemma, collapse = " "))

names(udi_uk_lemma)[names(udi_uk_lemma)=="doc_id"] <- "sample_ID" #rename column: doc identifier
udi_uk_lemma <- subset(udi_uk_lemma, select = c(sample_ID, lemma_pos))


udi_uk_lemma$dupl <- duplicated(udi_uk_lemma$sample_ID) #tag duplicated rows
udi_uk_lemma <- subset(udi_uk_lemma, dupl == FALSE)# select only unique rows
udi_uk_lemma <- subset(udi_uk_lemma, select = c(sample_ID, lemma_pos))
udi_uk_lemma$sample_ID <- as.character(udi_uk_lemma$sample_ID)

