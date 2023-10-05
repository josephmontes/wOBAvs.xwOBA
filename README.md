# Analyzing wOBA vs. xwOBA differences for Batted Ball Types
## Intro

In this baseball project, I am using Statcast pitch-by-pitch data from 2019 to 2023 in RStudio to examine the types of batted balls that can lead to a batter or pitcher's wOBA outperforming their xwOBA
- More specifically, I categorize batted balls by ***Pull, Center, Oppo*** and ***Flyball, Groundball, Linedrive, Popup*** in an attempt to identify wOBA vs. xwOBA differences based on *where* the ball was hit
- If there are notable differences in the league-wide wOBA and xwOBA based on where the ball was hit, then it implies that any individual player's actual wOBA/xwOBA discrepancy, or lack thereof, warrants further evaluation
- I am not implying that batters or pitchers have complete control over the type of batted balls that occur on an at-bat by at-bat basis, but there are likely tendencies developed through a player's approach, mechanics, pitch usage, etc. that result in certain types of batted ball occuring more often than normal for that player over the course of a season

The idea behind this analysis is that xwOBA is often used to explain that a batter or pitcher may be getting lucky or unlucky, but if there are types of batted balls that generally lead to notable differences in wOBA/xwOBA, then it may be the case that the player is not getting lucky or unlucky, instead, that is just generally how the batter hits the ball (or how the ball is generally hit against the pitcher)
- Ultimately, this project aims to identify some level of skill that may be misattributed as luck, and identify players that exhibit this distinction

## Analysis
It is widely understood that a *batter's* **above average sprint speed** can lead to ***outperforming*** his xwOBA and a *pitching team's* **above average defense** can lead the batter to ***underperforming*** his xwOBA 
- Batter's sprint speed and pitching team's defense are not the factors that are focused on in this project

The xwOBA value used in this project comes from Statcast's 'estimated_woba_using_speedangle' column 
  - This calculation of xwOBA is only taking into account the launch speed and the *vertical* launch angle of the batted ball

Here, I look at the *horizontal* component of launch angle (spray angle) to see what xwOBA is missing by excluding it
- I calculated the spray angle of every batted ball in my dataset using Statcast's hit coordinates in the following snippet of code
  
  ```allbdat$spray_angle <- with(allbdat, round((atan((hc_x-125.42)/(198.27-hc_y))*180/pi*.75),1))```

- The next snippet of code shows how I used each spray angle calculation, along with the handedness of the batter, to make another column titled 'hit_direction' that labels each of the batted balls as 'Pull', 'Center', or 'Oppo' 
  
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
 
#### The table below shows the wOBA vs. xwOBA value for each of the 12 distinct types of batted balls
  - 'd_wOBA' is wOBA - xwOBA
  - 'rate' is each batted ball type's frequency as a percentage

  ![Screenshot 2023-09-27 150552](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/0b88a4b2-5d5f-4236-9a72-b7410c3d4ac8)

This table shows that the type of batted balls that are most likely to lead to a batter outperforming their xwOBA are: ***Pulled Flyballs*** and ***Oppo Groundballs***
  - To make sense of why Oppo Groundballs are listed here, look at the most popular of the 12 batted ball types, Pulled Groundballs at 22%
    - Oppo Groundballs are hit at much lower rate, 5.5%, this difference forces defenses to generally position themselves anticipating a Pulled Groundball, so when a Oppo Groundball is hit the defense tends to be less optimally positioned to defend them
    - This makes the oppo groundball more likely to find a hole, which increases wOBA while the xwOBA remains similar between the 2 type of batted balls 
  - To make sense of why Pulled Flyballs lead to the largest *positive* difference in wOBA and xwOBA, it could help to look at the type of batted ball that leads to the largest *negative* difference in wOBA and xwOBA: **Center Flyballs** 
    - If a ball is hit with 30 degree launch angle and 98 mph launch speed, it will have a *high* ***xwOBA*** based on the fact that most balls hit 30deg/98mph are able to find a fence in the gap or down the line to go over for a homerun (increasing wOBA), but when that 30 degree/98mph Flyball is hit to Center it is more likely that there will be room for a defender to make a play (decreasing wOBA)
    - So why don't we see this effect for Oppo Flyballs? Because batters generally have more power to their pullside
      - This can be confirmed by the significantly lower xwOBA value on Oppo Flyballs in the table above



# Players
## Batters
### List of batters with >= 75th percentile 'PFB+OGB%'
- PFB is Pulled FB rate
- OGB is Oppo GB rate
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
- the average d_wOBA for this group is still .27 (wOBA/xwOBA)
  - They are outperforming their wOBA at an above average rate
- the uper 75th percentile value for PFB% is:
  - average:
- the upeer 75th percentile value for OGB% is:
  - average:

### Player Spotlight
#### Isaac Paredes
  - In his first 2 years, his wOBA has notably outperformed his xwOBA despite having below average sprint speed (26.1 ft/s)

![Screenshot 2023-10-01 004943](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/38ab2bcb-cd36-4766-ba2d-382725ab3bee)


- This makes him a prime example of a batter that cannot be described as 'getting lucky' because of his wOBA/xwOBA difference
  - He has displayed a skill to pull fly balls which drives this difference
- Here is the wOBA/xwOBA breakdown by batted ball type for Isaac Paredes in 2022 & 2023

##### 2022
![Screenshot 2023-10-01 005412](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/dac4984d-46ae-4a40-9f8d-fcd3a70ca771)

##### 2023
![Screenshot 2023-10-01 005341](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/0b863bbf-c35c-4bac-9bb6-34b2ce2d7c2a)

- He pulls Flyballs almost 3 times more than the league average rate
- Another interesting note: in 2022, the wOBA value on Paredes' Oppo Groundballs **underperformed** it's xwOBA value (negative d_wOBA value) which is contrary to the league wide trend shown in the table in the Analysis section 
  - But in 2023, his wOBA against Oppo Groundballs rebounded back to normal rates and his overall wOBA value benefited from this
    - This is a good example of a way to properly identify luck or unluck: by the wOBA/xwOBA discrepancy for a player on specific types of batted balls, not their overall wOBA/xwOBA difference

#### Nolan Arenado is another prime example of a player like Isaac Paredes

#### Bo Bichette
  - His wOBA typically outperforms his xwOBA despite average foot speed
    - He pulls flyballs at such a low rate that you would expect him to be someone that does not outperform his xwOBA - since that is the main way of doing it 

    
![Screenshot 2023-10-01 011233](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/92a29793-25a7-4420-b7f0-575571ec12e3)

- But what's happening in 2023?

##### 2021
![Screenshot 2023-10-01 011323](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/8db5d3ec-62a4-4393-b578-e8c953878d32)
##### 2022
![Screenshot 2023-10-01 011335](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/5dc924ce-8b84-4592-bf17-cd182e37d391)
##### 2023
![Screenshot 2023-10-01 011350](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/7e1c699c-16c7-4b90-a56f-6d7c6e691c41)

  - The wOBA value for his Oppo Groundballs has plummeted from above .400 to below .300
    - It is likely that the removal of the shift in 2023 has hurt batters hitting oppo groundballs like Bo Bichette
    - Maybe defenses were bound to make this adjustment against Bichette because of his tendency to hit them so frequently
  - Regardless, he is an example of a player that has benefited from hitting a lot of Oppo Groundballs
 
#### DJ LeMahieu is another great example too

### List of batters with >= 75th percentile Center FB rate

| Season    | Player Name        | wOBA  | xwOBA | d_wOBA | CENTER FB% | PULL FB% | OPPO FB% | Sprint Speed (ft/s) |
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
- The average d_wOBA for this group of hitters was lower than average
  - There are a couple people that find themselves on both lists:

### Player Spotlight
#### Matt Chapman
  - His wOBA consistently underperforms his xwOBA despite having above average sprint speed (28.3 ft/s)
![Screenshot 2023-10-01 012517](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/3335e55f-0f42-456a-bfde-b6c16fd9864f)

##### 2021
![Screenshot 2023-10-01 012627](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/2590254a-2d01-4e7c-bcdd-9d91a49766e8)
##### 2022
![Screenshot 2023-10-01 012638](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/16028e6a-960f-4655-af94-adbeb979efd0)
##### 2023
![Screenshot 2023-10-01 012647](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/de9c0d1d-bce1-4d92-94a7-375a54febbe1)

  - You can see that he simply hits way too many flyballs to center
    - Average: 11.7%
    - Chapman: 2021: 19.9% 2022: 17.2% 2023: 16.8%
  - Chapman's positive 'd_wOBA' trend in 2023 can likely be attributed to the fact that he is getting lucky with the wOBA against his Pulled Groundballs
    - normal d_wOBA: .218 / .213 -> .005
    - Chapman d_wOBA: .408 / .207 -> .201!

#### Kyle Tucker is another example too


## PITCHERS
### List of pitchers with >= 75th Percentile CENTER FB rate
-> skilled pitchers (unskilled batters)

### List of pitchers with >= 75th Percentile PFB+OGB rate
-> unskilled pitchers (skilled batters)

Thank you for checking out this research project
