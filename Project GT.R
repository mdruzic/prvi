#Downloading and data maipulation

if (!require("devtools")) install.packages("devtools")
devtools::install_github("PMassicotte/gtrendsR")

library(gtrendsR)
library(dplyr)

res <- gtrends(c("croatia","china","brazil"),time="all")

interest_over_time= res[[1]]
interest_by_country=res[[2]]


interest_by_country$hits= as.numeric(interest_by_country$hits)

Croatia = interest_by_country %>%
  filter(keyword=="croatia") %>%
  arrange(desc(hits)) %>%
  slice(2:10)

Brazil = interest_by_country %>%
  filter(keyword=="brazil") %>%
  arrange(desc(hits)) %>%
  slice(2:10)

China = interest_by_country %>%
  filter(keyword=="china") %>%
  arrange(desc(hits)) %>%
  slice(2:10)

China$location[3]="Myanmar"

ggplot(interest_over_time,aes(date,hits))+geom_line(aes(color=keyword))

#The connection with tourism

Croatia_World = interest_over_time %>%
  filter(keyword=="croatia") %>%
  select(hits)%>%
  slice(25:173)

library(readxl)
CRO_nights <- read_excel("C:/Users/Ozana/Desktop/CRO_nights.xlsx")
View(CRO_nights)

install.packages("ggplot2")
library(ggplot2)


df = data.frame(Croatia_World,CRO_nights)
head(df)
ggplot(df,aes(hits,Tourist_Nights)) + geom_point(aes(color = strDate, size = Tourist_Nights_12MA))+geom_smooth(method = "lm", se=FALSE, color="black", formula = y ~ x)


ggplot(df, aes(strDate)) + 
  geom_line(aes(y = Tourist_Nights, colour = "Tourist_Nights")) + 
  geom_line(aes(y = Tourist_Nights_12MA, colour = "Tourist_Nights_12MA"))

ggplot(df, aes(strDate)) + 
  geom_line(aes(y = hits, colour = "hits")) + 
  geom_line(aes(y = Tourist_Nights_12MA, colour = "Tourist_Nights_12MA"))

install.packages("gridExtra")

require(gridExtra)
p1 <- ggplot(df, aes(strDate,Tourist_Nights_12MA)) + geom_line(colour = "red", size = 1) 
p2 <- ggplot(df, aes(strDate,hits)) + geom_line(colour = "blue", size = 1) 

#Creating maps

Croatia$location[1]="Bosnia and Herzegovina"
Croatia$location[2]="Macedonia"
Brazil$location[7]="Trinidad and Tobago"
China$location[3]="Myanmar"

install.packages("rworldmap")

library("rworldmap")
data = Croatia 

mapDevice('x11')
spdf <- joinCountryData2Map(data, joinCode="NAME", nameJoinColumn="location" )

mapCountryData(spdf, nameColumnToPlot="hits", catMethod="fixedWidth", oceanCol="lightblue",
               missingCountryCol="grey")

identifyCountries(getMap(), nameColumnToPlot="POP2005")
grid.arrange(p1, p2, nrow=2)