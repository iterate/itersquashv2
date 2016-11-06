# Itervent




## Setup

### Database
Install PostgreSQL. Connect to the default template database with a superuser i.e. `postgres`.
```
psql -d template1 -U postgres
```
Create a database and a user, and grant this user access.
```
CREATE DATABASE itervent;
CREATE USER itervent WITH PASSWORD 'test';
GRANT ALL PRIVILEGES ON DATABASE itervent to itervent;
```

To create the initial tables, `npm install sequelize-cli` and run `node_modules/.bin/sequelize db:migrate --url postgresql://itervent:test@localhost:5432/itervent` from the `app/storage` folder. This will apply the migrations in `app/storage/migrations`.

If you _change_ the data models, you need to create a migration to update the tables. Take a look at the pre-defined migrations, and
the [Sequelize documentation ](http://docs.sequelizejs.com/en/v3/docs/migrations/)

### Run with docker
First [get docker compose](https://docs.docker.com/compose/install/).

`docker-compose up`. Add `-d` to run in the background.

### Run with Node

This project use the `[yarn](https://github.com/yarnpkg/yarn "Yarn")` package manager. Use `yarn` wherever you would use `npm`, alternatively stick to `npm`, but remember to do a `docker build .` to confirm the project builds with yarn before merging changes.

 ```
 npm install -g yarn && yarn
 ```

Run with `yarn start`, or `yarn run dev-start` for live reloading.


## Testing

This project use jshint and tap for code validation and testing.

Lint code with: `yarn run lint`
Run tests: `yarn test`


## Configuration

You'll find the app configuration schema in `config/config.js`.
Put your overrides in `config/development.json`.

Example:
```
{
    'version': '0.0.2',
    'httpServerPort': 1234
}
```

NB: Even though there are hints at environment variables, they are not used yet.

## Health check

Do a `GET /ping` and the app should return ok with app version i.e. `OK 0.0.1`.
