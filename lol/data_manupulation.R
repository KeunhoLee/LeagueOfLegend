# install.packages('jsonlite')
# library('jsonlite')
# install.packages("rjson")
# library("rjson")

#### item data ####
# url <- 'http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/item.json'
# lol <- fromJSON(file=url)
# #View(lol)
# 
# item_numbers <- names(lol$data)
# length(item_numbers)
# 
# var_name_lists <- list()
# for( i in 1:237 ) {
#   var_name_lists[[i]] <- names(lol$data[[i]])
# }
# 
# var_name_lists
# 
# item_names <- sapply(1:237, function(i) lol$data[[i]]$name)
# 
# item_from  <- sapply(1:237, function(i) lol$data[[i]]$from)
# item_from  <- sapply(item_from, function(x) paste(x,collapse = ', ') )
# item_from  <- ifelse(item_from == '', NA, item_from)
# 
# item_into  <- sapply(1:237, function(i) lol$data[[i]]$into)
# item_into  <- sapply(item_into, function(x) paste(x,collapse = ', ') )
# item_into  <- ifelse(item_into == '', NA, item_into)
# 
# item_gold_base  <- sapply(1:237, function(i) lol$data[[i]]$gold$base)
# item_gold_total <- sapply(1:237, function(i) lol$data[[i]]$gold$total)
# item_gold_sel   <- sapply(1:237, function(i) lol$data[[i]]$gold$sel)
# item_depth      <- sapply(1:237, function(i) lol$data[[i]]$depth)
# item_depth      <- sapply(item_depth, function(x) sum(x) )
# 
# length(item_from)
# items <- data.frame( id = item_numbers,
#             name = item_names,
#             from = item_from,
#             into = item_into,
#             gold_base = item_gold_base,
#             gold_total = item_gold_total,
#             gold_sel = item_gold_sel,
#             depth = item_depth )
# View(items)
# write.csv(items,'items.csv')


url2 <- 'http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/summoner.json' 
lol2 <- fromJSON(file=url2)
View(lol2)
####  ####

champs <- read.csv('champs.csv', stringsAsFactors = F)
#View(champs)

matches <- read.csv('matches.csv')
#View(matches)

participants <- read.csv('participants.csv')
#View(participants)

stats1 <- read.csv('stats1.csv', stringsAsFactors = F)
#(stats1)

stats2 <- read.csv('stats2.csv')
#View(stats2)

teambans <- read.csv('teambans.csv')
#View(teambans)

teamstats <- read.csv('teamstats.csv')
#View(teamstats)

items <- read.csv('items.csv')
items <- items[,-1]

items2 <- read.csv('tmp.csv')

# LL <- read.csv('LeagueofLegends.csv')
# names(LL)
# View(LL)
# 
# table(LL$Year)
# table(LL$League)
# 
# matchinfo <- read.csv('matchinfo.csv')
# View(matchinfo)
# 
# monsters <- read.csv('monsters.csv')
# View(monsters)
# 
# structures <- read.csv('structures.csv')
# View(structures)
# 
# bans <- read.csv('bans.csv')
# View(bans)
# 
# kills <- read.csv('kills.csv')
# View(kills)
# 
# gold <- read.csv('gold.csv')
# View(gold)

# id	ì°¸ê??žID
# matchid	ê²½ê¸°ID
# player	?”Œ? ˆ?´?–´ ?ˆœ?„œ
# championid	ì±”í”¼?–¸ID
# ss1	?†Œ?™˜?‚¬ì£¼ë¬¸1(D)
# ss2	?†Œ?™˜?‚¬ì£¼ë¬¸2(F)
# role	DUO, DUO_CARRY, DUO_SUPPORT, SOLO, NONE
# position	?¼?¸(TOP,MID,BOT,JUNGLE)

