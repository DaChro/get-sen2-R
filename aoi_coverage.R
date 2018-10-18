#function to compute the coverage of a given aoi by the different images resulting 
#from a query on that aoi
aoi_coverage <- function(query, aoi) {
  #check overlap with AOI
  imgfootprints <-st_as_sf(query,wkt="footprint", crs = 4326)$footprint
  suppressMessages(aoi_coverage <- as.data.frame(as.numeric(st_area(st_intersection(imgfootprints,aoi)) / st_area(aoi))))
  names(aoi_coverage) <- "aoi_coverage"
  return(aoi_coverage)
}