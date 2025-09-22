# Data-Football-Why-Raphinha-Could-Win-the-Ballon-d-Or-2025

When we talk about the Ballon d’Or, the debate usually centers on goals scored or trophies won. But football is about far more—it’s about total contribution on the pitch.

## That’s why I built a small project blending two datasets:

 Raw stats (d_or25.csv) → goals, assists, key passes, minutes, etc.

 An SQL model (d_or25.sql) → a weighted scoring system that ranks players fairly across multiple metrics.

## My Method
Instead of focusing only on goals, I built a balanced scoring system where each stat contributes to a final score:

 Goals (20%)

 Assists, Key Passes, Big Chances Created (30%)

 Trophies (15%)

 Minutes Played (5%)

 Discipline (5%)

 Efficiency (Goals/Minute + Key Passes/Minute) (10%)

 Shots on Target (5%)

This way, creativity, efficiency, and discipline matter as much as finishing.

## Here’s a quick taste of the SQL logic I used to combine everything into a final score 

ROUND(
    goals_norm * 0.20 +      
    assists_norm * 0.10 +    
    ga_norm * 0.10 +         
    key_passes_norm * 0.10 + 
    bcc_norm * 0.10 +        
    shots_norm * 0.05 +      
    trophies_norm * 0.15 +   
    minutes_norm * 0.05 +    
    cards_norm * 0.05 +      
    gpm_norm * 0.05 +        
    kppm_norm * 0.05         
, 2) AS final_score

_This snippet shows how I weighted each performance factor._

## What the Data Says after running the numbers:

Raphinha ranked #1 with 38 goals, 26 assists, (64 GAs), and 167 key passes—an elite mix of scoring and creativity.

Dembele impressed with efficiency, producing more per minute despite limited playtime.

Yamal, though very young, already showed consistency and creativity, pointing to a huge future.

## My Take
According to this model, Raphinha is not just having a good season—he’s having a Ballon d’Or level season.

His blend of finishing, creativity, and consistency sets him apart. While narratives and trophies often sway voters, the data strongly suggests Raphinha deserves serious Ballon d’Or consideration this year.

## Final Thoughts
Although at the end of the day, France Football and the authorized journalists will decide who should be the winner of the Ballon d'Or 2025, Data+Football offers new ways to evaluate performance beyond headlines and highlight reels.
