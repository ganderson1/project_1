library(tidyverse)
library(readxl)
library(janitor)


#Cleaning
#Extract all species names

#merge adult/subadult/plumage records

#Find and replace with current species (genus) name
#Catharacta / Stercorarius sp. = Stercorarius sp.
# Diomedea impavida / melanophrys = Thalassarche impavida / melanophrys
# Larus bulleri = Chroicocephalus bulleri
# Larus novaehollandiae = Chroicocephalus novaehollandiae
# Lugensa brevirostris = Aphrodroma brevirostris
#  #Procelsterna cerulea = Anous cerulea
#  Puffinus bulleri = Ardenna bulleri
#  Puffinus carneipes = Ardenna carneipes
#  Puffinus carneipes / pacificus = Ardenna carneipes / pacificus
#  Puffinus griseus = Ardenna griseus
#  Puffinus pacificus = Ardenna pacificus
#  Puffinus tenuirostris	= Ardenna tenuirostris
#  Puffinus tenuirostris / griseus	= Ardenna tenuirostris / griseus
#  Sterna albifrons = Sternula albifrons
#  Sterna bergii	= Thalasseus bergii
#  Stictocarbo punctatus	= Phalacrocorax punctatus

#Typos  
# Phaeton sp. = Phaethon sp.
#  Thallassarche cauta cauta / steadi = Thalassarche cauta cauta / steadi
#  Thallassarche sp = Thalassarche sp.

#Issues
#  Procellaria parkinsoni / Pterodroma macroptera gouldi	= !2 genera
#  Procellaria parkinsoni / Puffinus (Ardenna) carneipes	= !2 genera
#  Eudyptes / Magadyptes sp	= !2 genera in one row

#Still on task 1 @ 16:00 Tues so used find and replace on xls file in google sheets to (carefully) make changes to data (cross referencing with R ouput for number of unique species name forms)

#Also used find and replace here to remove any suffx terms (AD, JUV, SUBAD, IMM, DRK, LGHT etc)

#Exported from google sheets as new excel file (google sheets only allows .xlsx output) to perform rest of the cleaning



excel_sheets("raw_data/seabirds.xls")

raw_ship_data <- read_excel("raw_data/seabirds.xls", sheet = 1) %>% clean_names()
raw_bird_data <- read_excel("raw_data/seabirds.xls", sheet = 2) %>% clean_names()

raw_ship_data %>% 
  select(record, record_id, lat, long)

raw_bird_data %>% 
  select(record, record_id, species_common_name_taxon_age_sex_plumage_phase, species_scientific_name_taxon_age_sex_plumage_phase, species_abbreviation, count)

clean_bird_data <- raw_bird_data %>% write_csv('clean_data/clean_bird_data.csv')