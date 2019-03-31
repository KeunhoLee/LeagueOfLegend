champion <- union( rownames( supp_tbl ), rownames( carry_tbl ) ) 

tmp_fun2 <- function(x) {
  return(table(as.character(x))[champion])
}

contents_duos <-
  reshape_bot_duo[,3:4] %>% tbl_df() %>% rowwise() %>% do(out = tmp_fun2(.))

duos <-
  matrix(unlist(contents_duos[[1]]), nrow = dim(reshape_bot_duo)[1], byrow = T)

colnames(duos) <- champion
duos[is.na(duos)] <- 0
duos <- as(duos, "transactions")

( 1/length(carry_pool) ) * ( 1/length(supp_pool) )

rules_duos <- apriori(duos,
                      parameter = list( supp = 0.01, conf = 0.05, target = 'rules' ))

rules_duos

duos_result <- inspect(sort(rules_duos))

duos_result[order(duos_result$lift, decreasing = T),]

rules_duos2 <- apriori(duos,
                      parameter = list( supp = 0.004, conf = 0.15, target = 'rules' ))
rules_duos2

duos_result2 <- inspect(sort(rules_duos2))

duos_result2[order(duos_result2$lift, decreasing = T),]

#### ´ÜÀÏ Ã¨ÇÇ¾ð µîÀå ºñÀ² ####
supp_table <- bot_duo_stat %>% filter(row_number() %in% supp_idx) %>% select(name) %>% table() %>% 
  sort(decreasing = T) %>% prop.table() %>% round(4)*100

carry_table <- bot_duo_stat %>% filter(row_number() %in% carry_idx) %>% select(name) %>% table() %>% 
  sort(decreasing = T) %>% prop.table() %>% round(4)*100

sss <- data.frame(carry_table)
colnames(sss)[1] <- 'name'
View(sss)
#### Ã¨ÇÇ¾ð º° ½Â·ü ####

supp_win <- bot_duo_stat %>% tbl_df() %>% filter(row_number() %in% supp_idx) %>% group_by(name) %>% 
  summarise(winrate = mean(win, na.rm = T), n()) %>% data.frame() %>% filter( `n..` > 1000)

View(supp_win[order(supp_win$winrate, decreasing = T),])

carry_win <- bot_duo_stat %>% tbl_df() %>% filter(row_number() %in% carry_idx) %>% group_by(name) %>% 
  summarise(winrate = mean(win, na.rm = T), n()) %>% data.frame() %>% filter( `n..` > 1000)

View(carry_win[order(carry_win$winrate, decreasing = T),])

duo_win <- reshape_bot_duo %>% group_by(name.DUO_SUPPORT, name.DUO_CARRY) %>%
  summarise( winrate = mean(win), n = n()) %>% filter(n > 1000) %>% data.frame

duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_CARRY == 'Lucian')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_CARRY == 'Caitlyn')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_CARRY == 'Vayne')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_CARRY == 'Xayah')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_CARRY == 'Twitch')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_CARRY == 'KogMaw')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_CARRY == 'Draven')

duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_SUPPORT == 'Sona')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_SUPPORT == 'Janna')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_SUPPORT == 'Blitzcrank')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_SUPPORT == 'Thresh')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_SUPPORT == 'Lulu')
duo_win[order(duo_win$winrate, decreasing = T),] %>% filter(name.DUO_SUPPORT == 'Rakan')

