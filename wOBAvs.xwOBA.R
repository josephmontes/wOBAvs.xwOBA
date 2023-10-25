# 'tidyverse' is mainly used to manipulate data
library(tidyverse)

# DATA

## BATTING DATA

allbdat <- ### LOAD BATTING DATA (from 2019-2023 for my analysis)


  ### Calculate spray angle of each batted ball
  
  allbdat$spray_angle <- with(allbdat, round((atan((hc_x-125.42)/(198.27-hc_y))*180/pi*.75),1))
  
  
  ### Use spray angle calculation (and batter handedness) to label the direction of each hit ball in the column 'hit_direction'
  
  allbdat <- allbdat %>%
    mutate(hit_direction = case_when(
      stand == "R" & spray_angle <= -15 ~ "pull",
      stand == "L" & spray_angle >= 15 ~ "pull",
      abs(spray_angle) < 15 ~ "center",
      stand == "R" & spray_angle >= 15 & spray_angle <= 45 ~ "oppo",
      stand == "L" & spray_angle <= -15 & spray_angle >= -45 ~ "oppo",
      TRUE ~ NA
    ))
  
  
  ### Create an xwoba_value column that includes all outcomes
  
  allbdat <- allbdat %>% 
    mutate(xwoba_value = ifelse(!is.na(estimated_woba_using_speedangle), 
                                estimated_woba_using_speedangle, woba_value))


## Repeat for PITCHING DATA
p23 <- ### LOAD PITCHING DATA (from 2019-2023 for my analysis)

pdat$pfx_z_in <- NULL
pdat$pfx_x_in_pv <- NULL
pdat$count <- NULL

allpdat <- rbind(pdat, pdat20, pdat21, pdat, p23)

  allpdat$spray_angle <- with(allpdat, round((atan((hc_x-125.42)/(198.27-hc_y))*180/pi*.75),1))
  
  allpdat <- allpdat %>%
    mutate(hit_direction = case_when(
      stand == "R" & spray_angle <= -15 ~ "pull",
      stand == "L" & spray_angle >= 15 ~ "pull",
      abs(spray_angle) < 15 ~ "center",
      stand == "R" & spray_angle >= 15 & spray_angle <= 45 ~ "oppo",
      stand == "L" & spray_angle <= -15 & spray_angle >= -45 ~ "oppo",
      TRUE ~ NA
    ))
  
  allpdat <- allpdat %>% 
    mutate(xwoba_value = ifelse(!is.na(estimated_woba_using_speedangle), 
                                estimated_woba_using_speedangle, woba_value))


## CHART DATA

  ### Isolate necessary columns, filter out NA's, create 'combo' column that combines 'hit_direction' and 'bb_type' to create the 12 categories
  
  cdat <-  allbdat %>% 
    select(game_year, player_name, bb_type, hit_direction, spray_angle, hc_x, hc_y, woba_value, estimated_woba_using_speedangle) %>% 
    filter(!is.na(hit_direction) & !is.na(bb_type)) %>% 
    mutate(combo = paste(hit_direction, bb_type, sep = " "),
           xwoba_value = ifelse(!is.na(estimated_woba_using_speedangle), estimated_woba_using_speedangle, woba_value),
           num = 1,
           cfb = ifelse(combo == "center fly_ball",1,0),
           pfb = ifelse(combo == "pull fly_ball",1,0),
           ogb = ifelse(combo == "oppo ground_ball",1,0),
           pld = ifelse(combo == "pull line_drive",1,0),
           fb = ifelse(bb_type == "fly_ball",1,0),
           hit = ifelse(bb_type %in% c("fly_ball", "ground_ball", "popup", "line_drive"),1,0))



  ### MAKE THE CHART
  cdat %>% group_by(combo) %>% 
           summarise(wOBA = round(mean(woba_value, na.rm = T),3),
                     xwOBA = round(mean(xwoba_value, na.rm = T),3),
                     d_wOBA = round(wOBA - xwOBA,3),
                     freq = n()) %>% 
    mutate(rate = round(100*(freq/sum(freq)),1)) %>% 
    filter(freq >2) %>% 
    select("bb_type" = combo, wOBA, xwOBA, d_wOBA, rate) %>% 
    arrange(desc(d_wOBA))


## DATA USED FOR BATTERS LISTS ('ldat')
  
ldat <-  allbdat %>% 
  select(game_year, player_name, bb_type, hit_direction, spray_angle, hc_x, hc_y, woba_value, estimated_woba_using_speedangle) %>% 
  mutate(combo = paste(hit_direction, bb_type, sep = " "),
         xwoba_value = ifelse(!is.na(estimated_woba_using_speedangle), estimated_woba_using_speedangle, woba_value),
         num = ifelse(combo %in% c("pull ground_ball", "oppo ground_ball", "center line_drive",
                                   "center fly_ball", "pull line_drive", "pull popup", "center popup",
                                   "oppo line_drive", "center ground_ball", "oppo fly_ball", "oppo popup",
                                   "pull fly_ball"),1,0),
         sfb = ifelse(combo == "center fly_ball",1,0),
         pfb = ifelse(combo == "pull fly_ball",1,0),
         ogb = ifelse(combo == "oppo ground_ball",1,0),
         pld = ifelse(combo == "pull line_drive",1,0),
         fb = ifelse(bb_type == "fly_ball",1,0),
         hit = ifelse(bb_type %in% c("fly_ball", "ground_ball", "popup", "line_drive"),1,0)) %>% 
  group_by(player_name, game_year) %>% 
  summarise(woba = mean(woba_value, na.rm = TRUE),
            xwoba = mean(xwoba_value, na.rm = TRUE),
            d_woba = round(woba - xwoba, 3),
            sfb_pct = 100 * sum(sfb) / sum(num),
            pfb_pct = 100 * sum(pfb) / sum(num),
            ogb_pct = 100 * sum(ogb) / sum(num),
            pld_pct = 100 * sum(pld) / sum(num),
            freq = n()) %>% 
  mutate(g_plus = ogb_pct + pfb_pct) %>% 
  filter(freq >= 1500)


## BATTER LIST 1 ('ldat_a')

ldat_a <- ldat %>% 
  filter(g_plus >= 15) %>% 
  mutate(woba = round(woba,3),
         xwoba = round(xwoba, 3),
         sfb_pct = round(sfb_pct,1),
         pfb_pct = round(pfb_pct,1),
         ogb_pct = round(ogb_pct,1),
         g_plus = round(g_plus,1)) %>% 
  select(game_year, player_name, woba, xwoba, d_woba,g_plus, pfb_pct, ogb_pct, sfb_pct, freq)

  ### LOAD SPRINT SPEED DATA (from Baseball Savant leaderboard)
  ss <- read.csv("sprint_speed.csv")
  
  ### EDIT NAME COLUMN SO IT CAN BE MERGE WITH LDAT
  ss$player_name <- paste(ss$last_name, ss$first_name, sep=",")
  
  ### MERGE WITH LDAT_A WITH SPRINT SPEED DATA
  ldat_a <- left_join(ldat_a, ss, by= "player_name")
  ldat_a <- ldat_a %>% select(game_year, player_name, woba, xwoba, d_woba, g_plus,
                              pfb_pct, ogb_pct, sfb_pct, freq, sprint_speed)


## BATTER LIST 2 ('ldat_b')
  
ldat_b <- ldat %>% 
  filter(sfb_pct >=17 & pfb_pct <= 10) %>% 
  mutate(woba = round(woba,3),
         xwoba = round(xwoba, 3),
         sfb_pct = round(sfb_pct,1),
         pfb_pct = round(pfb_pct,1),
         ogb_pct = round(ogb_pct,1)) %>% 
  select(game_year, player_name, woba, xwoba, d_woba, sfb_pct, pfb_pct, ogb_pct, freq)

  ### MERGE SPRINT SPEED DATA
  ldat_b <- left_join(ldat_b, ss, by= "player_name")
  ldat_b <- ldat_b %>% select(game_year, player_name, woba, xwoba, d_woba,
                              pfb_pct, ogb_pct, sfb_pct, freq, sprint_speed)


## DATA USED FOR PITCHERS LISTS ('lpdat')

lpdat <- allpdat %>% 
  mutate(pitch_team = ifelse(inning_topbot == "Bot", away_team, home_team)) %>% 
  select(game_year, player_name, bb_type, hit_direction, spray_angle, hc_x, hc_y, 
         woba_value, estimated_woba_using_speedangle, pitch_team) %>% 
  mutate(combo = paste(hit_direction, bb_type, sep = " "),
         xwoba_value = ifelse(!is.na(estimated_woba_using_speedangle), estimated_woba_using_speedangle, woba_value),
         num = ifelse(combo %in% c("pull ground_ball", "oppo ground_ball", "center line_drive",
                                   "center fly_ball", "pull line_drive", "pull popup", "center popup",
                                   "oppo line_drive", "center ground_ball", "oppo fly_ball", "oppo popup",
                                   "pull fly_ball"),1,0),
         sfb = ifelse(combo == "center fly_ball",1,0),
         pfb = ifelse(combo == "pull fly_ball",1,0),
         ogb = ifelse(combo == "oppo ground_ball",1,0),
         pld = ifelse(combo == "pull line_drive",1,0),
         fb = ifelse(bb_type == "fly_ball",1,0),
         hit = ifelse(bb_type %in% c("fly_ball", "ground_ball", "popup", "line_drive"),1,0),
         team = pitch_team) %>% 
  group_by(player_name, game_year, pitch_team) %>% 
  summarise(woba = mean(woba_value, na.rm = TRUE),
            xwoba = mean(xwoba_value, na.rm = TRUE),
            d_woba = round(woba - xwoba, 3),
            sfb_pct = 100 * sum(sfb) / sum(num),
            pfb_pct = 100 * sum(pfb) / sum(num),
            ogb_pct = 100 * sum(ogb) / sum(num),
            pld_pct = 100 * sum(pld) / sum(num),
            freq = n()) %>% 
  mutate(g_plus = ogb_pct + pfb_pct) %>% 
  filter(freq >= 2500)

  ### LOAD AND EDIT THE OAA DATA SO IT CAN BE MERGED WITH THE PITCHER LISTS (OAA comes from Baseball Savant)
  oaa <- read.csv('outs_above_average.csv')

    #### In order to eventually combine this OAA dataframe with our list of pitchers,
    #### The 'team name' column from OAA needs to be changed from team names to team abbreviations
    #### To do this we will create the following separate dataframes
    
    team_names <- c("Orioles", "Red Sox", "White Sox", "Guardians", "Tigers", 
                    "Astros", "Royals", "Angels", "Twins", "Yankees", 
                    "Athletics", "Mariners", "Rays", "Rangers", "Blue Jays",
                    "D-backs", "Braves", "Cubs", "Reds", "Rockies", 
                    "Dodgers", "Marlins", "Brewers", "Mets", "Phillies", 
                    "Pirates", "Padres", "Giants", "Cardinals", "Nationals")
    
    abbreviations <- c("BAL", "BOS", "CWS", "CLE", "DET", "HOU", "KC", "LAA", "MIN", "NYY",
                       "OAK", "SEA", "TB", "TEX", "TOR", "AZ", "ATL", "CHC", "CIN", "COL",
                       "LAD", "MIA", "MIL", "NYM", "PHI", "PIT", "SD", "SF", "STL", "WSH")
    
    ##### Combine these tables
    
    mlb_teams <- data.frame(team_name = team_names, Abbreviation = abbreviations)
    
    
    ##### Now the team name column in oaa can be changed to abbreviations 
    
    oaa <- merge(oaa, mlb_teams, by="team_name")
    
    
    ##### Clean the data
    oaa$team_name <- NULL
    oaa$team_name <- oaa$Abbreviation
    oaa$Abbreviation <- NULL
    
    #### The 'year' column just needs to be retitled to 'game_year'
    oaa$year <- NULL
    oaa$game_year <- oaa$year
    
    
  ### Create a 'teamID' column using the abbreviation and game year, 'teamID' will be used to combine oaa with the pitcher lists
    
  oaa <- oaa %>% mutate(teamID = paste(game_year, team_name))


## PITCHER LIST 1 ('lpdat_b')
  
lpdat_b <- lpdat %>% 
    filter(sfb_pct >=13.8 & pfb_pct <= 6.8) %>% 
    mutate(woba = round(woba,3),
           xwoba = round(xwoba, 3),
           sfb_pct = round(sfb_pct,1),
           pfb_pct = round(pfb_pct,1),
           ogb_pct = round(ogb_pct,1),
           team_name = pitch_team) %>% 
    select(game_year, player_name, woba, xwoba,
           d_woba, sfb_pct, pfb_pct, ogb_pct, freq, team_name)
  
  ### Create teamID column here too
  lpdat_b <- lpdat_b %>% mutate(teamID = paste(game_year, team_name))
  
  ### Merge with oaa data
  lpdat_b <- left_join(lpdat_b, oaa, by= "teamID")
  
  ### Isolate necessary columns
  lpdat_b <- lpdat_b %>% select(game_year.x,  player_name, woba, xwoba, d_woba, sfb_pct,
                                pfb_pct, ogb_pct, team_name.x, outs_above_average)


## PITCHER LIST 2 ('lpdat_a')
  
lpdat_a <- lpdat %>% 
    filter(g_plus >= 13) %>% 
    mutate(woba = round(woba,3),
           xwoba = round(xwoba, 3),
           sfb_pct = round(sfb_pct,1),
           pfb_pct = round(pfb_pct,1),
           ogb_pct = round(ogb_pct,1),
           g_plus = round(g_plus,1),
           team_name = pitch_team) %>% 
    select(game_year, player_name, woba, xwoba,
           d_woba,  g_plus, pfb_pct, ogb_pct, sfb_pct, freq, team_name)
  
  ### Create teamID column here too
  
  lpdat_a <- lpdat_a %>% mutate(teamID = paste(game_year, team_name))
  
  ### Join the pitcher list with oaa data
  
  lpdat_a <- left_join(lpdat_a, oaa, by= "teamID")
  
  ### Isolate necessary columns
  lpdat_a <- lpdat_a %>% select(game_year.x, player_name, woba, xwoba, d_woba,
                                g_plus, pfb_pct, ogb_pct, sfb_pct, team_name.x, outs_above_average)



## OVERALL LIST ANALYSES
  
  ### NOTES LIST 1
  mean(ldat_a$woba)
  mean(ldat_a$xwoba)
  mean(ldat_a$sprint_speed, na.rm = T)

  ### FUNCTIONS FOR PLAYER ANALYSES

    #### 'find_woba()' FUNCTION TO FIND A PLAYER'S wOBA vs. xwOBA ACROSS SEASONS
    find_woba <- function(data, player){
      data %>% filter(player_name == player) %>% 
        group_by(game_year) %>% 
        summarise(wOBA = mean(woba_value, na.rm = T),
                  xwOBA = mean(xwoba_value, na.rm = T),
                  d_wOBA = wOBA - xwOBA,
                  freq = n()
        ) %>% 
        filter(freq >1500) %>% select(game_year, wOBA, xwOBA, d_wOBA)
      
    }
    
    #### 'find_player()' FUNCTION TO FIND ANY PLAYER FROM ANY SEASON'S wOBA vs. xwOBA PERFORMANCE ON THE 12 TYPES OF BATTED BALLS
    find_player <- function(data, player, year){
      data %>% filter(player_name == player & game_year == year) %>% 
        group_by(combo) %>% 
        summarise(wOBA = round(mean(woba_value, na.rm = T),3),
                  xwOBA = round(mean(xwoba_value, na.rm = T),3),
                  d_wOBA = round(wOBA - xwOBA,3),
                  freq = n()
        ) %>% 
        mutate(rate = round(100*(freq/sum(freq)),1)) %>% 
        filter(freq >2) %>% select("bb_type" = combo, wOBA, xwOBA, d_wOBA, rate) %>% arrange(desc(d_wOBA))
      
    }


    #### ISAAC PAREDES
    find_woba(allbdat, "Paredes, Isaac")
    
    find_player(cdat, "Paredes, Isaac", "2022")
    find_player(cdat, "Paredes, Isaac", "2023")
    
    
    #### BO BICHETTE
    find_woba(allbdat, "Bichette, Bo")
    
    find_player(cdat, "Bichette, Bo", "2021")
    find_player(cdat, "Bichette, Bo", "2022")
    find_player(cdat, "Bichette, Bo", "2023")

  ### NOTES LIST 2
  mean(ldat_b$woba)
  mean(ldat_b$xwoba)
  mean(ldat_b$sprint_speed, na.rm = T)


    #### MATT CHAPMAN
    find_woba(allbdat, "Chapman, Matt") %>% filter(game_year >= 2021)
    
    find_player(allbdat, "Chapman, Matt", "2021")
    find_player(allbdat, "Chapman, Matt", "2022")
    find_player(allbdat, "Chapman, Matt", "2023")


  ### NOTES LIST 3
  mean(lpdat_b$woba)
  mean(lpdat_b$xwoba)
  mean(lpdat_b$outs_above_average)


    #### MAX SCHERZER
    find_woba(allpdat, "Scherzer, Max")
    
    find_player(cpdat, "Scherzer, Max", "2021")
    find_player(cpdat, "Scherzer, Max", "2022")
    find_player(cpdat, "Scherzer, Max", "2023")


  ### NOTES LIST 4
  mean(lpdat_a$woba)
  mean(lpdat_a$xwoba)
  mean(lpdat_a$outs_above_average)

    #### JOSIAH GRAY
    find_woba(allpdat, "Gray, Josiah")
    
    find_player(cpdat, "Gray, Josiah", "2021")
    find_player(cpdat, "Gray, Josiah", "2022")
    find_player(cpdat, "Gray, Josiah", "2023")
    
    
    #### ANDRE PALLANTE
    find_woba(allpdat, "Pallante, Andre")
    
    find_player(cpdat, "Pallante, Andre", "2022")
    find_player(cpdat, "Pallante, Andre", "2023")




## CALCULATE THE PERCENTILE VALUE CHOSEN FROM THE BATTER LISTS (pitcher lists were just 75th percentile)
    
  ### LIST 1
  ecdf_function <- ecdf(ldat$g_plus)
    
    #### Calculate the percentile rank for a specific value, e.g., 18
    percentile_rank <- ecdf_function(15)
    
    #### Convert it to a percentage
    percentile_rank_percent <- percentile_rank * 100
    
    #### Print the result
    cat("The percentile rank of 15 is", percentile_rank_percent, "%")
  
  ### LIST 2
  ecdf_function <- ecdf(ldat$sfb_pct)
  
    #### Calculate the percentile rank for a specific value, e.g., 18
    percentile_rank <- ecdf_function(17)
    
    #### Convert it to a percentage
    percentile_rank_percent <- percentile_rank * 100
    
    #### Print the result
    cat("The percentile rank of 17 is", percentile_rank_percent, "%")
  


