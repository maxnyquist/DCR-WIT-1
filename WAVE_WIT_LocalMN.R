################################### HEADER ###################################
#  TITLE: WAVE_WIT_Local.R
#  DESCRIPTION: Use this to load libraries, config file, and datasets when running WAVE or WIT apps via R Studio
#  AUTHOR(S): Dan Crocker
#  DATE LAST UPDATED: Nov 2019
#  GIT REPO: None - Do not post on GitHub
#  R version 3.5.3 (2019-03-11)  i386
##############################################################################.

library(readxl)
library(tidyverse)
library(stringr)
library(odbc)
library(RODBC)
library(DBI)
library(lubridate)
library(magrittr)
library(readxl)
library(magrittr)
library(DescTools)
library(devtools)
library(tidyr)

# ###  
# # Specify Library path and Load libraries needed in this script only
# .libPaths(config[["R_lib_Path"]])
# 
# ipak <- function(pkg){
#   new.pkg <- pkg[!(pkg %in% installed.packages(lib.loc = config[["R_lib_Path"]])[, "Package"])]
#   if (length(new.pkg))
#     install.packages(new.pkg, lib = config[["R_lib_Path"]], dependencies = TRUE, repos="http://cran.rstudio.com/")
#   sapply(pkg, require, character.only = TRUE)
# }
# 
# # usage
# packages <- c("httpuv", "shiny")
# ipak(packages)
# 
# 
# 
# 
### LOAD CONFIGS FOR WAVE-WIT APPS ####
username <- Sys.getenv('USERNAME')
userlogin <- username
user_root <- paste0("C:/Users/",userlogin ,"/Commonwealth of Massachusetts/DCR-TEAMS-DWSPEQ - Documents/")
wach_team_root <- glue('C:/Users/{username}/Commonwealth of Massachusetts/DCR WSP - WaterQualityMonitoring/')
quab_team_root <- glue('C:/Users/{username}/Commonwealth of Massachusetts/DCR WSP - EQINSPEC/')
config_path <- paste0(user_root,"Water Quality/R-Shared/Configs/WAVE_WIT_Config.csv")
R_config <- read.csv(config_path, header = TRUE)
config <- as.character(R_config$CONFIG_VALUE)
config_names <- as.character(R_config$CONFIG_NAME)
names(config) <- config_names
userlocation <- "Wachusett" #Or use "Quabbin"

# config 8 is wachusett datasets, config 9 is Quabbin config 11 is testing db
datasets <-  paste0(wach_team_root, config[["Wach Import Datasets"]])
# datasets <-  paste0(quab_team_root, config[["Quab Import Datasets"]])
datasets <- read_excel(datasets) %>% print()
datasets$DataType
# Pick the dataset for import
dataset <- slice(datasets, 25)
# Process Args
# rawdatafolder <- paste0(quab_team_root, dataset[[11]])
rawdatafolder <- paste0(wach_team_root, dataset[[11]])
# List the available unprocessed files for importing
files <- list.files(rawdatafolder, pattern = dataset[[14]])
# Look at the files
files

# Choose the file to import
file <- files[1]

filename.db <- dataset[[6]]
filename.db
# probe <- "YSI_EXO2"
# probe = NULL # This only used for Aq Bio stuff

# Import Args
ImportTable <- dataset[[7]]
ImportFlagTable <-  dataset[[8]]
processedfolder <- paste0(wach_team_root, dataset[[12]])
# processedfolder <- paste0(quab_team_root, dataset[[12]])
# Flag Args
flag.db <- dataset[[6]]
datatable <- dataset[[7]]
flagtable <- dataset[[8]]

# App settings
username <- "Max Nyquist"



dataset <- slice(datasets, 2)
# Process Args
rawdatafolder <- paste0(wach_team_root, dataset[[11]])
# List the available unprocessed files for importing
files <- list.files(rawdatafolder, pattern = dataset[[14]])
# Look at the files
files

# Choose the file to import
file <- files[1]

filename.db <- dataset[[6]]
filename.db
probe <- "YSI_EXO2"
#probe = NULL # This only used for Aq Bio stuff

# Import Args
ImportTable <- dataset[[7]]
ImportFlagTable <-  dataset[[8]]
processedfolder <- paste0(wach_team_root, dataset[[12]])

# Flag Args
flag.db <- dataset[[6]]
datatable <- dataset[[7]]
flagtable <- dataset[[8]]

# App settings
username <- "Dan Crocker"
username <- "Max Nyquist"
### From here step into the WAVE-WIT scripts


