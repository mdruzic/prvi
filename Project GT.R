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
