"use strict";

/*
* Model to represent entries/participants to an event
*/

module.exports = function(sequelize, DataTypes) {

  var Entry = sequelize.define("Entry", {
    name: DataTypes.STRING
  }, {
    classMethods: {
      associate: function(models) {
        Entry.belongsTo(models.Room, {
          onDelete: "CASCADE",
          foreignKey: 'roomid'
        });
      }
    }
  });

  return Entry;
};
