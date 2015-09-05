#setwd("~/mexico-mortality/heat/")
library(dplyr)
library(tidyr)
library(ggplot2)

deaths <- read.csv("../deaths/deaths08.csv.bz2")

deaths$hod[deaths$hod == 99] <- NA
deaths$hod[deaths$hod == 24] <- 0
deaths$minod[deaths$minod == 99] <- NA

deaths <- mutate(deaths, 
                 day = as.Date(paste(yod, mod, dod, sep = "-"),
                               format = "%Y-%m-%d")) %>%
        select(sex, age, hod, minod, cod, day) %>%
        filter(as.POSIXlt(day)$year == 108)

## Add columns, `resp_death` and `cvd_death`, to note whether or not the
## death was a cardiovascular (I00-I78) or respiratory (J00-J99) death
deaths <- mutate(deaths,
                 resp_death = as.numeric(deaths$cod %in%
                   paste0("J", formatC(0:99, digits = 1, flag = 0))),
                 cvd_death = as.numeric(deaths$cod %in%
                   paste0("I", formatC(0:78, digits = 1, flag = 0))))

## Read in weather data
weather <- read.csv("../weather-simat2/weather-daily.csv")
weather <- mutate(weather, day = as.Date(as.character(day)))

## Create `cardioresp_deaths`, which includes one row per date, with number
## of cardiovascular and respiratory deaths summed for the date. Then merge in weather.
cardioresp_deaths <- group_by(deaths, day) %>%
        summarise(resp_deaths = sum(resp_death),
                  cvd_deaths = sum(cvd_death)) %>%
        left_join(weather)
write.csv(cardioresp_deaths, file = "cardioresp_deaths.csv",
          row.names = FALSE)
