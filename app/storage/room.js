"use strict";

/*
* Model to represent a page
*/

module.exports = function(sequelize, DataTypes) {

    var Room = sequelize.define('Room', {
        title: {
            type: DataTypes.STRING
        },
        description: {
            type: DataTypes.STRING
        }
    }, {
        classMethods: {
          associate: function(models) {
            Room.hasMany(models.Entry, {
              foreignKey: 'roomid'
          });
          }
        }
    });

  return Room;
};
