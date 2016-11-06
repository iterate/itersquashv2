'use strict';

let fs
        = require("fs"),
    path
        = require("path"),
    config
        = require('../../config/config'),
    Sequelize
        = require("sequelize"),
    log
        = require('../../lib/log'),
    basename
        = path.basename(module.filename);


let db = {}, sequelize;

if (config.get('env') === 'production') {
    sequelize = new Sequelize(config.get('dbURL'), {
            dialect: 'postgres',
            logging: false,
            dialectOptions: {
                ssl: true
            }});
}else {
    sequelize = new Sequelize(config.get('dbURL'), {
        dialect: 'postgres'
    });
}

//Test connection
sequelize
    .authenticate()
    .then(() => {
        log.info("Connected successfully to database");
        if (config.get('env') === 'production') {
            log.info('Set NODE_ENV to #development" to see SQL statements');
        }
    })
    .catch((err) => {
        log.error("Failed connecting to database: %s", err);
        return null;
    });

//Import models from same folder and expose on the db object
fs
  .readdirSync(__dirname)
  .filter(function(file) {
    return (file.indexOf('.') !== 0) && (file !== basename) && (file.slice(-3) === '.js');
  })
  .forEach(function(file) {
    var model = sequelize['import'](path.join(__dirname, file));
    db[model.name] = model;
  });

Object.keys(db).forEach(function(modelName) {
    debugger;
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;
