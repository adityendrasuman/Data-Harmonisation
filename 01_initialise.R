# cleanup the environment ----
rm(list = ls())
if (!is.null(dev.list())) dev.off()
cat("\014")
start_time <- Sys.time()

# capture variable coming from vba ----
args <- commandArgs(trailingOnly=T)

# set working director ---- 
setwd(do.call(file.path, as.list(strsplit(tail(args, 2)[1], "\\|")[[1]])))

# load custom functions ----
source(do.call(file.path, as.list(strsplit(paste0(tail(args, 3)[1], "00_functions.R"), "\\|")[[1]])), 
       print.eval = TRUE, echo = F)

# load libraries ----
error = f_libraries(
  necessary.std = c("dplyr", "forcats", "gdata", "glue", "ggplot2", "gridExtra", 
                    "jsonlite", "openxlsx", "purrr", "profvis", "rlang", "srvyr", 
                    "stringr", "stats", "scales", "tidyselect", "tibble", "utils", 
                    "tidyr", "caret", "janitor", "e1071", "rpart", "rpart.plot"),
  necessary.github = c()
)

# global variables ----
g_excel_backend_temp_nospace_dir_rf <- do.call(file.path, as.list(strsplit(args[2], "\\|")[[1]]))
g_excel_backend_dir                 <- do.call(file.path, as.list(strsplit(args[4], "\\|")[[1]]))
g_file_name                         <- args[5]

g_file_path                         <- file.path(g_excel_frontend_dir, g_file_name)
g_wd                                <- g_excel_backend_temp_dir
g_file_log                          <- file.path(g_excel_frontend_dir, "Latest R logs.txt")

# Log of run ----
glue::glue("===================== Running '01_initialise.R' =====================") %>% f_log_string(g_file_log) 
glue::glue("RUNNING R SERVER ...") %>% print()
glue::glue("Package status: {error}") %>% print()
glue::glue("\n") %>% print()

#====================================================

unlink(g_file_log)

#====================================================

# Log of run ----
glue::glue("{str}")%>% f_log_string(g_file_log)
glue::glue("\n") %>% f_log_string(g_file_log)
glue::glue("finished run in {round(Sys.time() - start_time, 0)} secs. Saving the environment!") %>% f_log_string(g_file_log)
glue::glue("\n\n") %>% f_log_string(g_file_log)

# remove unnecessary variables from environment ----
rm(list = setdiff(ls(), ls(pattern = "^(d_|g_|f_)")))

# save environment in a session temp variable ----
save.image(file=file.path(g_wd, "env.RData"))

# Close the R code ----
print(glue::glue("\n\nAll done!"))
for(i in 1:3){
  print(glue::glue("Finishing in: {4 - i} sec"))
  Sys.sleep(1)
}