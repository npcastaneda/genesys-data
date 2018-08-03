# Compare passport data in Production vs Sandbox
# N. Castaneda
# August 2018

require(compare)
require(openxlsx)
require(genesysr)
require(tidyverse)

# Sandbox
genesysr::setup_sandbox() 
genesysr::user_login()

sand <- fetch_accessions(list(institute.code =c("COL003")))
sand <- lapply(sand$content, unlist)
sand <- sand %>% map_df(bind_rows)
nrow(sand) #67772

# Production
genesysr::setup_production() 
genesysr::user_login()

# prod <- fetch_accessions(list(institute.code =c("COL003")))
prod <- fetch_accessions(list(institute.code =c("COL003")))
prod <- lapply(prod$content, unlist)
prod <- prod %>% map_df(bind_rows)
nrow(prod) #67770

# Only forages
unique(sand$cropName)
unique(sand$crops) #no

unique(prod$cropName)
unique(prod$crops)

sand.f <- sand[which(sand$cropName =="forages"),]
prod.f <- prod[which(prod$cropName == "forages"),]  

# Comparison
anti_join(sand.f,prod.f, by=c("acceNumb"))
View(anti_join(sand.f,prod.f, by=c("acceNumb")))

nrow(anti_join(sand,prod, by=c("acceNumb")))
View(anti_join(sand,prod, by=c("acceNumb")))

nrow(anti_join(sand,prod, by=c("acceNumb","taxonomy.genus")))
View(anti_join(sand,prod, by=c("acceNumb","taxonomy.genus")))
