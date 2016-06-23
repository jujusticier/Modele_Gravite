#Contient le code d'une boucle qui permet de trouver la distance des couples des 5 plus grandes villes des pays européens par l'API de google. La limite étant qu'on ne peut lancer que 2500 couples par jour. 
#Voir Distance_OSRM.R pour la suite.
library(data.table)
library(ggmap)
library(dplyr)
library(maps)
#source les nom des villes (anglais)
Ville_monde <- data.table(world.cities)
# filtre les pays européens 
Eu <- rbind("Belgium","Bulgaria","Czech Republic","Denmark","Germany","Estonia","Hungary","Greece","Spain","France","Croatia","Italy","Cyprus","Latvia","Lithuania","Luxembourg","Malta","Netherlands","Austria","Poland","Portugal","Romania","Slovenia","Slovakia","Finland","Sweden","UK","Norway")
Eu<-data.frame(Eu) 
Ville_europe <- merge(x= Ville_monde, y=Eu, by.x="country.etc",by.y="Eu", all= FALSE)

#donne un rang et garde les 5 premières (pour capter les petits pays)
Ville_europe$rank <- ave(-Ville_europe$pop, Ville_europe$country.etc,FUN=rank)
Ville_europe <- filter(Ville_europe, rank <=5)

#pour generer les couples de villes
x <- list()
for(i in Ville_europe$name){
  x[[i]]<- data.frame(rep(i, times= nrow(Ville_europe)),Ville_europe$name)
  message("...ecrit la ligne", i)
}
TableVille_Europe <- rbindlist(x)

#pour cleaner on supprime les objets inutiles
rm(x,i,Eu)

#on renomme et supprime les variables inutiles
TableVille_Europe <- rename(TableVille_Europe, From = rep.i..times...nrow.Ville_europe.., To = Ville_europe.name)
TableVille_Europe$To <- as.character(TableVille_Europe$To)
TableVille_Europe$From <- as.character(TableVille_Europe$From)


#on ajoute les pays pour les origines / destinations
Table_Ville.Pays <- data.frame(Ville_europe$country.etc,Ville_europe$name, stringsAsFactors = FALSE)
rm(Ville_europe,Ville_monde)

##### Utilisation de l'API Google######
# les donnees sont déja en bon format

x <-list()
for(i in 1:2499){
  from<- c(TableVille_Europe$From[i])
  to <- c(TableVille_Europe$To[i])
  x[[i]]<-mapdist(from,to,output = c("simple"),mode = c("driving"), messaging= FALSE)
  message("Traite la ligne",i)
}
Tabledistance <- rbindlist(x, fill=TRUE)
distQueryCheck()

Tabledistance <- merge(x=Tabledistance,y=Table_Ville.Pays, by.x="to",by.y="Ville_europe.name",all = FALSE)
Tabledistance <- rename(Tabledistance, Country.to = Ville_europe.country.etc)
Tabledistance <- merge(x=Tabledistance,y=Table_Ville.Pays, by.x="from",by.y="Ville_europe.name",all = FALSE)
Tabledistance <- rename(Tabledistance, Country.from = Ville_europe.country.etc)

#écrire un nouveau CSV par jour
write.csv(Tabledistance,file=paste0(getwd(),"/Dist1.csv"))



####boucle pour lire les csv#####

#on nettoie l'espace de travail
#ensuite il faudra moyenner par couple de pays et sortir avec une table de couple pays distance
#AhGCyLgs4kFp3JlLL2koinDWMHdQI1xNRLTVDGatqoxBFkqN8CuJ0S_5UeYo7Ur8
