'use strict';

/*
    The base database migration file. Don't modify this, create a new one. 
    Migrations are executed in sorted order, so prefix filename with a number in increasing value.
*/

module.exports = {
  //Up defines the actions to upgrade the database
  up: function(queryInterface, Sequelize) {
    return queryInterface.createTable('events', {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
          },
        title: {
          type: Sequelize.STRING
        },
        description: {
          type: Sequelize.STRING
        },
        createdAt: {
          allowNull: false,
          type: Sequelize.DATE
        },
        updatedAt: {
          allowNull: false,
          type: Sequelize.DATE
        }
    }).then(function () {
        return queryInterface.createTable('participants', {
            id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true
              },
            name: {
                type: Sequelize.STRING
            },
            createdAt: {
                allowNull: false,
                type: Sequelize.DATE
            },
            cancelled: {
                type: Sequelize.BOOLEAN,
                allowNull: false,
                defaultValue: false
            },
            updatedAt: {
                allowNull: false,
                type: Sequelize.DATE
            },
            eventid: {
                 type: Sequelize.INTEGER,
                 references: { model: 'events', key: 'id' }
            }
        });
    });
  },
  //Down defines the actions to rollback an upgrade
  down: function(queryInterface, Sequelize) {
    return queryInterface.dropTable('events') && queryInterface.dropTable('participants');
  }
};
