library(readxl)
library(dplyr)

select_file_old <-tryCatch({
  select_file_old = readRDS("Cache/select_file.rds")
  return(select_file_old)
},error = function(cond) {
  return(NA)
})

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


if (is.na(select_file_old)) {
  saveRDS(select_file,"Cache/select_file.rds")
} else {
  if (select_file_old==select_file){
    message("select file is still the same")
  } else {
    result <- read_excel(select_file)
    write.table(result,file="Output/output_data.csv",
                fileEncoding = "UTF-8",
                quote = T,
                dec = ".",
                sep = ",")
    message("CSV saved in Output")
  }
}


