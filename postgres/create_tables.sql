-- accounts
CREATE TABLE accounts(
    id SERIAL PRIMARY KEY, 
    first_name VARCHAR(25),
    last_name VARCHAR(25),
    is_vip BOOLEAN NOT NULL,
    country VARCHAR(25),
    region VARCHAR(25),
    platform VARCHAR(25) NOT NULL,
    install_time TIMESTAMP NOT NULL
);

-- games
CREATE TABLE games(
    id SERIAL PRIMARY KEY,
    league VARCHAR(25) NOT NULL,
    game_time TIMESTAMP NOT NULL,
    home_team VARCHAR(25) NOT NULL,
    away_team VARCHAR(25) NOT NULL
);

-- bets
CREATE TABLE bets (
    id SERIAL PRIMARY KEY,
    bet_timestamp TIMESTAMP NOT NULL,
    settled_timestamp TIMESTAMP,
    account_id INTEGER NOT NULL,
    bet_status VARCHAR(25),
    bet_category VARCHAR(25),
    number_of_legs INTEGER,
    amount INTEGER NOT NULL,
    to_win_amount INTEGER NOT NULL,
    CONSTRAINT fk_account FOREIGN KEY(account_id) REFERENCES accounts(id)
);

-- bet_legs
CREATE TABLE bet_legs (
    id SERIAL PRIMARY KEY,
    bet_id INTEGER NOT NULL,
    game_id INTEGER NOT NULL,
    bet_leg_type VARCHAR(25) NOT NULL,
    odds VARCHAR(25) NOT NULL,
    selection VARCHAR(25) NOT NULL,
    CONSTRAINT fk_bet FOREIGN KEY(bet_id) REFERENCES bets(id),
    CONSTRAINT fk_game FOREIGN KEY(game_id) REFERENCES games(id)
);
