"use strict";

let fs
        = require("fs"),
    path
        = require("path"),
    config
        = require('../config/config'),
    Sequelize
        = require("sequelize"),
    log
        = require('../lib/log');

let db        = {},
    sequelize = new Sequelize(config.get('dbURL'));

//Test connection
sequelize
    .authenticate()
    .then(() => {
        log.info("Connected successfully to database");
    })
    .catch((err) => {
        log.error("Failed connecting to database: %s", err);
        return null;
    });


//Import model definitions

fs
  .readdirSync(__dirname)
  .filter(function(file) {
    return (file.indexOf(".") !== 0) && (file !== "index.js");
  })
  .forEach(function(file) {
    //TODO: This is fragile shit, breaks if the files are not valid modules
    var model = sequelize.import(path.join(__dirname, file));
    db[model.name] = model;
  });

Object.keys(db).forEach(function(modelName) {
  if ("associate" in db[modelName]) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;
