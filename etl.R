library(readxl)
library(dplyr)

get_cache_file <- function(){
  tryCatch({
    select_file_old = readRDS("Cache/select_file.rds")
    return(select_file_old)
  },error = function(cond) {
    return(NA)
  })
}

select_file_old <- get_cache_file()

path = "Input/"

files <- list.files(path = path,pattern = "*.xlsx")

info_list <- lapply(files,function(x){
  info <- file.info(paste0(path,files[1]))
  return(info)
})

select_file <- info_list %>% 
  bind_rows() %>% 
  filter(ctime==min(ctime)) %>% 
  mutate(file = rownames(.)) %>% 
  pull(file)

dir.create(file.path("Cache/"), showWarnings = FALSE)
dir.create(file.path("Output/"), showWarnings = FALSE)



if (is.na(select_file_old)) {
  saveRDS(select_file,"Cache/select_file.rds")
  result <- read_excel(select_file)
  write.table(result,file="Output/output_data.csv",
              fileEncoding = "UTF-8",
              quote = T,
              dec = ".",
              sep = ",",
              row.names = F)
  message("CSV saved in Output")
} else {
  if (select_file_old==select_file){
    message("select file is still the same")
  } else {
    result <- read_excel(select_file)
    write.table(result,file="Output/output_data.csv",
                fileEncoding = "UTF-8",
                quote = T,
                dec = ".",
                sep = ",",
                row.names = F)
    message("CSV saved in Output")
  }
}


