"use strict";

/*
* Model to represent entries/participants to an event
*/

module.exports = function(sequelize, DataTypes) {
  const participant = sequelize.define('participant', {
    name: DataTypes.STRING,
    cancelled: DataTypes.BOOLEAN
  }, {
    classMethods: {
      associate: function(models) {
        participant.belongsTo(models.event, {
          onDelete: 'CASCADE',
          foreignKey: 'eventid'
        });
      }
    }
  });

  return participant;
};
