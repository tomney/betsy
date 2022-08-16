# betsy
## Setting up a postgres DB with docker
To create a docker container for testing we can use the default postgres docker image. We'll create the default database with a user called `postgres` and the password `testing`:
```
docker run -e POSTGRES_PASSWORD=testing -d -p 5432:5432 postgres 
```

You can generate the tables and some dummy data with
```
psql -h localhost -U postgres -d postgres -a -f ./postgres/create_tables.sql
psql -h localhost -U postgres -d postgres -a -f ./postgres/test/populate_dummy_data.sql
```

We can now connect to the database with the postgres client of our choice, by specifying 
```
host=localhost
database=postgres
user=postgres
password=testing
```

From here we can run the queries in the `/postgres` directory.