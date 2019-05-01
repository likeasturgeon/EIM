unzip_all <- function(folders = choose.files(caption = "Choose all the folders to extract")) {
     for (folder in folders) {
          unzip(zipfile = folder, 
                exdir = dirname(folder))
     }
unlink(folders)
}


unzip_all()
