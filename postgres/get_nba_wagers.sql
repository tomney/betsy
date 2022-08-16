WITH june_2019_nba_games AS (
    SELECT id
    FROM games
    WHERE league = 'NBA' 
        AND game_time >= MAKE_TIMESTAMP(2019,6,1,0,0,0) 
        AND game_time < MAKE_TIMESTAMP(2019,7,1,0,0,0)
)
, june_2019_nba_bet_legs AS (
    SELECT
        bet_legs.id 
        ,bet_id 
        ,game_id
    FROM bet_legs
    INNER JOIN june_2019_nba_games jg ON jg.id = bet_legs.game_id
)
, june_2019_nba_bets AS (
    SELECT 
        bets.id
        ,account_id
        ,amount 
    FROM bets
    INNER JOIN june_2019_nba_bet_legs jl ON jl.bet_id = bets.id
)

SELECT
    account_id
    ,COUNT(account_id) as num_bets
    ,COUNT(amount) as total_waged
FROM june_2019_nba_bets
GROUP BY account_id
ORDER BY
    total_waged DESC;