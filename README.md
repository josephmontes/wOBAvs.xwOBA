# Analyzing wOBA vs. xwOBA differences by Batted Ball Types
## Intro

In this baseball project, I use Statcast pitch-by-pitch data from 2019 to 2023 in RStudio to examine the types of batted balls that lead to a player's wOBA outperforming their xwOBA
- More specifically, I categorize each batted ball into 1 of 12 different groups by using the following 2 characteristics: horizontal launch angle component - ***Pull, Center, Oppo*** and vertical launch angle component - ***Flyball, Groundball, Linedrive, Popup*** in an attempt to identify wOBA vs. xwOBA differences by batted ball type
  - Ex: Pull Flyball, Oppo Groundball, Center Linedrive, etc.
- If there are notable differences in league-wide wOBA and xwOBA based on this categorization, then any individual player's overall wOBA vs. xwOBA difference needs to be looked at more closely
- I am not implying that batters or pitchers have complete control over the type of batted ball that occurs *on an at-bat by at-bat basis*, but there are likely tendencies developed through a player's approach, mechanics, pitch usage, etc. that lead to consistent variations in their batted ball types *over the course of a season* (especially for batters)

The motivation for this analysis is that xwOBA is often used to explain that a player may be experiencing good or bad 'luck', but if there are specific types of batted balls that generally lead to notable differences in wOBA vs. xwOBA, then it is likely that a player's overall wOBA/xwOBA difference is less about luck and more about the way that player hits the ball, or how it is hit against them
- Ultimately, this project aims to identify some level of skill that may be misattributed as luck, and to identify players that exhibit this distinction

## Analysis
It is known that a *batter's* **above average sprint speed** can lead to ***outperforming*** his xwOBA and a *pitching team's* **above average defense** can lead the batter to ***underperforming*** his xwOBA 
- This project is not focused on the batter's sprint speed or the pitching team's defense

The xwOBA value used in this project comes from Statcast's 'estimated_woba_using_speedangle' column 
  - This calculation of xwOBA only takes into account the **launch speed** and the *vertical* **launch angle** of the batted ball

This project is focused on the *horizontal* component of launch angle (**spray angle**) to see what xwOBA is missing by excluding it
- The spray angle of every batted ball in the dataset is calculated using Statcast's hit coordinates (hc_x, hc_y) in the following snippet of code
  
  ```allbdat$spray_angle <- with(allbdat, round((atan((hc_x-125.42)/(198.27-hc_y))*180/pi*.75),1))```

- The next snippet of code shows how each spray angle calculation, along with the handedness of the batter, is used to make the column ('hit_direction') that labels each of the batted balls as 'Pull', 'Center', or 'Oppo'
  - True Center is when spray_angle = 0
  
  ```
  allbdat <- allbdat %>%
    mutate(hit_direction = case_when(
           stand == "R" & spray_angle <= -15 ~ "pull",
           stand == "L" & spray_angle >= 15 ~ "pull",
           abs(spray_angle) < 15 ~ "center",
           stand == "R" & spray_angle >= 15 & spray_angle <= 45 ~ "oppo",
           stand == "L" & spray_angle <= -15 & spray_angle >= -45 ~ "oppo",
           TRUE ~ NA
  ))
  ```

- Statcast's 'bb_type' column was used to label fly_ball, ground_ball, line_drive, or popup
 
#### The table below shows the wOBA vs. xwOBA value for each of the 12 distinct types of batted balls
  - 'd_wOBA' is wOBA - xwOBA
  - 'rate' is each batted ball type's frequency as a percentage

  ![Screenshot 2023-10-06 132953](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/fd4cd8ed-c84c-440b-98d9-21fe8991295b)

This table shows that the type of batted balls that are most likely to lead to a *batter* outperforming their xwOBA are: ***Pulled Flyballs*** and ***Oppo Groundballs***
 - To understand why **Pulled Flyballs** lead to the largest *positive* difference in wOBA and xwOBA, it could help to look at the type of batted ball that leads to the largest *negative* difference in wOBA and xwOBA: **Center Flyballs** 
    - Think of it this way; If a ball is hit with 98 mph launch speed and 30° launch angle, then it will have a *high* ***xwOBA*** based on the fact that most balls hit 30°/98mph are able to find a gap or fence to go over for a homerun. But if that 30°/98mph Flyball is hit to Center, then it is more likely that there will be room for a defender to make an out
    - So why don't we see this effect for Oppo Flyballs? Because batters generally have more power to their pull side
      - This can be confirmed by the significantly lower xwOBA value on Oppo Flyballs (.234) compared to Pull Flyballs (.663) in the table above
  - To understand why **Oppo Groundballs** are listed here, it could help to look at the most frequent of the 12 batted ball types, **Pulled Groundballs** at 22%
    - Oppo Groundballs are hit at much lower rate, 5.5%, this difference forces defenses to generally position themselves anticipating a Pulled Groundball, so when a Oppo Groundball is hit the defense tends to be less optimally positioned to defend it
    - This makes the Oppo Groundball more likely to find a hole, which increases wOBA while the xwOBA remains similar between the 2 type of batted balls 
 

# Players
## Batters
### List of batters with >= 75th percentile 'PFB+OGB%'
- The upper 75th percentile value for PFB+OGB% is **15%**
- PFB is Pulled Flyball%
  - the upper 75th percentile value for PFB% is 7.3%
- OGB is Oppo Groundball%
  - the upper 75th percentile value for OGB% is 7%
- I could have weighted Pull Flyballs more heavily in the PFB+OGB% to more accurately reflect their potential xwOBA value, but I just want to provide a quick screenshot of players that Pull Flyballs, hit Oppo Groundballs, or a bit of both

| Season    | Player Name      | wOBA | xwOBA | d_wOBA | PFB+OGB% | PULL FB% | OPPO GB% |CENTER FB%| Sprint Speed (ft/s)|
|-----------|------------------|------|-------|--------|----------|----------|----------|----------|-------------------|
| 2023      | Bo Bichette      | 0.373| 0.367 | 0.006  | 21.1%    | 3.8%    | 17.3%   | 8.1%    | 27.7 ft/s    |
| 2022      | Nico Hoerner     | 0.330| 0.296 | 0.034  | 18.9%    | 7.7%    | 11.2%   | 8.9%    | 28.8 ft/s    |
| 2022      | Isaac Paredes    | 0.328| 0.298 | 0.030  | 18.7%    | 13.0%   | 5.7%    | 9.5%    | 26.1 ft/s    |
| 2022      | Joey Gallo       | 0.291| 0.299 | -0.007 | 18.2%    | 15.6%   | 2.6%    | 18.8%   | 27.3 ft/s    |
| 2023      | Isaac Paredes (2x)| 0.376| 0.320| 0.056  | 18.0%    | 13.9%   | 4.1%    | 12.4%   | 26.1 ft/s    |
| 2021      | Patrick Wisdom   | 0.356| 0.322 | 0.034  | 17.9%    | 15.2%   | 2.7%    | 15.8%   | 27.9 ft/s    |
| 2023      | James Outman     | 0.346| 0.314 | 0.032  | 17.9%    | 11.0%   | 6.9%    | 11.9%   | 28.8 ft/s    |
| 2022      | Bo Bichette (2x) | 0.353| 0.327 | 0.026  | 17.8%    | 2.8%    | 15.0%   | 9.9%    | 27.7 ft/s    |
| 2021      | David Fletcher   | 0.288| 0.273 | 0.015  | 17.2%    | 4.1%    | 13.1%   | 7.8%    | 27.5 ft/s    |
| 2023      | Lourdes Gurriel  | 0.340| 0.327 | 0.013  | 17.1%    | 5.8%    | 11.3%   | 13.4%   | 27.0 ft/s    |
| 2023      | Manny Machado    | 0.348| 0.340 | 0.008  | 17.0%    | 7.7%    | 9.3%    | 11.8%   | 26.4 ft/s    |
| 2022      | Jack Suwinski    | 0.315| 0.302 | 0.013  | 16.9%    | 12.2%   | 4.7%    | 13.1%   | 28.6 ft/s    |
| 2023      | Javier Báez      | 0.275| 0.264 | 0.011  | 16.9%    | 6.9%    | 10.0%   | 7.8%    | 28.3 ft/s    |
| 2021      | Brandon Belt     | 0.412| 0.377 | 0.035  | 16.7%    | 13.1%   | 3.6%    | 18.5%   | 25.3 ft/s    |
| 2023      | Geraldo Perdomo  | 0.338| 0.282 | 0.056  | 16.7%    | 10.5%   | 6.2%    | 11.2%   | 27.2 ft/s    |
| 2023      | Paul Goldschmidt | 0.356| 0.369 | -0.013 | 16.3%    | 4.7%    | 11.6%   | 11.9%   | 26.4 ft/s    |
| 2022      | Paul Goldschmidt(2x)| 0.432| 0.373| 0.059| 16.2%    | 8.8%    | 7.4%    | 13.6%   | 26.4 ft/s    |
| 2022      | Randal Grichuk   | 0.320| 0.278 | 0.042  | 16.2%    | 5.7%    | 10.4%   | 12.3%   | 27.9 ft/s    |
| 2023      | Nico Hoerner (2x)| 0.336| 0.300 | 0.036  | 16.2%    | 3.6%    | 12.6%   | 9.8%    | 28.8 ft/s    |
| 2019      | Xander Bogaerts  | 0.414| 0.355 | 0.059  | 16.1%    | 8.3%    | 7.9%    | 10.4%   | 27.8 ft/s    |
| 2019      | Lorenzo Cain     | 0.319| 0.323 | -0.004 | 16.1%    | 2.2%    | 13.9%   | 6.7%    | NA           |
| 2023      | Marcell Ozuna    | 0.341| 0.361 | -0.020 | 16.0%    | 8.6%    | 7.4%    | 14.4%   | 26.9 ft/s    |
| 2021      | Mike Zunino      | 0.374| 0.358 | 0.016  | 16.0%    | 14.5%   | 1.5%    | 13.5%   | 26.1 ft/s    |
| 2023      | Hunter Renfroe   | 0.330| 0.293 | 0.037  | 16.0 %   | 10.7%   | 5.2%    | 10.7%   | 27.1 ft/s    |
| 2019      | José Iglesias    | 0.329| 0.294 | 0.035  | 16.0%    | 4.9%    | 11.0%   | 10.1%   | NA           |
| 2022      | Byron Buxton     | 0.381| 0.365 | 0.016  | 15.9%    | 12.9%   | 3.0%    | 15.1%   | 29.9 ft/s    |
| 2019      | Nolan Arenado    | 0.427| 0.353 | 0.073  | 15.9%    | 8.2%    | 7.6%    | 11.8%   | 25.4 ft/s    |
| 2023      | Max Muncy        | 0.364| 0.384 | -0.019 | 15.8%    | 14.4%   | 1.4%    | 18.5%   | 27.2 ft/s    |
| 2019      | José Ramírez     | 0.349| 0.337 | 0.013  | 15.8%    | 11.0%   | 4.8%    | 11.0%   | 28.1 ft/s    |
| 2021      | Raimel Tapia     | 0.323| 0.265 | 0.058  | 15.8%    | 2.2%    | 13.6%   | 5.0%    | 28.3 ft/s    |
| 2022      | Ramón Urías      | 0.321| 0.318 | 0.002  | 15.6%    | 6.5%    | 9.0%    | 11.2%   | 26.8 ft/s    |
| 2022      | Gavin Sheets     | 0.321| 0.294 | 0.027  | 15.6%    | 7.6%    | 8.0%    | 10.0%   | 26.6 ft/s    |
| 2022      | Ramón Laureano   | 0.301| 0.302 | -0.001 | 15.5%    | 7.9%    | 7.5%    | 13.4%   | 28.0 ft/s    |
| 2022      | Darin Ruf        | 0.296| 0.308 | -0.013 | 15.5%    | 9.0%    | 6.4%    | 12.9%   | 25.8 ft/s    |
| 2022      | Thairo Estrada   | 0.333| 0.297 | 0.036  | 15.5%    | 6.1%    | 9.3%    | 8.1%    | 28.2 ft/s    |
| 2021      | Adam Duvall      | 0.333| 0.326 | 0.006  | 15.4%    | 13.6%   | 1.8%    | 20.8%   | 28.3 ft/s    |
| 2019      | Robinson Chirinos| 0.362| 0.323 | 0.039  | 15.4%    | 10.2%   | 5.1%    | 13.0%   | NA           |
| 2022      | Jurickson Profar | 0.329| 0.320 | 0.009  | 15.4%    | 7.5%    | 7.9%    | 9.4%    | 26.5 ft/s    |
| 2019      | Trea Turner      | 0.373| 0.327 | 0.046  | 15.2 %   | 5.9%    | 9.3%    | 9.1%    | 30.4 ft/s    |
| 2022      | DJ LeMahieu      | 0.349| 0.347 | 0.002  | 15.2%    | 0.7%    | 14.5%   | 6.4%    | 26.4 ft/s    |
| 2022      | Joc Pederson     | 0.375| 0.363 | 0.012  | 15.1%    | 8.8%    | 6.3%    | 15.8%   | 26.5 ft/s    |
| 2022      | Pete Alonso      | 0.372| 0.358 | 0.014  | 15.1%    | 9.8%    | 5.2%    | 11.9%   | 26.1 ft/s    |
| 2022      | Aaron Hicks      | 0.302| 0.296 | 0.006  | 15.1%    | 7.2%    | 7.9%    | 10.4%   | 27.6 ft/s    |
| 2023      | Marcus Semien    | 0.365| 0.326 | 0.039  | 15.0%    | 12.1%   | 2.9%    | 16.7%   | 28.5 ft/s    |
| 2019      | Delino DeShields | 0.315| 0.276 | 0.039  | 15.0%    | 3.8%    | 11.3%   | 10.2%   | NA           |

### NOTES
- The average d_wOBA for this group is .023
  - wOBA = .345/ xwOBA = .322
  - **The average d_wOBA for qualified batting seasons = .012**, which means that ***this group of batters is outperforming their xwOBA by 92% more than average***
- The average top sprint speed for this group is 27.38 ft/s
  - The overall average top sprint speed in my dataset is 27.5 ft/s
  - This Sprint Speed information comes from Baseball Savant's Sprint Speed Leaderboard that I exported as a CSV and combined in R
- There are 45 different batting seasons listed
  - There is a fairly even number of Pull FB to Oppo GB batting seasons on this list: 24 to 21


### PLAYER SPOTLIGHT
### Isaac Paredes
  - In his first 2 seasons, Paredes' wOBA has notably outperformed his xwOBA despite possessing below average sprint speed (26.1 ft/s)

![Screenshot 2023-10-01 004943](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/38ab2bcb-cd36-4766-ba2d-382725ab3bee)

- Paredes has displayed a skill to Pull Flyballs, which makes him very likely to outperform his xwOBA, despite being a slower runner
  - This makes him a prime example of a batter that cannot be described as 'getting lucky' because of his wOBA/xwOBA difference
  
- Here is the wOBA/xwOBA breakdown by batted ball type for Isaac Paredes in 2022 & 2023

##### 2022
![Screenshot 2023-10-01 005412](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/dac4984d-46ae-4a40-9f8d-fcd3a70ca771)

##### 2023
![Screenshot 2023-10-01 005341](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/0b863bbf-c35c-4bac-9bb6-34b2ce2d7c2a)

- He Pulls Flyballs almost 3 times more than the league average rate
  - League Average: 5.5%
- Another interesting note: in 2022, the wOBA value on Paredes' Oppo Groundballs **underperformed** it's xwOBA value (d_wOBA = -0.113) which is a stark contrast to the league wide trend shown in the table in the Analysis section for Oppo Groundballs (d_wOBA = 0.165)
  - But in 2023, his wOBA against Oppo Groundballs rebounded closer to more normal rates (d_wOBA = 0.245) and his overall wOBA value also benefited from this
    - This seems like a better way to identify a player that might be experiencing good or bad 'luck': by the wOBA/xwOBA difference they experiences on ***specific types of batted balls, not their overall wOBA/xwOBA difference***

#### Nolan Arenado is another prime example of a player who consistently outperforms his xwOBA, despite below average sprint speed, by Pulling Flyballs

### Bo Bichette
  - His wOBA typically outperforms his xwOBA despite hitting Pulled Flyballs at such a low rate (3.5% average)
    - He also possesses average foot speed (27.7 ft/s)
    
![Screenshot 2023-10-01 011233](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/92a29793-25a7-4420-b7f0-575571ec12e3)

- But what's happening to his wOBA/xwOBA difference in 2023?

##### 2021
![Screenshot 2023-10-01 011323](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/8db5d3ec-62a4-4393-b578-e8c953878d32)
##### 2022
![Screenshot 2023-10-01 011335](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/5dc924ce-8b84-4592-bf17-cd182e37d391)
##### 2023
![Screenshot 2023-10-01 011350](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/7e1c699c-16c7-4b90-a56f-6d7c6e691c41)

  - The wOBA value for his Oppo Groundballs has plummeted from .414 to .357 to .267
    - It is reasonable to assume that the removal of the shift in 2023 has hurt batters that were getting by hitting Oppo Groundballs, like Bo Bichette
    - Maybe defenses were bound to make this adjustment against Bichette anyways because of his tendency to hit Oppo GBs so frequently
    - Maybe Bichette is actually experiencing bad luck this year with his Oppo Groundballs (d_wOBA = .031) and is in store for a bit of a bounce back in 2024
  - Regardless, Bo Bichette has exemplified taking advantage of the xwOBA differences on Oppo Groundballs by consistently hitting them over 2x more than the average rate
    - Average Oppo GB% is 5.8%
      
#### DJ LeMahieu is an example of another player comparable to Bo Bichette

### List of batters with >= 75th percentile Center FB rate
- The 75th percentile Center FB% value is **17%**
- Additionally, I filtered out batters with > 10% Pull FB% (average is 7.3%) in an attempt to avoid creating a list of batters that just hit a lot of Flyballs in general
  - This list's aim is to find batters that hit a lot of Flyballs, but also, batters that hit *too many* of their Flyballs to Center 

| Season    | Player Name        | wOBA  | xwOBA | d_wOBA | CENTER FB% | PULL FB% | OPPO GB% | Sprint Speed (ft/s) |
|-----------|--------------------|-------|-------|--------|------------|----------|----------|---------------------|
| 2022      | Mike Trout         | 0.419 | 0.391 | 0.027  | 22.9%      | 9.0%     | 2.7%     | 29.4 ft/s           |
| 2019      | Cavan Biggio       | 0.362 | 0.351 | 0.011  | 21.8%      | 7.3%     | 3.0%     | 28.3 ft/s           |
| 2021      | Will Smith         | 0.376 | 0.361 | 0.015  | 21.1%      | 9.0%     | 1.6%     | 27.5 ft/s           |
| 2023      | J.D. Martinez      | 0.380 | 0.381 | 0.000  | 20.2%      | 7.3%     | 3.9%     | 26.3 ft/s           |
| 2022      | Luke Voit          | 0.315 | 0.323 | -0.009 | 20.1%      | 7.0%     | 2.1%     | 25.2 ft/s           |
| 2023      | MJ Melendez        | 0.308 | 0.318 | -0.010 | 19.9%      | 7.1%     | 2.8%     | 27.7 ft/s           |
| 2021      | Matt Chapman       | 0.319 | 0.319 | 0.000  | 19.9%      | 9.6%     | 1.5%     | 28.3 ft/s           |
| 2022      | Tyrone Taylor      | 0.317 | 0.303 | 0.015  | 19.7%      | 5.0%     | 3.2%     | 28.6 ft/s           |
| 2023      | Matt Olson         | 0.407 | 0.397 | 0.011  | 19.2%      | 9.1%     | 4.6%     | 26.2 ft/s           |
| 2021      | Willy Adames       | 0.365 | 0.323 | 0.043  | 18.8%      | 5.6%     | 2.6%     | 28.0 ft/s           |
| 2019      | Mike Trout (2x)    | 0.453 | 0.451 | 0.001  | 18.8%      | 8.7%     | 5.1%     | 29.4 ft/s           |
| 2022      | David Peralta      | 0.319 | 0.317 | 0.002  | 18.7%      | 4.2%     | 3.0%     | 27.3 ft/s           |
| 2021      | Paul DeJong        | 0.300 | 0.309 | -0.009 | 18.7%      | 8.7%     | 5.2%     | 27.4 ft/s           |
| 2022      | Kyle Schwarber     | 0.361 | 0.380 | -0.020 | 18.6%      | 8.4%     | 2.9%     | 26.5 ft/s           |
| 2019      | Eric Thames        | 0.361 | 0.327 | 0.034  | 18.6%      | 8.0%     | 2.7%     | NA                  |
| 2021      | Joey Gallo         | 0.351 | 0.351 | 0.000  | 18.6%      | 10.0%    | 3.2%     | 27.3 ft/s           |
| 2022      | Kyle Tucker        | 0.350 | 0.355 | -0.005 | 18.5%      | 9.9%     | 3.1%     | 27.1 ft/s           |
| 2019      | Christin Stewart   | 0.303 | 0.315 | -0.012 | 18.4%      | 6.6%     | 5.1%     | NA                  |
| 2022      | Yoán Moncada       | 0.274 | 0.282 | -0.008 | 18.3%      | 3.8%     | 5.5%     | 27.5 ft/s           |
| 2023      | Adolis García      | 0.380 | 0.377 | 0.003  | 18.3%      | 8.0%     | 4.5%     | 28.0 ft/s           |
| 2022      | Salvador Perez     | 0.343 | 0.332 | 0.010  | 18.1%      | 7.0%     | 2.9%     | 25.4 ft/s           |
| 2023      | Jorge Soler        | 0.360 | 0.366 | -0.006 | 18.1%      | 7.6%     | 4.3%     | 26.8 ft/s           |
| 2023      | Ozzie Albies       | 0.348 | 0.325 | 0.022  | 18.1%      | 9.6%     | 0.8%     | 28.2 ft/s           |
| 2022      | Jesús Aguilar      | 0.300 | 0.312 | -0.012 | 18.1%      | 6.2%     | 4.8%     | 24.0 ft/s           |
| 2022      | Taylor Ward        | 0.374 | 0.363 | 0.011  | 18.0%      | 5.7%     | 3.6%     | 28.3 ft/s           |
| 2021      | Enrique Hernández  | 0.348 | 0.346 | 0.002  | 17.9%      | 6.6%     | 2.8%     | 27.2 ft/s           |
| 2022      | Will Smith (2x)    | 0.353 | 0.349 | 0.003  | 17.9%      | 6.1%     | 4.5%     | 27.5 ft/s           |
| 2023      | Eugenio Suárez     | 0.317 | 0.336 | -0.020 | 17.9%      | 8.1%     | 2.1%     | 26.2 ft/s           |
| 2021      | Austin Meadows     | 0.336 | 0.325 | 0.012  | 17.9%      | 9.6%     | 2.3%     | 27.7 ft/s           |
| 2019      | Rhys Hoskins       | 0.360 | 0.339 | 0.021  | 17.9%      | 9.4%     | 1.3%     | NA                  |
| 2022      | Eugenio Suárez     | 0.344 | 0.337 | 0.006  | 17.8%      | 8.6%     | 4.3%     | 26.2 ft/s           |
| 2021      | Mookie Betts       | 0.382 | 0.355 | 0.027  | 17.8%      | 7.6%     | 2.4%     | 27.6 ft/s           | 
| 2021      | Joc Pederson       | 0.329 | 0.333 | -0.005 | 17.7%      | 3.5%     | 5.2%     | 26.5 ft/s           |
| 2019      | Mookie Betts (2x)  | 0.394 | 0.405 | -0.011 | 17.7%      | 5.8%     | 2.0%     | 27.6 ft/s           |
| 2019      | Justin Smoak       | 0.342 | 0.379 | -0.036 | 17.6%      | 6.4%     | 1.6%     | NA                  |
| 2022      | Cody Bellinger     | 0.291 | 0.275 | 0.016  | 17.5%      | 7.8%     | 1.9%     | 28.5 ft/s           |
| 2023      | Pete Alonso        | 0.360 | 0.382 | -0.022 | 17.5%      | 6.6%     | 3.6%     | 26.1 ft/s           |
| 2022      | Luis Urías         | 0.336 | 0.327 | 0.010  | 17.5%      | 8.4%     | 4.5%     | 26.7 ft/s           |
| 2019      | Chris Davis        | 0.280 | 0.296 | -0.016 | 17.4%      | 5.6%     | 2.2%     | NA                  |
| 2019      | Brandon Belt       | 0.334 | 0.358 | -0.024 | 17.3%      | 7.3%     | 3.2%     | 25.3 ft/s           |
| 2022      | Mookie Betts (3x)  | 0.380 | 0.343 | 0.037  | 17.3%      | 9.3%     | 1.5%     | 27.6 ft/s           |
| 2021      | Tony Kemp          | 0.359 | 0.319 | 0.040  | 17.3%      | 6.3%     | 2.1%     | 26.4 ft/s           |
| 2023      | Triston Casas      | 0.363 | 0.373 | -0.010 | 17.2%      | 6.7%     | 2.5%     | 24.9 ft/s           |
| 2021      | Max Muncy          | 0.386 | 0.405 | -0.020 | 17.2%      | 6.7%     | 2.2%     | 27.2 ft/s           |
| 2022      | Matt Chapman (2x)  | 0.334 | 0.341 | -0.006 | 17.2%      | 7.8%     | 3.2%     | 28.3 ft/s           |
| 2021      | Kyle Tucker (2x)   | 0.396 | 0.398 | -0.003 | 17.1%      | 6.7%     | 2.9%     | 27.1 ft/s           |
| 2019      | Teoscar Hernández  | 0.338 | 0.307 | 0.031  | 17.1%      | 5.3%     | 4.6%     | 28.7 ft/s           |
| 2019      | Mitch Garver       | 0.416 | 0.378 | 0.038  | 17.1%      | 9.2%     | 4.4%     | 26.1 ft/s           |
| 2022      | Jake Cronenworth   | 0.331 | 0.302 | 0.029  | 17.1%      | 6.0%     | 5.0%     | 28.4 ft/s           |    

### Notes
- The average d_wOBA for this group of batting seasons is .004 (.340/.336)
  - This is 67% lower than the average qualified batting season's d_wOBA
- The average sprint speed for this group is 27.2 ft/s
- There are a few players that find themselves on both lists: Max Muncy, Joey Gallo, Pete Alonso
  - Muncy and Gallo's d_wOBA were about the same in each of the seasons
    - 2021 Muncy: wOBA = .386, xwOBA = .405, d_wOBA = **-.02** || 2023 Muncy: wOBA = .364, xwOBA = .384, d_wOBA = **-.02**
    - 2021 Gallo: wOBA = .351, xwOBA = .351, d_wOBA = **0** || 2022 Gallo: wOBA = .291, xwOBA = .299, d_wOBA = **-.08**
  - Pete Alonso's season where he hit more Pulled Flyballs, and less Center Flyballs, (2022) was notably better (according to d_wOBA and wOBA, but not xwOBA) than his 2023 season
    - 2023 Alonso: wOBA = .360, xwOBA = .382, d_wOBA = **-.022** || 2022 Alonso: wOBA = .372, xwOBA = .358, d_wOBA = **.014**
    - Alonso's -.036 change in d_wOBA, -.012 change in wOBA, and .024 change in xwOBA between his 2022 & 2023 seasons minimizes the significance of a player's overall xwOBA as it relates to their overall production
      - Alonso shows that actual production can be lost by a batter that hits too mamy FBs to Center despite an increase in xwOBA
      
### Player Spotlight
### Matt Chapman
  - His wOBA consistently underperforms his xwOBA despite having above average sprint speed (28.3 ft/s)
![Screenshot 2023-10-01 012517](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/3335e55f-0f42-456a-bfde-b6c16fd9864f)

- The following tables show that, from 2021-2023, Matt Chapman hits Flyballs to Center at an above average rate
    - Average Center FB%: 11.7%

##### 2021
![Screenshot 2023-10-01 012627](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/2590254a-2d01-4e7c-bcdd-9d91a49766e8)
##### 2022
![Screenshot 2023-10-01 012638](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/16028e6a-960f-4655-af94-adbeb979efd0)
##### 2023
![Screenshot 2023-10-01 012647](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/de9c0d1d-bce1-4d92-94a7-375a54febbe1)

  
  - Chapman's Center FB% in 2021: **19.9%**, 2022: **17.2%**, 2023: **16.8%**
  - Chapman's positive 'd_wOBA' trend in 2023 could be attributed to the fact that he is outperforming his xwOBA on Pulled Groundballs at an unsustainably high rate
    - league-wide d_wOBA on Pull GBs: .218 - .213 = **.005**
    - Chapman d_wOBA on Pull GBs in 2023: .408 - .207 = **.201!**

#### Kyle Tucker is an example of another player that consistently hits a lot of Center Flyballs


## PITCHERS
### List of pitchers with >= 75th Percentile CENTER FB%
- The 75th Percentile CENTER FB% value for qualified pitchers is 13.8%
- Additionally, I filtered out pitchers with an above average Pull FB% (above 6.8%)

| Season      |   Player Name   |  wOBA  | xwOBA | d_wOBA | CENTER FB% | PULL FB% | OPPO GB% |   Team   |        OAA         |
|:-----------:|:---------------:|:------:|:-----:|:------:|:--------:|:--------:|:-------:|:-----------:|:------------------:|
|    2022     |  Max Scherzer   |  0.258 | 0.263 | -0.004 |   17.2%  |   4.3%   |   4.0%   |     NYM     |         11         |
|    2022     |  Tyler Alexander|  0.337 | 0.347 | -0.010 |   17.1%  |   2.3%   |   5.2%   |     DET     |         12         |
|    2022     |  Bailey Falter  |  0.336 | 0.327 |  0.010 |   16.7%  |   4.9%   |   5.7%   |     PHI     |        -34         |
|    2022     | Kutter Crawford |  0.352 | 0.332 |  0.021 |   16.4%  |   6.7%   |   3.1%   |     BOS     |        -13         |
|    2022     |   Tyler Mahle   |  0.308 | 0.284 |  0.025 |   16.3%  |   6.1%   |   6.5%   |     CIN     |        -22         |
|    2021     |    Luis Garcia  |  0.303 | 0.302 |  0.001 |   15.7%  |   5.9%   |   6.1%   |     HOU     |         36         |
|    2022     |    Yu Darvish   |  0.267 | 0.296 | -0.028 |   15.6%  |   6.2%   |   5.5%   |     SD      |         33         |
|    2022     | Justin Verlander|  0.231 | 0.255 | -0.024 |   15.3%  |   4.7%   |   4.0%   |     HOU     |         36         |
|    2022     |    Cole Irvin   |  0.313 | 0.324 | -0.011 |   15.3%  |   5.7%   |   5.4%   |     OAK     |        -5          |
|    2021     |   Gerrit Cole   |  0.290 | 0.277 |  0.012 |   15.3%  |   6.4%   |   4.3%   |     NYY     |        -21         |
|    2022     |   Chris Flexen  |  0.326 | 0.337 | -0.011 |   15.1%  |   6.0%   |   5.1%   |     SEA     |         2          |
|    2022     |   Blake Snell   |  0.301 | 0.289 |  0.012 |   15.1%  |   4.0%   |   6.8%   |     SD      |         33         |
|    2022     | Triston McKenzie|  0.271 | 0.289 | -0.018 |   14.8%  |   6.6%   |   5.0%   |     CLE     |         23         |
|    2022     |    Zach Davies  |  0.322 | 0.324 | -0.002 |   14.7%  |   6.6%   |   6.6%   |     AZ      |         44         |
|    2021     |   Chris Flexen  |  0.319 | 0.315 |  0.003 |   14.6%  |   4.8%   |   5.5%   |     SEA     |        -5          |
|    2022     |    José Suarez  |  0.314 | 0.301 |  0.013 |   14.5%  |   4.8%   |   4.8%   |     LAA     |         0          |
|    2022     |   Johnny Cueto  |  0.316 | 0.309 |  0.006 |   14.5%  |   5.4%   |   5.6%   |     CWS     |        -17         |
|    2021     |   Kevin Gausman |  0.281 | 0.288 | -0.007 |   14.4%  |   5.8%   |   9.3%   |     SF      |         29         |
|    2022     |   Austin Voth   |  0.311 | 0.315 | -0.003 |   14.4%  |   6.2%   |   4.1%   |     BAL     |         3          |
|    2022     | Trevor Williams |  0.320 | 0.299 |  0.021 |   14.3%  |   5.3%   |   3.0%   |     NYM     |         11         |
|    2022     |   Kyle Freeland |  0.354 | 0.340 |  0.014 |   14.1%  |   5.8%   |   4.4%   |     COL     |        -2          |
|    2022     |  Jameson Taillon|  0.315 | 0.317 | -0.001 |   14.0%  |   5.9%   |   4.1%   |     NYY     |         20         |
|    2021     |   Taijuan Walker|  0.314 | 0.324 | -0.011 |   14.0%  |   4.1%   |   6.1%   |     NYM     |         24         |
|    2022     | Jonathan Heasley|  0.373 | 0.361 |  0.013 |   14.0%  |   6.4%   |   3.5%   |     KC      |         1          |
|    2021     |    Jordan Lyles |  0.360 | 0.348 |  0.012 |   13.9%  |   6.3%   |   3.6%   |     TEX     |         27         |
|    2021     |     Julio Urías |  0.274 | 0.269 |  0.005 |   13.8%  |   5.4%   |   4.0%   |     LAD     |        -18         |

### NOTES
- The average d_wOBA for this group of pitching seasons is 0.001
  - This is 86% below average
  - The average d_wOBA for qualified pitchers is 0.007
- The average OAA value for this group of pitchers is 7 OAA
  - league-wide OAA: 0 OAA
  - OAA data comes from Baseball Savant's Leaderboard
- I believe that its worth noting here that pitchers likely have less control than batters do over the types of batted balls they encounter
  - This makes logical sense since pitchers do not bat the balls
  - Statistical evidence for this claim can be found in the d_wOBA for qualified pitchers being .007 whereas for batters its .012
    - This indicates that batters might have an easier time leveraging the types of batted balls they hit in their favor
      - If it generally favored pitchers, then the average d_wOBA for qualified pitchers would be negative or even closer to 0.00
  

### PLAYER SPOTLIGHT

### Max Scherzer
- Max Scherzer has been able to outperform his xwOBA consistently, likely having to do with the fact that he has invoked a lot of Center FBs
![Screenshot 2023-10-09 140722](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/f97ffe25-269f-4562-a427-a4bc6361ed16)

- What is happening in 2023?
##### 2021
![Screenshot 2023-10-09 140752](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/57e5c113-7a0c-42b1-8fad-03c67e2e895a)
##### 2022
![Screenshot 2023-10-09 140808](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/5aa4c9ce-7f6b-4fa1-8c6e-fab363cba944)
##### 2023
![Screenshot 2023-10-09 140819](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/6ecc31c8-e761-4872-a8b3-007158535478)

- In 2023, the wOBA against his Center FBs has drastically increased:
  - 2021: .269, 2022: .278, 2023: .477
    - It is especially concerning because the xwOBA value on Center FB's against him is also increasing
    - This incidates that he is getting hit much harder in general, and his FBs to Center are not doing the trick anymore
      - HR/FB% vs. Scherzer year by year: 2021: 17.3%, 2022: 11.8%, 2023: 21.5%
        - Average HR/FB%: 12.7% (from FanGraphs)
      - Hard Hit% year by year: 2021: 34.3%, 2022: 33.9%, 2023: 36.9%
        - Average Hard Hit%: 36.1% (from Baseball Savant)
          
#### Chris Flexen is a good example of another pitcher that invokes a lot of Center FBs

### List of pitchers with >= 75th Percentile PFB+OGB%
| Season      | Player Name           | wOBA  | xwOBA | d_wOBA | PFB+OGB%| PULL FB% | OPPO GB% |CENTER FB% | Team      | OAA                |
|-------------|-----------------------|-------|-------|--------|---------|----------|----------|----------|-------------|--------------------|
| 2022        | Andre Pallante        | 0.321 | 0.298 | 0.023  | 19.4%   | 3.2%     | 16.2%    | 3.2%     | STL         | 26                 |
| 2022        | Brock Burke           | 0.281 | 0.280 | 0.001  | 17.7%   | 7.4%     | 10.2%    | 12.6%    | TEX         | -5                 |
| 2022        | Ryan Yarbrough        | 0.352 | 0.314 | 0.039  | 17.6%   | 8.6%     | 9.0%     | 12.6%    | TB          | 2                  |
| 2022        | Josiah Gray           | 0.361 | 0.327 | 0.034  | 15.9%   | 10.7%    | 5.1%     | 15.4%    | WSH         | -50                |
| 2022        | Antonio Senzatela     | 0.392 | 0.348 | 0.043  | 15.7%   | 4.2%     | 11.5%    | 5.4%     | COL         | -2                 |
| 2022        | Chris Bassitt         | 0.305 | 0.292 | 0.013  | 15.2%   | 6.5%     | 8.6%     | 11.1%    | NYM         | 11                 |
| 2021        | Kevin Gausman         | 0.281 | 0.288 | -0.007 | 15.1%   | 5.8%     | 9.3%     | 14.4%    | SF          | 29                 |
| 2022        | Gerrit Cole           | 0.288 | 0.285 | 0.003  | 15.0%   | 7.6%     | 7.4%     | 12.9%    | NYY         | 20                 |
| 2022        | Cristian Javier       | 0.255 | 0.244 | 0.011  | 14.9%   | 11.6%    | 3.4%     | 14.6%    | HOU         | 36                 |
| 2022        | Michael Lorenzen      | 0.310 | 0.310 | 0.000  | 14.9%   | 4.8%     | 10.0%    | 10.0%    | LAA         | 0                  |
| 2022        | Caleb Smith           | 0.329 | 0.297 | 0.033  | 14.6%   | 11.7%    | 2.9%     | 16.6%    | AZ          | 44                 |
| 2022        | Jon Gray              | 0.300 | 0.297 | 0.003  | 14.5%   | 5.5%     | 9.0%     | 12.1%    | TEX         | -5                 |
| 2022        | Jordan Montgomery     | 0.303 | 0.314 | -0.011 | 14.5%   | 6.2%     | 8.3%     | 9.7%     | NYY         | 20                 |
| 2022        | Zach Thompson         | 0.359 | 0.341 | 0.018  | 14.5%   | 8.1%     | 6.4%     | 7.6%     | PIT         | -22                |
| 2022        | Hunter Greene         | 0.335 | 0.323 | 0.011  | 14.4%   | 10.7%    | 3.8%     | 15.4%    | CIN         | -22                |
| 2022        | Carlos Rodón          | 0.263 | 0.254 | 0.008  | 14.0%   | 7.0%     | 7.0%     | 13.3%    | SF          | -34                |
| 2022        | Taylor Hearn          | 0.346 | 0.338 | 0.008  | 14.0%   | 7.6%     | 6.4%     | 10.7%    | TEX         | -5                 |
| 2022        | Aaron Ashby           | 0.349 | 0.307 | 0.042  | 14.0%   | 4.7%     | 9.3%     | 7.3%     | MIL         | 3                  |
| 2022        | Roansy Contreras      | 0.325 | 0.328 | -0.003 | 13.9%   | 9.5%     | 4.4%     | 14.2%    | PIT         | -22                |
| 2022        | Madison Bumgarner     | 0.360 | 0.349 | 0.011  | 13.9%   | 9.8%     | 4.1%     | 11.3%    | AZ          | 44                 |
| 2022        | Paolo Espino          | 0.355 | 0.335 | 0.020  | 13.7%   | 8.5%     | 5.2%     | 14.5%    | WSH         | -50                |
| 2022        | Nestor Cortes         | 0.247 | 0.256 | -0.009 | 13.7%   | 8.3%     | 5.4%     | 12.7%    | NYY         | 20                 |
| 2022        | Patrick Sandoval      | 0.308 | 0.306 | 0.002  | 13.7%   | 5.6%     | 8.1%     | 10.5%    | LAA         | 0                  |
| 2022        | Jeffrey Springs       | 0.285 | 0.283 | 0.002  | 13.6%   | 5.9%     | 7.8%     | 12.3%    | TB          | 2                  |
| 2022        | Glenn Otto            | 0.333 | 0.343 | -0.011 | 13.6%   | 6.7%     | 6.9%     | 10.1%    | TEX         | -5                 |
| 2022        | Luis Severino         | 0.274 | 0.261 | 0.013  | 13.6%   | 6.8%     | 6.8%     | 9.1%     | NYY         | 20                 |
| 2022        | Ranger Suárez         | 0.322 | 0.298 | 0.024  | 13.6%   | 3.5%     | 10.1%    | 6.8%     | PHI         | -34                |
| 2022        | Austin Gomber         | 0.357 | 0.326 | 0.032  | 13.5%   | 8.6%     | 4.9%     | 14.7%    | COL         | -2                 |
| 2022        | George Kirby          | 0.307 | 0.286 | 0.021  | 13.5%   | 4.7%     | 8.9%     | 12.8%    | SEA         | 2                  |
| 2022        | Shohei Ohtani         | 0.264 | 0.260 | 0.004  | 13.5%   | 6.8%     | 6.8%     | 11.5%    | LAA         | 0                  |
| 2022        | Michael Kopech        | 0.296 | 0.312 | -0.016 | 13.4%   | 9.2%     | 4.2%     | 15.8%    | CWS         | -17                |
| 2022        | Dylan Bundy           | 0.333 | 0.323 | 0.010  | 13.4%   | 10.5%    | 2.9%     | 12.6%    | MIN         | -16                |
| 2022        | Zach Davies           | 0.322 | 0.324 | -0.002 | 13.3%   | 6.6%     | 6.6%     | 14.7%    | AZ          | 44                 |
| 2022        | Luis Garcia           | 0.299 | 0.294 | 0.004  | 13.3%   | 8.0%     | 5.3%     | 13.1%    | HOU         | 36                 |
| 2021        | Patrick Corbin        | 0.372 | 0.354 | 0.018  | 13.3%   | 5.7%     | 7.6%     | 9.4%     | WSH         | -25                |
| 2022        | Kevin Gausman         | 0.310 | 0.285 | 0.025  | 13.2%   | 3.8%     | 9.5%     | 13.2%    | TOR         | 6                  |
| 2022        | Brady Singer          | 0.301 | 0.306 | -0.005 | 13.2%   | 3.7%     | 9.5%     | 11.8%    | KC          | 1                  |
| 2022        | Dylan Cease           | 0.268 | 0.258 | 0.010  | 13.1%   | 7.3%     | 5.7%     | 14.4%    | CWS         | -17                |
| 2022        | Freddy Peralta        | 0.269 | 0.260 | 0.009  | 13.1%   | 8.0%     | 5.2%     | 13.6%    | MIL         | 3                  |
| 2022        | Dean Kremer           | 0.324 | 0.333 | -0.009 | 13.1%   | 6.8%     | 6.3%     | 10.6%    | BAL         | 3                  |
| 2021        | Zack Greinke          | 0.317 | 0.316 | 0.001  | 13.1%   | 6.1%     | 7.0%     | 9.8%     | HOU         | 36                 |
| 2021        | Max Fried             | 0.287 | 0.286 | 0.002  | 13.1%   | 4.6%     | 8.5%     | 9.2%     | ATL         | 9                  |
| 2022        | Joe Ryan              | 0.298 | 0.293 | 0.005  | 13.0%   | 7.8%     | 5.2%     | 17.4%    | MIN         | -16                |
| 2022        | Tyler Wells           | 0.307 | 0.300 | 0.006  | 13.0%   | 7.6%     | 5.5%     | 14.2%    | BAL         | 3                  |
| 2022        | Ryan Feltner          | 0.346 | 0.341 | 0.005  | 13.0%   | 7.4%     | 5.7%     | 12.4%    | COL         | -2                 |
| 2022        | Luis Castillo         | 0.278 | 0.279 | -0.001 | 13.0%   | 5.8%     | 7.2%     | 9.0%     | CIN         | -22                |

### NOTES
- The average d_wOBA for this group of pitching seasons is 0.010
  - This 46% above average
- The average OAA value for this group of pitchers is 1

### PLAYER SPOTLIGHT

### Josiah Gray
- Josiah Gray is an example of a pitcher that has given up a lot of Pull FBs in his short career
- The following table shows the wOBA vs. xwOBA trend for the first few years of Josiah Gray's career
  
![Screenshot 2023-10-10 133713](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/e8215ee7-3040-46df-8607-a759a7bb2470)

- He was unqualified in 2021, but it is still important to note that he was being hit exceptionally hard according to wOBA and not as hard according to xwOBA
- In 2023, his wOBA / xwOBA difference reverted back to normal rates, what happened?

##### 2021
![Screenshot 2023-10-10 134323](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/7db814dd-1238-4aef-8f84-e3bca8c4bd5e)

##### 2022
![Screenshot 2023-10-10 134339](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/cec4c153-13a9-4e57-8e27-dcf2500859c7)

##### 2023
![Screenshot 2023-10-10 134355](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/57725a17-2d1f-47a9-9fa6-452a5b4689ae)

- In 2023, his Pull FB% is closer to the league-average rate of 5.5% (6.5% in 2023), this is a significant shift from his previous tendency to surrender Pull FBs at a rate almost 2x as much as the average, 10.7% in 2021 and 9.5% in 2022
- This progression for Gray coincides with a change in his pitch mix in 2023, in 2021 and 2022 he was a very 4-Seam heavy pitcher
  - 4-Seam Fastball Usage by season: 2021: 51%, 2022: 39%, 2023: 17%
  - In 2023, he throws his Slider more than any other pitch (25%), as well as a Cutter (17.8%) and Sinker (17.2%) more than his 4-Seam Fastball
    - This change in his approach to batters via pitch mix could be at the root of the change in his year to year overall wOBA/xwOBA difference, more specifically in his Pull FB% 
    - This would be a good entry point to provide further analysis on this topic: how do different pitch types (and locations) affect batted ball types?


### Andre Pallante
- Andre Pallante is an example of a pitcher that has displayed a tendency to give up a lot of Oppo Groundballs
- The following table shows that he is also known to underperform his xwOBA value as a pitcher despite having one of the best defenses behind him in the St. Louis Cardinals
  
![Screenshot 2023-10-10 140312](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/c99ea152-dec9-494c-b394-f8644b1f27d9)

- Here is a breakdown by batted ball type for Andre Pallante in 2022 and 2023

##### 2022
![Screenshot 2023-10-10 140423](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/054f61bc-7fe3-47c8-ae6d-0113001a8f70)
##### 2023
![Screenshot 2023-10-10 140441](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/adfdc9fb-cdc7-4c21-8d3f-e1e10f963a6a)

- He gives up a lot of Groundballs in general, but Oppo GBs at a rate over 3x higher than average!
  - the average Oppo GB% is 5.5%
- The d_wOBA he surrenders on Oppo Linedrives and Center Linedrives indicates that Pallante may be getting some bad luck in 2023, but even if those 2 types of batted balls produced league average d_wOBA rates, his Oppo GB% would still lead to his underpeforming of his xwOBA as a pitcher
  - Pallantes overall 2023 d_wOBA: .039
    - If his d_wOBA on Oppo LDs was .012 instead of .501, then the weighted d_wOBA on Oppo Lds would be: .0003 instead of .014 -> decreasing his d_wOBA to .028
      - weighted d_wOBA = d_wOBA x rate
    - If his d_wOBA on Center LDs was -.02 instead of .106, then the weighted d_wOBA on Center LDs would be: -.002 instead of .022 -> decreasing his d_wOBA to .004
  

## CONCLUSION 
- Pull FBs and Oppo GBs will help batters outperform their xwOBA value (pitchers underperform)
- Center FBs will help batters underperform their xwOBA value (pitchers overperform)
  - MLB banning the shift logically should have had some type of impact on this analysis, but we likely need another season of batted balls and the requisite defensive changes that teams are making to draw conclusions
    - It is fair to assume that Oppo GBs will not maintain the magnitude of league-wide difference between wOBA/xwOBA due to this specific rule change (Shift ban)
- It is not made clear in this analysis how much control a batter or pitcher has over the types of batted balls that they produce
  - Additionally, it is suggested that batters have more control than pitchers over the types of batted ball they produce
- wOBA/xwOBA differences were more prevalent for batters than for pitchers in the research
  - In addition to the d_wOBA for qualified hitters being .012 and it being .007 for pitchers, I also found more batters than pitchers that displayed consistent batted ball tendencies from season to season
    - This could likely be because all a pitcher has to do to try and get different results is change their pitch usage or pitch location whereas a batter might have to change the mechanics of their swing to stop hitting so many FB to center or to Pull more FB
    - This effect can be seen when you look at the 4 lists, there are batters who appear on their list multiple times but there are 0 pitchers who are on their list multiple times
- Despite proving that there is a level of skill that needs to be considered when evaluating any player's wOBA/xwOBA differences, there is still an aspect of luck that wOBA xwOBA differences can help us identify
  - Like the Isaac Paredes example where he underperformed his xwOBA on Oppo GBs in 2022, but that number rebounded in 2023
    - On the other hand, there is a chance that defenses/pitchers have a batter scouted so accurately that they can counter a batter's approach of exploiting Pull FBs or Oppo GBs
- Going forward, I wonder if it would be viable to create an xwOBA value that takes into account the spray angle too, considering its notable effect displayed in this project




Thank you for checking out this research project! Please email me at josephmontes.baseball@gmail.com with any Questions, Comments, Concerns, Suggestions, Feedback about this project! Or if you would like to see the batted ball breakdown of a specific player. 
