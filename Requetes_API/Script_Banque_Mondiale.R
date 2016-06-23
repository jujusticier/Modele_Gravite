

#Script pour les données API Banque mondiale 
library(jsonlite)
conversion2 <- read.csv2(file=file.choose())
nbpage <- c(requeteAPI[[1]]$pages)
urlAPI <- "http://api.worldbank.org/countries/indicators/SP.POP.TOTL?per_page=100&date=2007:2016&format=json"
requeteAPI <- fromJSON(urlAPI)

list_destinat<- list()
library(data.table)

for(i in 1:nbpage){
  mydata<- fromJSON(paste0(urlAPI,"&page=",i))
  message("... Charge la page ",i,"/",nbpage)
  list_destinat[[i+1]] <- mydata[[2]]
  }
Datacomplete <- rbind.pages(list_destinat)
Datacomplete <- cbind(Datacomplete$country,Datacomplete$value,Datacomplete$decimal,Datacomplete$date)

##### ajouter les iso3
Datacomplete <- merge(x=Datacomplete, y=conversion2, by.x = "id", by.y = "Alpha.2.code", all.x = TRUE)
Datacomplete <- Datacomplete[!is.na(Datacomplete$Alpha.3.code),]
write.csv(x=Datacomplete, file="F:/POP.csv")



#il reste encore à automatiser la liste des URLapi ?? faire boucler sur la base des donnees Profils Pays
