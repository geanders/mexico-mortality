#setwd("~/mexico-mortality/legionnaires/")
deaths <- read.csv("../deaths/deaths08.csv.bz2")

deaths$hod[deaths$hod == 99] <- NA
deaths$hod[deaths$hod == 24] <- 0

deaths$minod[deaths$minod == 99] <- NA

disease <- read.csv("../disease/icd-main.csv")
disease[grep("A48", disease$code), ]


## A48 includes: Gas gangrene, Legionnaires' disease, 
## Pontiac fever, Toxic shock syndrome, Brazilian purpuric
## fever, other specified botulism, and other specified
## bacterial diseases
ld <- filter(deaths, cod == "A48") %>%
        select(sex, age, yod, mod, dod, hod, minod, cod)
ld
table(ld$mod)
