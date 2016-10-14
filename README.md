# Itervent




## Setup

First install packages: `npm i`

Run with `npm start`, or `npm run dev-start` for live reloading.

## Testing

This project use jshint and mocha for code validation and testing.

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
