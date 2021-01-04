#paste in a REDCap data set from Excel and convert long to wide write back out to clipboard

library(tidyr) #for pivot functions
library(dplyr) #for mutate_all

#read in the clipboard data
rdata <- read.delim("clipboard")
rdata <- rdata %>% mutate_all(as.character)

x <- colnames(rdata[,3:ncol(rdata)])

#reshape
#first convert the data to standard long with key value pairs
rdata_long <- pivot_longer(rdata, cols = x, names_to = "key", values_to = "values")

#concatenate redcap event name and variable name
rdata_long$event.variable <- paste(rdata_long$redcap_event_name,".",rdata_long$key)

#reorder columns
rdata_wide <- rdata_long[,c(1,5,4)]

#convert long to wide
rdata_wide <- pivot_wider(rdata_wide, names_from = "event.variable", values_from = "values")

#write to clipboard
write.table(rdata_wide, "clipboard", sep="\t", row.names=FALSE)

