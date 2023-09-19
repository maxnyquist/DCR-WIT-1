h###############################  HEADER  ######################################
#  TITLE: UpdateRDS_Manual.R
#  DESCRIPTION: Call individual functions to update RDS files associated with individual data streams
#  AUTHOR(S): Dan Crocker
#  DATE LAST UPDATED: 2021-02-24
#  GIT REPO: None
#  R version 4.0.3 (2020-10-10)  i386
##############################################################################.

library("callr")

### Use the one associated with your office and delete the other in your personal copy of this script
userlocation <- "Wachusett"
# userlocation <- "Quabbin"

### Launch mode should be network
launch_mode <- "network"

### Read config file ####
if (launch_mode == "local") {
  config_w_path <- "C:/WQDatabase/WAVE_WIT_Apps/WAVE-WIT_Local/Configs/WAVE_WIT_Config.csv"
  config_q_path <- ""
} else { # launch_mode = "network"
  config_w_path <- "//env.govt.state.ma.us/enterprise/DCR-WestBoylston-WKGRP/WatershedJAH/EQStaff/WaterQualityMonitoring/R-Shared/WAVE-WIT/Configs/WAVE_WIT_Config.csv"
  config_q_path <- "//env.govt.state.ma.us/enterprise/DCR-Quabbin-WKGRP/EQINSPEC/WQDatabase/config/WAVE_WIT_Config.csv"
}

if (userlocation == "Wachusett") {
  config <- read.csv(config_w_path, header = TRUE)
} else if(try(file.access(config_q_path, mode = 4)) == 0) {
  config <- read.csv(config_q_path, header = TRUE)
} else {
  stop("No configuration file available, cannot update RDS files now.")
}

config <- as.character(config$CONFIG_VALUE)

### This will run each function specified by WIT (datasets with new data or flags successfully added)
### To run this manually, just create a new funList vector of functions and then run the loop
### Options:

fun_choices <- c("QW_mwra",     # 1
                 "Q_phyto",     # 2
                 "Q_profile",   # 3
                 "Q_flags",     # 4
                 "W_flags",     # 5
                 "W_phyto",     # 6
                 "W_profile",   # 7
                 "W_resnuts",   # 8
                 "W_secchi",    # 9
                 "W_trib_trans",#10
                 "W_wells",     #11
                 "W_flow")      #12

### Make a vector of the RDS files that you want to update
###  Look at the ImportDatasets excel file to see which datasets are associated with each of the choices

funList <- fun_choices[c(9)]

### Call the update_WAVE.R script and run the functions specified above
rscript(
  script = config[11],
  cmdargs = funList,
  libpath = config[15],
  repos = default_repos(),
  stdout = "updateWAVE.log",
  stderr = "2>&1",
  poll_connection = FALSE,
  echo = TRUE,
  show = TRUE,
  callback = NULL,
  block_callback = NULL,
  spinner = TRUE,
  system_profile = FALSE,
  user_profile = TRUE,
  env = rcmd_safe_env(),
  timeout = Inf,
  wd = config[13],
  fail_on_status = TRUE,
  color = FALSE
)

### RDS FILES THAT ARE INFREQUENTLY USED ###

#############################.
# COMBINE WATERSHED DATA ####
#############################.


# All Tributaries
# df_trib_all_exp <- bind_rows(df_trib_quab, df_trib_ware, df_trib_wach)
# df_trib_all <- df_trib_all_exp %>%  select(col_trib_quab_ware)
# saveRDS(df_trib_all, paste0(path,"/df_trib_all.rds"))

##############################################.
# Final Site/Location Information Dataframes #
##############################################.

# All Sites - # Combine All Sites into 1 dataframe (Need to update when Sites are squared away)
### NOTE THIS IS ONLY FOR THE WAVE HOME PAGE MAP _ NOTHING ELSE

# df_all_site <- bind_rows(df_quab_ware_site, df_chem_prof_wach_site, df_wq_wach_site)
# saveRDS(df_all_site, paste0(path,"/df_all_site.rds"))
# files <<- c(files, "df_all_site.rds")
# # # All Tributaries
# df_trib_all_site <- df_all_site %>% filter(LocationType == "Tributary")
# saveRDS(df_trib_all_site, paste0(path,"/df_trib_all_site.rds"))
# files <<- c(files, "df_trib_all_site.rds")
########################################################################.
###                         MANUAL RDS CALLS                        ####
########################################################################.

# user_rds <- function() {
#
#   df_users <- dbReadTable(con_wach_wq, Id(schema = schema, table = "tblEmailAccounts"))
#   saveRDS(df_users, paste0(path,"/df_users.rds"))
#   files <<- c(files, "df_users.rds")
# }
