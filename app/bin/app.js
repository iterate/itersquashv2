"use strict";

const http        = require('http');
const path        = require('path');
const express     = require('express');
const compress    = require('compression')();
const cors        = require('cors');
const log         = require('../lib/log.js');
const router      = require('../lib/router.js');
const app         = express();
const swPrecache  = require('sw-precache');
const fs          = require('fs');


/*
* Compile service worker
*/

log.info('Making service worker script with pre-cached resources.');
swPrecache.write(`${path.resolve('client/public')}/sw.js`, {
  staticFileGlobs: [ `${path.resolve('client/public/assets')}/**/*.{js,css,png,jpg,gif,svg,eot,ttf,woff}` ],
  stripPrefix: [ path.resolve('client/public') ],
  verbose: true,
  runtimeCaching : [{
      urlPattern: /marked/,
      handler: 'cacheFirst'
  },{
    urlPattern: /assets\//,
    handler: 'cacheFirst'
  },{
    urlPattern: /api\//,
    handler: 'networkFirst'
  },{
    urlPattern: /fonts\.googleapis\.com/,
    handler: 'cacheFirst'
  },{
    urlPattern: /fonts\.gstatic\.com/,
    handler: 'cacheFirst'
  },{
    urlPattern: /code\.getmdl\.io/,
    handler: 'cacheFirst'
  }]
});


/*
* App config
*/

app.disable('x-powered-by');
app.enable('trust proxy');
app.use(compress);
app.use(cors());


/*
*  Routes
*/

app.use('/', router);


/*
* Error logging
*/

app.use((error, req, res, next) => {
    log.error(error);
    next(error);
});


/*
* Serve 500 error page for requests that does not match any middleware or routes
*/

app.use((error, req, res, next) => {
    /* jshint unused: false */
    res
      .status(500)
      .send({ error: 'Internal server error' });
});


module.exports = http.createServer(app);
