#!/usr/bin/env node
/* jshint node: true, strict: true */

"use strict";

const config      = require('../config/config.js'),
      server      = require('./app.js'),
      log         = require('./log.js'),
      fs          = require('fs'),
      db          = require('./db');



// Start application

server.listen(config.get('httpServerPort'), () => {
    db.open();
    fs.readFile('./.art', "ASCII", function(err, data) {
        if(!err) {
            log.info(data);
        }

        log.info('server running at http://localhost:' + server.address().port);
        log.info('server process has pid ' + process.pid);
    });
});



// Catch uncaught exceptions, log it and take down server in a nice way.
// Upstart or forever should handle kicking the process back into life!

process.on('uncaughtException', (error) => {
    log.error('shutdown - server taken down by force due to a uncaughtException');
    log.error(error.message);
    log.error(error.stack);
    db.close();
    server.close();
    process.nextTick(() => {
        process.exit(1);
    });
});



// Listen for SIGINT (Ctrl+C) and do a gracefull takedown of the server

process.on('SIGINT', () => {
    log.info('shutdown - got SIGINT - taking down server gracefully');
    db.close();
    server.close();
    process.nextTick(() => {
        process.exit(0);
    });
});



// Listen for SIGTERM (Upstart) and do a gracefull takedown of the server

process.on('SIGTERM', () => {
    log.info('shutdown - got SIGTERM - taking down server gracefully');
    db.close();
    server.close();
    process.nextTick(() => {
        process.exit(0);
    });
});