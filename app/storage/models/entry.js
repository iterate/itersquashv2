"use strict";

/*
* Model to represent entries/participants to an event
*/

module.exports = function(sequelize, DataTypes) {

  var entry = sequelize.define("entry", {
    name: DataTypes.STRING
  }, {
    classMethods: {
      associate: function(models) {
        entry.belongsTo(models.room, {
          onDelete: "CASCADE",
          foreignKey: 'roomid'
        });
      }
    }
  });

  return entry;
};
