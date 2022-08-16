WITH kcc_games AS (
    SELECT id
    FROM games
    WHERE home_team = 'Kansas City Chiefs' OR away_team = 'Kansas City Chiefs'
)
, fall_2019_kcc_bet_legs AS (
    SELECT
        bet_legs.id 
        ,bet_id 
        ,game_id
    FROM bet_legs
    INNER JOIN kcc_games kg ON kg.id = bet_legs.game_id
)
, fall_2019_kcc_bets AS (
    SELECT 
        bets.id
        ,bet_timestamp
        ,account_id
        ,amount 
    FROM bets
    INNER JOIN fall_2019_kcc_bet_legs fbl ON fbl.bet_id = bets.id
    WHERE bet_timestamp >= MAKE_TIMESTAMP(2019,9,1,0,0,0) 
        AND bet_timestamp < MAKE_TIMESTAMP(2020,1,1,0,0,0)
)
, kcc_bets_by_region_month AS (
    SELECT 
        accounts.id
        ,region
        ,EXTRACT(MONTH from fb.bet_timestamp) as month_placed
        ,fb.amount as amount
    FROM accounts
    INNER JOIN fall_2019_kcc_bets fb ON fb.account_id = accounts.id
    WHERE accounts.country = 'US'
)

SELECT  
    region
    ,month_placed
    ,SUM(amount) as total_amount
FROM kcc_bets_by_region_month
GROUP BY
    region
    ,month_placed
ORDER BY
    month_placed DESC
    ,region;
