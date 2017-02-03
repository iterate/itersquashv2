# [Itervent](https://itervent.app.iterate.no)

### Usage

`GET` `/r/pingpong` returns a shareable event url for the event `pingpong`.

`GET` `/api/pingpong` returns data associated with `pingpong`.

`PUT` `/api/pingpong/entry` add a new signup entry to the `pingpong` event.

`GET` `/ping` health check - return ok with app version i.e. `OK 0.0.1`.

### Setup


This project use the [yarn package manager](https://github.com/yarnpkg/yarn). Use `yarn` wherever you would use `npm`. Remember to commit the `yarn.lock` when you add or change modules.

 ```
 npm install -g yarn && yarn
 ```

Run with `yarn start`, or `yarn run dev-start` for live reloading.

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


## Deployment

[See wiki for details](https://iterate.atlassian.net/wiki/display/iter/app.iterate.no+-+Heroku+style+deployment)

Add git remote:
`git add remote iterate dokku@app.iterate.no:itervent`

Push to deploy:
`git push iterate master`

Apply any new migrations manually after deploy.
