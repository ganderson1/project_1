library(tidyverse)
library(stringr)
library(janitor)
library(readxl)

candy2015_raw <- read_excel("raw_data/boing-boing-candy-2015.xlsx") %>% clean_names()
candy2016_raw <- read_excel("raw_data/boing-boing-candy-2016.xlsx") %>% clean_names()
candy2017_raw <- read_excel("raw_data/boing-boing-candy-2017.xlsx") %>% clean_names()


#rename column headers in candy2017_raw (remove q1-9 prefix)


candy2017_raw <- candy2017_raw %>% 
  rename_at(vars(matches("q[1-9]_")), ~ str_remove(., "q[1-9]_"))



#what is needed to answer questions?
 # candy ratings, age, Country (none for 2015), gender (none for 2015), going trick or treating?,
#
#country in 2016 and 2017 a mess. Need to check for unique entries, choose which to include or disregard (state has info that sometimes be useful(also state/country sometimes switched)) 

candy2017_raw <- candy2017_raw %>% 
  select(-1, -81, -12, -65:-69, -110:-120)
candy2016_raw <- candy2016_raw %>% 
  select(-1, -79, -12, -66:-68, -107:-123)
candy2015_raw <- candy2015_raw %>% 
  select(-1, -97:-114, -116:-124)

candy2015_raw <- candy2015_raw %>% 
  rename("age" = 1) %>%
  rename("going_out" = 2) %>% 
  rename("m_ms_regular" = 73) %>%
  rename("m_ms_peanut" = 72) %>% 
  rename("m_ms_mint" = 74) %>% 
  rename("hersheys_dark_chocolate" = 21) %>%
  rename("hersheys_milk_chocolate" = 36) %>%
  rename("hersheys_kissables" = 35) %>%
  rename("reeses_peanut_butter_cups" = 64) %>%
  relocate(2) %>% 
  add_column(year = 2015, .before = "going_out" )

candy2016_raw <- candy2016_raw %>% 
  rename("box_o_raisins" = 12) %>% 
  rename("country" = 4) %>%
  rename("state_province" = 5) %>%
  rename("gender" = 2) %>% 
  rename("age" = 3) %>%
  rename("going_out" = 1) %>% 
  rename("m_ms_regular" = 62) %>% 
  rename("m_ms_peanut" = 63) %>% 
  rename("sweetums" = 88) %>%
  rename("licorice" = 53) %>%
  rename("hersheys_milk_chocolate" = 39) %>%
  rename("bonkers" = 10) %>%
  rename("reeses_peanut_butter_cups" = 75) %>%
  add_column(year = 2016, .before = "going_out" )

candy2017_raw <- candy2017_raw %>% 
  rename("box_o_raisins" = 12) %>% 
  rename("state_province" = 5) %>%
  rename("x100_grand_bar" = 6) %>%
  rename("m_ms_regular" = 61) %>% 
  rename("m_ms_peanut" = 62) %>% 
  rename("sweetums" = 88) %>%
  rename("licorice" = 53) %>%
  rename("hersheys_milk_chocolate" = 39) %>%
  rename("anonymous_brown_globs_that_come_in_black_and_orange_wrappers" = 7) %>%
  rename("bonkers" = 10) %>%
  rename("reeses_peanut_butter_cups" = 74) %>%
  add_column(year = 2017, .before = "going_out" )



#sort candy variable columns by name

candy2015_raw <- candy2015_raw %>% select(1:3, sort(colnames(.)))
candy2016_raw <- candy2016_raw %>% select(1:6, sort(colnames(.)))
candy2017_raw <- candy2017_raw %>% select(1:6, sort(colnames(.)))




all_equal(candy2017_raw, candy2017_raw, ignore_col_order = FALSE)


candyall <- full_join(candy2016_raw, candy2017_raw) %>% 
  full_join(candy2015_raw) %>% 
  select(1:6, sort(colnames(.)))


#replace age by NA if not number

candyall$age <- as.numeric(as.character(candyall$age))





candyall <- candyall  %>% 
  mutate(country = tolower(country)) 

#should have given unique id to all rows

#strings to normalise country names
#usa_pat <- c("'ud'|'usa'|'us'|'usa'|'united states of america'|'usa'|'united states'|'united states'|'ussa'|'u.s.a'|'murica'|'usa!'|'usa (i think but it's an election year so who can really tell)'|'usa'|'u.s.'|'us'|'america'|'units states'|'united states'|'usa usa usa'|'the best one - usa'|'usa! usa! usa!'|'u.s.'|'the yoo ess of aaayyyyyy'|'united states of america'|'usa!!!!!!'|'usa! usa!'|'united sates'|'sub-canadian north america... 'merica'|'trumpistan'|'u.s.'|'merica'|'united states'|'united stetes'|'usa usa usa usa'|'united states of america'|'united state'|'united staes'|'u.s.a.'|'usausausa'|'us of a'|'unites states'|'the united states'|'north carolina'|'unied states'|'u s'|'the united states of america'|'unite states'|'usa? hard to tell anymore..'|''merica'|'usas'|'pittsburgh'|'new york'|'california'|'usa'|'i pretend to be from canada'|'but i am really from the united states.'|'united stated'|'ahem....amerca'|'new jersey'|'united ststes'|'united statss'|'murrika'|'usaa'|'alaska'|'united states'|'u s a'|'united statea'|'united ststes'|'usa usa usa!!!!'|'the republic of cascadia'|'cascadia'|'god's country'|'n. america'|'eua'|'narnia'|'i don't know anymore'|'cascadia'|'unhinged states'|'i don't know anymore'")

#can_pat <- c("can|canada|canada`|canae|soviet canuckistan")
#uk_pat <- c("endland|england|scotland|u.k.|uk|united kingdom")

#candyall <- candyall %>% 
#str_replace_all(usa_pat, 'usa')



write_csv(candyall, "clean_data/clean_candy_data.csv")
