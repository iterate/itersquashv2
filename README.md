# Itervent

### Setup

This project use the `[yarn](https://github.com/yarnpkg/yarn "Yarn")` package manager. Use `yarn` wherever you would use `npm`. _Remember to commit the `yarn.lock` when you add or change modules_.

 ```
 npm install -g yarn && yarn
 ```

Run with `yarn start`, or `yarn run dev-start` for live reloading.

### Docker build
Do a test build before deployment. From project root: `docker build .`

### Postgresql DB
Install PostgreSQL. Connect to the default template database with a superuser, typically `postgres`.
```
psql -d template1 -U postgres
```
Create a database and a user, and grant this user access.
```
CREATE DATABASE itervent;
CREATE USER itervent WITH PASSWORD 'test';
GRANT ALL PRIVILEGES ON DATABASE itervent to itervent;
```
The first time you also need to run migrations to create the tables.
Sequelize-cli is installed as a node package, so from the `app/storage` folder, do
```
../../node_modules/.bin/sequelize db:migrate --url postgresql://itervent:test@localhost:5432/itervent
```
This will apply the migrations from `app/storage/migrations`.

## Testing

This project use jshint and tap for code validation and testing.

Lint code with: `yarn run lint`
Run tests: `yarn test`


## Configuration

You'll can override environment settings using `config/development.json` or in `config/config.js`, the latter also explains which environment variables the app needs.

Example `development.json`:
```
{
    'version': '0.0.2',
    'httpServerPort': 1234
}
```

## Health check

Do a `GET /ping` and the app should return ok with app version i.e. `OK 0.0.1`.
