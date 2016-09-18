"use strict";

const http            = require('http'),
      path            = require('path'),
      express         = require('express'),
      compress        = require('compression')(),
      cors            = require('cors'),
      log             = require('./log.js'),
      router          = require('../lib/router.js'),
      app             = express(),
      swPrecache      = require('sw-precache');



// Set up handlebars as template engine

app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');
app.set('views', path.resolve('client/public'));



// Create service worker

swPrecache.write(path.resolve('client/public') +'/sw.js',
{
  staticFileGlobs: [path.resolve('client/public') + '/**/*.{js,html,css,png,jpg,gif,svg,eot,ttf,woff}'],
  stripPrefix: [path.resolve('client/public')],
  verbose: true,
  runtimeCaching : [{
      urlPattern: '/bundle\.js/',
      handler: 'cacheFirst'
  },
  {
      urlPattern: '/\.css/',
      handler: 'cacheFirst'
  },
  {
      urlPattern: '/service-worker\.js/',
      handler: 'networkFirst'
  }
]
});


// Configure application

app.disable('x-powered-by');
app.enable('trust proxy');



// Set middleware

app.use(compress);
app.use(cors());



// Attach lib routers

app.use('/', router);


// Log errors

app.use((error, req, res, next) => {
    log.error(error);
    next(error);
});



// Catch all requests which fall through the
// middleware chain, not matching any routes,
// and serve a 500 page

app.use((error, req, res, next) => {
    /* jshint unused: false */
    res.status(500).send({error: "Internal server error"});
});



// Set up http server and Export application

module.exports = http.createServer(app);
