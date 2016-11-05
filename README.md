# Itervent




## Setup

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

### Run with docker (optional)
First [get docker compose](https://docs.docker.com/compose/install/).

`docker-compose up`. Add `-d` to run in the background.

### Run with Node

This project use the `[yarn](https://github.com/yarnpkg/yarn "Yarn")` package manager. Why? Ensuring consistent package behavior across environments. _Remember to commit the `yarn.lock` when you add or change modules_. Use `yarn` wherever you would use `npm`.

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
