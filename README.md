## clinicaltrialsgov package
This ClinicalTrials.gov website is one of largest registers of clinical trials in world. It is primarily focused on US market/healthcare but also frequently includes trials from other countries and could be used for analysis of trends in drug discovey. This ClinicalTrials.gov provides manual data downloading and API functionality. This package provides convenient ways to access clinical trial records within the R environment to facilitate subsequent analyses. The package allows specifying conditions, treatments as well as any advanced filter option in the ClinicalTrials search engine (via URL suffix).

-   This package is designed to download data from ClinicalTrials.gov (https://clinicaltrials.gov/)
-   It supports legacy and new APIs (as of 2022-2023)
-   Several search features are available
-   As of now only downloading full data is supported
-   The ClinicalTrials.gov beta (<https://beta.clinicaltrials.gov/>) is
    not yet implemented

``` r
# Package installation
library(remotes)
remotes::install_github("AleksandrVSokolov/clinicaltrialsgov", force = TRUE)
```

    ## Downloading GitHub repo AleksandrVSokolov/clinicaltrialsgov@HEAD

    ## 
    ## ── R CMD build ─────────────────────────────────────────────────────────────────
    ##      checking for file ‘/tmp/RtmppauxFX/remotes76c13318f068/AleksandrVSokolov-clinicaltrialsgov-ef4630d/DESCRIPTION’ ...  ✔  checking for file ‘/tmp/RtmppauxFX/remotes76c13318f068/AleksandrVSokolov-clinicaltrialsgov-ef4630d/DESCRIPTION’
    ##   ─  preparing ‘clinicaltrialsgov’:
    ##    checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
    ##   ─  checking for LF line-endings in source and make files and shell scripts
    ## ─  checking for empty or unneeded directories
    ##   ─  building ‘clinicaltrialsgov_0.1.0.tar.gz’
    ##      
    ## 

    ## Installing package into '/home/aleksandr/R/x86_64-pc-linux-gnu-library/4.2'
    ## (as 'lib' is unspecified)

We have installed the package

``` r
# Importing
library(clinicaltrialsgov)
```

# Downloading trials with the new API

ClinicalTrials.gov provides convenient API to access its data. Derailed
information could be read here: <https://clinicaltrials.gov/api/gui> As
of March, 2023 only 100 studies could be downloaded per request with
this API. The clinicaltrialsgov package currently supports downloading
all information for trials

-   In the following code we download studies for lung cancer with
    API-acceptable expression

``` r
# In this example we downloaded 50 trials for lung cancer (NOTE: max_rnk - min_rnk should be no more than 100)
dataset_1 <- clinicaltrialsgov::get_trials_API_query(query = "lung+cancer",
                                                    download_folder = "test",
                                                    min_rnk = 1,
                                                    max_rnk = 50)
```

This function is also creates a folder “test” and dumps there a
corresponding JSON file with trials before concatenation

``` r
list.files("test")
```

    ## [1] "downloaded_trials.json"

Preview of the data (we just show first 10 columns)

``` r
head(dataset_1[,1:10])
```

    ##         NCTId               OrgStudyId
    ## 1 NCT03581708        No.GDREC 2018009H
    ## 2 NCT05572944 MOHW111-TDU-B-221-114019
    ## 3 NCT01130285               UTHSC - 11
    ## 4 NCT05762731            HKU_UW_19_444
    ## 5 NCT03992833           2016YFE0103000
    ## 6 NCT02725892              D133FR00108
    ##                                                OrgFullName OrgClass
    ## 1                   Guangdong Provincial People's Hospital    OTHER
    ## 2                            Chung Shan Medical University    OTHER
    ## 3                                     University of Toledo    OTHER
    ## 4                              The University of Hong Kong    OTHER
    ## 5 Tianjin Medical University Cancer Institute and Hospital    OTHER
    ## 6                                              AstraZeneca INDUSTRY
    ##                                                                     BriefTitle
    ## 1                               Venous Thromboembolism in Advanced Lung Cancer
    ## 2      Multidimensional Modeling for Never Smoking Lung Cancer Risk Prediction
    ## 3                         Validation of a Multi-gene Test for Lung Cancer Risk
    ## 4     Screening for Lung Cancer in Subjects With Family History of Lung Cancer
    ## 5       Methods of Computed Tomography Screening and Management of Lung Cancer
    ## 6 National Lung Cancer Registry in Men and Women Based on Diagnosis in Algeria
    ##                                                                                                                              OfficialTitle
    ## 1                 Real-world Study of the Incidence and Risk Factors of Venous Thromboembolism (VTE) in Chinese Advanced Stage Lung Cancer
    ## 2 Validation and Optimization of Multidimensional Modelling for Never Smoking Lung Cancer Risk Prediction by Multicenter Prospective Study
    ## 3                                                                                     Validation of a Multi-gene Test for Lung Cancer Risk
    ## 4                                                                 Screening for Lung Cancer in Subjects With Family History of Lung Cancer
    ## 5                       Methods of Computed Tomography Screening and Management of Lung Cancer in Tianjin: A Population-based Cohort Study
    ## 6                                                                                               LuCaReAl: Lung Cancer Registry in Algeria.
    ##    Acronym StatusVerifiedDate  OverallStatus        LastKnownStatus
    ## 1    RIVAL           May 2018 Unknown status     Not yet recruiting
    ## 2     <NA>      December 2022     Recruiting                   <NA>
    ## 3     <NA>       October 2020 Unknown status Active, not recruiting
    ## 4     <NA>       January 2023     Recruiting                   <NA>
    ## 5     <NA>          June 2019 Unknown status             Recruiting
    ## 6 LuCaReAl         March 2022      Completed                   <NA>

Data may have a very big number of columns since every term obtained
from a trial is stored in the independemt cell in the initial XML
document

In some cases one might be willing to download more than 100 trials. In
this case, it is necessary to perform to functions:
clinicaltrialsgov::prepare_download_URLs()
clinicaltrialsgov::get_trials_API_urls()

In the example below we will download \~ 400 trials for a drug olaparib

``` r
urls <- clinicaltrialsgov::prepare_download_URLs(query = "olaparib")
writeLines(urls)
```

    ## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=1&max_rnk=100
    ## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=101&max_rnk=200
    ## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=201&max_rnk=300
    ## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=301&max_rnk=400
    ## https://ClinicalTrials.gov/api/query/full_studies?expr=olaparib&min_rnk=401&max_rnk=406

Now obtained URLs could be used to download trials

``` r
dataset_2 <- clinicaltrialsgov::get_trials_API_urls(url_list = urls, download_folder = "test2")
```

    ## 1   20 % completed at 2023-03-21 16:44:13
    ## 2   40 % completed at 2023-03-21 16:44:30
    ## 3   60 % completed at 2023-03-21 16:44:45
    ## 4   80 % completed at 2023-03-21 16:44:55
    ## 5   100 % completed at 2023-03-21 16:44:58
    ## Combining 406 datasets at 2023-03-21 16:44:58

Preview of the data (we just show first 10 columns)

``` r
head(dataset_2[,1:10])
```

    ##         NCTId     OrgStudyId    SecondaryId     SecondaryIdType
    ## 1 NCT03786796         J18166    IRB00197147    Other Identifier
    ## 2 NCT01562210 NL35195.031.11         N11ORL Registry Identifier
    ## 3 NCT04515836     IRB20-0117           <NA>                <NA>
    ## 4 NCT03367689      MedOPP100 2016-002892-80      EudraCT Number
    ## 5 NCT02533765     IRST186.02           <NA>                <NA>
    ## 6 NCT02338622        CCR4058 2013-004692-13      EudraCT Number
    ##   SecondaryIdDomain
    ## 1           JHM IRB
    ## 2               PTC
    ## 3              <NA>
    ## 4              <NA>
    ## 5              <NA>
    ## 6              <NA>
    ##                                                         OrgFullName OrgClass
    ## 1        Sidney Kimmel Comprehensive Cancer Center at Johns Hopkins    OTHER
    ## 2                                  The Netherlands Cancer Institute    OTHER
    ## 3                                             University of Chicago    OTHER
    ## 4                                                            MedSIR    OTHER
    ## 5 Istituto Scientifico Romagnolo per lo Studio e la cura dei Tumori    OTHER
    ## 6                                Royal Marsden NHS Foundation Trust    OTHER
    ##                                                                                                      BriefTitle
    ## 1                  Study of Olaparib in Metastatic Renal Cell Carcinoma Patients With DNA Repair Gene Mutations
    ## 2            Olaparib Dose Escalating Trial + Concurrent RT With or Without Cisplatin in Locally Advanced NSCLC
    ## 3                                                          Olaparib in Patients With HRD Malignant Mesothelioma
    ## 4 A Two-stage Simon Design Phase II Study for Non-BRCA MBC Patients With HRD Treated With Olaparib Single Agent
    ## 5                                         Olaparib as Salvage Treatment for Cisplatin-resistant Germ Cell Tumor
    ## 6                                                       Trial of Olaparib in Combination With AZD5363 (ComPAKT)
    ##                                                                                                                                                              OfficialTitle
    ## 1                                     Phase II Study of Olaparib in Metastatic Renal Cell Carcinoma Patients Harboring a BAP-1 or Other DNA Repair Gene Mutations (ORCHID)
    ## 2             Olaparib Dose Escalating Trial in Patients Treated With Radiotherapy With or Without Daily Dose Cisplatin for Locally Advanced Non-small Cell Lung Carcinoma
    ## 3                                                                            Phase II Trial of Olaparib in Homologous Recombination Deficient (HRD) Malignant Mesothelioma
    ## 4 A Two-stage Simon Design Phase II Study for NOn-BRCA Metastatic BReast Cancer (MBC) Patients With Homologous Recombination Deficiency Treated With OLAparib Single Agent
    ## 5                                                                                                    Olaparib as Salvage Treatment for Cisplatin-resistant Germ Cell Tumor
    ## 6                         A Phase I Multi-centre Trial of the Combination of Olaparib (PARP Inhibitor) and AZD5363 (AKT Inhibitor) in Patients With Advanced Solid Tumours
    ##    Acronym
    ## 1   ORCHID
    ## 2 olaparib
    ## 3     <NA>
    ## 4  NOBROLA
    ## 5     <NA>
    ## 6  ComPAKT

``` r
nrow(dataset_2[,1:10])
```

    ## [1] 406

``` r
str(dataset_2[,1:10])
```

    ## 'data.frame':    406 obs. of  10 variables:
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

# Downloading trials with legacy API

Legacy ClinicalTrials.gov API was based on the URL:
“<https://clinicaltrials.gov/ct2/results/download_fields>?” and
parameters from the advanced search
“<https://clinicaltrials.gov/ct2/search/advanced>?”

-   This API allows downloading very large sets of trials in the format
    as it is seen on the website
-   clinicaltrialsgov package currently supports specifying conditions
    and treatments as well as additional parameters via URL “suffix”
-   By default it downloads Interventional clinical trials

In the code below, we could see downloading trials for all combinations
of several types of cancers with several treatments

``` r
dataset_3 <- clinicaltrialsgov::clinical_trial_downloader_two_terms(
  condition_terms = c("brain cancer", "glioma"),
  treatment_terms = c("cisplatin", "temozolomide", "olaparib"),
  folder = "test_downloads",
  url_suffix = "&cntry=GB&state=&city=London")
```

    ## 1   16.6667 % complete at 2023-03-21 16:45:03
    ## 2   33.3333 % complete at 2023-03-21 16:45:06
    ## 3   50 % complete at 2023-03-21 16:45:09
    ## 4   66.6667 % complete at 2023-03-21 16:45:14
    ## 5   83.3333 % complete at 2023-03-21 16:45:18
    ## 6   100 % complete at 2023-03-21 16:45:21

Preview data (first 10 columns)

``` r
nrow(dataset_3)
```

    ## [1] 53

``` r
head(dataset_3[,1:10])
```

    ##   Rank  NCT.Number
    ## 1    1 NCT02066220
    ## 2    2 NCT00281905
    ## 3    3 NCT00360945
    ## 4    4 NCT00274911
    ## 5    5 NCT00293358
    ## 6    1 NCT02617589
    ##                                                                                                                                                                                              Title
    ## 1                                                                                                                       International Society of Paediatric Oncology (SIOP) PNET 5 Medulloblastoma
    ## 2                                                                                                Combination Chemotherapy With or Without Radiation Therapy in Treating Children With Brain Tumors
    ## 3                                                                                                                      Cisplatin and Temozolomide in Treating Young Patients With Malignant Glioma
    ## 4                                                           Radiation Therapy Followed By Combination Chemotherapy in Treating Young Patients With Supratentorial Primitive Neuroectodermal Tumors
    ## 5                                                                                           Combination Chemotherapy and Radiation Therapy in Treating Patients With Germ Cell Tumors in the Brain
    ## 6 An Investigational Immuno-therapy Study of Nivolumab Compared to Temozolomide, Each Given With Radiation Therapy, for Newly-diagnosed Patients With Glioblastoma (GBM, a Malignant Brain Cancer)
    ##         Acronym                 Status        Study.Results
    ## 1          <NA> Active, not recruiting No Results Available
    ## 2          <NA>         Unknown status No Results Available
    ## 3          <NA>         Unknown status No Results Available
    ## 4          <NA>         Unknown status No Results Available
    ## 5          <NA>              Completed No Results Available
    ## 6 CheckMate 498              Completed          Has Results
    ##                                              Conditions
    ## 1                                          Brain Tumors
    ## 2 Brain and Central Nervous System Tumors|Neuroblastoma
    ## 3               Brain and Central Nervous System Tumors
    ## 4               Brain and Central Nervous System Tumors
    ## 5               Brain and Central Nervous System Tumors
    ## 6                                          Brain Cancer
    ##                                                                                                                                                                                                                                                                                                                                                                      Interventions
    ## 1 Radiation: Radiotherapy without Carboplatin|Drug: Reduced-intensity maintenance chemotherapy|Radiation: Radiotherapy with Carboplatin|Drug: Maintenance chemotherapy|Radiation: WNT-HR < 16 years|Radiation: WNT-HR >= 16 years|Drug: Induction Chemotherapy|Radiation: SHH-TP53 M0|Radiation: SHH-TP53 M+ (germline)|Radiation: SHH-TP53 (somatic)|Drug: Vinblastin Maintenance
    ## 2                                                                                                                                                                                                                                               Drug: carboplatin|Drug: cisplatin|Drug: cyclophosphamide|Drug: methotrexate|Drug: vincristine sulfate|Radiation: radiation therapy
    ## 3                                                                                                                                            Drug: cisplatin|Drug: temozolomide|Genetic: fluorescence in situ hybridization|Genetic: loss of heterozygosity analysis|Other: immunohistochemistry staining method|Other: laboratory biomarker analysis|Radiation: radiation therapy
    ## 4                                                                                                                                                                                                                                                               Drug: cisplatin|Drug: lomustine|Drug: vincristine sulfate|Procedure: adjuvant therapy|Radiation: radiation therapy
    ## 5                                                                                                                                                                             Drug: carboplatin|Drug: cisplatin|Drug: etoposide phosphate|Drug: ifosfamide|Procedure: adjuvant therapy|Procedure: conventional surgery|Procedure: neoadjuvant therapy|Radiation: radiation therapy
    ## 6                                                                                                                                                                                                                                                                                                                       Drug: Nivolumab|Drug: Temozolomide|Radiation: Radiotherapy
    ##                                                                                                                                                                                                                                                                                                                                        Outcome.Measures
    ## 1 3-year Event-Free Survival (EFS)|Overall survival|Pattern of relapse|Late effects of therapy on endocrine function|Late effects of therapy on audiology|Late effects of therapy on neurology|Late effects of therapy on quality of survival|Progression-free survival|Feasibility of carboplatin treatment|Residual tumor|Leukoencephalopathy grading
    ## 2                                                            Response rate|Event-free survival|Local recurrence or occurrence of CNS metastases|Quality of survival|Tolerance|Long-term toxicity|Proportion of patients requiring radiotherapy|Prognosis of children who receive both chemotherapy and radiotherapy|Nature and behavior of brain tumors
    ## 3                                                                                                                                                                        Response rate after 2 courses|Relapse-free survival|Best response in patients receiving more than 2 courses|Rate of progression at 6 months and 1 and 2 years|Overall survival
    ## 4                                              Toxicity measured by hematological, gastrointestinal, mucosal, neurological, and skin morbidity during treatment and for 6 weeks after completion of treatment|Overall and relapse free survival at follow up every 2 months for 1 year, every 3 months for 2 years, and then every 6 months for 2 years
    ## 5                                                                                                                                                                                                                                                                                                                          Survival|Event-free survival
    ## 6                                                                                                                                                                        Overall Survival (OS)|Progression Free Survival (PFS)|OS at 24 Months|OS in Tumor Mutational Burden (TMB) High Population|PFS in Tumor Mutational Burden (TMB) High Population
    ##                                                   Sponsor.Collaborators
    ## 1   Universitätsklinikum Hamburg-Eppendorf|Deutsche Kinderkrebsstiftung
    ## 2 Children's Cancer and Leukaemia Group|National Cancer Institute (NCI)
    ## 3 Children's Cancer and Leukaemia Group|National Cancer Institute (NCI)
    ## 4 Children's Cancer and Leukaemia Group|National Cancer Institute (NCI)
    ## 5 Children's Cancer and Leukaemia Group|National Cancer Institute (NCI)
    ## 6                       Bristol-Myers Squibb|Ono Pharmaceutical Co. Ltd

In the folder test_downloads we could find individual download files and
reporting file

``` r
list.files("test_downloads")
```

    ## [1] "1___.csv"           "2___.csv"           "4___.csv"          
    ## [4] "5___.csv"           "reporting_file.csv"

Let’s see the reporting file

``` r
report_1 <- read.csv("test_downloads/reporting_file.csv")
report_1
```

    ##   X                        Term Index
    ## 1 1    BRAIN+CANCER&&&CISPLATIN     1
    ## 2 2 BRAIN+CANCER&&&TEMOZOLOMIDE     2
    ## 3 3     BRAIN+CANCER&&&OLAPARIB     3
    ## 4 4          GLIOMA&&&CISPLATIN     4
    ## 5 5       GLIOMA&&&TEMOZOLOMIDE     5
    ## 6 6           GLIOMA&&&OLAPARIB     6
    ##                                                                                                                                                                                         URL
    ## 1    https://clinicaltrials.gov/ct2/results/download_fields?cond=BRAIN+CANCER&intr=CISPLATIN&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
    ## 2 https://clinicaltrials.gov/ct2/results/download_fields?cond=BRAIN+CANCER&intr=TEMOZOLOMIDE&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
    ## 3     https://clinicaltrials.gov/ct2/results/download_fields?cond=BRAIN+CANCER&intr=OLAPARIB&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
    ## 4          https://clinicaltrials.gov/ct2/results/download_fields?cond=GLIOMA&intr=CISPLATIN&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
    ## 5       https://clinicaltrials.gov/ct2/results/download_fields?cond=GLIOMA&intr=TEMOZOLOMIDE&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
    ## 6           https://clinicaltrials.gov/ct2/results/download_fields?cond=GLIOMA&intr=OLAPARIB&type=Intr&down_count=10000&down_chunk=1&down_fmt=csv&down_flds=all&cntry=GB&state=&city=London
    ##                                                                                                          URL_check
    ## 1    https://clinicaltrials.gov/ct2/results?cond=BRAIN+CANCER&intr=CISPLATIN&type=Intr&cntry=GB&state=&city=London
    ## 2 https://clinicaltrials.gov/ct2/results?cond=BRAIN+CANCER&intr=TEMOZOLOMIDE&type=Intr&cntry=GB&state=&city=London
    ## 3     https://clinicaltrials.gov/ct2/results?cond=BRAIN+CANCER&intr=OLAPARIB&type=Intr&cntry=GB&state=&city=London
    ## 4          https://clinicaltrials.gov/ct2/results?cond=GLIOMA&intr=CISPLATIN&type=Intr&cntry=GB&state=&city=London
    ## 5       https://clinicaltrials.gov/ct2/results?cond=GLIOMA&intr=TEMOZOLOMIDE&type=Intr&cntry=GB&state=&city=London
    ## 6           https://clinicaltrials.gov/ct2/results?cond=GLIOMA&intr=OLAPARIB&type=Intr&cntry=GB&state=&city=London
    ##              Status Trials Intervention Condition_searched
    ## 1        Downloaded      5    cisplatin       brain cancer
    ## 2        Downloaded     14 temozolomide       brain cancer
    ## 3 No trials/Invalid      0     olaparib       brain cancer
    ## 4        Downloaded      6    cisplatin             glioma
    ## 5        Downloaded     28 temozolomide             glioma
    ## 6 No trials/Invalid      0     olaparib             glioma

All combinations of diseases and treatments are searched

``` r
report_1[,c("Intervention", "Condition_searched")]
```

    ##   Intervention Condition_searched
    ## 1    cisplatin       brain cancer
    ## 2 temozolomide       brain cancer
    ## 3     olaparib       brain cancer
    ## 4    cisplatin             glioma
    ## 5 temozolomide             glioma
    ## 6     olaparib             glioma

This function also supports specification of just disease or just
therapy

``` r
dataset_4 <- clinicaltrialsgov::clinical_trial_downloader_two_terms(
  treatment_terms = c("cisplatin", "temozolomide", "olaparib"),
  folder = "test_downloads2")
```

    ## 1   33.3333 % complete at 2023-03-21 16:45:31
    ## 2   66.6667 % complete at 2023-03-21 16:45:36
    ## 3   100 % complete at 2023-03-21 16:45:39

``` r
nrow(dataset_4)
```

    ## [1] 5349
