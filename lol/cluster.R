# 서포터 공격성 
items3 <- items %>% inner_join( items2, by ='id' )

att <- items3[items3$X == 1,'id']
def <- items3[items3$X == -1,'id']
neu <- items3[items3$X == 0,'id']

bot_duo_stat$a_score <- rowSums( cbind( ifelse( bot_duo_stat$item1 %in% att, 1, 0),
                                 ifelse( bot_duo_stat$item2 %in% att, 1, 0),
                                 ifelse( bot_duo_stat$item3 %in% att, 1, 0),
                                 ifelse( bot_duo_stat$item4 %in% att, 1, 0),
                                 ifelse( bot_duo_stat$item5 %in% att, 1, 0),
                                 ifelse( bot_duo_stat$item6 %in% att, 1, 0)
                                 ) )
head(bot_duo_stat)

bot_duo_stat$d_score <- rowSums( cbind( ifelse( bot_duo_stat$item1 %in% def, 1, 0),
                                        ifelse( bot_duo_stat$item2 %in% def, 1, 0),
                                        ifelse( bot_duo_stat$item3 %in% def, 1, 0),
                                        ifelse( bot_duo_stat$item4 %in% def, 1, 0),
                                        ifelse( bot_duo_stat$item5 %in% def, 1, 0),
                                        ifelse( bot_duo_stat$item6 %in% def, 1, 0)
                                ) )

participants$team <- ifelse( participants$player %in% 1:5, 'A', 'B')

stats <- inner_join( rbind(stats1,stats2), participants[,c('id','matchid','team')], by = 'id' )

teams <- stats %>% tbl_df() %>% group_by( matchid, team ) %>% summarise(team_dmg = sum(totdmgtochamp),
                                                                        team_kills = sum(kills),
                                                                        team_deaths = sum(deaths),
                                                                        team_assists = sum(assists),
                                                                        team_dmgtaken = sum(totdmgtaken) ) %>% data.frame
rm(stats)
dim(bot_duo_stat)
head(bot_duo_stat)
head(teams)
bot_duo_stat <- bot_duo_stat %>% merge( ., teams, by = c('matchid', 'team')) 

bot_duo_stat$killrate  <- bot_duo_stat$kills / bot_duo_stat$team_kills 
bot_duo_stat$deathrate <- bot_duo_stat$deaths / bot_duo_stat$team_deaths 
bot_duo_stat$dmgtakenrate <- bot_duo_stat$totdmgtaken / bot_duo_stat$team_dmgtaken 
bot_duo_stat$dmgrate <- bot_duo_stat$totdmgtochamp / bot_duo_stat$team_dmg 
bot_duo_stat$KArate  <- ( bot_duo_stat$assists + bot_duo_stat$kills ) / bot_duo_stat$team_kills


hist(bot_duo_stat[supp_idx,]$dmgrate)
hist(bot_duo_stat[supp_idx,]$killrate)
hist(bot_duo_stat[supp_idx,]$deathrate)
hist(bot_duo_stat[supp_idx,]$KArate)
hist(bot_duo_stat[supp_idx,]$dmgtakenrate)
hist(bot_duo_stat[supp_idx,]$tot_score)
hist(bot_duo_stat[supp_idx,]$totheal)
hist(bot_duo_stat[supp_idx,]$a_score)
hist(bot_duo_stat[supp_idx,]$d_score)

data.frame( names(bot_duo_stat) )

km_data <- bot_duo_stat[supp_idx, c('a_score','d_score')]
km_data2 <- data.frame( lapply( km_data , scale) )
km_data2 <- na.omit(km_data2)

summary(km_data2)
model1 <- kmeans(km_data2, 3)
model1$centers
# rm(stats1)
X11()
fviz_cluster(model1, 
             data = km_data2,
             stand = F)

sort( table( bot_duo_stat[supp_idx, ][model1$cluster == 1,]$name ) , decreasing = T)[1:30]
sort( table( bot_duo_stat[supp_idx, ][model1$cluster == 2,]$name ) , decreasing = T)[1:30]
sort( table( bot_duo_stat[supp_idx, ][model1$cluster == 3,]$name ) , decreasing = T)[1:30]

supp_type <- data.frame( bot_duo_stat[supp_idx, c('name','matchid','team')], cluster = model1$cluster)
data.frame(names(bot_duo_stat) )
tmp <- merge( bot_duo_stat[carry_idx,c(1:3,5,6,19,27:31)], supp_type, by = c('matchid', 'team'), all.x = T )
tmp <- na.omit(tmp)

aggregate( killrate ~ cluster , tmp, mean )
aggregate( deathrate ~ cluster , tmp, mean )
aggregate( KArate ~ cluster , tmp, mean )
aggregate( dmgrate ~ cluster , tmp, mean )
aggregate( dmgtakenrate ~ cluster , tmp, mean )
aggregate( win ~ cluster , tmp, mean )
aggregate( firstblood ~ cluster , tmp, mean )

model1$centers

cluster1 <- tmp %>% filter(cluster == 1) %>% group_by(name.x) %>% summarise(winrate = mean(win), n = n()) %>% filter( n > 1000 ) %>% data.frame()
cluster2 <- tmp %>% filter(cluster == 2) %>% group_by(name.x) %>% summarise(winrate = mean(win), n = n()) %>% filter( n > 1000 ) %>% data.frame()
cluster3 <- tmp %>% filter(cluster == 3) %>% group_by(name.x) %>% summarise(winrate = mean(win), n = n()) %>% filter( n > 1000 ) %>% data.frame()

cluster1[order(cluster1$winrate, decreasing = T),]
cluster2[order(cluster2$winrate, decreasing = T),]
cluster3[order(cluster3$winrate, decreasing = T),]
