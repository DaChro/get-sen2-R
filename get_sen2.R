# function to download and prepare Sentinel-2 data
# This is a wrapper around getSpatialData() by J. Schwalb-Willmann. This function adds unzipping and the possibility to check tiles for how much they overlap with the aoi

get_sen2 <- function(time_range, min_coverage = 0, target_dir = "data", tile_id = NULL, relative_orbit=NULL, draw_aoi=TRUE, username, password){
  require(mapedit)
  require(sf)
  require(getSpatialData)
  require(rgdal)
  username <- username
  password <- password
  
  if(draw_aoi==T){
    drwn = drawFeatures()
    mapview(drwn)
    aoi <- drwn$geometry
    
    query <-
      getSentinel_query(
        time_range = time_range,
        aoi = aoi,
        platform = "Sentinel-2",
        username = username,
        password = password
      )
    
    print(paste(nrow(query), "tiles found for this AOI."))
    #check overlap with AOI
    #imgfootprints <-st_as_sf(query,wkt="footprint", crs = 4326)$footprint
    #aoi_coverage <- as.data.frame(as.numeric(st_area(st_intersection(imgfootprints,aoi)) / st_area(aoi)))
    #names(aoi_coverage) <- "aoi_coverage"
    
    print("AOI coverage of tiles:")
    print(aoi_coverage(query,aoi))
    query <- cbind(query,aoi_coverage(query,aoi))
    query <- query[which(query$aoi_coverage >= min_coverage),]
    print(paste(nrow(query), "tiles with sufficient coverage. Downloading..."))
    dir.create(target_dir)
    datasets <- getSentinel_data(records = query,dir_out = target_dir, username = username, password = password)
     
    
  }
  else{
    #put code here for alternative selection, e.g. using parameters for tile id and/or relative orbit
  }
  
  #unzip all zip files in folder and delete zipfiles
  print("Download complete. Unzipping...")
  zipfiles <- list.files(path = target_dir, pattern = ".zip", full.names = T)
  lapply(zipfiles, function(x){
    unzip(zipfile = x, exdir = target_dir)
    unlink(x)
  })
  print("Done.")
  
}

