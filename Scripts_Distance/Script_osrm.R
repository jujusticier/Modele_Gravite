library(data.table)
library(maps)
library(dplyr)
#### script final OSRM

library(osrm)
Ville_monde <- data.table(world.cities)
Ville_monde$rank <- ave(-Ville_monde$pop, Ville_monde$country.etc,FUN=rank)
Ville_monde <- filter(Ville_monde, rank<=5)

### on crée une grande table de couple
x <- list()
for(i in 1:nrow(Ville_monde)){
  x[[i]]<- data.frame(rep(Ville_monde$name[i], times= nrow(Ville_monde)),
                      rep(Ville_monde$lat[i],times= nrow(Ville_monde)),
                      rep(Ville_monde$long[i],times= nrow(Ville_monde)),
                      rep(Ville_monde$country.etc[i], times=nrow(Ville_monde)),
                      Ville_monde$name,
                      Ville_monde$long,
                      Ville_monde$lat,
                      Ville_monde$country.etc)
  message("...ecrit la ligne ", i)
}
Table_Ville_Monde <- rbindlist(x)
Table_Ville_Monde<- distinct(Table_Ville_Monde)

###### cleanons la table pour s'y retrouver
Table_Ville_Monde <- rename(Table_Ville_Monde, From=rep.Ville_monde.name.i...times...nrow.Ville_monde..,
                            lat.from = rep.Ville_monde.lat.i...times...nrow.Ville_monde..,
                            long.from=rep.Ville_monde.long.i...times...nrow.Ville_monde..,
                            to =Ville_monde.name,
                            long.to = Ville_monde.long,
                            lat.to = Ville_monde.lat,
                            country.from=rep.Ville_monde.country.etc.i...times...nrow.Ville_monde..,
                            country.to=Ville_monde.country.etc)

Table_Ville_Monde$country.from <- as.character(Table_Ville_Monde$country.from)
Table_Ville_Monde$country.to <- as.character(Table_Ville_Monde$country.to)
Table_Ville_Monde$From <- as.character(Table_Ville_Monde$From)
Table_Ville_Monde$to <- as.character(Table_Ville_Monde$to)


#sans correction d'erreur : NE PAS UTILISER 
#Distance <- data.frame(matrix(ncol = 2, nrow = 1))
#for(i in 1:5){
#  Distance[i,] <- rbind(osrmRoute(src=c(Table_Ville_Monde$From[i],Table_Ville_Monde$long.from[i], Table_Ville_Monde$lat.from[i]),
#                                         dst=c(Table_Ville_Monde$to[i], Table_Ville_Monde$long.to[i], Table_Ville_Monde$lat.to[i]),
#                                         overview = FALSE))
#  message("Traite la ligne ", i)
#}


## Avec correction

Distance <- data.frame(matrix(ncol = 6, nrow = 1))
for(i in 1:6){
  if (class(osrmRoute(src=c(Table_Ville_Monde$From[i], Table_Ville_Monde$long.from[i], Table_Ville_Monde$lat.from[i]),
                      dst = c(Table_Ville_Monde$to[i], Table_Ville_Monde$long.to[i], Table_Ville_Monde$lat.to[i]),
                      overview = FALSE))!="NULL"){
    Distance[i,1:2] <-rbind(osrmRoute(src=c(Table_Ville_Monde$From[i],Table_Ville_Monde$long.from[i], Table_Ville_Monde$lat.from[i]),
                                   dst=c(Table_Ville_Monde$to[i], Table_Ville_Monde$long.to[i], Table_Ville_Monde$lat.to[i]),
                                   overview = FALSE))
  }else{
    Distance[i,1:2] <- rbind(NA,NA)
  }
 Distance[i,3]<- Table_Ville_Monde$From[i]
 Distance[i,4]<- Table_Ville_Monde$country.from[i]
 Distance[i,5]<- Table_Ville_Monde$to[i]
 Distance[i,6]<- Table_Ville_Monde$country.to[i]
  message("Traite la ligne ", i)
}

#renommer les colonnes

