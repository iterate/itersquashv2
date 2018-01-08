"use strict";

/*
* Model to represent a page
*/

module.exports = function(sequelize, DataTypes) {
    const event = sequelize.define('event', {
        title: DataTypes.STRING,
        description: DataTypes.STRING
    }, {
        classMethods: {
          associate: function(models) {
            event.hasMany(models.participant, {
              foreignKey: 'eventid'
          });
          }
        }
    });

  return event;
};
