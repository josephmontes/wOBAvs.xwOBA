# Intro

Thank you for checking out this research project

Today, I will be looking at how batters can outperform their expected wOBA value (xwOBA) 
- There are typical ways such as batter's sprint speed and pitching team's defense that will effect the discrepancy between wOBA and xwOBA
- In this analysis, I will look at the woba vs. xwoba for batted balls with different characterstics

The first set of characterstics used to differentiate batted balls: Pull, Center, Oppo
- From there, I divided each batted ball into another 4 categories: Flyball, Linedrive, Groundball, Popup
- These 12 groups of hits will be used to differentiate hit types to find if there is specific batted ball types that lead to higher wOBA than xwOBA gives it credit for

  ![Screenshot 2023-09-27 150552](https://github.com/josephmontes/xwOBAvs.wOBA/assets/125607783/0b88a4b2-5d5f-4236-9a72-b7410c3d4ac8)

- This graphic shows that pulled fly balls and oppo groundballs will help a batter outperform their xwOBA
- Conversely, center fly balls will help a batter underperform their xwOBA

## Example of batter with upper percentile pulled flyballs
- Isaac Paredes
  - In his first 2 years, he has outperformed his xwoba despite having below average sprint speed
  - You cannot just say that this batter is getting lucky because he has a skill to pull fly balls leading to this perceived "luck"

- Nolan Arenado too

## Example of batter with upper percentile oppo groundballs
- DJ LeMahieu
  - Known to outperform his xwOBA despite lower foot speed
  - hits a lot of oppo field groundballs
 
- Marcus Semien too

## Example of batter with upper percentile center flyball
- Matt Chapman
  - Known to underperform his xwOBA despite higher sprint speed
  - hits too many flyballs to center
 
### Check out full list in code
- divided by players that hit a lot of Center FB's or Oppo GB's / Straight FB's
  - players hitting straight FB's have a bigger difference in wOBA supporting the notion of this research project
  
