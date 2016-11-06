"use strict";

/*
* Model to represent a page
*/

module.exports = function(sequelize, DataTypes) {

    var room = sequelize.define('room', {
        title: {
            type: DataTypes.STRING
        },
        description: {
            type: DataTypes.STRING
        }
    }, {
        classMethods: {
          associate: function(models) {
            room.hasMany(models.entry, {
              foreignKey: 'roomid'
          });
          }
        }
    });

  return room;
};
