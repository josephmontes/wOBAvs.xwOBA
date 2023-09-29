# Intro

Thank you for checking out this research project

Today, I will be looking at how a batter's wOBA can outperform their xwOBA 
- The xwOBA value I am using comes from Statcast's 'estimated_woba_using_speedangle' column in their pitch by pitch CSV data
  - This version of xwOBA is only taking into account the launch speed and the *vertical* launch angle of the batted ball


It is widely understood that a *batter's* **above average sprint speed** can lead to ***outperforming*** his xwOBA and a *pitching team's* **above average defense** can lead the batter to ***underperforming*** his xwOBA 
- Batter's sprint speed and pitching team's defense are not the factors that I am evaluating in this project

Here, I will look at the *horizontal* component of launch angle (spray angle) to see what xwOBA is missing by excluding it
- To do this, I will catgeorize wOBA and xwOBA values on batted balls by: Pull, Center, Oppo
  - Additionally, each type of batted ball is divided into 4 more categories: Flyball, Linedrive, Groundball, Popup
    - The following table shows the wOBA vs. xwOBA value for each of those 12 distinct types of batted balls
      - 'd_wOBA' is wOBA - xwOBA
      - 'rate' is each batted ball type's frequency as a percentage

  ![Screenshot 2023-09-27 150552](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/0b88a4b2-5d5f-4236-9a72-b7410c3d4ac8)

- Pulled Flyballs and Oppo Groundballs are the type of batted balls that can lead a batter to outperforming their xwOBA
  - Pulled Flyballs' being listed here makes sense when you see that Center Flyballs lead to a batter most underperforming their xwOBA
    - Put simply, if a ball is hit 399 feet, it is likely to have a *higher* ***xwOBA*** based on the fact that most balls batted similarly will find a fence in the gap or down the line to go over for a homerun, but when the ball is hit towards Center it is more likely that there will be room for the defender to make a play (*lowering* ***wOBA***)
  - Oppo Groundballs being listed here makes sense when you see that the most popular type of batted ball is a Pulled Groundball (22.7%), whereas Oppo Groundballs are hit at about 5.5%
    - This large difference causes defenses to typically be positioned for Pulled Groundballs, so when Oppo Groundballs are hit, they catch the defense off guard and find a hole

The idea behind looking for this discrepancy between wOBA and xwOBA by batted ball type is that many times xwOBA will be used to help explain a batter or pitcher that is getting lucky or getting unlucky
- However, if there are types of batted balls that can lead to large discrepancies in wOBA/xwOBA, then it may be the case that the player is not getting lucky or unlucky, instead, that is just the way they impact the ball
  - Batters nor pitchers have complete control over their type of batted balls, but there is likely a tendency developed through their pitch usage, mechanics or overall approach that results in a certain type of batted ball more often than others
- In other words, there may be some type of skill component that is being misattributed to luck

# Players
## Batters
### List of batters with >= upper 75th percentile 'PFB+OGB' rate
- PFB is Pulled FB rate
- OGB is Oppo GB rate

| Season    | Player Name      | wOBA | xwOBA | d_wOBA | PFB+OGB% | PULL FB% | OPPO GB% |CENTER FB%| Freq |Sprint Speed (ft/s)|
|-----------|------------------|------|-------|--------|----------|----------|----------|----------|------|-------------------|
| 2023      | Bo Bichette      | 0.373| 0.367 | 0.006  | 21.1%  | 3.8%    | 17.3%   | 8.1%    | 1808 | 27.7 ft/s    |
| 2022      | Nico Hoerner     | 0.330| 0.296 | 0.034  | 18.9%  | 7.7%    | 11.2%   | 8.9%    | 1849 | 28.8 ft/s    |
| 2022      | Isaac Paredes    | 0.328| 0.298 | 0.030  | 18.7%  | 13.0%   | 5.7%    | 9.5%    | 1624 | 26.1 ft/s    |
| 2022      | Joey Gallo       | 0.291| 0.299 | -0.007 | 18.2%  | 15.6%   | 2.6%    | 18.8%   | 1780 | 27.3 ft/s    |
| 2023      | Isaac Paredes (2x)| 0.376| 0.320| 0.056  | 18.0%  | 13.9%   | 4.1%    | 12.4%   | 1631 | 26.1 ft/s    |
| 2021      | Patrick Wisdom   | 0.356| 0.322 | 0.034  | 17.9%  | 15.2%   | 2.7%    | 15.8%   | 1631 | 27.9 ft/s    |
| 2023      | James Outman     | 0.346| 0.314 | 0.032  | 17.9%  | 11.0%   | 6.9%    | 11.9%   | 1626 | 28.8 ft/s    |
| 2022      | Bo Bichette (2x) | 0.353| 0.327 | 0.026  | 17.8%  | 2.8%    | 15.0%   | 9.9%    | 2586 | 27.7 ft/s    |
| 2021      | David Fletcher   | 0.288| 0.273 | 0.015  | 17.2%  | 4.1%    | 13.1%   | 7.8%    | 2218 | 27.5 ft/s    |
| 2023      | Lourdes Gurriel  | 0.340| 0.327 | 0.013  | 17.1%  | 5.8%    | 11.3%   | 13.4%   | 1634 | 27.0 ft/s    |
| 2023      | Manny Machado    | 0.348| 0.340 | 0.008  | 17.0%  | 7.7%    | 9.3%    | 11.8%   | 1650 | 26.4 ft/s    |
| 2022      | Jack Suwinski    | 0.315| 0.302 | 0.013  | 16.9%  | 12.2%   | 4.7%    | 13.1%   | 1577 | 28.6 ft/s    |
| 2023      | Javier Báez      | 0.275| 0.264 | 0.011  | 16.9%  | 6.9%    | 10.0%   | 7.8%    | 1608 | 28.3 ft/s    |
| 2021      | Brandon Belt     | 0.412| 0.377 | 0.035  | 16.7%  | 13.1%   | 3.6%    | 18.5%   | 1578 | 25.3 ft/s    |
| 2023      | Geraldo Perdomo  | 0.338| 0.282 | 0.056  | 16.7%  | 10.5%   | 6.2%    | 11.2%   | 1544 | 27.2 ft/s    |
| 2023      | Paul Goldschmidt | 0.356| 0.369 | -0.013 | 16.3%  | 4.7%    | 11.6%   | 11.9%   | 2109 | 26.4 ft/s    |
| 2022      | Paul Goldschmidt(2x)| 0.432| 0.373| 0.059| 16.2%  | 8.8%    | 7.4%    | 13.6%   | 2714 | 26.4 ft/s    |
| 2022      | Randal Grichuk   | 0.320| 0.278 | 0.042  | 16.2%  | 5.7%    | 10.4%   | 12.3%   | 2006 | 27.9 ft/s    |
| 2023      | Nico Hoerner (2x)| 0.336| 0.300 | 0.036  | 16.2%  | 3.6%    | 12.6%   | 9.8%    | 1875 | 28.8 ft/s    |
| 2019      | Xander Bogaerts  | 0.414| 0.355 | 0.059  | 16.1%  | 8.3%    | 7.9%    | 10.4%   | 2875 | 27.8 ft/s    |
| 2019      | Lorenzo Cain     | 0.319| 0.323 | -0.004 | 16.1%  | 2.2%    | 13.9%   | 6.7%    | 2526 | NA           |
| 2023      | Marcell Ozuna    | 0.341| 0.361 | -0.020 | 16.0%  | 8.6%    | 7.4%    | 14.4%   | 1637 | 26.9 ft/s    |
| 2021      | Mike Zunino      | 0.374| 0.358 | 0.016  | 16.0%  | 14.5%   | 1.5%    | 13.5%   | 1502 | 26.1 ft/s    |
| 2023      | Hunter Renfroe   | 0.330| 0.293 | 0.037  | 16.0 %  | 10.7%   | 5.2%    | 10.7%   | 1723 | 27.1 ft/s    |
| 2019      | José Iglesias    | 0.329| 0.294 | 0.035  | 16.0%  | 4.9%    | 11.0%   | 10.1%   | 1968 | NA           |
| 2022      | Byron Buxton     | 0.381| 0.365 | 0.016  | 15.9%  | 12.9%   | 3.0%    | 15.1%   | 1558 | 29.9 ft/s    |
| 2019      | Nolan Arenado    | 0.427| 0.353 | 0.073  | 15.9%  | 8.2%    | 7.6%    | 11.8%   | 2426 | 25.4 ft/s    |
| 2023      | Max Muncy        | 0.364| 0.384 | -0.019 | 15.8%  | 14.4%   | 1.4%    | 18.5%   | 1768 | 27.2 ft/s    |
| 2019      | José Ramírez     | 0.349| 0.337 | 0.013  | 15.8%  | 11.0%   | 4.8%    | 11.0%   | 2191 | 28.1 ft/s    |
| 2021      | Raimel Tapia     | 0.323| 0.265 | 0.058  | 15.8%  | 2.2%    | 13.6%   | 5.0%    | 1973 | 28.3 ft/s    |
| 2022      | Ramón Urías      | 0.321| 0.318 | 0.002  | 15.6%  | 6.5%    | 9.0%    | 11.2%   | 1680 | 26.8 ft/s    |
| 2022      | Gavin Sheets     | 0.321| 0.294 | 0.027  | 15.6%  | 7.6%    | 8.0%    | 10.0%   | 1737 | 26.6 ft/s    |
| 2022      | Ramón Laureano   | 0.301| 0.302 | -0.001 | 15.5%  | 7.9%    | 7.5%    | 13.4%   | 1522 | 28.0 ft/s    |
| 2022      | Darin Ruf        | 0.296| 0.308 | -0.013 | 15.5%  | 9.0%    | 6.4%    | 12.9%   | 1643 | 25.8 ft/s    |
| 2022      | Thairo Estrada   | 0.333| 0.297 | 0.036  | 15.5%  | 6.1%    | 9.3%    | 8.1%    | 1966 | 28.2 ft/s    |
| 2021      | Adam Duvall      | 0.333| 0.326 | 0.006  | 15.4%  | 13.6%   | 1.8%    | 20.8%   | 2158 | 28.3 ft/s    |
| 2019      | Robinson Chirinos| 0.362| 0.323 | 0.039  | 15.4%  | 10.2%   | 5.1%    | 13.0%   | 1752 | NA           |
| 2022      | Jurickson Profar | 0.329| 0.320 | 0.009  | 15.4%  | 7.5%    | 7.9%    | 9.4%    | 2830 | 26.5 ft/s    |
| 2019      | Trea Turner      | 0.373| 0.327 | 0.046  | 15.2 %  | 5.9%    | 9.3%    | 9.1%    | 2272 | 30.4 ft/s    |
| 2022      | DJ LeMahieu      | 0.349| 0.347 | 0.002  | 15.2%  | 0.7%    | 14.5%   | 6.4%    | 2199 | 26.4 ft/s    |
| 2022      | Joc Pederson     | 0.375| 0.363 | 0.012  | 15.1%  | 8.8%    | 6.3%    | 15.8%   | 1706 | 26.5 ft/s    |
| 2022      | Pete Alonso      | 0.372| 0.358 | 0.014  | 15.1%  | 9.8%    | 5.2%    | 11.9%   | 2526 | 26.1 ft/s    |
| 2022      | Aaron Hicks      | 0.302| 0.296 | 0.006  | 15.1%  | 7.2%    | 7.9%    | 10.4%   | 2060 | 27.6 ft/s    |
| 2023      | Marcus Semien    | 0.365| 0.326 | 0.039  | 15.0%  | 12.1%   | 2.9%    | 16.7%   | 2033 | 28.5 ft/s    |
| 2019      | Delino DeShields | 0.315| 0.276 | 0.039  | 15.0%  | 3.8%    | 11.3%   | 10.2%   | 1702 | NA           |

### NOTES
- I could have weighted Pull Flyballs more heavily in my PFB+OGB rate to more accurately reflect their potential xwOBA value, but I just wanted a quick screenshot of players that Pull Flyballs, hit Oppo Groundballs, or a bit of both
- the average d_wOBA for this group is still .27
  - They are outperforming their wOBA at an above average rate

### Player Spotlight
#### Isaac Paredes
  - In his first 2 years, he has outperformed his xwOBA despite having below average sprint speed (26.1)
    - wOBA/xwOBA: 2022: /  2023:

    
  - You cannot just say that this batter is getting lucky because he has displayed a skill to pull fly balls leading to this perceived "luck"

#### Nolan Arenado too

#### Bo Bichette
  - Known to outperform his xwOBA despite average foot speed
    - wOBA/xwOBA: 2021: /   2022: /  2023: /
  - hits a lot of oppo field groundballs
 
#### DJ LeMahieu too

### List of batters with >= 75th percentile Center FB rate

| Season    | Player Name        | wOBA  | xwOBA | d_wOBA | CENTER FB% | PULL FB% | OPPO FB% | Freq | Sprint Speed (ft/s) |
|-----------|--------------------|-------|-------|--------|------------|----------|----------|------|---------------------|
| 2022      | Mike Trout         | 0.419 | 0.391 | 0.027  | 22.9%      | 9.0%     | 2.7%     | 2132 | 29.4 ft/s           |
| 2019      | Cavan Biggio       | 0.362 | 0.351 | 0.011  | 21.8%      | 7.3%     | 3.0%     | 1878 | 28.3 ft/s           |
| 2021      | Will Smith         | 0.376 | 0.361 | 0.015  | 21.1%      | 9.0%     | 1.6%     | 2080 | 27.5 ft/s           |
| 2023      | J.D. Martinez      | 0.380 | 0.381 | 0.000  | 20.2%      | 7.3%     | 3.9%     | 1517 | 26.3 ft/s           |
| 2022      | Luke Voit          | 0.315 | 0.323 | -0.009 | 20.1%      | 7.0%     | 2.1%     | 2276 | 25.2 ft/s           |
| 2023      | MJ Melendez        | 0.308 | 0.318 | -0.010 | 19.9%      | 7.1%     | 2.8%     | 1801 | 27.7 ft/s           |
| 2021      | Matt Chapman       | 0.319 | 0.319 | 0.000  | 19.9%      | 9.6%     | 1.5%     | 2675 | 28.3 ft/s           |
| 2022      | Tyrone Taylor      | 0.317 | 0.303 | 0.015  | 19.7%      | 5.0%     | 3.2%     | 1545 | 28.6 ft/s           |
| 2023      | Matt Olson         | 0.407 | 0.397 | 0.011  | 19.2%      | 9.1%     | 4.6%     | 2250 | 26.2 ft/s           |
| 2021      | Willy Adames       | 0.365 | 0.323 | 0.043  | 18.8%      | 5.6%     | 2.6%     | 2221 | 28.0 ft/s           |
| 2019      | Mike Trout (2x)    | 0.453 | 0.451 | 0.001  | 18.8%      | 8.7%     | 5.1%     | 2556 | 29.4 ft/s           |
| 2022      | David Peralta      | 0.319 | 0.317 | 0.002  | 18.7%      | 4.2%     | 3.0%     | 1889 | 27.3 ft/s           |
| 2021      | Paul DeJong        | 0.300 | 0.309 | -0.009 | 18.7%      | 8.7%     | 5.2%     | 1578 | 27.4 ft/s           |
| 2022      | Kyle Schwarber     | 0.361 | 0.380 | -0.020 | 18.6%      | 8.4%     | 2.9%     | 2950 | 26.5 ft/s           |
| 2019      | Eric Thames        | 0.361 | 0.327 | 0.034  | 18.6%      | 8.0%     | 2.7%     | 1918 | NA                  |
| 2021      | Joey Gallo         | 0.351 | 0.351 | 0.000  | 18.6%      | 10.0%    | 3.2%     | 2612 | 27.3 ft/s           |
| 2022      | Kyle Tucker        | 0.350 | 0.355 | -0.005 | 18.5%      | 9.9%     | 3.1%     | 2275 | 27.1 ft/s           |
| 2019      | Christin Stewart   | 0.303 | 0.315 | -0.012 | 18.4%      | 6.6%     | 5.1%     | 1661 | NA                  |
| 2022      | Yoán Moncada       | 0.274 | 0.282 | -0.008 | 18.3%      | 3.8%     | 5.5%     | 1752 | 27.5 ft/s           |
| 2023      | Adolis García      | 0.380 | 0.377 | 0.003  | 18.3%      | 8.0%     | 4.5%     | 1983 | 28.0 ft/s           |
| 2022      | Salvador Perez     | 0.343 | 0.332 | 0.010  | 18.1%      | 7.0%     | 2.9%     | 1715 | 25.4 ft/s           |
| 2023      | Jorge Soler        | 0.360 | 0.366 | -0.006 | 18.1%      | 7.6%     | 4.3%    | 1903 | 26.8 ft/s            |
| 2023      | Ozzie Albies       | 0.348 | 0.325 | 0.022  | 18.1%      | 9.6%     | 0.8%     | 1975 | 28.2 ft/s           |
| 2022      | Jesús Aguilar      | 0.300 | 0.312 | -0.012 | 18.1%      | 6.2%     | 4.8%     | 2121 | 24.0 ft/s           |
| 2022      | Taylor Ward        | 0.374 | 0.363 | 0.011  | 18.0%      | 5.7%     | 3.6%     | 2352 | 28.3 ft/s           |
| 2021      | Enrique Hernández  | 0.348 | 0.346 | 0.002  | 17.9%      | 6.6%     | 2.8%     | 2265 | 27.2 ft/s           |
| 2022      | Will Smith (2x)    | 0.353 | 0.349 | 0.003  | 17.9%      | 6.1%     | 4.5%     | 2411 | 27.5 ft/s           |
| 2023      | Eugenio Suárez     | 0.317 | 0.336 | -0.020 | 17.9%      | 8.1%     | 2.1%     | 2052 | 26.2 ft/s           |
| 2021      | Austin Meadows     | 0.336 | 0.325 | 0.012  | 17.9%      | 9.6%     | 2.3%     | 2366 | 27.7 ft/s           |
| 2019      | Rhys Hoskins       | 0.360 | 0.339 | 0.021  | 17.9%      | 9.4%     | 1.3%     | 3227 | NA                  |
| 2022      | Eugenio Suárez     | 0.344 | 0.337 | 0.006  | 17.8%      | 8.6%     | 4.3%     | 2650 | 26.2 ft/s           |
| 2021      | Mookie Betts       | 0.382 | 0.355 | 0.027  | 17.8%      | 7.6%     | 2.4%     | 2232 | 27.6 ft/s           | 
| 2021      | Joc Pederson       | 0.329 | 0.333 | -0.005 | 17.7%      | 3.5%     | 5.2%     | 1918 | 26.5 ft/s           |
| 2019      | Mookie Betts (2x)  | 0.394 | 0.405 | -0.011 | 17.7%      | 5.8%     | 2.0%     | 2928 | 27.6 ft/s           |
| 2019      | Justin Smoak       | 0.342 | 0.379 | -0.036 | 17.6%      | 6.4%     | 1.6%     | 2080 | NA                  |
| 2022      | Cody Bellinger     | 0.291 | 0.275 | 0.016  | 17.5%      | 7.8%     | 1.9%     | 2337 | 28.5 ft/s           |
| 2023      | Pete Alonso        | 0.360 | 0.382 | -0.022 | 17.5%      | 6.6%     | 3.6%     | 1778 | 26.1 ft/s           |
| 2022      | Luis Urías         | 0.336 | 0.327 | 0.010  | 17.5%      | 8.4%     | 4.5%     | 1974 | 26.7 ft/s           |
| 2019      | Chris Davis        | 0.280 | 0.296 | -0.016 | 17.4%      | 5.6%     | 2.2%     | 1567 | NA                  |
| 2019      | Brandon Belt       | 0.334 | 0.358 | -0.024 | 17.3%      | 7.3%     | 3.2%     | 2560 | 25.3 ft/s           |
| 2022      | Mookie Betts (3x)  | 0.380 | 0.343 | 0.037  | 17.3%      | 9.3%     | 1.5%     | 2464 | 27.6 ft/s           |
| 2021      | Tony Kemp          | 0.359 | 0.319 | 0.040  | 17.3%      | 6.3%     | 2.1%     | 1511 | 26.4 ft/s           |
| 2023      | Triston Casas      | 0.363 | 0.373 | -0.010 | 17.2%      | 6.7%     | 2.5%     | 1550 | 24.9 ft/s           |
| 2021      | Max Muncy          | 0.386 | 0.405 | -0.020 | 17.2%      | 6.7%     | 2.2%     | 2434 | 27.2 ft/s           |
| 2022      | Matt Chapman (2x)  | 0.334 | 0.341 | -0.006 | 17.2%      | 7.8%     | 3.2%     | 2684 | 28.3 ft/s           |
| 2021      | Kyle Tucker (2x)   | 0.396 | 0.398 | -0.003 | 17.1%      | 6.7%     | 2.9%     | 2180 | 27.1 ft/s           |
| 2019      | Teoscar Hernández  | 0.338 | 0.307 | 0.031  | 17.1%      | 5.3%     | 4.6%     | 1972 | 28.7 ft/s           |
| 2019      | Mitch Garver       | 0.416 | 0.378 | 0.038  | 17.1%      | 9.2%     | 4.4%     | 1518 | 26.1 ft/s           |
| 2022      | Jake Cronenworth   | 0.331 | 0.302 | 0.029  | 17.1%      | 6.0%     | 5.0%     | 2707 | 28.4 ft/s           |    

### Notes
- The average d_wOBA for this group of hitters was lower than average
  - There are a couple people that find themselves on both lists

### Player Spotlight
#### Matt Chapman
  - Known to underperform his xwOBA despite higher sprint speed (28.3)
    - Simply hits too many flyballs to center

#### Kyle Tucker is another example too


## PITCHERS
### List of pitchers with >= 75th Percentile CENTER FB rate
-> skilled pitchers (unskilled batters)

### List of pitchers with >= 75th Percentile PFB+OGB rate
-> unskilled pitchers (skilled batters)
