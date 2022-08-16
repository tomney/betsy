WITH jan_jun_2019_monthly_bets AS (
    SELECT
        EXTRACT(month FROM bet_timestamp) AS bet_month
        ,amount
    FROM bets
    WHERE bet_timestamp >= MAKE_TIMESTAMP(2019,1,1,0,0,0) 
        AND bet_timestamp < MAKE_TIMESTAMP(2019,7,1,0,0,0)
)
, jan_jun_2019_monthly_bet_totals AS (
    SELECT
        bet_month
        ,SUM(amount) AS monthly_total
    FROM jan_jun_2019_monthly_bets
    GROUP BY 
        bet_month
)
SELECT
    bet_month,
    monthly_total,
    SUM(monthly_total) OVER (ORDER BY bet_month) AS cumulative_total
FROM jan_jun_2019_monthly_bet_totals
ORDER BY bet_month;

