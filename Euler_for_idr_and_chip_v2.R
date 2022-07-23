#load required libraries
library(tidyverse)
library(eulerr)

df <- data.frame (items  = c(
  "0001", "0010", "0011", "0100", "0110",
  "1000", "1001", "1010", "1011", "1100",
  "1101", "1110", "1111"),
  value = c("0", "0", "0", "0", "0",
            "0", "0", "0", "0", "0",
            "0", "0", "0")
)

#create a function
make_plot <- function(Peak_txt_file) {
  
  file_name <- Peak_txt_file
  
  my_file_temp <- read.table(file_name, header = TRUE)
  
  my_file_temp[c('First', 'Last')] <-  str_split_fixed(my_file_temp$file, pattern = '_',2)
  
  my_file <- full_join(df, my_file_temp, by=c("items"= "First")) %>% 
    replace(is.na(.), 0) %>% 
    select(file, overlap)
  
  #write.table(my_file,file = paste0(file_name,"finalOverlap.txt"), sep="\t", row.names=FALSE)
  
  my_file <- my_file %>%
    select(2)
  
  #write.table(my_file,file = paste0(file_name,"finalOverlapOneColumn.txt"), sep="\t", row.names=FALSE)
  
  Upreg <- euler(c("top"= my_file$overlap[1],
                 "mid" = my_file$overlap[2],
                 "bottom" = my_file$overlap[4],
                 "atac" = my_file$overlap[6],
                 "atac&top" = my_file$overlap[7],
                 "atac&mid" = my_file$overlap[8],
                 "atac&bottom" = my_file$overlap[10]),
               shape = "ellipse")
  
  filename = paste0(file_name,".jpg")
  
  print(filename)
  
  #Open jpeg file
  jpeg(filename=filename, width = 600, height = 600)
  
  the_plot <- plot(Upreg,
                   main = "filename",
                   labels = list(fontfamily = "Arial", fontsize=15),
                   fill=c("#FCD1B8", "#53D2CE", "#C8A2C8"), numbers=TRUE,
                   fontsize = 8,
                   quantities = list(fontfamily = "Arial", fontsize=15, type = c("counts","percent")),
                   #legend = list(side = "right"),
                   lwd = 1.5)
  print(the_plot)
  
  dev.off()
}

#get list of overlap.txt files
myFiles <- list.files(pattern = ".txt") 

#apply function over the list of files
lapply(myFiles, make_plot)

