# named entity recognition


#load your data
library(data.table)
corpus <- fread("")

# what language model? 
#https://spacy.io/usage/models

##
#en
###

library(spacyr)
# spacy_finalize() #close previous session (where previous language model was loaded)
spacy_initialize(model = "en")


#  the function spacy_extract_entity extracts entities without first parsing the entire text:

corpus_entities <- spacy_extract_entity(corpus$text_mt) # specify the text column


# specify the enty_types wanted, for an overview of available entities see https://spacy.io/usage/linguistic-features#named-entities

# 'PER'  = Named person or family; 
# 'GPO' = Geopolitical entity, i.e. countries, cities, states..
# 'ORG' =  Named corporate, governmental, or other organizational entity.
# 'MISC' =  #Miscellaneous entities, e.g. events, nationalities, products or works of art. 

# select  'LOC', 'GPE' 'PER' aggregate back as string on article level

table(corpus_entities$ent_type)
corpus_entities_sub <- subset(corpus_entities, ent_type == 'PER' | ent_type == 'GPE' | ent_type == 'LOC')
#write.csv(corpus_entities_sub, "corpus_entities.csv") save it just as a backup


# Aggregate all extracted entities and the corresponding entity_type per article & list them in one string separated by ; 

library(dplyr)
#entity text
entity_agg <- corpus_entities_sub %>% 
  group_by(doc_id) %>% 
  mutate(entity = paste0(text, collapse = "; "))

entity_agg <- subset(entity_agg, select = c(doc_id, entity))

entity_agg$dupl <- duplicated(entity_agg$doc_id) #tag duplicated rows
entity_agg <- subset(entity_agg, dupl == FALSE)# select only unique rows
entity_agg <- subset(entity_agg, select = c(doc_id, entity))


