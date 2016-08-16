"use strict"

let mongoClient = require('mongodb').MongoClient,
    Promise     = require('bluebird'),
    log         = require('./log'),
    config      = require('../config/config');

let database;

function open(){
    return new Promise((resolve, reject) => {
        if(database) {
            return resolve(database);
        }else {
            mongoClient.connect(config.get('db'), function(err, db) {
                if(err) {
                    log.error("Failed connecting to database");
                    reject(err);
                }else {
                    log.info("Connected successfully to mongo database");
                    database = db;
                }
                return resolve(database);
            });
        }
    });
};

function close(){
    if(database) {
        log.info("Closing database connection");
        database.close();
    }
}

module.exports.open = open;
module.exports.close = close;
