#' Checks if the requested URL exists
#'
#' @description
#' `valid_url()` This function is used to check if the requested URL is valid. This function is
#' expected to be used internally
#'
#' @details
#' This function is used to check if the requested URL is valid. This function is
#' expected to be used internally. It tries to establish conntection to the requested URL
#'
#' @return
#' Boolean. TRUE if the URL is valid, and FALSE if it is not
#'
#' @param url A string URL to check
#' @param t Timeout in seconds for connection
#' @examples
#'
#' valid_url(url = "https://cran.r-project.org/")
#' valid_url(url = "https://i-dont-exist-at-all.com/")
valid_url <- function(url, t = 2){
  conncection <- url(url)
  check <- suppressWarnings(try(open.connection(conncection, open= "rt", timeout = t), silent = TRUE)[1])
  suppressWarnings(try(close.connection(conncection), silent = TRUE))
  ifelse(is.null(check), TRUE, FALSE)
}

# ------------------------------------------------------------------------------

#' A function to download trials for a set of diseases and drugs
#'
#' @description
#' `clinical_trial_downloader_two_terms()` This function is used to download trials for a set of diseases and drugs
#' just as they would have been seen during manual search on the website. The search is performed for all combinations of treatments
#' and diseases.
#'
#' @details
#' All terms must be URL compatible. "url_suffix" parameters could be found in the advanced search for
#' ClinicalTrials.gov (https://clinicaltrials.gov/ct2/search/advanced?cond=&term=&cntry=&state=&city=&dist=). This
#' function depends on the legacy ClinicalTrials.gov API that may get defunct at any time. The search automatically
#' applies synonyms for drugs and conditions. In the download folder, one could find a reporting file reporting_file.csv
#' for the information about the downloaded trials and searches.
#'
#' @return
#' Data.frame of clinical trials or a message string.
#'
#' @param condition_terms Optional. A character vector of conditions (diseases).
#' @param treatment_terms Optional. A character vector of interventions (treatments).
#' @param folder A full path to store files.
#' @param url_suffix Optional. Additional parameters from advanced search starting with "&" (such as "&city=Stockholm").
#' @examples
#'
#' clinical_trial_downloader_two_terms(
#' condition_terms = c("brain cancer", "glioma"),
#' treatment_terms = c("cisplatin", "temozolomide", "olaparib"),
#' folder = "test_downloads",
#' url_suffix = "&cntry=GB&state=&city=London")
#' @export
#' @import "stringr"
#' @import "stringi"
clinical_trial_downloader_two_terms <- function(condition_terms = NULL,
                                               treatment_terms = NULL,
                                               folder,
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

    Base_string_1_main <- "https://clinicaltrials.gov/ct2/results/download_fields?cond="
    Base_string_2_main <- "&intr="
    Base_string_3_main <- "&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all"
    Base_string_1_check <- "https://clinicaltrials.gov/ct2/results?cond="
    Base_string_2_check <- "&intr="
    Base_string_3_check <- "&type=Intr"

    if (!is.null(url_suffix)){
      Base_string_3_main <- paste0(Base_string_3_main, url_suffix)
      Base_string_3_check <- paste0(Base_string_3_check, url_suffix)
    }


  urls <- paste0(Base_string_1_main, condition_terms, Base_string_2_main)
  urls <- as.vector(sapply(urls, function(x) paste0(x, treatment_terms, Base_string_3_main)))

  urls_check <- paste0(Base_string_1_check, condition_terms, Base_string_2_check)
  urls_check <- as.vector(sapply(urls_check, function(x) paste0(x, treatment_terms, Base_string_3_check)))

  reporting_file <- as.vector(sapply(condition_terms, function(x) paste0(x, "&&&", treatment_terms)))
  reporting_file <- data.frame(reporting_file)
  colnames(reporting_file) <- "Term"
  reporting_file$Index <- NA
  reporting_file$URL <- NA
  reporting_file$URL_check <- NA
  reporting_file$Status <- NA
  reporting_file$Trials <- NA
  reporting_file$Intervention <- NA
  reporting_file$Condition_searched <- NA

  index = 1
  while(index <= length(urls)){

    reporting_file$Index[index] <- index
    reporting_file$URL[index] <- urls[index]
    reporting_file$URL_check[index] <- urls_check[index]
    reporting_file$Intervention[index] <- terms_initial[index]
    reporting_file$Condition_searched[index] <- condition_terms_initial[index]

    if (valid_url(urls_check[index])){

      destination <- paste0(folder,"/",index, "___",".csv")
      error_flag_ctgov <- FALSE
      skip_Flag <- FALSE
      error_counter_get_trials <- 0

      tryCatch({
        download.file(urls[index], destination, quiet = TRUE)
        reporting_file$Status[index] <- "Downloaded"
      }, error = function(e){error_flag_ctgov <<- TRUE})

      while(error_flag_ctgov){
        Sys.sleep(2**error_counter_get_trials)
        error_counter_get_trials <- error_counter_get_trials + 1

        warning(paste0('Error detected during getting trials file from   ',
                       urls[index],
                       '  ',
                       Sys.time(),
                       ' Trying to reopen link  #',
                       error_counter_get_trials), immediate. = TRUE)

        if (error_counter_get_trials > 10){

          warning(paste0("Unable to get trials from ", urls[index]))
          skip_Flag <- TRUE
          error_flag_ctgov <- FALSE

        } else {

          tryCatch({
            download.file(urls[index], destination, quiet = TRUE)
            reporting_file$Status[index] <- "Downloaded"
            error_flag_ctgov <<- FALSE
          }, error = function(e){error_flag_ctgov <<- TRUE})

        }

      }

      if (skip_Flag){
        suppressWarnings(rm(list = c("error_flag_ctgov", "error_counter_get_trials", "skip_Flag")))
        reporting_file$Status[index] <- "Link failed"
        reporting_file$Trials[index] <- 0
      }

    } else {
      suppressWarnings(rm(list = c("error_flag_ctgov", "error_counter_get_trials", "skip_Flag")))
      reporting_file$Status[index] <- "No trials/Invalid"
      reporting_file$Trials[index] <- 0
    }

    percent = round((index/length(urls))*100, 4)
    writeLines(paste0(index,'   ', percent,' % complete at ', Sys.time()))
    index <- index + 1
    Sys.sleep(1)

  }

  files = list.files(folder)
  if (length(files)<1){
    reporting_file$Trials <- 0
    write.csv(reporting_file, paste0(folder, '/', "reporting_file", ".csv"))
    return("0 trials found")
  }

  files = files[files != "reporting_file.csv"]
  if (length(files)<1){
    reporting_file$Trials <- 0
    write.csv(reporting_file, paste0(folder, '/', "reporting_file", ".csv"))
    return("0 trials found")
  }

  paths <- paste0(folder,"/", files)

  files_list = list()
  for (i in 1:length(paths)){
    df <- read.csv(paths[i], header = TRUE, encoding = "UTF-8")
    idx <- unlist(stringi::stri_split_fixed(paths[i], pattern = "/"))
    idx <- idx[length(idx)]
    idx <- unlist(stringi::stri_split_fixed(idx, pattern = "___"))
    idx <- idx[1]
    df$Search_term <- reporting_file[reporting_file$Index == idx, "Term"]
    df$Requested_inter <- reporting_file[reporting_file$Index == idx, "Intervention"]
    df$Requested_cond <- reporting_file[reporting_file$Index == idx, "Condition_searched"]
    reporting_file[reporting_file$Index == idx, "Trials"] <- nrow(df)
    write.csv(df, paths[i])
    files_list[[i]] <- df
  }

  write.csv(reporting_file, paste0(folder, "/", "reporting_file", ".csv"))
  output_data <- do.call(rbind, files_list)
  return(output_data)
}

