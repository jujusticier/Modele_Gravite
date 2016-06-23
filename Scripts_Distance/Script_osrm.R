library(data.table)
library(maps)
library(dplyr)
library(osrm)
Ville_monde <- data.table(world.cities)
Ville_monde$rank <- ave(-Ville_monde$pop, Ville_monde$country.etc,FUN=rank)
Ville_monde <- filter(Ville_monde, rank <=5)
x <- list()
for(i in 1:nrow(Ville_monde)){
  x[[i]]<- data.frame(rep(Ville_monde[i,name], times= nrow(Ville_monde)),rep(Ville_monde[i,lat], times= nrow(Ville_monde)),rep(Ville_monde[i,long], times= nrow(Ville_monde)),rep(Ville_monde[i,country.etc], times= nrow(Ville_monde)),Ville_monde$name,Ville_monde$lat,Ville_monde$long,Ville_monde$country.etc)
  message("...ecrit la ligne ", i)
}
TableVille_monde <- rbindlist(x)
TableVille_monde <- distinct(TableVille_monde)
TableVille_monde <- data.frame(TableVille_monde)


################## ne fonctionne pas encore 
z <- list()
for(i in 445:450){
  z[[i-444]] <-osrmRoute(src= TableVille_monde[i,names(select(TableVille_monde,1,2,3))],dst = TableVille_monde[i,names(select(TableVille_monde,5,6,7))],overview = FALSE)
message("travaille la ligne ",i)
  }
