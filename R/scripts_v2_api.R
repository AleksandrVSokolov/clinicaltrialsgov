#' A function to concatenate list of data frames into a single data frame
#'
#' @description
#' `list_to_df()` This function is used internally
#'
#' @details
#' Intended for internal use
#'
#' @return
#' A data frame
#' Properties:
#' Each data frame in initial list must have the same column names
#'
#' @param data_list A list of data frames
#' @examples
#'df1 = data.frame(
#'  y1 = c(1, 2, 3),
#'  y2 = c(4, 5, 6)
#')

#'# Create another dataframe
#'df2 = data.frame(
#'  y1 = c(7, 8, 9),
#'  y2 = c(1, 4, 6)
#')

#'# Create list of data frame using list()
#'listOfDataframe = list(df1, df2)
#'concatenated_list = list_to_df(listOfDataframe)
list_to_df <- function(data_list){
  if (length(data_list) > 1){
    data_list <- do.call(rbind, data_list)
  } else {
    data_list <- data_list[[1]]
  }
  return(data_list)
}



# ------------------------------------------------------------------------------

#' Download all clinical trials via specified APIv2 ULR
#'
#' @description
#' `download_v2_url()` is used to download trials for
#' a provided APIv2 URL (see more: https://clinicaltrials.gov/data-api/api). Currently
#' it can download 1000 trials per request. If resulting number of trials > 1000,
#' more than one request URL will be generated internally
#'
#' @details
#' Could be used for any URL supported by https://clinicaltrials.gov/data-api/api
#' Primarily intended for internal use
#'
#' @return
#' 0 if the number of trials is 0 or the number of trials. The function primarily
#' saves data in the specified folder
#' Properties:
#' * Sensitive to provided URL. Some URLs may not be supported by https://clinicaltrials.gov/data-api/api
#'
#' @param url A string URL for the ClinicalTrials.gov APIv2
#' @param folder Folder to save download file with trials (before concatenation)
#' @param index Index value for naming downloaded files
#' @examples
#'
#' download_v2_url(url = "https://clinicaltrials.gov/api/v2/studies?format=csv&query.cond=lung+cancer&query.intr=&pageSize=1000",
#' folder = "test2",
#' index = 3)
#' @export
#' @import "httr"
#' @import "stringi"
download_v2_url <- function(url, folder, index = 1){

condition = NA
treatment = NA

if (stri_detect_fixed(url, pattern = "query.cond")){
  fragments <- unlist(stri_split_fixed(url, "&"))
  condition <- fragments[stri_detect_fixed(fragments, pattern = "query.cond")]
  condition <- stri_replace_all_fixed(condition, pattern = "query.cond=", replacement = "")
}

if (stri_detect_fixed(url, pattern = "query.intr")){
  fragments <- unlist(stri_split_fixed(url, "&"))
  treatment <- fragments[stri_detect_fixed(fragments, pattern = "query.intr")]
  treatment <- stri_replace_all_fixed(treatment, pattern = "query.intr=", replacement = "")
}

# First download
response <- httr::GET(url)
content <- httr::content(response, encoding = "UTF-8", show_col_types = FALSE)

if (nrow(content) > 0) {

  ref_colnames <- colnames(content)

  # Iterating
  content_list <- list()
  content_list[[1]] <- content
  i <- 2

  while (!is.null(response$headers$`x-next-page-token`)){
    url_2 <- paste0(url,"&pageToken=", response$headers$`x-next-page-token`)
    response <- httr::GET(url_2)
    content <- httr::content(response, encoding = "UTF-8", show_col_types = FALSE, col_names = FALSE)
    colnames(content) <- ref_colnames
    content_list[[i]] <- content
    i <- i + 1
    Sys.sleep(0.1)
  }

  content_list <- list_to_df(content_list)
  content_list$treatm_term <- treatment
  content_list$cond_term <- condition
  file_name <- paste0(index, "_trials.csv")
  path <- file.path(folder, file_name)
  write.csv(content_list, path)

  return(nrow(content_list))

} else {
  # Zero trials
  return(0)
}

}


# ------------------------------------------------------------------------------
#' Download all clinical trials for specified conditions, treatment, and parameters via APIv2 ULR
#'
#' @description
#' `clinical_trial_downloaderV2_API()` is used to download trials for specified conditions, treatment,
#' and parameters via APIv2 ULR(see more: https://clinicaltrials.gov/data-api/api). Currently
#' it can download 1000 trials per request. If resulting number of trials > 1000,
#' more than one request URL will be generated internally
#'
#' @details
#' Currently supports only .csv format of downloads.
#' Additional download parameters could be provided via url_suffix
#' The function looks for all combinations of specified treatment and
#' condition terms
#'
#' @return
#' Nothing. The function downloads data to a specified folder.
#' Properties:
#' Specified conditions, treatments, and suffix could be "".
#' If the number of trials was 0 for some URLs, saves a file ZERO_URLS.txt with
#' these URLs.
#' If some URLs resulted in an error, saves a file FAILED_URLS.txt with
#' these URLs.
#'
#' @param condition_terms A vector of conditions to look for
#' @param treatment_terms A vector of therapies to look for
#' @param folder A folder to store download files (used only once)
#' @param format_suffix Currently supports only CSV. Do not change!
#' @param url_suffix Additional API provided provided as URL fragment as in https://clinicaltrials.gov/data-api/api
#' @examples
#'
#' clinical_trial_downloaderV2_API(condition_terms = c("brain cancer", "glioma", "lung cancer"),
#'                                treatment_terms = c("cisplatin", "temozolomide", "olaparib"),
#'                                folder = "test_downloads3",
#'                                url_suffix = "&query.patient=AREA[LocationCity] London")
#' results = import_ct_results_v2_csv("test_downloads3")
#' @export
#' @import "httr"
#' @import "stringi"
clinical_trial_downloaderV2_API = function(condition_terms = NULL,
                                           treatment_terms = NULL,
                                           folder,
                                           format_suffix = "format=csv",
                                           url_suffix = NULL){


  if (!(paste0('./', folder) %in% list.dirs())){
    dir.create(folder)
  } else {
    stop("Please specify a new folder")
  }

  if (!is.null(condition_terms)){
    condition_terms <- stringr::str_trim(condition_terms)
    condition_terms <- condition_terms[condition_terms != ""]
    condition_terms <- condition_terms[!is.na(condition_terms)]
    condition_terms_initial <- condition_terms
    condition_terms <- toupper(condition_terms)
    condition_terms <- unique(condition_terms)
    condition_terms <- stringi::stri_replace_all_fixed(str = condition_terms, pattern = " ", replacement = "+")
    condition_terms <- URLencode(condition_terms)

    if (length(treatment_terms) >= 1){
      condition_terms_initial <- sapply(condition_terms_initial, function(x) paste0(x, rep("", times = length(treatment_terms))))
    }

  }

  if (!is.null(treatment_terms)){
    treatment_terms <- stringr::str_trim(treatment_terms)
    treatment_terms <- treatment_terms[treatment_terms != ""]
    treatment_terms <- treatment_terms[!is.na(treatment_terms)]
    terms_initial <- treatment_terms

    if (length(condition_terms) >= 1){
      terms_initial <- rep(terms_initial, times = length(condition_terms))
    }


    treatment_terms <- toupper(treatment_terms)
    treatment_terms <- unique(treatment_terms)
    treatment_terms <- stringi::stri_replace_all_fixed(str = treatment_terms, pattern = " ", replacement = "+")
    treatment_terms <- URLencode(treatment_terms)
  }

  if (is.null(condition_terms)){
    condition_terms <- ""
    condition_terms_initial <- ""
  }
  if (is.null(treatment_terms)){
    treatment_terms <- ""
    terms_initial <- NA
  }

  Base_string_1_main <- paste0("https://clinicaltrials.gov/api/v2/studies?", format_suffix)
  Base_string_2_main <- "&query.intr="
  Base_string_3_main <- "&query.cond="

  urls <- paste0(Base_string_1_main, Base_string_2_main, treatment_terms)
  urls <- as.vector(sapply(urls, function(x) paste0(x, Base_string_3_main, condition_terms)))
  urls <- paste0(urls, "&pageSize=1000")

  if (!is.null(url_suffix)){
    url_suffix <- URLencode(url_suffix)
    urls <- paste0(urls, url_suffix)
  }

  failed_urls = vector()
  zero_results = vector()

  for (i in 1:length(urls)){
    message <- paste0("Parsing URL:", urls[i], " index: ", i)
    writeLines(message)

    ERROR_FLAG_CTGOV <- FALSE
    ERROR_COUNTER <- 0
    SKIP_FLAG <- FALSE

    tryCatch(
      {
        result <- download_v2_url(urls[i], folder = folder, index = i)
      },
      error = function(e){
        print(e)
        ERROR_FLAG_CTGOV <<- TRUE
      })

    while(ERROR_FLAG_CTGOV){
      Sys.sleep(2**ERROR_COUNTER)
      ERROR_COUNTER <- ERROR_COUNTER + 1

      warning(paste0('Error detected during getting trials file from   ',
                     urls[i],
                     '  ',
                     Sys.time(),
                     ' Trying to reopen link, attempt: ',
                     ERROR_COUNTER), immediate. = TRUE)

      if (ERROR_COUNTER > 10){
        warning(paste0("Unable to get trials from ", urls[i]))
        failed_urls = c(failed_urls, urls[i])
        ERROR_FLAG_CTGOV <- FALSE
      } else {
        tryCatch(
          {
            result <- download_v2_url(urls[i], folder = folder, index = i)
            ERROR_FLAG_CTGOV <<- FALSE
          },
          error = function(e){
            print(e)
            ERROR_FLAG_CTGOV <<- TRUE
          })
      }
    }
    if (result == 0){
      zero_results = c(zero_results, urls[i])
    }
  }

  if (length(failed_urls) > 0){
    p_fail = file.path(folder, "FAILED_URLS.txt")
    writeLines(text = failed_urls, con = p_fail)
  }
  if (length(zero_results) > 0){
    p_zero = file.path(folder, "ZERO_URLS.txt")
    writeLines(text = zero_results, con = p_zero)
  }
}




# ------------------------------------------------------------------------------
#' Import downloaded trials into R
#'
#' @description
#' `import_ct_results_v2_csv()` is to import all downloaded trials from a specified folder
#'
#' @details
#' Currently supports only .csv format of downloads.
#'
#' @return
#' Data frame
#'
#' @param folder A folder with stored downloaded files via clinical_trial_downloaderV2_API()
#' @examples
#'
#' clinical_trial_downloaderV2_API(condition_terms = c("brain cancer", "glioma", "lung cancer"),
#'                                treatment_terms = c("cisplatin", "temozolomide", "olaparib"),
#'                                folder = "test_downloads3",
#'                                url_suffix = "&query.patient=AREA[LocationCity] London")
#' results = import_ct_results_v2_csv("test_downloads3")
#' @export
#' @import "httr"
#' @import "stringi"
import_ct_results_v2_csv = function(folder){
  files <- list.files(folder)
  files <- files[stri_detect_fixed(files, pattern = ".csv")]
  paths <- file.path(folder, files)
  trial_df <- lapply(paths, function(x){read.csv(x, header = TRUE)})
  trial_df <- list_to_df(trial_df)
  return(trial_df)
}

