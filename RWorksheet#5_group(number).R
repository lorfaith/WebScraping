library(rvest)
library(httr)
library(dplyr) # use of pipeline %>%
library(polite)

#install.packages("kableExtra")
#kableExtra package is to create tables using the kable() function 

library(kableExtra)



polite::use_manners(save_as = 'polite_scrape.R')

#Specifying the url for desired website to be scraped
url <- 'https://www.imdb.com/chart/toptv/?ref_=nv_tvv_250'

# asking permission to scrape
session <- bow(url,
               user_agent = "Educational")
session

#creating objects for the dataset
rank_title <- character(0)

# scraping in polite way using the h3 element
title_list <- scrape(session) %>%
  html_nodes('h3.ipc-title__text') %>% 
  html_text

# Extracting titles and simple data cleaning process
# we will use the title_list 
class(title_list)

title_list_sub <- as.data.frame(title_list[2:51])

head(title_list_sub)
tail(title_list_sub)
#changing column names to ranks
colnames(title_list_sub) <- "ranks"

#split the string(rank and title)
split_df <- strsplit(as.character(title_list_sub$ranks),".",fixed = TRUE)
split_df <- data.frame(do.call(rbind,split_df))

#rename and delete columns
# deleting columns 3 and 4 since it duplicated the columns
split_df <- split_df[-c(3:4)] 

#renaming column 1 and 2
colnames(split_df) <- c("ranks","title") 

# structure of splif_df
str(split_df) 
class(split_df)
head(split_df)

rank_title <- data.frame(
  rank_title = split_df)
rank_title<-rank_title[,-3]
colnames(rank_title)<-c("Rank","Title")
write.csv(rank_title,file = "title.csv")

#------------------------------------------------------------


rate<- character(0)

# scraping in polite way using the h3 element
rate_list <- scrape(session) %>%
  html_nodes('span.ipc-rating-star--imdb') %>% 
  html_text

# Extracting titles and simple data cleaning process
# we will use the title_list 
class(rate_list)

rate_list_sub <- as.data.frame(rate_list[2:51])

head(rate_list_sub)
tail(rate_list_sub)
#changing column names to ranks
colnames(rate_list_sub) <- "ratings"

#split the string(rank and title)
split_df <- strsplit(as.character(rate_list_sub$ratings), "(",fixed = TRUE)
split_df <- data.frame(do.call(rbind,split_df))

#rename and delete columns
# deleting columns 3 and 4 since it duplicated the columns
split_df <- split_df[-c(3:4)] 

#renaming column 1 and 2
colnames(split_df) <- c("Ratings","Number of Votes") 

# structure of splif_df
str(split_df) 
class(split_df)
head(split_df)
split_dq <- strsplit(as.character(split_df$`Number of Votes`), ")",fixed = TRUE)
split_df<-split_df[,-2]
split_df<-rbind(split_df,split_dq)

split_df<-t(split_df)
split_df

ratings <- data.frame(
  ratings = split_df)
colnames(ratings)<-c("Ratings","Number of Votes")
ratings

next2<-cbind(rank_title,ratings)
next2
