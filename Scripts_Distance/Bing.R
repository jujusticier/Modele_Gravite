#### script avec BING
Script le plus prometteur pour l'instant

#ne pas oublier la clé API
options(BingMapsKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxx")

### la fonction georoute ici
#'Find driving routes using online services
#'
#'Find transit routes using Google or Bing's API
#'
#'@aliases georoute georoute.default
#'@param x A character vector of length>=2, where each element is a (starting, ending, or intermediate) waypoint, or a numeric matrix with columns c('lat','lon') where each row is a waypoint
#'@param verbose Provide additional information
#'@param returntype What information to return.  Currently, the options are "all", "distance", "distanceUnit", "path", "time", and/or "timeUnit".  Can be combined, as in returntype=c("time","distance").
#'@param service API to use.  Currently the only option is "bing"
#'@param \dots Other items to pass along
#'@return Route information (see the returntype argument)
#'@author Ari B. Friedman
#'@examples
#'\dontrun{
#'georoute( c("3817 Spruce St, Philadelphia, PA 19104", 
#'  "9000 Rockville Pike, Bethesda, Maryland 20892"), verbose=TRUE )
#'georoute( c("3817 Spruce St, Philadelphia, PA 19104", 
#'  "Tulum, MX","9000 Rockville Pike, Bethesda, Maryland 20892"), returntype="distance" )
#'georoute( c("3817 Spruce St, Philadelphia, PA 19104", 
#'  "9000 Rockville Pike, Bethesda, Maryland 20892"), verbose=TRUE, returntype="path" )
#'georoute( c("3817 Spruce St, Philadelphia, PA 19104", 
#'  "9000 Rockville Pike, Bethesda, Maryland 20892"), verbose=TRUE, returntype="time" )
#'# Using lat/lon
#'xmat <- rbind( 
#'  geocode( "3817 Spruce St, Philadelphia, PA 19104" ), 
#'  geocode( "9000 Rockville Pike, Bethesda, Maryland 20892" ) 
#')
#'colnames(xmat) <- c( 'lat', 'lon' )
#'georoute( xmat, verbose=TRUE, returntype = c("distance","distanceUnit") )
#'}
#'@rdname georoute
#'@export georoute
georoute <- function( x, verbose=FALSE, service="bing", returntype="all", ... ) {
  UseMethod("georoute",x)
}
#'@rdname georoute
#'@method georoute default
#'@S3method georoute default
georoute.default <- function( x, verbose=FALSE, service="bing", returntype="all", ...) {
  # Input regularization and checking
  service <- tolower(service)
  BingMapsKey <- getOption("BingMapsKey")
  if(service=="bing" && is.null(BingMapsKey) ) stop("To use Bing, you must save your Bing Maps API key (obtain at http://msdn.microsoft.com/en-us/library/ff428642.aspx) using options(BingMapsKey='mykey').\n")
  # URL constructing
  construct.georoute.url <- list()
  construct.georoute.url[["bing"]] <- function(waypoints, maxSolutions=1, optimize="time", distanceUnit="km",travelMode="Driving",path=(returntype=="path") ) { # documented at http://msdn.microsoft.com/en-us/library/ff701717
    if( "data.frame" %in% class(waypoints) )  waypoints <- as.matrix(waypoints)
    if( class(waypoints) == "matrix" ) { # handle lat/lon cases by converting to character strings separated by commas (e.g. 42.5,-77 gets converted to "42.5,-77" for use in the URL)
      waypoints <- apply( waypoints, 1, paste0, collapse="," )
    }
    root <- "http://dev.virtualearth.net/REST/v1/Routes"
    waypointsquery <- paste("wayPoint.",seq_along(waypoints),"=",waypoints,collapse="&",sep="")
    routePathOutputquery <- ifelse(path,"&routePathOutput=Points","")
    u <- paste0(root, "?", waypointsquery, "&maxSolutions=",maxSolutions,"&optimize=",optimize,
                routePathOutputquery,"&distanceUnit=",distanceUnit,"&travelMode=",travelMode,
                "&key=",BingMapsKey)
    return(URLencode(u))
  }
  if(verbose) message(x,appendLF=FALSE)
  u <- construct.georoute.url[[service]](x)
  doc <- RCurl::getURL(u)
  j <- RJSONIO::fromJSON(doc,simplify = FALSE)
  # Parse and return
  parse.json <- list()
  parse.json[["bing"]] <- function(j) {
    if(j$authenticationResultCode != "ValidCredentials") stop("Your BingMapsKey was not accepted.\n")
    if(j$statusDescription!="OK") stop("Something went wrong. Bing Maps API return status code ",j$statusCode," - ", j$statusDescription,"\n")
    rt <- j$resourceSets[[1]]$resources[[1]]
    if(verbose) message(" - Confidence: ", rt$routeLegs[[1]]$startLocation$confidence,appendLF=FALSE)
    if(verbose) message(" - Distance unit: ", rt$distanceUnit, " Time unit:", rt$durationUnit ,appendLF=FALSE)
    if( "all" %in% returntype ) {
      res <- rt$routeLegs[[1]]
    } else {
      res <- list()
      if( "path" %in% returntype ) res[[ "path" ]] <-  t(sapply(rt$routePath$line$coordinates, unlist))
      if( "distance" %in% returntype ) res[[ "distance" ]] <-  rt$travelDistance
      if( "distanceUnit" %in% returntype ) res[[ "distanceUnit" ]] <- rt$distanceUnit
      if( "time" %in% returntype ) res[[ "time" ]] <- rt$travelDuration
      if( "timeUnit" %in% returntype ) res[[ "timeUnit" ]] <- rt$durationUnit
      res <- as.data.frame(res)
    }
    res
  }
  if(verbose) message("\n",appendLF=FALSE)
  return( parse.json[[service]](j) )
}

########################################################## Code perso



### on recrée une table mondiale
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

#### boucle à faire et trouver un moyen de merger
#### comment gérer les erreurs ? 

georoute(x=c(Table_Ville_Monde$From[2],Table_Ville_Monde$to[2]),verbose = TRUE,returntype =c("distance","time"))
