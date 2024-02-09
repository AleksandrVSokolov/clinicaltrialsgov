#' Recursive parsing of a clinical trial XML record from ClinicalTrials.gov
#'
#' @description
#' `parse_single_trial_recursive()` This function is used internally in other functions to parse
#' XML response for a clinical trial.
#'
#' @details
#' This is a recursive function. It is intebded for internal use.
#'
#' @return
#' A list representation of a clinical trial record.
#' Properties:
#' * Returned lists eventually terminate with a character vector with "Name" and "Value"
#'
#' @param x A clincal trial record in the list format obtained directly from [xml2::as_list()]
#' @param previous_name Typically is null and changed only within recursion
#'
#' @examples
#' url <- "https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=1&max_rnk=100"
#' data <- httr::GET(url)
#' data_parsed <- xml2::read_xml(data)
#' trial_list <- xml2::xml_find_all(data_parsed, "FullStudyList")
#' trial_list <- xml2::as_list(trial_list)
#' trial_list <- trial_list[[1]]
#' single_trial <- trial_list[[1]]
#' single_trial <- parse_single_trial_recursive(single_trial)
parse_single_trial_recursive <- function(x, previous_name = NULL){

  if (!is.list(x)){

    return(c(previous_name, x))

  }

  name <- attr(x, "Name")
  lapply(x, function(x) parse_single_trial_recursive(x, previous_name = name))

}

# ------------------------------------------------------------------------------

#' Get 1-100 trials from a specified query to the ClinicalTrials.gov API
#'
#' @description
#' `get_trials_API_query()` used to download limited number of studies were the
#' number is not more than 100 trials. Currently only "full study" format is supported.
#' Look here for detail: https://clinicaltrials.gov/api/gui/home
#'
#' @details
#' The function is not useful for big lists of clinical trials!
#' Use [clinicaltrialsgov::prepare_download_URLs()] and
#' [clinicaltrialsgov::get_trials_API_urls()] instead
#'
#' @return
#' A data.frame with clinical trials. Missing columns are handled via [data.table::rbindlist()].
#' Could return NA (if 0 trials)
#' Properties:
#' * May contain big number of columns
#'
#' @param query A string URL for the ClinicalTrials.gov API
#' @param download_folder Optional. Folder to save JSON file with trials (before concatenation)
#' @param min_rnk Starting index of downloaded trials
#' @param max_rnk Ending index of downloaded trials (max_rnk - min_rnk must be <= 100)
#'
#' @examples
#'
#' get_trials_API_query(query = "lung+cancer", download_folder = "test")
#' @export
#' @import "xml2"
#' @import "rjson"
#' @import "httr"
#' @import "data.table"
get_trials_API_query <- function(query,
                                 download_folder = NULL,
                                 min_rnk = 1,
                                 max_rnk = 100){

  base_URL <- "https://ClinicalTrials.gov/api/query/full_studies?expr="

  url <- paste0(base_URL, query, "&min_rnk=", min_rnk, "&max_rnk=", max_rnk)
  url <- URLencode(url)

  data <- httr::GET(url)
  data_parsed <- xml2::read_xml(data)

  trial_count <- xml2::xml_find_all(data_parsed, "NStudiesFound")
  trial_count <- xml2::xml_text(trial_count)
  trial_count <- as.numeric(trial_count)

  if (trial_count < 1){
    warning("No trials found")
    return(NA)
  }

  trial_list <- xml2::xml_find_all(data_parsed, "FullStudyList")
  trial_list <- xml2::as_list(trial_list)
  trial_list <- trial_list[[1]]

  trial_list_restructured <- lapply(trial_list, function(x){
    x <- parse_single_trial_recursive(x)
    x <- unlist(x)
    names(x) <- NULL
    x <- matrix(x, ncol=2,  byrow = TRUE)
    x <- as.data.frame(t(x))
    colnames(x) <- x[1,]
    x <- x[-1,]
    x <- data.frame(x)
    return(x)
  })

  if (!is.null(download_folder)){
    dir.create(download_folder)
    trials_json <- rjson::toJSON(trial_list)
    download_path <- paste0(download_folder, "/downloaded_trials.json")
    write(trials_json, download_path)
  }

  trial_list_restructured <- as.data.frame(data.table::rbindlist(trial_list_restructured, fill = TRUE))

  return(trial_list_restructured)
}

# ------------------------------------------------------------------------------

#' Prepare download URLs to get all trials for the specified query to the ClinicalTrials.gov API
#'
#' @description
#' `prepare_download_URLs()` used to prepare a character vector of URLs to subsequently pass to
#' [clinicaltrialsgov::get_trials_API_urls()]
#' Currently only "full study" format is supported.
#' Look here for detail: https://clinicaltrials.gov/api/gui/home
#'
#' @details
#' The function just prepares URLs for [clinicaltrialsgov::get_trials_API_urls()]
#'
#' @return
#' A character vector of ready-to-use URLs for the ClinicalTrials.gov API or NA (if 0 trials)
#' Properties:
#' * Each URL corresponds to 100 trials
#'
#' @param query A string URL for ClinicalTrials.gov API
#'
#' @examples
#'
#' prepare_download_URLs(query = "lung+cancer")
#' @export
#' @import "xml2"
#' @import "httr"
prepare_download_URLs <- function(query){

  base_URL <- "https://ClinicalTrials.gov/api/query/full_studies?expr="

  url <- paste0(base_URL, query)
  url <- URLencode(url)

  data <- httr::GET(url)
  data_parsed <- xml2::read_xml(data)

  trial_count <- xml2::xml_find_all(data_parsed, "NStudiesFound")
  trial_count <- xml2::xml_text(trial_count)
  trial_count <- as.numeric(trial_count)

  if (trial_count < 1){
    warning("No trials found")
    return(NA)
  }

  sequence_starts <- seq(from = 1, to = trial_count, by = 100)
  sequence_ends <- sequence_starts + 99
  sequence_ends[length(sequence_ends)] <- trial_count

  url_requests <- mapply(function(x,y){

    request <- paste0(base_URL, query, "&min_rnk=", x, "&max_rnk=", y)
  }, sequence_starts, sequence_ends)

  return(url_requests)
}

# ------------------------------------------------------------------------------

#' Download all trials from vector of URLs to ClinicalTrials.gov API
#'
#' @description
#' `get_trials_API_urls()` This function is used to download all clinical trials from a character vector
#' of ClinicalTrials.gov API URLs.
#' Currently only "full study" format is supported.
#' Note: execution could take relatively long time depending on the number of trials. The resulting
#' data.frame may have a lot of columns (thousands)
#' Look here for detail: https://clinicaltrials.gov/api/gui/home
#'
#' @details
#' The function download all trials and concatenates the output. If download fails, it tries to download file 10 times and then proceeds to
#' next URL. A folder could be specified to stode all trials in the JSON format (before concatenation)
#'
#' @return
#' A data.frame with clinical trials. Missing columns are handled via [data.table::rbindlist()].
#'
#' @param url_list A character vector of urls from [clinicaltrialsgov::prepare_download_URLs()]
#' @param delay A delay in seconds between requests
#' @param download_folder Optional. Folder to save JSON file with trials (before concatenation)
#'
#' @examples
#'
#' urls <- prepare_download_URLs(query = "lung+cancer")
#' trials <- get_trials_API_urls(url_list = urls, download_folder = "test")
#' @export
#' @import "xml2"
#' @import "rjson"
#' @import "httr"
#' @import "data.table"
get_trials_API_urls <- function(url_list,
                               delay = 0.5,
                               download_folder = NULL){

  full_data <- list()
  for (i in 1:length(url_list)){

    Sys.sleep(delay)

    error_flag_get_trials_API <- FALSE
    error_counter_get_trials_API <- 0
    skip_Flag <- FALSE

    tryCatch({
      data <- httr::GET(url_list[i])
      data_parsed <- xml2::read_xml(data)
    }
    , error = function(e) {error_flag_get_trials_API <<- TRUE})

    while(error_flag_get_trials_API){
      Sys.sleep(2**error_counter_get_trials_API)
      error_counter_get_trials_API <- error_counter_get_trials_API + 1
      warning(paste0('Error detected during getting trials file from   ',
                     url_list[i],
                     '  ',
                     Sys.time(),
                     ' Trying to reopen link  #',
                     error_counter_get_trials_API), immediate. = TRUE)

      if (error_counter_get_trials_API > 10){

        warning(paste0("Unable to get trials from ", url_list[i]))
        skip_Flag <- TRUE
        error_flag_get_trials_API <- FALSE

      } else {

        tryCatch({
          data <- httr::GET(url_list[i])
          data_parsed <- xml2::read_xml(data)
          error_flag_get_trials_API <<- FALSE
        }
        , error = function(e) {error_flag_get_trials_API <<- TRUE})

      }

    }

    if (skip_Flag){
      rm(list = c("error_flag_get_trials_API", "error_counter_get_trials_API", "skip_Flag"))
      next
    }
    rm(list = c("error_flag_get_trials_API", "error_counter_get_trials_API", "skip_Flag"))

    trial_list <- xml2::xml_find_all(data_parsed, "FullStudyList")
    trial_list <- xml2::as_list(trial_list)
    trial_list <- trial_list[[1]]

    trial_list_restructured <- lapply(trial_list, function(x){
      x <- parse_single_trial_recursive(x)
      x <- unlist(x)
      names(x) <- NULL
      x <- matrix(x, ncol = 2,  byrow = TRUE)
      x <- as.data.frame(t(x))
      colnames(x) <- x[1,]
      x <- x[-1,]
      x <- data.frame(x)
      return(x)
    })
    full_data <- c(full_data, trial_list_restructured)
    percent <- round(i/length(url_list)*100, digits = 4)
    writeLines(paste0(i, "   ", percent, " % completed at ", Sys.time()))
  }

  if (!is.null(download_folder)){
    dir.create(download_folder)
    trials_json <- rjson::toJSON(full_data)
    download_path <- paste0(download_folder, "/downloaded_trials.json")
    write(trials_json, download_path)
  }

  writeLines(paste0("Combining ", length(full_data), " datasets at ", Sys.time()))
  full_data <- as.data.frame(data.table::rbindlist(full_data, fill = TRUE))

  return(full_data)

}
