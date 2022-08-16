-- here are some functions to help generate random data
CREATE OR REPLACE FUNCTION random_value_from_list(valueList IN TEXT[])
    RETURNS TEXT AS
    $$
    WITH base AS (
    SELECT val
        FROM UNNEST(valueList) val
    )
    SELECT val
    FROM base
    ORDER BY RANDOM()
    LIMIT 1
    $$
    LANGUAGE 'sql'
    VOLATILE;

CREATE OR REPLACE FUNCTION random_between(low INT ,high INT) RETURNS INT
    LANGUAGE sql
    RETURN floor(random()* (high-low + 1) + low);

CREATE OR REPLACE FUNCTION random_name() RETURNS VARCHAR(25)
    LANGUAGE sql
    RETURN random_value_from_list(ARRAY['Frederick','Gary','OG','Pascal','Scott','Susan','Aja','Elizabeth','Diana','Kia']);

CREATE OR REPLACE FUNCTION random_2019_timestamp() RETURNS TIMESTAMP
    LANGUAGE sql
    RETURN MAKE_TIMESTAMP(2019,1,1,0,0,0) + RANDOM() * INTERVAL '365 days';

CREATE OR REPLACE FUNCTION random_future_timestamp() RETURNS TIMESTAMP
    LANGUAGE sql
    RETURN CURRENT_TIMESTAMP + RANDOM() * INTERVAL '1 days';

CREATE OR REPLACE FUNCTION random_past_timestamp() RETURNS TIMESTAMP
    LANGUAGE sql
    RETURN CURRENT_TIMESTAMP - RANDOM() * INTERVAL '1 days';

CREATE OR REPLACE FUNCTION random_timestamp() RETURNS TIMESTAMP
    LANGUAGE sql
    RETURN CURRENT_TIMESTAMP + (RANDOM() * INTERVAL '2 days') - (RANDOM() * INTERVAL '2 days');

CREATE OR REPLACE FUNCTION random_boolean() RETURNS BOOLEAN
    LANGUAGE sql
    RETURN random() > 0.5;

CREATE OR REPLACE FUNCTION random_team() RETURNS VARCHAR(25)
    LANGUAGE sql
    RETURN random_value_from_list(ARRAY['New York Yankees', 'New York Mets', 'Kansas City Chiefs', 'Green Bay Packers', 'Toronto Raptors']);

-- generate random data for the tables
INSERT INTO accounts(id, first_name, last_name, is_vip, country, region, platform, install_time)
SELECT
    generate_series(1,10) as id,
    random_name() as first_name,
    random_name() as last_name,
    random_boolean()  as is_vip,
    random_value_from_list(ARRAY['A', 'US', 'GB']) as country,
    random_value_from_list(ARRAY['NJ', 'NY', 'ON']) as region,
    random_value_from_list(ARRAY['iOS', 'android']) as platform,
    random_2019_timestamp() as install_time;

INSERT INTO games(id, league, game_time, home_team, away_team)
SELECT
    generate_series(1,300) as id,
    random_value_from_list(ARRAY['NFL', 'NHL', 'NBA', 'MLB']) as league,
    random_2019_timestamp() as game_time,
    random_team() as home_team, 
    random_team() as away_team;

INSERT INTO bets(id, bet_timestamp, settled_timestamp, account_id, bet_status, bet_category, number_of_legs, amount, to_win_amount)
SELECT
    generate_series(1,1000) as id,
    random_2019_timestamp() as bet_timestamp,
    random_2019_timestamp() as settled_timestamp,
    floor(random() * 10 + 1)::int  as account_id,
    random_value_from_list(ARRAY['win', 'loss', 'pending']) as bet_status,
    random_value_from_list(ARRAY['straight', 'parlay', 'teaser']) as bet_category,
    floor(random() * 11)::int  as number_of_legs,
    floor(random() * 200)::int as amount,
    floor(random() * 400)::int as to_win_amount;

INSERT INTO bet_legs(id, bet_id, game_id, bet_leg_type, odds, selection)
SELECT
    generate_series(1,2000) as id,
    floor(random() * 1000 +1)::int as bet_id,
    floor(random() * 300 +1)::int as game_id,
    random_value_from_list(ARRAY['moneyline', 'over under', 'spread', 'future']) as bet_leg_type,
    (random() * 10)::varchar(25) as odds,
    random_value_from_list(ARRAY['Kansas City Chiefs -7', 'Over 52', 'Green Bay Packers Win']) as selection;
