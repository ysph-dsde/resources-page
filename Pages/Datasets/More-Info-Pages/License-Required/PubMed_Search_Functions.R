## ----------------------------------------------------------------
## Define the coding parameters used in the environment.
##
##      Authors: Shelby Golden, M.S.
## Date Created: June 15th, 2025
## 
## Description: All custom functions used to search for publications that use
##              a specific dataset and are affiliated with the Yale School of
##              Public Health. Also includes some formatting in preparation
##              for printing on an HTML page. Much of this content was written
##              with the assistance of Yale's AI Clarity.
##
##              NOTE: A copy of these functions is required in all 
##              More-Info-Pages subdirectories to allow them to be sourced.
##
## Functions
##    1. build_search_query: Constructs a comprehensive search term based on
##       specified keywords, affiliation, and a date range. The search term is 
##       assembled to query PubMed with multiple conditions combined using the 
##       AND operator.
## 
##    2. fetch_summaries_in_batches: Fetches PubMed summaries in batches to 
##       handle cases where the number of records retrieved exceeds the maximum 
##       allowable UIDs per request. This function helps in managing such large 
##       requests by fetching in batches.
## 
##    3. fetch_detailed_pubmed_records: Fetches detailed records from PubMed 
##       using the search result object, retrieves them in XML format, and
##       parses the XML to extract detailed information.
## 
##    4. extract_author_affiliations: Extracts author affiliations from 
##       detailed PubMed records in XML format. The function processes the XML 
##       data to retrieve authors and their affiliations for each article.
##
##    5. get_citations: Searches for citations in PubMed using specified 
##       keywords, affiliation, and a date range. The function dynamically 
##       adjusts the search range if no records are found, incrementing the 
##       range up to a specified maximum. It fetches detailed records, extracts 
##       author affiliations, and formats the citations while highlighting 
##       authors from a specified affiliation.
##
##    6. make_pub_list: This function processes a list of citations and formats 
##       them into an HTML structure with list items (`<li>`) and a search query 
##       description.


## ----------------------------------------------------------------
## FUNCTIONS


build_search_query <- function(keywords = NULL, affiliation = NULL, years = NULL) {
  #' @description
  #' Constructs a comprehensive search term based on specified keywords,
  #' affiliation, and a date range. The search term is assembled to query PubMed 
  #' with multiple conditions combined using the AND operator.
  #'
  #' @param keywords A string or vector of strings specifying the keywords to 
  #'                 search within the Title/Abstract fields. If NULL, this 
  #'                 parameter is ignored.
  #' @param affiliation A string specifying the affiliation to include in the 
  #'                    search term. If NULL, this parameter is ignored.
  #' @param years An integer specifying the number of past years to include in 
  #'              the search range. If NULL, this parameter is ignored.
  #'
  #' @return A string representing the combined search query to be used for 
  #'         querying PubMed.
  #' 
  #' @examples
  #' build_search_query(keywords = "cancer", affiliation = "Yale", years = 5)
  
  
  search_terms <- c()  # Initialize an empty vector to hold search terms
  
  if (!is.null(keywords) && length(keywords) > 0) {
    # Combine keywords and construct the search term for keywords within Title/Abstract
    keyword_terms <- paste0('"', keywords, '"[Title/Abstract] OR "', keywords, '"')
    # Exclude keywords from Conflict of Interest Statements
    keyword_not_coi <- paste0('(', keyword_terms, ' NOT "', keywords, '"[Conflict of Interest Statements])')
    # Add the combined search term to the search terms vector
    search_terms <- c(search_terms, keyword_not_coi)
  }
  
  if (!is.null(affiliation)) {
    # Construct the search term for affiliation
    affiliation_term <- paste0('"', affiliation, '"[Affiliation]')
    # Add the affiliation search term to the search terms vector
    search_terms <- c(search_terms, affiliation_term)
  }
  
  if (!is.null(years)) {
    # Get the current year
    current_year <- as.numeric(format(Sys.Date(), "%Y"))
    # Calculate the start year based on the number of years provided
    start_year <- current_year - years
    # Construct the search term for the date range
    date_range <- paste0(start_year, ':', current_year)
    date_term <- paste0('(', date_range, '[dp])')
    # Add the date range search term to the search terms vector
    search_terms <- c(search_terms, date_term)
  }
  
  # Combine all search terms with the AND operator
  search_query <- paste(search_terms, collapse = ' AND ')
  return(search_query)  # Return the final search query
}




fetch_summaries_in_batches <- function(web_history, batch_size = 500) {
  #' @description
  #' Fetches PubMed summaries in batches to handle cases where the number
  #' of records retrieved exceeds the maximum allowable UIDs per request.
  #' This function helps in managing such large requests by fetching in batches.
  #'
  #' @param web_history An object containing the web history returned by an 
  #'                    Entrez search, which allows for subsequent requests to 
  #'                    the same query.
  #' @param batch_size An integer specifying the number of records to fetch per 
  #'                  batch. Default is 500.
  #'
  #' @return A list of summaries retrieved from PubMed.
  #' 
  #' @examples
  #' # Assuming `web_history` is obtained from a previous entrez_search() call
  #' summaries <- fetch_summaries_in_batches(web_history)
  
  
  summaries <- list()  # Initialize an empty list to hold summaries
  count <- 0  # Start the count at zero to keep track of the number of records fetched
  
  while (TRUE) {
    # Fetch a batch of summaries from PubMed using the web history and specified batch size
    batch <- entrez_summary(db = 'pubmed', web_history = web_history, retstart = count, retmax = batch_size)
    # Append the fetched batch to the summaries list
    summaries <- c(summaries, batch)
    # If the length of the fetched batch is less than the batch size, it means we have fetched all available records
    if (length(batch) < batch_size) {
      break  # Exit the loop
    }
    # Increment the count by the batch size to fetch the next set of records in the subsequent iteration
    count <- count + batch_size
  }
  
  return(summaries)  # Return the list of fetched summaries
}




fetch_detailed_pubmed_records <- function(search_result) {
  #' @description 
  #' Fetches detailed records from PubMed using the search result object,
  #' retrieves them in XML format, and parses the XML to extract detailed 
  #' information.
  #'
  #' @param search_result An object containing the result of a previous Entrez 
  #'                      search, including the web history for retrieving 
  #'                      detailed records.
  #'
  #' @return An XML object containing the detailed PubMed records.
  
  
  # Fetch detailed records using the web history from the search result
  fetch_result <- entrez_fetch(db = 'pubmed', web_history = search_result$web_history, rettype = 'xml', retmax = search_result$count)
  
  # Parse the XML result to extract detailed information
  xml_data <- read_xml(fetch_result)
  
  return(xml_data)  # Return the parsed XML data
}




extract_author_affiliations <- function(xml_data) {
  #' @description 
  #' Extracts author affiliations from detailed PubMed records in XML format. 
  #' The function processes the XML data to retrieve authors and their 
  #' affiliations for each article.
  #'
  #' @param xml_data An XML object containing the detailed PubMed records.
  #'
  #' @return A list containing the titles, PMIDs, and authors with their 
  #'         affiliations for each article.
  
  
  # Find all PubmedArticle nodes in the XML data
  articles <- xml_find_all(xml_data, ".//PubmedArticle")
  
  # Initialize an empty list to hold the affiliation information
  affiliation_list <- list()
  
  # Loop through each article node
  for (i in seq_along(articles)) {
    article <- articles[[i]]
    # Extract the PMID of the article
    pmid <- xml_text(xml_find_first(article, ".//PMID"))
    # Extract the title of the article
    title <- xml_text(xml_find_first(article, ".//ArticleTitle"))
    # Find all Author nodes in the article
    authors <- xml_find_all(article, ".//Author")
    
    # Initialize a list to hold author information for the article
    article_info <- list(title = title, pmid = pmid, authors = list())
    
    # Loop through each author node
    for (j in seq_along(authors)) {
      author <- authors[[j]]
      # Extract the last name of the author
      last_name <- xml_text(xml_find_first(author, ".//LastName"))
      # Extract the fore name of the author
      fore_name <- xml_text(xml_find_first(author, ".//ForeName"))
      # Find all Affiliation nodes for the author
      affiliations <- xml_find_all(author, ".//AffiliationInfo/Affiliation")
      
      # Extract the text content of each affiliation node
      affiliation_texts <- sapply(affiliations, xml_text)
      
      # Store the author information in a list
      author_info <- list(
        last_name = last_name,
        fore_name = fore_name,
        affiliations = affiliation_texts
      )
      
      # Add the author information to the article's author list
      article_info$authors[[j]] <- author_info
    }
    
    # Add the article information to the affiliation list
    affiliation_list[[i]] <- article_info
  }
  
  return(affiliation_list)  # Return the list of affiliations
}




get_citations <- function(keywords = NULL, affiliation = NULL, start_years = 5, increment_years = 5, max_range_years = 25, max_results = 1000) {
  #' @description 
  #' Searches for citations in PubMed using specified keywords, affiliation, and 
  #' a date range. The function dynamically adjusts the search range if no 
  #' records are found, incrementing the range up to a specified maximum. It 
  #' fetches detailed records, extracts author affiliations, and formats the 
  #' citations while highlighting authors from a specified affiliation.
  #'
  #' @param keywords A string or vector of strings specifying the keywords to 
  #'                 search within the Title/Abstract fields. If NULL, this 
  #'                 parameter is ignored.
  #' @param affiliation A string specifying the affiliation to include in the 
  #'                    search term. If NULL, this parameter is ignored.
  #' @param start_years An integer specifying the initial number of years to 
  #'                    include in the search range. Default is 5 years.
  #' @param increment_years An integer specifying the increment in years if no 
  #'                        records are found initially. Default is 5 years.
  #' @param max_range_years An integer specifying the maximum number of past 
  #'                        years to include in the search range. Default is 25 
  #'                        years.
  #' @param max_results An integer specifying the maximum number of records to 
  #'                    fetch in the search. Default is 1000.
  #'
  #' @return A list containing the formatted citations and the final search 
  #'         query used. If no records are found, a message indicating no 
  #'         publications are found within the range.
  #' 
  #' @examples
  #' # Fetching citations with specified parameters
  #' citations_output <- get_citations(keywords = "All of Us", affiliation = "Yale School of Public Health", start_years = 5)
  
  
  current_year <- as.numeric(format(Sys.Date(), "%Y"))
  
  # Initialize search parameters
  years <- start_years
  records_found <- FALSE
  initial_search <- NULL
  
  # Loop through search attempts, incrementing the year range until records are found or the maximum range is reached
  while (years <= max_range_years && !records_found) {
    query_term <- build_search_query(keywords, affiliation, years)
    
    # Initial search on PubMed
    initial_search <- tryCatch({
      entrez_search(
        db = 'pubmed',
        term = query_term,
        retmax = max_results,
        use_history = TRUE)
    }, error = function(e) {
      cat('Error during entrez_search:', '\n', e)
      return(NULL)
    })
    
    records_found <- (!is.null(initial_search) && length(initial_search$ids) > 0)
    
    if (!records_found) {
      years <- years + increment_years
    }
  }
  
  # Check if no records were found after exhausting the date range
  if (is.null(initial_search) || length(initial_search$ids) == 0) {
    return(list(citations = paste0('No publications found in the last ', max_range_years, " years."), query = query_term))  # Return the list of citations and the search query used
  }
  
  # Grab PubMed IDs (PMIDs)
  pmids <- initial_search$ids
  
  # Fetch summaries in batches to avoid 'Too many UIDs' error
  pmid_summary <- tryCatch({
    fetch_summaries_in_batches(initial_search$web_history, batch_size = 500)
  }, error = function(e) {
    cat('Error during entrez_summary:', '\n', e)
    return(NULL)
  })
  
  if (is.null(pmid_summary)) {
    warning('No esummary records found.')
    return('No publications found.')
  }
  
  # Fetch detailed PubMed records
  xml_data <- fetch_detailed_pubmed_records(initial_search)
  author_affiliation <- extract_author_affiliations(xml_data)
  
  # Initialize the citations vector
  citations <- vector('character', length(author_affiliation))
  
  # Loop through each article to extract relevant details and format the citation
  for (ii in seq_along(author_affiliation)) {
    article <- author_affiliation[[ii]]
    
    title <- article$title
    pmid <- article$pmid
    authors_info <- article$authors
    
    # Format author names, bolding those affiliated with the specified institution
    authors <- sapply(authors_info, function(author) {
      name <- paste(author$fore_name, author$last_name)
      if (any(grepl("Yale School of Public Health", author$affiliations))) {
        name <- paste0("<strong>", name, "</strong>")  # Use HTML for bold text
      }
      return(name)
    })
    
    authors <- paste(authors, collapse = ', ')
    
    publication <- pmid_summary[[ii]]
    epub_date <- paste0(publication$epubdate, '.')
    journal <- paste0(publication$source, '.')
    doi <- paste0(publication$elocationid, '.')
    uid <- publication$uid
    pmid_with_text <- glue('PMID: {uid}')
    
    # Hyperlink the title with PubMed URL
    title_hyperlink <- glue('<a href="https://pubmed.ncbi.nlm.nih.gov/{uid}/">{title}</a>')
    
    # Format the citation string
    citation <- paste0(
      title_hyperlink, '<br>', 
      authors, '<br>', 
      journal, ' ', 
      epub_date, ' ', 
      doi, '<br>', 
      pmid_with_text
    )
    
    # Add citation to the vector
    citations[ii] <- citation
  }
  
  return(list(citations = citations, query = query_term))  # Return the list of citations and the search query used
}




make_pub_list <- function(citations) {
  #' @description 
  #' This function processes a list of citations and formats them into an HTML 
  #' structure with list items (`<li>`) and a search query description.
  #'
  #' @param citations A list containing citations and a search query.
  #'   - `citations$citations`: A list of HTML-formatted citation strings.
  #'   - `citations$query`: A search query description.
  #' @return A formatted HTML object containing the citations as an HTML unordered list.
  #' @examples
  #' citations <- list(
  #'   citations = list(
  #'     "<a href='https://pubmed.ncbi.nlm.nih.gov/40421744/'>Example Citation 1</a>",
  #'     "<a href='https://pubmed.ncbi.nlm.nih.gov/40268942/'>Example Citation 2</a>"
  #'   ), 
  #'   query = "Search Query Example"
  #' )
  #' make_pub_list(citations)
  
  
  # Check if 'citations' is a character vector (e.g., an error message)
  if (is.character(citations)) {
    # If true, wrap the character string in paragraph tags and return as HTML
    return(htmltools::HTML(paste0('<p>', citations, '</p>')))
  }
  
  # Otherwise, process the citations list
  # Wrap each citation in <li> tags for list item formatting, ensuring valid HTML structure
  pubs_list <- lapply(citations$citations, function(citation) {
    paste0('<li>', citation, '</li>')  # Wrap each citation with <li> tags
  })
  
  # Combine all the <li> items into a single HTML string
  pubs_list_html <- paste(unlist(pubs_list), collapse = '')
  
  
  # Combine everything into a single HTML format
  return(htmltools::HTML(paste0(
    '<div id="citations-box">',  # Begin a container div for the citations
    '<ul id="citations-content">',  # Begin a <ul> for the citation list
    pubs_list_html,  # Insert all the <li> items for the citations
    '</ul>',  # Close the <ul>
    '</div>'  # Close the container div
  )))
}


