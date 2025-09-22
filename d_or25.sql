CREATE TABLE player_stats (
    name TEXT,
    goals INT,
    assists INT,
    ga INT, -- G+A
    key_passes INT,
    big_chance_created INT,
    shots_on_goal INT,
    trophies INT,
    minutes_played INT,
    y_card INT,
    red_card INT,
    goal_per_minute NUMERIC,
    kep_pass_per_minute NUMERIC
);

INSERT INTO player_stats
(name, goals, assists, ga, key_passes, big_chance_created, shots_on_goal,
 trophies, minutes_played, y_card, red_card, goal_per_minute, kep_pass_per_minute)
VALUES
('Raphinha', 38, 26, 64, 167, 43, 88, 3, 3360, 4, 0, 0.01131, 0.049702),
('Yamal', 19, 24, 43, 115, 50, 89, 3, 3859, 0, 0, 0.004924, 0.029800),
('Dembele', 33, 13, 46, 133, 25, 91, 4, 1752, 2, 1, 0.018836, 0.075913);


-- Step 1: Prepare base stats
WITH base AS (
    SELECT
        name,
        goals,
        assists,
        ga,  -- goals + assists combined
        key_passes,
        big_chance_created,
        shots_on_goal,
        trophies,
        minutes_played,
        
        -- Combine yellow and red cards into one metric
        -- Red cards are weighted double
        (y_card + 2*red_card) AS cards,

        goal_per_minute,
        kep_pass_per_minute
    FROM player_stats
),

-- Step 2: Normalize stats (scale everything to 0–10)
norm AS (
    SELECT
        name,

        -- Offensive metrics (higher is better)
        (goals::NUMERIC / MAX(goals) OVER()) * 10 AS goals_norm,
        (assists::NUMERIC / MAX(assists) OVER()) * 10 AS assists_norm,
        (ga::NUMERIC / MAX(ga) OVER()) * 10 AS ga_norm,
        (key_passes::NUMERIC / MAX(key_passes) OVER()) * 10 AS key_passes_norm,
        (big_chance_created::NUMERIC / MAX(big_chance_created) OVER()) * 10 AS bcc_norm,
        (shots_on_goal::NUMERIC / MAX(shots_on_goal) OVER()) * 10 AS shots_norm,

        -- Achievement (higher is better)
        (trophies::NUMERIC / MAX(trophies) OVER()) * 10 AS trophies_norm,

        -- Durability (more minutes played is better)
        (minutes_played::NUMERIC / MAX(minutes_played) OVER()) * 10 AS minutes_norm,

        -- Discipline: fewer cards = higher score
        ((MAX(cards) OVER() - cards::NUMERIC) / 
         NULLIF(MAX(cards) OVER() - MIN(cards) OVER(),0)) * 10 AS cards_norm,

        -- Efficiency metrics (higher is better)
        (goal_per_minute::NUMERIC / MAX(goal_per_minute) OVER()) * 10 AS gpm_norm,
        (kep_pass_per_minute::NUMERIC / MAX(kep_pass_per_minute) OVER()) * 10 AS kppm_norm

    FROM base
)

-- Step 3: Apply weights and compute final score
SELECT
    name,
    ROUND(
        goals_norm * 0.20 +        -- Goals: 20%
        assists_norm * 0.10 +      -- Assists: 10%
        ga_norm * 0.10 +           -- Goals + Assists: 10%
        key_passes_norm * 0.10 +   -- Key passes: 10%
        bcc_norm * 0.10 +          -- Big chances created: 10%
        shots_norm * 0.05 +        -- Shots on target: 5%
        trophies_norm * 0.15 +     -- Trophies won: 15%
        minutes_norm * 0.05 +      -- Minutes played: 5%
        cards_norm * 0.05 +        -- Discipline (cards): 5%
        gpm_norm * 0.05 +          -- Goal efficiency: 5%
        kppm_norm * 0.05           -- Passing efficiency: 5%
    , 2) AS final_score
FROM norm
ORDER BY final_score DESC;  -- Rank players from best to worst