--    Create the matches table.
--    Stores match-level information such as season, teams,
--    toss details, match result, winner, venue, and umpires.
--    The id column is the Primary Key.

CREATE TABLE matches (
    id INTEGER PRIMARY KEY,
    season VARCHAR(20),
    city VARCHAR(50),
    date DATE,
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(20),
    result VARCHAR(30),
    dl_applied INTEGER,
    winner VARCHAR(100),
    win_by_runs INTEGER,
    win_by_wickets INTEGER,
    player_of_match VARCHAR(100),
    venue VARCHAR(150),
    umpire1 VARCHAR(100),
    umpire2 VARCHAR(100),
    umpire3 VARCHAR(100)
);

--    Create the deliveries table.
--    Stores ball-by-ball information for every IPL match.
--    match_id is a Foreign Key referencing matches(id).
--    The "over" column is enclosed in double quotes because
--    OVER is used as a SQL keyword.
CREATE TABLE deliveries (
    match_id INTEGER,
    inning INTEGER,
    batting_team VARCHAR(100),
    bowling_team VARCHAR(100),
    "over" INTEGER,
    ball INTEGER,
    batsman VARCHAR(100),
    non_striker VARCHAR(100),
    bowler VARCHAR(100),
    is_super_over INTEGER,
    wide_runs INTEGER,
    bye_runs INTEGER,
    legbye_runs INTEGER,
    noball_runs INTEGER,
    penalty_runs INTEGER,
    batsman_runs INTEGER,
    extra_runs INTEGER,
    total_runs INTEGER,
    player_dismissed VARCHAR(100),
    dismissal_kind VARCHAR(50),
    fielder VARCHAR(100),

    FOREIGN KEY (match_id)
        REFERENCES matches(id)
);

--    Display all table names present in the public schema.
--    Used to verify whether the tables have been created.
SELECT tablename
FROM pg_tables
WHERE schemaname = 'public';

--    Retrieve all records from the matches table.
--    Displays complete match-level information.
select * from matches;

--    Display the column names and their data types
--    for the matches table.
--    Uses the information_schema system view.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'matches';

--    Retrieve all records from the deliveries table.
--    Displays ball-by-ball match information.
select * from deliveries;

--    Count the total number of records in the matches table.
--    Helps verify the number of matches loaded.
SELECT COUNT(*) FROM matches;

--    Count the total number of records in the deliveries table.
--    Helps verify the number of ball-by-ball records loaded.
SELECT COUNT(*) FROM deliveries;

--    Find the number of matches played in each IPL season.
--    GROUP BY season groups matches by their season.
--    COUNT(season) counts the matches in each season.
--    ORDER BY season displays seasons in ascending order.
select season,count(season) from matches group by season order by season;

--     Find the total number of matches won by each team
--     across all IPL seasons.
--     Excludes records where the winner is NULL.
--     Displays teams in descending order of matches won.
select winner,count(*) as matches_won from matches where winner is not null group by winner order by matches_won desc;

--     For the year 2016, find the total extra runs
--     conceded by each bowling team.
--     Joins matches and deliveries using match id.
--     Filters matches from the 2016 season.
--     SUM(extra_runs) calculates total extras conceded.
--     Displays teams with the highest extras first.
select bowling_team,sum(extra_runs) as total_extra_runs from matches inner join deliveries on matches.id=deliveries.match_id where season='2016'
group by bowling_team order by total_extra_runs desc;

--     For the year 2015, find the top economical bowlers.
--     Calculates economy rate as:
--     Total runs charged to the bowler / legal overs bowled.
--
--     Wide runs and no-ball runs are included in the runs
--     charged to the bowler.
--
--     Wide deliveries and no-ball deliveries are excluded
--     from the legal ball count.
--
--     ROUND(..., 2) rounds the economy rate to 2 decimals.
--     ORDER BY economy_rate sorts from lowest to highest.
select d.bowler, ROUND(sum(d.batsman_runs+d.wide_runs+d.noball_runs)*6.0/sum(case when d.wide_runs=0 and d.noball_runs=0 then 1 else 0 end),2) as
economy_rate from matches m inner join deliveries d on m.id=d.match_id where m.season='2015' group by d.bowler order by economy_rate;

--     For the year 2016, find the top 5 teams
--     based on their total runs scored.
--     SUM(total_runs) calculates the runs scored by each team.
--     GROUP BY batting_team groups records by batting team.
--     ORDER BY total_runs DESC sorts from highest to lowest.
--     LIMIT 5 returns only the top 5 teams.
select d.batting_team, sum(d.total_runs) as total_runs from matches m inner join deliveries d on m.id=d.match_id where m.season='2016' group by 
d.batting_team order by total_runs desc limit 5;
