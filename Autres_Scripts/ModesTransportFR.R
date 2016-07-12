Ci dessous la réparatition des échanges dans l'UE par mode de transport

```{r warning=FALSE, message=FALSE, echo=FALSE,eval=FALSE}
library(dplyr)
library(ggplot2)
library(data.table)
library(plotly)

##### trouver pour chaque pays européen le mix mode de transport par partenaire
mod_transport <- read.csv(file = paste0(getwd(),"/Data/MixTranspMode.csv"),sep = ",", dec = ".")

europe <- read.csv(file = paste0(getwd(),"/Data/EuropeanCountries.csv"),sep = ";", dec = ",", header = FALSE)

testmerge <- merge(x=mod_transport, y=europe, by.x=c("PARTNER_LAB"), by.y=c("V1"), all= FALSE)
MTeurope <- filter(testmerge, V2 == 1)
MTeurope <- data.table(MTeurope)
MTeurope <- setkey(MTeurope, value=TRANSPORT_MODE_LAB)
Graph_Transport  <- ggplot(MTeurope, aes(y=INDICATOR_VALUE, x=PERIOD_LAB, fill=TRANSPORT_MODE_LAB)) +geom_bar(stat="identity", position="fill")

ggplotly(Graph_Transport)
```
