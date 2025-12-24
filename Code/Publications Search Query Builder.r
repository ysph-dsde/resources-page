## ----------------------------------------------------------------
## Publications Searching Guidance and Procedures
##
##      Authors: Shelby Golden, M.S.
## Date Created: October 12th, 2025
## 
## Description: All custom functions used to build search queries and to find 
##              publications that use a specific dataset and are affiliated 
##              with the Yale School of Public Health. Also includes some 
##              formatting in preparation for printing on an HTML page. 
##              Additional data-specific details are included to guide users 
##              to update the listed publications.

# The same functions are used in all data type folders.
source('Code/PubMed Search_Functions.R')


## Example usage:
## These examples demonstrate how to use the 'build_search_query' function
## to construct search queries for PubMed.
##
##   Example 1:
##   The listed keywords are combined using the OR operator. Each keyword 
##   is treated as a separate criterion, and the search results will include 
##   articles that match any of the keywords.

all_keywords_or <- build_search_query(
  keywords = c("National Health and Nutrition Examination Survey", "NHANES"), 
  affiliation = "Yale School of Public Health", years = 5)

##
##   Example 2:
##   Adding "AND" within a single element will treat the entire string as
##   one search criterion. This will search for articles that match all 
##   the keywords within the element together.

combined_keywords_and <- build_search_query(
  keywords = c("National Health and Nutrition Examination Survey AND NHANES"), 
  affiliation = "Yale School of Public Health", years = 5)




## ----------------------------------------------------------------
## FREELY ACCESSIBLE


## ----------------
## NCHS

build_search_query(
  keywords = c("National Center for Health Statistics", "NCHS"), 
  affiliation = "Yale School of Public Health", years = 5)


## ----------------
## NHANES

build_search_query(
  keywords = c("National Health and Nutrition Examination Survey", "NHANES"), 
  affiliation = "Yale School of Public Health", years = 5)


## ----------------
## NHIS

build_search_query(
  keywords = c("NCHS's National Health Interview Survey", "NHIS"), 
  affiliation = "Yale School of Public Health", years = 5)


## ----------------
## SEER

build_search_query(
  keywords = c("Surveillance, Epidemiology, and End Results Program", "SEER"), 
  affiliation = "Yale School of Public Health", years = 5)


## ----------------
## NHCS's

build_search_query(
  keywords = c("National Health Care Survey", "NHCS"), 
  affiliation = "Yale School of Medicine", years = 5)

build_search_query(
  keywords = c("National Ambulatory Medical Care Survey", "NAMCS"), 
  affiliation = "Yale School of Public Health", years = 5)

build_search_query(
  keywords = c("National Electronic Health Records Survey", "NEHRS"), 
  affiliation = "Yale", years = 5)

build_search_query(
  keywords = c("National Hospital Ambulatory Medical Care Survey", "NHAMCS"), 
  affiliation = "Yale School of Public Health", years = 5)


## ----------------
## RSS

build_search_query(
  keywords = c("Rapid Surveys System", "Rapid Surveys"), 
  affiliation = "Yale School of Public Health", years = 5)



## ----------------------------------------------------------------
## LICENSE REQUIRED

## ----------------
## MarketScan

# Pre-2016: MarketScan Databases were known as Truven Health MarketScan Research Databases.
# 2016 to 2022: After the acquisition by IBM, they were known as IBM MarketScan Databases.
# 2022 onwards: Following the sale to Francisco Partners and rebranding, they are now 
#               referred to as Merative MarketScan.

build_search_query(
  keywords = c("Merative's MarketScan", "Merative AND MarketScan", "MarketScan"), 
  affiliation = "Yale School of Public Health", years = 5)




## ----------------------------------------------------------------
## RESTRICTED ACCESS

## ----------------
## All of Us

build_search_query(
  keywords = c("All of Us"), 
  affiliation = "Yale School of Public Health", years = 5)


## ----------------
## UK Biobank

build_search_query(
  keywords = c("UK Biobank"), 
  affiliation = "Yale School of Public Health", years = 5)


## ----------------
## Epic Cosmos

build_search_query(
  keywords = c("Epic Cosmos"), 
  affiliation = "Yale School of Public Health", years = 5)

build_search_query(
  keywords = c("Epic Cosmos"), 
  affiliation = "Yale School of Medicine", years = 5)


## ----------------
## YNHHS Epic

build_search_query(
  keywords = c("Yale New Haven Health System", "YNHHS"), 
  affiliation = "Yale School of Public Health", years = 5)




