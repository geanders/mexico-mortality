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

## Add a column, `heat_death` to note whether or not the deaths was a
## heat death
## (X30 = "Exposure to excessive natural heat")
deaths <- mutate(deaths, heat_death = as.numeric(deaths$cod == "X30"))

## Read in weather data
weather <- read.csv("../weather-simat2/weather-daily.csv")
weather <- mutate(weather, day = as.Date(as.character(day)))

## Create `heat_deaths`, which includes one row per date, with number
## of heat deaths summed for the date. Then merge in weather.
heat_deaths <- group_by(deaths, day) %>%
        summarise(heat_deaths = sum(heat_death)) %>%
        left_join(weather)
write.csv(heat_deaths, file = "heat_deaths.csv",
          row.names = FALSE)
