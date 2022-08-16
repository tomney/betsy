--  4. Write a query that returns the total dollars bet monthly from 
--  Jan 2019 to June 2019 (inclusive) as well as the cumulative total 
--  dollars bet over the 6 month period. The resulting columns
--  should be: month, monthly_total, cumulative_total.

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
    SUM(monthly_total) OVER (PARTITION BY bet_month ORDER BY bet_month) AS cumulative_total
FROM jan_jun_2019_monthly_bet_totals;

