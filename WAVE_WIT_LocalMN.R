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


# Read config file
#config_w_path <- "//env.govt.state.ma.us/enterprise/DCR-WestBoylston-WKGRP/WatershedJAH/EQStaff/WaterQualityMonitoring/R-Shared/WAVE-WIT/Configs/WAVE_WIT_Config.csv"
config_w_path <- "W:/WatershedJAH/EQStaff/WaterQualityMonitoring/R-Shared/WAVE-WIT/Configs/WAVE_WIT_Config.csv"
# config_q_path <- "//env.govt.state.ma.us/enterprise/DCR-Quabbin-WKGRP/EQINSPEC/WQDatabase/config/WAVE_WIT_Config.csv"

if (try(file.exists(config_w_path))) {
  config <- read.csv(config_w_path, header = TRUE)
} else if(try(file.exists(config_q_path))) {
  config <- read.csv(config_q_path, header = TRUE)
} else {
  stop("No configuration file available, cannot use WIT now.")
}

config <- as.character(config$CONFIG_VALUE)
# config 8 is wachusett datasets, config 9 is Quabbin config 11 is testing db
datasets <- config[8]
datasets <- read_excel(datasets) %>% print()
datasets$DataType
# Pick the dataset for import
dataset <- slice(datasets, 2)
# Process Args
rawdatafolder <- dataset[[11]]
# List the available unprocessed files for importing
files <- list.files(rawdatafolder, pattern = dataset[[14]])
# Look at the files
files

# Choose the file to import
file <- files[2]

filename.db <- dataset[[6]]
filename.db
 probe <- "YSI_EXO2"
#probe = NULL # This only used for Aq Bio stuff

# Import Args
ImportTable <- dataset[[7]]
ImportFlagTable <-  dataset[[8]]
processedfolder <- dataset[[12]]

# Flag Args
flag.db <- dataset[[6]]
datatable <- dataset[[7]]
flagtable <- dataset[[8]]

### From here step into the WAVE-WIT scripts
