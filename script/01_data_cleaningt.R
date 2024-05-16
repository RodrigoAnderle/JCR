
## Reading the database

## Packages
require(tidyverse)



# Data reading ------------------------------------------------------------

JCR <- read.csv2("raw/JCR2022.csv", skip = 2, header = T, sep = ",", 
                 colClasses = "character", nrows = 1026, row.names = NULL)
# li como character para não perder informações por conta de virgulas e pontos


# Names Adjustment --------------------------------------------------------
head(JCR)
names(JCR)
names(JCR) <- names(JCR[2:11])
JCR <- JCR[,-11]
JCR %>% 
  rename(JIF.2022= X2022.JIF, JCI.2022= X2022.JCI, 
         Rate.OA.Gold = X..of.OA.Gold) -> JCR
head(JCR)

# Data cleaning -----------------------------------------------------------

#ajustando números para ter vírgulas e pontos no formato do R.
str(JCR)
JCR$Total.Citations <- as.numeric(str_replace_all(JCR$Total.Citations, ",", "."))
JCR$JIF.2022 <- as.numeric(JCR$JIF.2022)
JCR$JCI.2022 <- as.numeric(JCR$JCI.2022)
JCR$Rate.OA.Gold <- as.numeric(gsub("%", "", JCR$Rate.OA.Gold))
rename(JCR, Perc.OA.Gold  = Rate.OA.Gold) -> JCR
head(JCR)

# Creating JCR Categories -------------------------------------------------

JCR %>% 
  mutate(JCR_Category = gsub(".*-", "", JCR$Category),
         Category = sub(" -.*", "", JCR$Category)
  ) -> JCR

JCR$JCR_Category %>% table() # não funcionou direito.
JCR$Category %>% table() # por subcategoria tem muito poucas
nrow(JCR) # deveriam ser mais de 11 mil, tenho só mil

saveRDS(object = JCR, file = "data/JCR.rds")

## tests
hist(JCR$JIF.2022, breaks = 1000)
hist(JCR$JIF.2022, breaks = 1000, freq = F)
