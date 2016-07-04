---
title: "Equation de Gravité"
author: "Axxxxxxn"
date: "30 mai 2016"
output: 
  html_document: 
    theme: cosmo
    toc: yes
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
#  TO DO LIST
- Harmoniser et finaliser la liste de variable à intégrer dans les modèles
- Ajouter indicatrice EU et Schengen
- Finir de mettre à jour la base de donnes
- verifier les unités des variables
- Voir colonne 18 bizarre


# Introduction
Ce document de travail a pour objet de présenter l'avancement des recherches du bureau Macro 3 quant à la mise à jour d'un modèle de gravité des échanges internationaux. Il est rédigé de façon à permettre la reproductibilité complète des analyses

Le modèle doit permettre de: 
- Travailler sur des potentiels de commerce 
- Simuler l'impact de l'ajout ou du retrait de certaines variables, telle que l'appartenance à une ALE, sur ces potentiels de commerce
- Autres utilisations ? 

Nous construirons deux modèles : 
1. Modèle mondial : avec des données couvrant la periode 1967-2014 et une spécification classique.Dans un souci de simplicité nous estimerons ce modèle avec des données pré-traitées issues du travail du CEPII (base Gravity et Chelem).

2. Modèle européen: avec des données couvrant la période 1967-2014, une variable de distance routière et une spécification adaptée à l'UE.



# 1. Revue de littérature 
D'abord développée, dans sa forme la plus simple par Tinbergen (1962) et Linnemann (1966), l'équation de gravité fait dépendre les flux bilatéraux de commerce de forces d'attraction et de résistance.Sa robustesse (reconnue par la littérature (Mayer 2001)) en fait un outil privilégié de l'analyse des échanges internationaux de biens et de services (Kimura et Lee 2006).

Il existe deux branches pour la spécification des modèles de gravité : 
- Les modèles intuitifs ou naifs
- Les modèles théoriquement fondés (Anderson et Wincoop 2003)

## 1.1. Le modèle de gravité intuitif
## 1.2. Les modèles de gravité théoriques

Deardoff (??) reprend l'hypothèse d'Armington sur la différenciation des produits selon leur provenance
le produit des revenus (Y) des deux partenaires i et j divisés par la distance 

(1) $$ X_{ij} = \alpha \frac{Y^{\beta_{1}}_{i} Y^{\beta_{2}}_{i}}{D^{\beta_{3}}_{ij}}$$




Avec $\alpha, \beta_1, \beta_2 et \beta_3$ comme paramètres à estimer. L’équation sous une forme log-linéraire afin d’interpréter les coefficients comme des élasticités de flux de commerce (2)

$$ Ln(X_ijt )=α+β_1 〖lna(PIB〗_it)+β_2 lna(〖PIB〗_jt)+β_3 lna(〖PIBcap〗_it)+β_4 lna(〖PIBcap〗_jt)+β_5 lna(〖Dist〗_ij)〖+β〗_6 〖Front〗_ij+β_7 〖Lang〗_ij+β_8 〖ALE〗_ijt+ε_ijt$$

(McCallum (1995), Anderson Wincoop (2006))

(2)


On oppose l'approche naive de l'équation gravité à son approche fondée théoriquement.

# 2. Source des données et description des variables
###	2.1. Echanges bilatéraux
Pour les échanges bilatéraux, la base de données CHELEM fournit des données harmonisées (importations/exportations). Cependant  on utilise uniquement des données d'exportations donc l'harmonisation est secondaire, nous avons procédé à une analyse de la sensibilité du modèle aux différentes sources de données disponibles (harmonisées / non harmonisées). 
Quid  d'une hypothése de sensibilité de sectorielle des exportations é la gravité é Certains produits seraient plus sensibles é la distance que d'autres. Il faut des données sectorielles pour le savoir. 


### 2.2 Données de gravité
Par défaut les données de gravitéproviennent de la base du CEPII.

# 3.Description des variables explicatives
## 3.1 Variables intégrées aux modèles
###	3.1.1 PIB
Le poids d'une économie dans le commerce mondial est plus ou moins proportionnel é son PNB. Ainsi l'intensité bilatérale est proportieonelle au produit de leurs PNB 
Estimation de l'importance du commerce intrabranche. 
La valeur absolue de la différence de PIB par habitant afin de tester les différences de dotation factorielle . Un coefficient positif signifierait la prédominance du commerce traditionnel (interbranche). Un signe négatif irait dans le sens de la thése de Linder (1961) qui place le rapprochement des revenus par habitant comme l'un des déterminants de l'échange intra-branche (J. Frankel, 1997). Variable utilisée par B. Baltagi et alii (2003) et L. De Benedictis et alii (2005) : 

Le coefficient des PIB devrait etre positif, la taille de l'économie serait corrélé positivement aux échanges.  

Nous utilisons la base de la banque mondiale WDI

### 3.1.2 Population 
Nous utilisons la base de la banque mondiale WDI pour la population. Le signe attendu est positif, plus le pays est grand plus il aura tendance à participer au commerce.

### 3.1.3 Distances
La variable de distance est exclusivement un proxy des couts de transport. On attend un coefficient négatif.  
#### 3.1.3.1 Distance géodésique

La variable de distance est classiquement une distance géodésique c'est à dire à vol d'oiseau. Elle est construite en général comme la distance moyenne des plus grandes villes d'un pays avec celles de ces partenaires. Cette méthodologie est largement utilisée dans la littérature. Nous utilisons pour le modèle 1 la base de données CEPII Gravité. 

#### 3.1.3.2 Distance routière - Dans le cas de l'Union Européenne

Pour compléter on peut se rapprocher d'une définition logistique des échanges, en utilisant la distance routiére. Nous avons récupérer les 5 plus grandes villes des 28 pays européens, puis réalisé une moyenne simple des distances entre ces villes. Cette variante a pour objectif de raffiner la variable de distance pour les pays européens où 70% à 75% des échanges commerciaux sont transportés par la route.

Dans les prochaines versions il s'agira de prendre en compte les principaux centres logistiques et non les grandes villes. De plus, cet indicateur pourrait etre transposé au niveau mondial en pondérant par pays la distance par mode de transport. 

Ci dessous la réparatition des échanges dans l'UE par mode de transport

```{r warning=FALSE, message=FALSE, echo=FALSE,eval=FALSE}
library(dplyr)
library(ggplot2)
library(data.table)
library(plotly)

mod_transport <- read.csv(file = paste0(getwd(),"/data-12957078.csv"),sep = ",", dec = ".")

europe <- read.csv(file = paste0(getwd(),"/EuropeanCountries.csv"),sep = ";", dec = ",", header = FALSE)

testmerge <- merge(x=mod_transport, y=europe, by.x=c("PARTNER_LAB"), by.y=c("V1"), all= FALSE)
MTeurope <- filter(testmerge, V2 == 1)
MTeurope <- data.table(MTeurope)
MTeurope <- setkey(MTeurope, value=TRANSPORT_MODE_LAB)
Graph_Transport  <- ggplot(MTeurope, aes(y=INDICATOR_VALUE, x=PERIOD_LAB, fill=TRANSPORT_MODE_LAB)) +geom_bar(stat="identity", position="fill")

ggplotly(Graph_Transport)
```

#### 3.1.3.2 Distance logistique 
On peut raffiner la distance entre les pays

#### 3.1.3.3 Pondération de la distance : Remoteness 
Il faut introduire une variable de distance relative (Deardoff 1998, Baldwin et Taglioni 2006) sur le modelé de Wei 1996, on appellera cette variable REMOT pour remotness (typiquement l'australie et la Nouvelle-Zélande commerce plus en entre eux car sont isolés). On choisit cette option car elle semble compatible é la fois avec les distances routiéres et les distance géodésiques: 


Pour l'intégrer en tant que variable on peut retenir le log de la moyenne des distances entre i et tous les j [donc une valeur de remoteness pour chaque pays ]. 

### 3.1.4 Frontière commune
L'indicatrice de frontière commune (Contig) permet d'identifier les pays ayant au moins une frontière terrestre commune. Les données proviennent de la base CEPII. 
On attend un signe positif.

### 3.1.5 Origine légale commune
L'indicatrice d'origine légale commune provient d'Andrei Shleifer (http://post.economics.harvard.edu/faculty/shleifer/Data/qgov_web.xls). Elle approche les couts de transaction. Le signe attendu est positif

### 3.1.6 Accord commercial régional 
L'indicatrice d'accord de libre échange (RTA) provient de la base de donnees gravité CEPII. Le signe attendu est positif


## 3.2 Autres variables indicatrices à intégrer

### 3.2.1 Appartenance à l'espace Schengen
L'indicatrice Schengen permet d'apprcier l'effet de l'espace Schengen sur les échanges entre pays européens. 

### 3.2.2 Nombre de frontiéres Schengen à traverser


### 3.2.3 Langue commune officielle / ethnique
Variable est une construction fusionnant les indicatrices utilisées par le CEPII de langue commune officielle et ethnique. Elle a pour objet d'indiquer si les partenaires ont une langue commune. Nous attendons un coefficient positif dans la mesure où la langue commune devrait réduire les coûts de transaction. 

### 3.2.4Immigration
L'idée sous-jacente est de lier les échanges commerciaux aux réseaux personnels des immigrés installés dans le pays. [INDICATRICE à trouver]

### 3.2.5 Variable prenant en compte l'hétérogénéité des pays
[INDICATRICE à trouver]
### 3.2.6 Taux de change réel
[INDICATRICE à trouver]

### 3.2.7 Barrières tarifaires et non tarifaires
Il s'agira de tester l'impact des barrières non tarifaires. On pourrait également ajouter une variable numérique avec le taux de droit de douane bilatéral moyen. 
#### Enclavement
La variable d'enclavement indique si le pays exportateur a une frontiére maritime ou non. Cette variable a pour objet de raffiner la distance comme proxy des couts de transport.  Compte tenu de l'importance du commerce international par voie maritime on suppose que l'enclavement a pour effet une augmentation des couts de transports. 
Source ?
On a attend donc un coefficient négatif. 

#### Colonies
Malgré la qualité du travail de Head sur le sujet, nous ne reprenons pas ici les indicatrices sur les colonies


## Synthése des variables
L'objectif du modéle est de sélectionner des variables afin d'obtenir un modéle cour et pouvoir y ajouter des variables indicatrice permettant de mesurer l'impact de certains faits économiques sur le commerce é long terme. 

#4. Gestion des données

Dans un premier temps nous traiterons les données gravite du CEPII et commerce de la base Chelem (CEPII). Afin d'avoir un socle de données é augmenter par la suite.


```{r results="hide", warning=FALSE,message=FALSE, tidy=TRUE}
##on charge les bons packages et on augmente la mémoire disponible
library(data.table)
library(dplyr)
library(plm)
library(stargazer)
memory.limit(20000)
```

```{r, message=FALSE, warning=FALSE, tidy=TRUE}
##on charge les donnees trade directement en data.table
Donnees_Commerce<- fread(input=paste0(getwd(),"/Chelem.csv"),data.table= TRUE, verbose = FALSE, stringsAsFactors = TRUE )

##Renomer la variable t pour la transformer en year
Donnees_Commerce <- rename(Donnees_Commerce, year=t)

## on réduit la base donnees commerce avec uniquement les totaux
Donnees_Commerce <- filter(Donnees_Commerce, k == "TT")
```


```{r,message=FALSE, warning=FALSE, tidy=TRUE}
##on charge les donnees gravité directement en data.table
Donnees_Gravite <- fread(input=paste0(getwd(),"/gravdata_cepii.csv"),data.table= TRUE,verbose = FALSE)

## Reduit les donnees de gravité é 1967, car nous n'avons pas de données commerce avant cette date
Donnees_Gravite <- filter(Donnees_Gravite, year > 1966)

##renomer les variables origine et destination 
Donnees_Gravite <- rename(Donnees_Gravite, i = iso3_o)
Donnees_Gravite <- rename(Donnees_Gravite, j=iso3_d)


##on passe les indicatrices en facteur
Donnees_Gravite$rta <- ifelse(is.na(Donnees_Gravite$rta),"0", Donnees_Gravite$rta)
Donnees_Gravite$rta <- as.factor(Donnees_Gravite$rta)
Donnees_Gravite$contig <- as.factor(Donnees_Gravite$contig)
Donnees_Gravite$comleg <- as.factor(Donnees_Gravite$comleg)
Donnees_Gravite$gatt_o<- as.factor(Donnees_Gravite$gatt_o)
Donnees_Gravite$gatt_d <- as.factor(Donnees_Gravite$gatt_d)
Donnees_Gravite$comcur <- as.factor(Donnees_Gravite$comcur)
Donnees_Gravite$acp_to_eu <- as.factor(Donnees_Gravite$acp_to_eu)
Donnees_Gravite$eu_to_acp <- as.factor(Donnees_Gravite$eu_to_acp)
Donnees_Gravite$commlang <- ifelse((Donnees_Gravite$comlang_off|Donnees_Gravite$comlang_ethno) == 1,1,0)
Donnees_Gravite$commlang <- as.factor(Donnees_Gravite$commlang)


##On peut d'ore et déjà alléger la base
Donnees_Gravite$indepdate <- NULL
Donnees_Gravite$leg_o <- NULL
Donnees_Gravite$leg_d <- NULL
Donnees_Gravite$area_o <- NULL
Donnees_Gravite$area_d<- NULL
Donnees_Gravite$empire <- NULL
Donnees_Gravite$V1 <- NULL
Donnees_Gravite$iso2_o<- NULL
Donnees_Gravite$iso2_d<- NULL
Donnees_Gravite$conflict <- NULL
Donnees_Gravite$col45<- NULL
Donnees_Gravite$col_to<- NULL
Donnees_Gravite$col_fr<- NULL
Donnees_Gravite$colony<- NULL
Donnees_Gravite$tdiff <- NULL
Donnees_Gravite$comcol<- NULL
Donnees_Gravite$curcol<- NULL
Donnees_Gravite$heg_d<- NULL
Donnees_Gravite$heg_o<- NULL
Donnees_Gravite$comlang_off <- NULL
Donnees_Gravite$comlang_ethno<- NULL
Donnees_Gravite$acp_to_eu<- NULL
Donnees_Gravite$eu_to_acp <- NULL

## Pour l'instant impossible d'utiliser GATT
Donnees_Gravite$gatt_o <- NULL
Donnees_Gravite$gatt_d <- NULL
```

```{r include=FALSE, warning=FALSE}
gc()
```


```{r, tidy=TRUE}
##Créer une une variable couple de pays/annees dans les deux bases (CPA) et une variable couple pays
Donnees_Commerce$CPA <- paste(Donnees_Commerce$i, Donnees_Commerce$j,Donnees_Commerce$year)
Donnees_Gravite$CPA <- paste(Donnees_Gravite$i, Donnees_Gravite$j,Donnees_Gravite$year)
Donnees_Gravite$ij <- paste(Donnees_Gravite$i,Donnees_Gravite$j)
Donnees_Commerce$ij<- paste(Donnees_Commerce$i,Donnees_Commerce$j)


```

```{r include=FALSE}
gc()
```

Mise à jour des données avec GDP et PIB
```{r, tidy=TRUE}
library(dplyr)
##### Donnees PIB et Population du WDI
PIB07 <- read.csv(file = paste0(getwd(),"/PIB.csv"))
PIB07 <- rename(PIB07, i = Alpha.3.code,year = Datacomplete.date)
PIB07$iy <- paste(PIB07$i,PIB07$year)

POP07 <-read.csv(file = paste0(getwd(),"/POP.csv"))
POP07 <- rename(POP07, i = Alpha.3.code,year = Datacomplete.date)
POP07$iy <- paste(POP07$i,POP07$year)


######################## il va falloir construire la meme base et rbind à la fin

##on crée la base de données
MAJ <- data.frame(rep(as.character(PIB07$i), each=9*211), rep(as.character(PIB07$i),times=9*211),rep(PIB07$year,times=9*211), rep(PIB07$Datacomplete.value, times=9*211),rep(PIB07$Datacomplete.value, times=9*211), rep(POP07$Datacomplete.value, times=9*211))

##on crée une colonne commune on aurait pu renommer ici aussi
MAJ$iy <- paste(MAJ$rep.as.character.PIB07.i...each...9...211.,MAJ$rep.PIB07.year..times...9...211.)

#mettons les données à la meme unité
PIB07[,4]<- PIB07[,4]/(10^6)
POP07[,4]<- POP07[,4]/(10^6)


##on fusionne avec dplyr
MAJ<- merge(MAJ,select(PIB07,4,8),by="iy",all.x = TRUE)
MAJ<- merge(MAJ,select(POP07,4,8),by="iy", all.x=TRUE)

##on renomme pour faciliter la fusion 
MAJ<- rename(MAJ,i = rep.as.character.PIB07.i...each...9...211., j = rep.as.character.PIB07.i...times...9...211., year = rep.PIB07.year..times...9...211., gdp_o = Datacomplete.value.x, gdp_d = rep.PIB07.Datacomplete.value..times...9...211., pop_o = Datacomplete.value.y, pop_d = rep.POP07.Datacomplete.value..times...9...211.)

##creons colonne commune pour fusion et supprimons les colonnes inutiles
MAJ$ij <- paste(MAJ$i, MAJ$j)
MAJ$CPA <- paste(MAJ$i,MAJ$j,MAJ$year)
MAJ$iy <- NULL
MAJ$jy <- NULL

##supprimons les annees inutiles
MAJ<- filter(MAJ, year <2015)

## il faudra utiliser un subset sur 2006 pour limiter les risques de doublons à partir de donnees grav

Donnees_Gravite06 <- filter(Donnees_Gravite, year == 2006)

##créons les variables manquantes
MAJ$gdpcap_o <- MAJ$gdp_o/MAJ$pop_o
MAJ$gdpcap_d <- MAJ$gdp_d/MAJ$pop_d
MAJ <- merge(MAJ,select(Donnees_Gravite06,4,5,12,13,14,15,17), by="ij", all.x = TRUE)###merge par couple pays

##### On supprime les doublons
MAJ <- distinct(MAJ)
```

```{r}

#supprimons les données PIB et POP
rm(PIB07,POP07,Donnees_Gravite06)
```


Finalement créer la table avec les donnees de gravite et de commerce

```{r , tidy=TRUE}
#Donnees_Gravite$CPA <- paste(Donnees_Gravite$i, Donnees_Gravite$j,Donnees_Gravite$year)
Table_Gravite <- bind_rows(Donnees_Gravite,MAJ)
Table_Gravite <- merge(x=Table_Gravite,y=select(Donnees_Commerce,7,8), by= c("CPA") ,all= FALSE)
```

Création de la dummy EU
```{r}
#il va falloir faire ce type de code 
Table_Gravite$EUi<- ifelse(Table_Gravite$year>1957 & (Table_Gravite$i == "FRA"|Table_Gravite$i == "DEU"|Table_Gravite$i == "BEL"|Table_Gravite$i == "ITA"|Table_Gravite$i =="LUX"|Table_Gravite$i =="NLD")|Table_Gravite$year>1995 &(Table_Gravite$i=="AUT"|Table_Gravite$i =="FIN"|Table_Gravite$i =="SWE")|Table_Gravite$year>2007&(Table_Gravite$i=="BGR"|Table_Gravite$i=="ROU")|Table_Gravite$year>2004&(Table_Gravite$i=="CYP"|Table_Gravite$i=="EST"|Table_Gravite$i=="HUN"|Table_Gravite$i=="LVA"|Table_Gravite$i=="LTU"|Table_Gravite$i=="MLT"|Table_Gravite$i=="POL"|Table_Gravite$i=="CZE"|Table_Gravite$i=="SVK"|Table_Gravite$i=="SVN")|Table_Gravite$year>2013&(Table_Gravite$i=="HRV")|Table_Gravite$year>1986&(Table_Gravite$i=="ESP"|Table_Gravite$i=="PRT")|Table_Gravite$year>1981&(Table_Gravite$i=="GRC")|Table_Gravite$year>1973&(Table_Gravite$i=="GBR"|Table_Gravite$i=="IRL"|Table_Gravite$i=="DNK"),1,0)

Table_Gravite$EUj<- ifelse(Table_Gravite$year>1957 & (Table_Gravite$j == "FRA"|Table_Gravite$j == "DEU"|Table_Gravite$j == "BEL"|Table_Gravite$j == "ITA"|Table_Gravite$j =="LUX"|Table_Gravite$j =="NLD")|Table_Gravite$year>1995 &(Table_Gravite$j=="AUT"|Table_Gravite$j =="FIN"|Table_Gravite$j =="SWE")|Table_Gravite$year>2007&(Table_Gravite$j=="BGR"|Table_Gravite$j=="ROU")|Table_Gravite$year>2004&(Table_Gravite$j=="CYP"|Table_Gravite$j=="EST"|Table_Gravite$j=="HUN"|Table_Gravite$j=="LVA"|Table_Gravite$j=="LTU"|Table_Gravite$j=="MLT"|Table_Gravite$j=="POL"|Table_Gravite$j=="CZE"|Table_Gravite$j=="SVK"|Table_Gravite$j=="SVN")|Table_Gravite$year>2013&(Table_Gravite$j=="HRV")|Table_Gravite$year>1986&(Table_Gravite$j=="ESP"|Table_Gravite$j=="PRT")|Table_Gravite$year>1981&(Table_Gravite$j=="GRC")|Table_Gravite$year>1973&(Table_Gravite$j=="GBR"|Table_Gravite$j=="IRL"|Table_Gravite$j=="DNK"),1,0)

Table_Gravite$EU<- ifelse(Table_Gravite$EUi == 1 & Table_Gravite$EUj==1,1,0)
Table_Gravite$EU<- as.factor(Table_Gravite$EU)
Table_Gravite$EUi<- NULL
Table_Gravite$EUj<-NULL
```


On peut donc supprimer les autres données inutiles afin de libérer de la mémoire avant de faire tourner les modèles

```{r warning=FALSE, tidy=TRUE}
rm(Donnees_Gravite,Donnees_Commerce,MAJ, Donnees_Gravite06)

```

```{r, tidy=TRUE }
#On peut prendre les données sur 20 ans
Table_Gravite96_06 <- filter(Table_Gravite, year > 1995)
```

```{r include=FALSE}
gc()
```

```{r}
head(Table_Gravite)
```




#Modéles de regression
## Sur l'ensemble des donnéees 
La régression sur l'ensemble des données permet de voir si le modéle général fonctionne 
```{r tidy=TRUE}
#MCO classique
RegMCO <- lm(log(v) ~ log(gdp_o)+log(gdp_d)+log(distw)+log(pop_o)+log(pop_d)+contig+comcur+commlang+gatt_o+gatt_d+rta, data= Table_Gravite , na.action = na.omit)

#Equation de gravite en panel
RegPanelTime <- plm(log(v) ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d+rta, data=Table_Gravite, index= c("ij","year"), model = c("within"), effect=c("time"), na.action= na.omit)

RegPanelCountry <- plm(log(v) ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d+rta, data=Table_Gravite, index= c("ij","year"), model = c("within"), effect=c("individual"), na.action= na.omit)

#En MCO classique on retrouve bien les memes coefs
RegPanel_pool <- plm(log(v) ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d+rta, data=Table_Gravite, index= c("ij","year"), model = c("pooling"),na.action= na.omit)

#glm poisson
RegPoiss <- glm(v ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d+rta, data=Table_Gravite, na.action = na.omit, family = quasipoisson(link="log"))
```

Idem sur 20 ans 
```{r cache=TRUE, tidy=TRUE}
#MCO classique
RegMCO96 <- lm(log(v) ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d+rta, data= Table_Gravite96_06 , na.action = na.omit)

#Equation de gravite en panel
RegPanelTime96bis <- plm(log(v) ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d, data=Table_Gravite96_06, index= c("ij","year"), model = c("within"), effect=c("time"), na.action= na.omit)

RegPanelCountry96 <- plm(log(v) ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d, data=Table_Gravite96_06, index= c("ij","year"), model = c("within"), effect=c("individual"), na.action= na.omit)

#Sans utiliser le plm
RegPanelMCO96 <-lm(log(v) ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d+factor(year)-1, data= Table_Gravite96_06 , na.action = na.omit)

#En MCO classique on retrouve bien les memes coefs
RegPanel_pool96 <- plm(log(v) ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d, data=Table_Gravite96_06, index= c("ij","year"), model = c("pooling"),na.action= na.omit)

#glm poisson
RegPoiss96 <- glm(v ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d, data=Table_Gravite96_06, na.action = na.omit, family = quasipoisson(link="log"))
#effet fixe annee
RegPoiss96bis <- glm(v ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d+factor(year)-1, data=Table_Gravite96_06, na.action = na.omit, family = quasipoisson(link="log"))

```




###Premiers résultats obtenus
Sur l'ensemble des données 
```{r results="asis", echo=FALSE, tidy=TRUE}
stargazer(RegPanelTime, RegPanelCountry, RegPanel_pool ,RegMCO, RegPoiss,column.labels = c("Panel Temps","Panel Pays","Panel Pooled", "MCO", "QuasiPoisson") ,type = "html")
```

Sur 20 ans
```{r results="asis", echo=FALSE, tidy=TRUE}
stargazer(RegPanelTime96bis, RegPanelCountry96, RegPanel_pool96 ,RegMCO96, RegPoiss96bis,column.labels = c("Panel Temps","Panel Pays","Panel Pooled", "MCO", "QuasiPoissontemps") ,type = "html")
```

### Pour obtenir des standards erreurs robustes
```{r}
#utile pour l'estimation de poisson
library("lmtest") 
library("sandwich") 

coeftest(RegPoiss, vcov = sandwich)
```

 




### Premières prévisions sur modèle monde et potentiel de commerce

```{r, tidy=TRUE}

library(dplyr)
library(data.table)

#prenons les deux estimations préferées
RegPoissFRA <- glm(v ~ log(gdp_o)+log(gdp_d)+log(distw)+log(gdpcap_o)+log(gdpcap_d)+contig+comcur+commlang+gatt_o+gatt_d, data=Table_Gravite96_06, na.action = na.omit, family = quasipoisson(link="log"))


#creer une nouvelle table pour les prédictions pour la France en MCO
Table_Prev <- filter(Table_Gravite, i== "FRA")
Table_Prev <- cbind(predict.glm(RegPoissFRA, newdata=Table_Prev) ,Table_Prev)
Table_Prev$fit <- exp(Table_Prev$V1)
Table_Prev$n<-1:3308


library(ggplot2)
library(plotly)
ComparaisonFrance <- ggplotly(ggplot(Table_Prev, aes(n))+ geom_line(aes(y=v), colour="blue")+geom_line(aes(y=fit),colour="red"))
ComparaisonFrance


```

### Potentiels de commerce


```{r, tidy=TRUE}
#nous utilisons la formule d'ajustement de fontagné
Table_Prev$ajust <- (Table_Prev$fit*(sum(Table_Prev$v, na.rm = TRUE )-Table_Prev$v)) /(sum(Table_Prev$fit,na.rm = TRUE)-Table_Prev$fit)

print(Table_Prev)
```

# Tests statistiques
Pour les tests statistiques nous utilisons [...]

Test Hausman (Ftest) 

Test de Breusch-Pagan pour l'hétéroscédasticité

Modéle Hausman-Taylor pour l'endogénéité




# Augmenter le modèle
Pour obtenir les données de distances routières nous utilisons l'API Google avec le script suivant :

```{r ,eval=FALSE}
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

######################## Utilisation de l'API Google ######################

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



```

Pour mettre à jour les donnees on peut utiliser l'API worldbank avec ce code (modifier l'adresse de la requete JSON)
```{r, eval=FALSE}
library(jsonlite)
#utiliser le csv préparé sur github
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

```


# Bibliographie

Didier, Head (2008)

Head, K. and T. Mayer, (2013), "Gravity Equations: Toolkit, Cookbook, Workhorse."  Handbook of International Economics, Vol. 4,eds. Gopinath, Helpman, and Rogoff, Elsevier.

Sevestre P. (2002), « Econométrie des données de panel », Dunod

Baier S. et Bergstrang J. (2002), « On the endogeneity of international trade flows and free trade agreements », Manuscript

Baier S. et Bergstrang J. (2005), « Do free trade agreements actually increase Members’ international trade? », Manuscript

Da Silva J.S. et Tenreyro S. (2006), « The log of Gravity », The review of Economics and Statistics

Feenstra, R. (2003), « Advanced international trade: Theory and Evidence », Princeton, NJ: Princeton University Press

Fontagné L., Mayer T. et Zignago S. (2005), « A re-evaluation of the impact of regional trade agreements on trade », Draft Version, CEPII
