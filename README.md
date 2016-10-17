# Itervent




## Setup

### Postgresql DB
Install PostgreSQL. Connect to the default template database with a superuser, typically `postgres`.
```
su - postgres
psql -d template1 -U postgres
```
Create a database and a user, and grant this user access.
```
CREATE DATABASE itervent;
CREATE USER itervent WITH PASSWORD 'test';
GRANT ALL PRIVILEGES ON DATABASE itervent to itervent;
```

### Node

Install packages: `npm i`

Run with `npm start`, or `npm run dev-start` for live reloading.

## Testing

This project use jshint and tap for code validation and testing.

Lint code with: `npm run lint`
Run tests: `npm test`


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
