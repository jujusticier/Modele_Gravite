

#Script pour les donn??es API Banque mondiale 
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



#il reste encore ?? automatiser la liste des URLapi ?? faire boucler sur la base des donnees Profils Pays

################################################################

#Script Eurostat
library(eurostat)
library(dplyr)
test <- get_eurostat("fats_out2_r2", Filters=list(geo="FR"))


##########################################
#Script donnees geo

library(data.table)
library(ggmap)
library(dplyr)
cities<- read.csv2(file.choose())
#pour g??n??rer les couples de villes
x <- list()
for(i in cities$City){
  x[[i]]<- data.frame(rep(i, times= 229),cities$City)
}
#table g??n??r??e
TableVille <- rbindlist(x)
TableVille$rep.i..times...229. <- as.character(TableVille$rep.i..times...229.)
TableVille$cities.City <- as.character(TableVille$cities.City )


#pour la distance entre les villes il va surement falloir utiliser OSRM
x <-list()
for(i in 555:556){
from<- c(TableVille$rep.i..times...229.[i:i])
to <- c(TableVille$cities.City[i:i])
x[[i]]<-mapdist(from,to,output = c("simple"),mode = c("driving"))
message("Traite la ligne",i)
}

tabledistance <- rbindlist(x)
distQueryCheck()


######################### avec Here

https://route.cit.api.here.com/routing/7.2/calculateroute.json?waypoint0=52.5129%2C13.4037&waypoint1=52.5206%2C13.3862&mode=fastest%3Bcar%3Btraffic%3Aenabled&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg&departure=now

#ensuite il faudra merger les villes par pays (fois 2) puis agregate par couple ij
