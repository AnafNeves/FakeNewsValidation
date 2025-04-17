library(jsonlite)
library(progress)


options(warn = 2) # Stop on warnings

path <- "C:/Users/asf25/Box/FakeNewsValidation/"

files <- list.files(path, pattern = "*.csv")

# Progress bar
progbar <- progress_bar$new(total = length(files))

alldata <- data.frame()

for (file in files) {
  progbar$tick()
  rawdata <- read.csv(paste0(path, "/", file))

  # Initialize participant-level data
  dat <- rawdata[rawdata$screen == "browser_info", ]
  

  data_ppt <- data.frame(
    # Participant = dat$participantID,
    Recruitment = dat$researcher,
    Condition = dat$condition,
    Experiment_StartDate = as.POSIXct(paste(dat$date, dat$time), format = "%d/%m/%Y %H:%M:%S"),
    Experiment_Duration = rawdata[rawdata$screen == "demographics_debrief", "time_elapsed"] / 1000 / 60,
    Browser_Version = paste(dat$browser, dat$browser_version),
    Mobile = dat$mobile,
    Platform = dat$os,
    Screen_Width = dat$screen_width,
    Screen_Height = dat$screen_height
    )
    
    if("prolific_id" %in% colnames(dat)){
    data_ppt$Prolific_ID <- dat$prolific_id
    }
  
  # Demographics
  demog <- jsonlite::fromJSON(rawdata[rawdata$screen == "demographic_questions", ]$response)
  
}
