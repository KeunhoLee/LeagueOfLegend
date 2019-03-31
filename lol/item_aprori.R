
keyitems <- stats1[,3:8] %>% unlist() %>% table() %>% sort(decreasing = T) %>% data.frame() %>% filter( Freq > 2000 ) %>%
  select(1) %>% unlist() %>% as.character()
keyitems <- keyitems[-1]

tmp <- items[items$id %in% as.numeric( keyitems ), c('id','name')]
tmp$name <- as.character(tmp$name) 
row.names(tmp) <- tmp$id
write.csv(tmp,'tmp.csv')

keyitems2 <- intersect( keyitems, tmp$id )[!( intersect( keyitems, tmp$id ) %in% (1400:1419) )]
keyitems2 <- sort(keyitems2)
keyitems3 <- tmp[tmp$id %in% keyitems2 ,]$name


tmp_fun <- function(x) {
  return(table(as.character(x))[as.character(keyitems2)])
}

contents_items <-  bot_duo_stat[supp_idx ,7:12][sample(length(supp_idx),100000),] %>% tbl_df() %>% rowwise() %>% do(out = tmp_fun(.))

item_matrix <-
  matrix(unlist(contents_items[[1]]),  nrow = 100000, byrow = T)

item_matrix[is.na(item_matrix)] <- 0
item_matrix <- ifelse(item_matrix > 0, 1, 0)

colnames(item_matrix) <- keyitems3

rules_items <- apriori(item_matrix,
                      parameter = list( supp = 0.15, conf = 0.1, target = 'rules' ))
item_result_supp <- inspect(sort(rules_items))

##### carry

contents_items <-  bot_duo_stat[carry_idx ,7:12][sample(length(carry_idx),100000),] %>% tbl_df() %>% rowwise() %>% do(out = tmp_fun(.))

item_matrix <-
  matrix(unlist(contents_items[[1]]),  nrow = 100000, byrow = T)

item_matrix[is.na(item_matrix)] <- 0
item_matrix <- ifelse(item_matrix > 0, 1, 0)

colnames(item_matrix) <- keyitems3

rules_items <- apriori(item_matrix,
                       parameter = list( supp = 0.01, conf = 0.3, target = 'rules' )) #ÀÌÁî

rules_items <- apriori(item_matrix,
                       parameter = list( supp = 0.1, conf = 0.3, target = 'rules' ))

item_result_carry <- inspect(sort(rules_items))
