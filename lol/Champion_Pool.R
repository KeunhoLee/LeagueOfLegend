
bot_duo  <- participants %>% filter(role == 'DUO_CARRY' | role == 'DUO_SUPPORT')
bot_duo2 <- bot_duo %>% left_join(champs, by = c('championid' = 'id')) %>% 
  mutate( team = ifelse(.$player > 5, 'B','A') ) %>% 
  left_join(rbind(stats1[,c('id','win')],stats2[,c('id','win')]), by = 'id')

reshape_bot_duo <- bot_duo2 %>% select(matchid, team, name, role, win ) %>%
  reshape(timevar = 'role', idvar = c('matchid', 'team'), direction = 'wide') %>% na.omit()

reshape_bot_duo <- reshape_bot_duo[,-4]
names(reshape_bot_duo)[5] <- 'win'

supp_tbl   <- table( reshape_bot_duo$name.DUO_SUPPORT )
carry_tbl  <- table( reshape_bot_duo$name.DUO_CARRY )

supp_pool  <- rownames( supp_tbl[supp_tbl >= 100] )
carry_pool <- rownames( carry_tbl[carry_tbl >= 600] )

intersect( supp_pool, carry_pool )

supp_matchid1 <- reshape_bot_duo %>% 
  filter( name.DUO_SUPPORT %in% intersect(supp_pool, carry_pool) & name.DUO_CARRY %in% setdiff(carry_pool, supp_pool)) %>%
  select(matchid) %>% unlist()

supp_matchid2 <- reshape_bot_duo %>% 
  filter( name.DUO_CARRY %in% intersect(supp_pool, carry_pool) & name.DUO_SUPPORT %in% setdiff(carry_pool, supp_pool)) %>%
  select(matchid) %>% unlist()

carry_matchid1 <- reshape_bot_duo %>% 
  filter( name.DUO_CARRY %in% intersect(supp_pool, carry_pool) & name.DUO_SUPPORT %in% setdiff(supp_pool, carry_pool)) %>%
  select(matchid) %>% unlist()

carry_matchid2 <- reshape_bot_duo %>% 
  filter( name.DUO_SUPPORT %in% intersect(supp_pool, carry_pool) & name.DUO_CARRY %in% setdiff(supp_pool, carry_pool)) %>%
  select(matchid) %>% unlist()

data.frame(names( stats1 ) )

data.frame(names( bot_duo2 ) )

bot_duo_stat <- left_join(bot_duo2, rbind(stats1,stats2), by = 'id' ) %>% select(id,                                                                   
                                                                    matchid,
                                                                    role,
                                                                    name,
                                                                    team,
                                                                    win = win.x,
                                                                    item1,
                                                                    item2,
                                                                    item3,
                                                                    item4,
                                                                    item5,
                                                                    item6,
                                                                    kills,
                                                                    deaths,
                                                                    assists,
                                                                    totdmgtochamp,
                                                                    totheal,
                                                                    totdmgtaken, firstblood)                                                                  

supp_idx1 <- which( bot_duo_stat$name %in% setdiff( supp_pool, carry_pool ) )
supp_idx2 <- which( ( bot_duo_stat$role == 'DUO_SUPPORT' ) & ( bot_duo_stat$matchid %in% supp_matchid1 ) )
supp_idx3 <- which( ( bot_duo_stat$role == 'DUO_CARRY' ) & ( bot_duo_stat$matchid %in% supp_matchid2 ) )

carry_idx1 <- which( bot_duo_stat$name %in% setdiff( carry_pool, supp_pool ) )
carry_idx2 <- which( ( bot_duo_stat$role == 'DUO_CARRY' ) & ( bot_duo_stat$matchid %in% carry_matchid1 ) )
carry_idx3 <- which( ( bot_duo_stat$role == 'DUO_SUPPORT' ) & ( bot_duo_stat$matchid %in% carry_matchid2 ) )

supp_idx <- union( union( supp_idx1, supp_idx2), supp_idx3) 
carry_idx <- union( union( carry_idx1, carry_idx2), carry_idx3)

