winner <- bot_duo_stat %>% filter(row_number() %in% carry_idx ) %>% filter(win == 1) %>% data.frame() 
loser <- bot_duo_stat %>% filter(row_number() %in% carry_idx ) %>% filter(win == 0) %>% data.frame() 

par(mfrow = c(2,1))
hist(winner$killrate)
hist(loser$killrate)

par(mfrow = c(2,1))
hist(winner$deathrate)
hist(loser$deathrate)

par(mfrow = c(2,1))
hist(winner$KArate, xlim = c(0,1))
hist(loser$KArate, xlim = c(0,1))

par(mfrow = c(2,1))
hist(winner$dmgrate)
hist(loser$dmgrate)


