---
title: "Package clinicaltrialsgov to download clinical data"
author: "Aleksandr V. Sokolov"
date: "2024-02-09"
output:
  md_document:
    variant: markdown_github
code_folding: show
---

## clinicaltrialsgov package

-   This package is designed to download data from ClinicalTrials.gov
-   It supports legacy and new APIs (as of 2021-2024)
-   Several search features are available, including specification of all search terms in advanced search
-   As of now only downloading full data is supported
-   The V2 version (2024) introduced support for ClinicalTrials.gov API, version 2.0 (https://clinicaltrials.gov/data-api/api)


```r
# Package installation
library(remotes)
remotes::install_github("AleksandrVSokolov/clinicaltrialsgov", force = TRUE)
```

```
## Downloading GitHub repo AleksandrVSokolov/clinicaltrialsgov@HEAD
```

```
## These packages have more recent versions available.
## It is recommended to update all of them.
## Which would you like to update?
## 
##  1: All                                 
##  2: CRAN packages only                  
##  3: None                                
##  4: rlang      (1.1.0  -> 1.1.3 ) [CRAN]
##  5: lifecycle  (1.0.3  -> 1.0.4 ) [CRAN]
##  6: glue       (1.6.2  -> 1.7.0 ) [CRAN]
##  7: cli        (3.6.1  -> 3.6.2 ) [CRAN]
##  8: sys        (3.4.1  -> 3.4.2 ) [CRAN]
##  9: askpass    (1.1    -> 1.2.0 ) [CRAN]
## 10: vctrs      (0.6.1  -> 0.6.5 ) [CRAN]
## 11: stringi    (1.7.12 -> 1.8.3 ) [CRAN]
## 12: openssl    (2.0.6  -> 2.1.1 ) [CRAN]
## 13: jsonlite   (1.8.4  -> 1.8.8 ) [CRAN]
## 14: curl       (5.0.0  -> 5.2.0 ) [CRAN]
## 15: stringr    (1.5.0  -> 1.5.1 ) [CRAN]
## 16: httr       (1.4.5  -> 1.4.7 ) [CRAN]
## 17: xml2       (1.3.3  -> 1.3.6 ) [CRAN]
## 18: data.table (1.14.8 -> 1.15.0) [CRAN]
## 
## ── R CMD build ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
##   
   checking for file ‘/tmp/RtmpzFE0R4/remotes176d3661973fb/AleksandrVSokolov-clinicaltrialsgov-27932a4/DESCRIPTION’ ...
  
✔  checking for file ‘/tmp/RtmpzFE0R4/remotes176d3661973fb/AleksandrVSokolov-clinicaltrialsgov-27932a4/DESCRIPTION’
## 
  
─  preparing ‘clinicaltrialsgov’:
## ✔  checking DESCRIPTION meta-information
## 
  
─  checking for LF line-endings in source and make files and shell scripts
## 
  
─  checking for empty or unneeded directories
## ─  building ‘clinicaltrialsgov_0.2.0.tar.gz’
## 
  
   
## 
```

```
## Installing package into '/home/aleksandr/R/x86_64-pc-linux-gnu-library/4.2'
## (as 'lib' is unspecified)
```

We have installed the package


```r
# Importing
library(clinicaltrialsgov)
```

# Downloading clinical trials with the API version 2.0

This api provides support for both .CSV downloads (as in 2021) and as beta version developed in 2023. 
The process of downloading is simple and could be performed in few lines of code.


```r
# In this example we download all clinical trials with breast cancer, glioma, lung cancer that were treated with cisplatin or temozolomide or olaparib or dasatinib
clinical_trial_downloaderV2_API(condition_terms = c("breast cancer", "glioma", "lung cancer"),
                               treatment_terms = c("cisplatin", "temozolomide", "olaparib", "dasatinib"),
                               folder = "test_downloads_v2",
                               url_suffix = "&query.patient=AREA[LocationCity] London")
```

```
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=CISPLATIN&query.cond=BREAST+CANCER&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 1
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=CISPLATIN&query.cond=GLIOMA&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 2
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=CISPLATIN&query.cond=LUNG+CANCER&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 3
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=TEMOZOLOMIDE&query.cond=BREAST+CANCER&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 4
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=TEMOZOLOMIDE&query.cond=GLIOMA&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 5
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=TEMOZOLOMIDE&query.cond=LUNG+CANCER&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 6
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=OLAPARIB&query.cond=BREAST+CANCER&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 7
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=OLAPARIB&query.cond=GLIOMA&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 8
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=OLAPARIB&query.cond=LUNG+CANCER&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 9
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=DASATINIB&query.cond=BREAST+CANCER&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 10
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=DASATINIB&query.cond=GLIOMA&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 11
## Parsing URL:https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=DASATINIB&query.cond=LUNG+CANCER&pageSize=1000&query.patient=AREA[LocationCity]%20London index: 12
```

Note: we download clinical trials for all combinations between treatments and conditions. We specified via suffix "&query.patient=AREA[LocationCity] London" that we want to get trials specifically from London. Other text fields could be seen here: https://clinicaltrials.gov/data-api/api. To import clinical trials we can simply use the function import_ct_results_v2_csv() and specify a downloaded folder.


```r
results = import_ct_results_v2_csv("test_downloads_v2")
str(results)
```

```
## 'data.frame':	191 obs. of  33 variables:
##  $ X                         : int  1 2 3 4 5 6 7 8 9 1 ...
##  $ NCT.Number                : chr  "NCT02983045" "NCT03102320" "NCT02595905" "NCT02445391" ...
##  $ Study.Title               : chr  "A Dose Escalation and Cohort Expansion Study of NKTR-214 in Combination With Nivolumab and Other Anti-Cancer Th"| __truncated__ "Phase 1b Multi-indication Study of Anetumab Ravtansine in Mesothelin Expressing Advanced Solid Tumors" "Cisplatin With or Without Veliparib in Treating Patients With Recurrent or Metastatic Triple-Negative and/or BR"| __truncated__ "Platinum in Treating Patients With Residual Triple-Negative Breast Cancer Following Neoadjuvant Chemotherapy" ...
##  $ Study.URL                 : chr  "https://clinicaltrials.gov/study/NCT02983045" "https://clinicaltrials.gov/study/NCT03102320" "https://clinicaltrials.gov/study/NCT02595905" "https://clinicaltrials.gov/study/NCT02445391" ...
##  $ Acronym                   : chr  "PIVOT-02" "ARCS-Multi" NA NA ...
##  $ Study.Status              : chr  "COMPLETED" "COMPLETED" "ACTIVE_NOT_RECRUITING" "ACTIVE_NOT_RECRUITING" ...
##  $ Brief.Summary             : chr  "In this four-part study, NKTR-214 was administered in combination with nivolumab and with/without other antican"| __truncated__ "The key purpose of the main part of the study is to assess efficacy and safety of anetumab ravtansine as monoth"| __truncated__ "This randomized phase II trial studies how well cisplatin works with or without veliparib in treating patients "| __truncated__ "This randomized phase III trial studies how well cisplatin or carboplatin (platinum based chemotherapy) works c"| __truncated__ ...
##  $ Study.Results             : chr  "YES" "NO" "NO" "YES" ...
##  $ Conditions                : chr  "Melanoma|Renal Cell Carcinoma|Non Small Cell Lung Cancer|Urothelial Carcinoma|Triple Negative Breast Cancer|HR+"| __truncated__ "Neoplasms" "Metastatic BRCA-Associated Breast Carcinoma|Metastatic Breast Carcinoma|Metastatic Malignant Neoplasm in the Br"| __truncated__ "Estrogen Receptor Negative|HER2/Neu Negative|Invasive Breast Carcinoma|Progesterone Receptor Negative|Stage II "| __truncated__ ...
##  $ Interventions             : chr  "DRUG: Dose Escalation Doublet: Combination of NKTR-214 + nivolumab|DRUG: Dose Expansion Doublet: Combination of"| __truncated__ "DRUG: Cisplatin|DRUG: Gemcitabine|DRUG: Anetumab ravtansine (BAY94-9343)" "DRUG: Cisplatin|OTHER: Laboratory Biomarker Analysis|OTHER: Placebo Administration|DRUG: Veliparib" "DRUG: Capecitabine|DRUG: Carboplatin|DRUG: Cisplatin" ...
##  $ Primary.Outcome.Measures  : chr  "Part 1 Dose Escalation: Incidence of Dose-limiting Toxicity (DLT) During the DLT Evaluation Window, Part 1of th"| __truncated__ "Number of patients in the safety lead-in (SLI) phase who completed Cycle 1 or had a DLT and were not replaced.,"| __truncated__ "Progression-free survival (PFS), Veliparib will be compared to no veliparib in the BRCA mutation-carriers, BRCA"| __truncated__ "3-year Invasive Disease-Free Survival (IDFS) Rate in Basal-Subtype Patients, IDFS was defined to be time from r"| __truncated__ ...
##  $ Secondary.Outcome.Measures: chr  NA "Number of serious and non-serious adverse events (AEs), Include treatment-emergent AEs, SAEs, treatment-related"| __truncated__ "Overall survival (OS), Veliparib will be compared to no veliparib in the BRCA mutation-carriers, BRCA mutation-"| __truncated__ "3-year Recurrence-Free Survival (RFS) Rate in Basal-Subtype Patients, RFS was defined as time from randomizatio"| __truncated__ ...
##  $ Other.Outcome.Measures    : chr  NA NA NA NA ...
##  $ Sponsor                   : chr  "Nektar Therapeutics" "Bayer" "National Cancer Institute (NCI)" "ECOG-ACRIN Cancer Research Group" ...
##  $ Collaborators             : chr  "Bristol-Myers Squibb" "ImmunoGen, Inc.|MorphoSys AG" NA "National Cancer Institute (NCI)" ...
##  $ Sex                       : chr  "ALL" "ALL" "ALL" "ALL" ...
##  $ Age                       : chr  "ADULT, OLDER_ADULT" "ADULT, OLDER_ADULT" "ADULT, OLDER_ADULT" "ADULT, OLDER_ADULT" ...
##  $ Phases                    : chr  "PHASE1|PHASE2" "PHASE1" "PHASE2" "PHASE3" ...
##  $ Enrollment                : int  557 173 333 415 181 224 1006 110 1732 155 ...
##  $ Funder.Type               : chr  "INDUSTRY" "INDUSTRY" "NIH" "NETWORK" ...
##  $ Study.Type                : chr  "INTERVENTIONAL" "INTERVENTIONAL" "INTERVENTIONAL" "INTERVENTIONAL" ...
##  $ Study.Design              : chr  "Allocation: NON_RANDOMIZED|Intervention Model: PARALLEL|Masking: NONE|Primary Purpose: TREATMENT" "Allocation: NON_RANDOMIZED|Intervention Model: PARALLEL|Masking: NONE|Primary Purpose: TREATMENT" "Allocation: RANDOMIZED|Intervention Model: PARALLEL|Masking: NONE|Primary Purpose: TREATMENT" "Allocation: RANDOMIZED|Intervention Model: PARALLEL|Masking: NONE|Primary Purpose: TREATMENT" ...
##  $ Other.IDs                 : chr  "16-214-02" "15834|2016-004002-33" "NCI-2015-01912|NCI-2015-01912|S1416|S1416|S1416|U10CA180888" "EA1131|NCI-2014-01820|EA1131|EA1131|U10CA180820|U24CA196172" ...
##  $ Start.Date                : chr  "2016-12-19" "2017-05-26" "2016-09-15" "2015-10-20" ...
##  $ Primary.Completion.Date   : chr  "2022-04-28" "2020-09-16" "2024-10-31" "2021-04-07" ...
##  $ Completion.Date           : chr  "2022-04-28" "2021-07-26" "2024-10-31" "2031-03-29" ...
##  $ First.Posted              : chr  "2016-12-06" "2017-04-05" "2015-11-04" "2015-05-15" ...
##  $ Results.First.Posted      : chr  "2022-11-29" NA NA "2021-12-09" ...
##  $ Last.Update.Posted        : chr  "2023-03-13" "2022-06-30" "2024-01-09" "2023-07-10" ...
##  $ Locations                 : chr  "UCSD, Moores Cancer Center, La Jolla, California, 92093, United States|UCLA, Los Angeles, California, 90095, Un"| __truncated__ "Mayo Clinic Hospital, Phoenix, Arizona, 85054-4502, United States|University of Southern California, Los Angele"| __truncated__ "Anchorage Associates in Radiation Medicine, Anchorage, Alaska, 98508, United States|Anchorage Radiation Therapy"| __truncated__ "Mobile Infirmary Medical Center, Mobile, Alabama, 36607, United States|University of South Alabama Mitchell Can"| __truncated__ ...
##  $ Study.Documents           : chr  "Study Protocol, https://storage.googleapis.com/ctgov2-large-docs/45/NCT02983045/Prot_000.pdf|Statistical Analys"| __truncated__ NA NA "Study Protocol and Statistical Analysis Plan, https://storage.googleapis.com/ctgov2-large-docs/91/NCT02445391/Prot_SAP_000.pdf" ...
##  $ treatm_term               : chr  "CISPLATIN" "CISPLATIN" "CISPLATIN" "CISPLATIN" ...
##  $ cond_term                 : chr  "BREAST+CANCER" "BREAST+CANCER" "BREAST+CANCER" "BREAST+CANCER" ...
```

Note: one of the combinations did not yield any result. To see it, simply read the file ZERO_URLS.txt located in the download directory


```r
readLines("test_downloads_v2/ZERO_URLS.txt")
```

```
## [1] "https://clinicaltrials.gov/api/v2/studies?format=csv&query.intr=OLAPARIB&query.cond=GLIOMA&pageSize=1000&query.patient=AREA[LocationCity]%20London"
```
It means that there was no clinical trial in London that was investigating glioma with a treatment of olaparib


# Downloading trials with the API beta-version 2023 (probably will expire soon, NOT RECOMMENDED)

Derailed information could be read here: <https://clinicaltrials.gov/api/gui> As of March, 2023 only 100 studies could be downloaded per request with this API. The clinicaltrialsgov package currently supports downloading all information for trials

-   In the following code we download studies for lung cancer with API-acceptable expression


```r
# In this example we downloaded 50 trials for lung cancer (NOTE: max_rnk - min_rnk should be no more than 100)
dataset_1 <- clinicaltrialsgov::get_trials_API_query(query = "lung+cancer",
                                                    download_folder = "test",
                                                    min_rnk = 1,
                                                    max_rnk = 50)
```

This function is also creates a folder "test" and dumps there a corresponding JSON file with trials before concatenation


```r
list.files("test")
```

```
## [1] "downloaded_trials.json"
```


Preview of the data (we just show first 10 columns)


```r
head(dataset_1[,1:10])
```

```
##         NCTId               OrgStudyId                                              OrgFullName OrgClass
## 1 NCT03581708        No.GDREC 2018009H                   Guangdong Provincial People's Hospital    OTHER
## 2 NCT06145750               DELFI-L301                                   Delfi Diagnostics Inc. INDUSTRY
## 3 NCT05572944 MOHW111-TDU-B-221-114019                            Chung Shan Medical University    OTHER
## 4 NCT01130285               UTHSC - 11                                     University of Toledo    OTHER
## 5 NCT05762731            HKU_UW_19_444                              The University of Hong Kong    OTHER
## 6 NCT03992833           2016YFE0103000 Tianjin Medical University Cancer Institute and Hospital    OTHER
##                                                                                                                                             BriefTitle
## 1                                                                                                       Venous Thromboembolism in Advanced Lung Cancer
## 2 Implementing Fragmentomics Into Real World Screening IntervenTions to Evaluate Clinical Utility Among Individuals With Elevated Risk for Lung Cancer
## 3                                                                                              Formatting the Risk Models for Never-Smoked Lung Cancer
## 4                                                                                                 Validation of a Multi-gene Test for Lung Cancer Risk
## 5                                                                             Screening for Lung Cancer in Subjects With Family History of Lung Cancer
## 6                                                                               Methods of Computed Tomography Screening and Management of Lung Cancer
##                                                                                                                              OfficialTitle       Acronym StatusVerifiedDate
## 1                 Real-world Study of the Incidence and Risk Factors of Venous Thromboembolism (VTE) in Chinese Advanced Stage Lung Cancer         RIVAL           May 2018
## 2                                                                    Investigating the Clinical Utility of DELFI Evaluation of Lung Cancer FIRSTLungL301       January 2024
## 3 Validation and Optimization of Multidimensional Modelling for Never Smoking Lung Cancer Risk Prediction by Multicenter Prospective Study       FORMOSA      December 2023
## 4                                                                                     Validation of a Multi-gene Test for Lung Cancer Risk          <NA>       October 2020
## 5                                                                 Screening for Lung Cancer in Subjects With Family History of Lung Cancer          <NA>       January 2023
## 6                       Methods of Computed Tomography Screening and Management of Lung Cancer in Tianjin: A Population-based Cohort Study          <NA>          June 2019
##    OverallStatus        LastKnownStatus
## 1 Unknown status     Not yet recruiting
## 2     Recruiting                   <NA>
## 3     Recruiting                   <NA>
## 4 Unknown status Active, not recruiting
## 5     Recruiting                   <NA>
## 6 Unknown status             Recruiting
```

Data may have a very big number of columns since every term obtained from a trial is stored in the independemt cell in the initial XML document

In some cases one might be willing to download more than 100 trials. In this case, it is necessary to perform to functions: clinicaltrialsgov::prepare_download_URLs() clinicaltrialsgov::get_trials_API_urls()

In the example below we will download \~ 400 trials for a drug olaparib


```r
urls <- clinicaltrialsgov::prepare_download_URLs(query = "olaparib")
writeLines(urls)
```

```
## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=1&max_rnk=100
## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=101&max_rnk=200
## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=201&max_rnk=300
## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=301&max_rnk=400
## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=401&max_rnk=431
```

Now obtained URLs could be used to download trials


```r
dataset_2 <- clinicaltrialsgov::get_trials_API_urls(url_list = urls, download_folder = "test2")
```

```
## 1   20 % completed at 2024-02-09 19:52:39
## 2   40 % completed at 2024-02-09 19:52:52
## 3   60 % completed at 2024-02-09 19:53:13
## 4   80 % completed at 2024-02-09 19:53:25
## 5   100 % completed at 2024-02-09 19:53:30
## Combining 431 datasets at 2024-02-09 19:53:31
```

Preview of the data (we just show the first 10 columns)


```r
head(dataset_2[,1:10])
```

```
##         NCTId     OrgStudyId    SecondaryId     SecondaryIdType SecondaryIdDomain                                                       OrgFullName OrgClass
## 1 NCT03786796         J18166    IRB00197147    Other Identifier           JHM IRB        Sidney Kimmel Comprehensive Cancer Center at Johns Hopkins    OTHER
## 2 NCT01562210 NL35195.031.11         N11ORL Registry Identifier               PTC                                  The Netherlands Cancer Institute    OTHER
## 3 NCT04515836     IRB20-0117           <NA>                <NA>              <NA>                                             University of Chicago    OTHER
## 4 NCT03367689      MedOPP100 2016-002892-80      EudraCT Number              <NA>                                                            MedSIR    OTHER
## 5 NCT02533765     IRST186.02           <NA>                <NA>              <NA> Istituto Scientifico Romagnolo per lo Studio e la cura dei Tumori    OTHER
## 6 NCT02338622        CCR4058 2013-004692-13      EudraCT Number              <NA>                                Royal Marsden NHS Foundation Trust    OTHER
##                                                                                                      BriefTitle
## 1                  Study of Olaparib in Metastatic Renal Cell Carcinoma Patients With DNA Repair Gene Mutations
## 2            Olaparib Dose Escalating Trial + Concurrent RT With or Without Cisplatin in Locally Advanced NSCLC
## 3                                                          Olaparib in Patients With HRD Malignant Mesothelioma
## 4 A Two-stage Simon Design Phase II Study for Non-BRCA MBC Patients With HRD Treated With Olaparib Single Agent
## 5                                         Olaparib as Salvage Treatment for Cisplatin-resistant Germ Cell Tumor
## 6                                                       Trial of Olaparib in Combination With AZD5363 (ComPAKT)
##                                                                                                                                                              OfficialTitle  Acronym
## 1                                     Phase II Study of Olaparib in Metastatic Renal Cell Carcinoma Patients Harboring a BAP-1 or Other DNA Repair Gene Mutations (ORCHID)   ORCHID
## 2             Olaparib Dose Escalating Trial in Patients Treated With Radiotherapy With or Without Daily Dose Cisplatin for Locally Advanced Non-small Cell Lung Carcinoma olaparib
## 3                                                                            Phase II Trial of Olaparib in Homologous Recombination Deficient (HRD) Malignant Mesothelioma     <NA>
## 4 A Two-stage Simon Design Phase II Study for NOn-BRCA Metastatic BReast Cancer (MBC) Patients With Homologous Recombination Deficiency Treated With OLAparib Single Agent  NOBROLA
## 5                                                                                                    Olaparib as Salvage Treatment for Cisplatin-resistant Germ Cell Tumor     <NA>
## 6                         A Phase I Multi-centre Trial of the Combination of Olaparib (PARP Inhibitor) and AZD5363 (AKT Inhibitor) in Patients With Advanced Solid Tumours  ComPAKT
```


```r
nrow(dataset_2[,1:10])
```

```
## [1] 431
```

```r
str(dataset_2[,1:10])
```

```
## 'data.frame':	431 obs. of  10 variables:
##  $ NCTId            : chr  "NCT03786796" "NCT01562210" "NCT04515836" "NCT03367689" ...
##  $ OrgStudyId       : chr  "J18166" "NL35195.031.11" "IRB20-0117" "MedOPP100" ...
##  $ SecondaryId      : chr  "IRB00197147" "N11ORL" NA "2016-002892-80" ...
##  $ SecondaryIdType  : chr  "Other Identifier" "Registry Identifier" NA "EudraCT Number" ...
##  $ SecondaryIdDomain: chr  "JHM IRB" "PTC" NA NA ...
##  $ OrgFullName      : chr  "Sidney Kimmel Comprehensive Cancer Center at Johns Hopkins" "The Netherlands Cancer Institute" "University of Chicago" "MedSIR" ...
##  $ OrgClass         : chr  "OTHER" "OTHER" "OTHER" "OTHER" ...
##  $ BriefTitle       : chr  "Study of Olaparib in Metastatic Renal Cell Carcinoma Patients With DNA Repair Gene Mutations" "Olaparib Dose Escalating Trial + Concurrent RT With or Without Cisplatin in Locally Advanced NSCLC" "Olaparib in Patients With HRD Malignant Mesothelioma" "A Two-stage Simon Design Phase II Study for Non-BRCA MBC Patients With HRD Treated With Olaparib Single Agent" ...
##  $ OfficialTitle    : chr  "Phase II Study of Olaparib in Metastatic Renal Cell Carcinoma Patients Harboring a BAP-1 or Other DNA Repair Ge"| __truncated__ "Olaparib Dose Escalating Trial in Patients Treated With Radiotherapy With or Without Daily Dose Cisplatin for L"| __truncated__ "Phase II Trial of Olaparib in Homologous Recombination Deficient (HRD) Malignant Mesothelioma" "A Two-stage Simon Design Phase II Study for NOn-BRCA Metastatic BReast Cancer (MBC) Patients With Homologous Re"| __truncated__ ...
##  $ Acronym          : chr  "ORCHID" "olaparib" NA "NOBROLA" ...
```

# Downloading trials with legacy API (version 2021, NOT RECOMMENDED)

Legacy ClinicalTrials.gov API was based on the URL: "https://clinicaltrials.gov/ct2/results/download_fields?" and parameters from the advanced search "https://clinicaltrials.gov/ct2/search/advanced?"

- This API allows downloading very large sets of trials in the format as it is seen on the website
- clinicaltrialsgov package currently supports specifying conditions and treatments as well as additional parameters via URL "suffix"
- By default it downloads Interventional clinical trials

In the code below, we could see downloading trials for all combinations of several types of cancers with several treatments


```r
dataset_3 <- clinicaltrialsgov::clinical_trial_downloader_two_terms(
  condition_terms = c("lung cancer", "glioma"),
  treatment_terms = c("cisplatin", "temozolomide", "doxorubicin"),
  folder = "test_downloads_old_api",
  url_suffix = "&cntry=GB&state=&city=London")
```

```
## 1   16.6667 % complete at 2024-02-09 19:53:36
## 2   33.3333 % complete at 2024-02-09 19:53:39
## 3   50 % complete at 2024-02-09 19:53:42
## 4   66.6667 % complete at 2024-02-09 19:53:45
## 5   83.3333 % complete at 2024-02-09 19:53:49
## 6   100 % complete at 2024-02-09 19:53:52
```
Preview data (first 10 columns)

```r
nrow(dataset_3)
```

```
## [1] 126
```


```r
head(dataset_3[,1:10])
```

```
##   Rank  NCT.Number                                                                                                                Title  Acronym         Status        Study.Results
## 1    1 NCT00801736                                                                                                 ERCC1 Targeted Trial       ET     Terminated No Results Available
## 2    2 NCT00003240 Standard Therapy Given With or Without Combination Chemotherapy in Treating Patients With Non-small Cell Lung Cancer          Unknown status No Results Available
## 3    3 NCT04648033                                                  Atovaquone With Radical ChemorADIotherapy in Locally Advanced NSCLC ARCADIAN      Completed No Results Available
## 4    4 NCT00004209                 Combination Chemotherapy in Treating Patients With Stage IIIB or Stage IV Non-small Cell Lung Cancer          Unknown status No Results Available
## 5    5 NCT01641575                                A Dose Ascending Study of Gemcitabine Elaidate (CO-101) in Combination With Cisplatin              Terminated No Results Available
## 6    6 NCT01590160                                            Ganetespib With Platinum, in Patients With Malignant Pleural Mesothelioma  MESO-02      Completed No Results Available
##                                           Conditions
## 1                                        Lung Cancer
## 2                                        Lung Cancer
## 3        Locally Advanced Non-Small Cell Lung Cancer
## 4                                        Lung Cancer
## 5 Solid Tumor|Non-small-cell Lung Cancer|Lung Cancer
## 6       Lung Cancer - Malignant Pleural Mesothelioma
##                                                                                                                                                                          Interventions
## 1                                                                                                                                                          Drug: Cisplatin, Paclitaxel
## 2 Drug: cisplatin|Drug: ifosfamide|Drug: mitomycin C|Drug: vinblastine sulfate|Drug: vindesine|Drug: vinorelbine tartrate|Procedure: conventional surgery|Radiation: radiation therapy
## 3                                                                        Drug: Atovaquone Oral Suspension|Drug: Standard of care chemotherapy|Radiation: Standard of care radiotherapy
## 4                                                                                                                          Drug: cisplatin|Drug: mitomycin C|Drug: vinblastine sulfate
## 5                                                                                                                                                          Drug: CO-1.01 and Cisplatin
## 6                                                                                                                                                                     Drug: Ganetespib
##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Outcome.Measures
## 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Overall Survival|Time to progression
## 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
## 3                                                                                                                                                                                                                                                             The dose of atovaquone associated with no more than 48% dose limiting toxicity (DLT) rate (target toxicity level)|Number of adverse events graded per Common Terminology Criteria for Adverse Events (CTCAE) v4.03|Hypoxia metagene signature from diagnostic tissue using 3'RNA-Seq|Correlation between tumour hypoxic volume and plasma miR-210 level|Correlation between tumour hypoxic volume and tumour hypoxia gene expression|Correlation between changes in tumour hypoxic volume and plasma miR-210 level|Response to treatment assessed per Response Evaluation Criteria in Solid Tumours (RECIST) V1.1
## 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
## 5 Dose limiting toxicities (DLT)(Part 1)|Adverse events (Description of event in medical terminology, Intensity, Relationship to drug, Outcome, and/or Follow up )(Part 2)|Clinical Laboratory Abnormalities (ANC, Platelets, Hemoglobin, AST/ALT, Bilirubin, Creatinine clearance)(Part 2)|ECG Abnormalities (Part 2)|PK parameters for CO-1.01 and its metabolites in plasma and urine (AUC, Cmax, Tmax, half life, kel, Vss, Cl, and MRT) (Part 1)|Adverse events (Description of event in medical terminology, Intensity, Relationship to drug, Outcome, and/or Follow up )( (Part 1)|Clinical Laboratory Abnormalities (ANC, Platelets, Hemoglobin, AST/ALT, Bilirubin, Creatinine clearance)(Part 1)|ECG abnormalities (Part 1)|Overall response rate (ORR)(Part 2)|Duration of response (Part 2)|Progression-free survival (PFS)(Part 2)|Tumor hENT1 expression (Part 2)
## 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Maximum Tolerated Dose of Ganetespib|Progression Free Survival
##                                                                                                                                                                                              Sponsor.Collaborators
## 1                                                                                                                                              University College, London|Eli Lilly and Company|Cancer Research UK
## 2                                                                                                                                                                                  National Cancer Institute (NCI)
## 3 University of Oxford|Cancer Research UK|National Institute for Health Research, United Kingdom|NHS Lothian|Oxford University Hospitals NHS Trust|NHS Research Scotland|Guy's and St Thomas' NHS Foundation Trust
## 4                                                                                                                                                               Cancer Research UK|National Cancer Institute (NCI)
## 5                                                                                                                                                                                            Clovis Oncology, Inc.
## 6                                                                                                                                                                    University College, London|Cancer Research UK
```
In the folder test_downloads we could find individual download files and reporting file


```r
list.files("test_downloads_old_api")
```

```
## [1] "1___.csv"           "2___.csv"           "3___.csv"           "4___.csv"           "5___.csv"           "6___.csv"           "reporting_file.csv"
```
Let's see the reporting file

```r
report_1 <- read.csv("test_downloads_old_api/reporting_file.csv")
report_1
```

```
##   X                       Term Index
## 1 1    LUNG+CANCER&&&CISPLATIN     1
## 2 2 LUNG+CANCER&&&TEMOZOLOMIDE     2
## 3 3  LUNG+CANCER&&&DOXORUBICIN     3
## 4 4         GLIOMA&&&CISPLATIN     4
## 5 5      GLIOMA&&&TEMOZOLOMIDE     5
## 6 6       GLIOMA&&&DOXORUBICIN     6
##                                                                                                                                                                                        URL
## 1    https://clinicaltrials.gov/ct2/results/download_fields?cond=LUNG+CANCER&intr=CISPLATIN&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
## 2 https://clinicaltrials.gov/ct2/results/download_fields?cond=LUNG+CANCER&intr=TEMOZOLOMIDE&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
## 3  https://clinicaltrials.gov/ct2/results/download_fields?cond=LUNG+CANCER&intr=DOXORUBICIN&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
## 4         https://clinicaltrials.gov/ct2/results/download_fields?cond=GLIOMA&intr=CISPLATIN&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
## 5      https://clinicaltrials.gov/ct2/results/download_fields?cond=GLIOMA&intr=TEMOZOLOMIDE&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
## 6       https://clinicaltrials.gov/ct2/results/download_fields?cond=GLIOMA&intr=DOXORUBICIN&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
##                                                                                                         URL_check     Status Trials Intervention Condition_searched
## 1    https://clinicaltrials.gov/ct2/results?cond=LUNG+CANCER&intr=CISPLATIN&type=Intr&cntry=GB&state=&city=London Downloaded     82    cisplatin        lung cancer
## 2 https://clinicaltrials.gov/ct2/results?cond=LUNG+CANCER&intr=TEMOZOLOMIDE&type=Intr&cntry=GB&state=&city=London Downloaded      1 temozolomide        lung cancer
## 3  https://clinicaltrials.gov/ct2/results?cond=LUNG+CANCER&intr=DOXORUBICIN&type=Intr&cntry=GB&state=&city=London Downloaded      6  doxorubicin        lung cancer
## 4         https://clinicaltrials.gov/ct2/results?cond=GLIOMA&intr=CISPLATIN&type=Intr&cntry=GB&state=&city=London Downloaded      6    cisplatin             glioma
## 5      https://clinicaltrials.gov/ct2/results?cond=GLIOMA&intr=TEMOZOLOMIDE&type=Intr&cntry=GB&state=&city=London Downloaded     30 temozolomide             glioma
## 6       https://clinicaltrials.gov/ct2/results?cond=GLIOMA&intr=DOXORUBICIN&type=Intr&cntry=GB&state=&city=London Downloaded      1  doxorubicin             glioma
```
All combinations of diseases and treatments are searched

```r
report_1[,c("Intervention", "Condition_searched")]
```

```
##   Intervention Condition_searched
## 1    cisplatin        lung cancer
## 2 temozolomide        lung cancer
## 3  doxorubicin        lung cancer
## 4    cisplatin             glioma
## 5 temozolomide             glioma
## 6  doxorubicin             glioma
```

This function also supports specification of just disease or just therapy


```r
dataset_4 <- clinicaltrialsgov::clinical_trial_downloader_two_terms(
  treatment_terms = c("cisplatin", "temozolomide", "olaparib"),
  folder = "test_downloads_old_api2")
```

```
## 1   33.3333 % complete at 2024-02-09 19:53:58
## 2   66.6667 % complete at 2024-02-09 19:54:05
## 3   100 % complete at 2024-02-09 19:54:10
```

```r
nrow(dataset_4)
```

```
## [1] 5635
```



