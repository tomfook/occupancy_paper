library(tibble)
library(dplyr)
library(readr)
library(purrr)
library(modelr)

get_v <- function(p1,p2,p3,p4){
  p <- c(p1, p2, p3, p4)
  if(!near(sum(p),1)){
    print(sum(p))
    print(p)
    stop("arrival stat total is not 1")
  }

  #n=8
  v44 <- p %*% c(8, 8, 8, 8)

  #n=7
  v34 <- p %*% c(v44, 7, 7, 7)
  v43 <- v34

  #n=6
  v42 <- p %*% c(v43, v44, 6, 6)
  v33 <- p %*% c(v43, 6, 6, 6)
  v24 <- v42

  #n=5
  v41 <- p %*% c(v42, v43, v44, 5)
  p32_1 <- v42>v33 #前に詰めるべきかどうか？
  v32 <- p %*% c(if(p32_1){v42}else{v33}, v43, 5, 5)
  v23 <- v32
  v14 <- v41

  #n=4
  v40 <- p %*% c(v41, v42, v43, v44)
  p31_1 <- v41 > v32
  v31 <- p %*% c(if(p31_1){v41}else{v32}, v33, v43, 4)
  v22 <- p %*% c(v32, v42, 4, 4)
  v13 <- v31
  v04 <- v40

  #n=3
  p30_1 <- v40>v31
  v30 <- p %*% c(if(p30_1){v40}else{v31}, v32, v33, v34)
  p21_1 <- v31>v22
  p21_2 <- v41>v32
  v21 <- p %*% c(if(p21_1){v31}else{v22}, if(p21_2){v41}else{v32}, v42, 3)
  v12 <- v21
  v03 <- v30

  #n=2
  p20_1 <- v30>v21
  p20_2 <- v40>v22
  v20 <- p %*% c(if(p20_1){v30}else{v21}, if(p20_2){v40}else{v22}, v23, v24)
  v11 <- p %*% c(v21, v31, v41, 2)
  v02 <- v20

  #n=1
  p10_1 <- v20>v11
  p10_2 <- v30>v12
  p10_3 <- v40>v13
  v10 <- p %*% c(if(p10_1){v20}else{v11}, if(p10_2){v30}else{v12}, if(p10_3){v40}else{v13}, v14)
  v01 <- v10

  #n=0
  v00 <- p %*% c(v10, v20, v30, v40)

  #sim result
  list_value <- list(v00=v00,
		    v10=v10, v01=v01,
		    v20=v20, v11=v11, v02=v02,
		    v30=v30, v21=v21, v12=v12, v03=v03,
		    v40=v40, v31=v31, v22=v22, v13=v13, v04=v04,
		    v41=v41, v32=v32, v23=v23, v14=v14,
		    v42=v42, v33=v33, v24=v24,
		    v43=v43, v34=v34,
		    v44=v44
		    )
  list_policy <- list(p32_1=p32_1, p31_1=p31_1, p30_1=p30_1, p21_1=p21_1, p21_2=p21_2, p20_1=p20_1, p20_2=p20_2,
		    p10_1=p10_1, p10_2=p10_2, p10_3=p10_3
		    )

  return(list(prob = p, value = list_value, policy = list_policy))
}


get_transfer <- function(prob,policy){
  pival <- function(i,j,k,op){
    prob <- prob[k]
    policy <- policy[[paste0("p",i,j,"_",k)]]
    if (op){
      out <- prob * policy
    } else {
      out <- prob * (!policy)
    }
    return(out)
  }

  u10 <- c(0, pival(1,0,1,T), pival(1,0,1,F), pival(1,0,2,T), pival(1,0,2,F), pival(1,0,3,T), pival(1,0,3,F), 0, prob[4], 0,0,0,0,0)
  u20 <- c(0, 0, 0, pival(2,0,1,T), pival(2,0,1,F), pival(2,0,2,T), 0, pival(2,0,2,F), 0, prob[3], prob[4], 0, 0, 0)
  u11 <- c(0,0,0,0,prob[1],0,prob[2],0,prob[3],0,0,0,0,0)
  u30 <- c(0,0,0,0,0, pival(3,0,1,T), pival(3,0,1,F), 0, 0, prob[2], 0, prob[3], prob[4],0)
  u21 <- c(0,0,0,0,0,0, pival(2,1,1,T), pival(2,1,1,F),pival(2,1,2,T), pival(2,1,2,F), prob[3], 0, 0, 0)
  u40 <- c(rep(0,8),prob[1],0,prob[2],0,prob[3],prob[4])
  u31 <- c(rep(0,8),pival(3,1,1,T), pival(3,1,1,F), 0, prob[2], prob[3], 0)
  u22 <- c(rep(0,9),prob[1],prob[2],0,0,0)
  u41 <- c(rep(0,10),prob[1],0,prob[2],prob[3])
  u32 <- c(rep(0,10),pival(3,2,1,T), pival(3,2,1,F), prob[2], 0)
  u42 <- c(rep(0,12),prob[1],prob[2])
  u33 <- c(rep(0,12),prob[1],0)
  u43 <- c(rep(0,13),prob[1])
  u44 <- c(rep(0,14))

  u <- matrix(c(
		u10,
		u20, u11,
		u30, u21,
		u40, u31, u22,
		u41, u32,
		u42, u33,
		u43,
		u44
		), ncol=14, byrow=TRUE)

  d10 <- rep(0,14)
  d20 <- rep(0,14)
  d11 <- c(rep(0,5),prob[4],rep(0,8))
  d30 <- rep(0,14)
  d21 <- c(rep(0,5),prob[4],rep(0,8))
  d40 <- rep(0,14)
  d31 <- c(rep(0,5),prob[4],rep(0,8))
  d22 <- c(rep(0,3),prob[3],0,prob[4],rep(0,8))
  d41 <- c(rep(0,5),prob[4],rep(0,8))
  d32 <- c(rep(0,3),prob[3],0,prob[4],rep(0,8))
  d42 <- c(rep(0,3),prob[3],0,prob[4],rep(0,8))
  d33 <- c(0, prob[2],0,prob[3],0,prob[4],rep(0,8))
  d43 <- c(0, prob[2],0,prob[3],0,prob[4],rep(0,8))
  d44 <- c(prob[1], prob[2],0,prob[3],0,prob[4],rep(0,8))
  d <- matrix(c(d10, d20,d11, d30,d21, d40,d31,d22, d41,d32, d42,d33, d43, d44), ncol=14, byrow=TRUE)

  return(list(u = u,d = d, t = u+d))
}

get_stationary <- function(transfer){
  ev <- transfer %>% t %>% eigen
  ev1 <- ev$vectors[,near(ev$values,1)]
  stationary_state <- Re(ev1/sum(ev1))

  return(stationary_state)
}

get_occupancy <- function(stationary, mat_d){
  prob_dispatch <- sum(stationary %*% mat_d)

  seat_provided <- c(1,2,2,3,3,4,4,4,5,5,6,6,7,8)
  occp_dispatch <- sum(stationary %*% diag(seat_provided) %*% mat_d)
  return(occp_dispatch)
}

sim_grid <- function(grid = 0.01){
  p_grid <- seq(0, 1, by = grid)
  df <- tibble(p1 = p_grid, p2 = p_grid, p3 = p_grid) %>%
      data_grid(p1,p2,p3) %>%
      mutate(p4 = 1-p1-p2-p3) %>%
      filter(p4>0) %>%
      mutate(
	     sim = pmap(list(p1,p2,p3,p4), get_v),
	     sim_policy = map(sim, "policy"),
	     sim_prob = map(sim, "prob"),
	     transfers = map2(sim_prob, sim_policy, get_transfer),
	     stationary = map(transfers, "t") %>% map(get_stationary),
	     mat_dispatch = map(transfers, "d"),
	     expect_occupancy = map2_dbl(stationary, mat_dispatch, get_occupancy)

      )

  return(df)
}

do_sim <- TRUE
if (do_sim){
  df <- sim_grid(0.01)
  #write_rds("simnmr_df.rds")
} else {
  df <- read_rds("simmnr_df.rds")
}

## policy choice visualization
#df_policy <- df %>%
#    mutate(policy = map(sim, ~.x$policy)) %>%
#    select(-sim) %>%
#    unnest(policy) %>%
#    mutate(
#  	 policy_name = names(policy),
#  	 policy_value = map_lgl(policy, ~.x)
#    )%>%
#  select(-policy)
#df_policy %>% filter(p1==0.1) %>% ggplot(aes(p2, p3)) + geom_point(aes(color = policy_value)) + facet_wrap(~policy_name)


