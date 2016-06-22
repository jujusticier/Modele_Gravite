library(data.table)
library(maps)
library(dplyr)
Ville_monde <- data.table(world.cities)
Ville_monde$rank <- ave(-Ville_monde$pop, Ville_monde$country.etc,FUN=rank)
Ville_monde <- filter(Ville_monde, rank <=5)
x <- list()
for(i in Ville_monde$name){
  x[[i]]<- data.frame(rep(i, times= nrow(Ville_monde)),Ville_monde$name)
  message("...ecrit la ligne ", i)
}
TableVille_monde <- rbindlist(x)
TableVille_monde2 <- distinct(TableVille_monde)
