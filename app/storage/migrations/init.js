'use strict';

/*
    The base database migration file. Don't modify this, create a new one.
*/

module.exports = {
  //Up defines the actions to upgrade the database
  up: function(queryInterface, Sequelize) {
    return queryInterface.createTable('rooms', {
        id: {
          allowNull: false,
          autoIncrement: true,
          primaryKey: true,
          type: Sequelize.INTEGER
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
        return queryInterface.createTable('entries', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER
            },
            name: {
                type: Sequelize.STRING
            },
            createdAt: {
                allowNull: false,
                type: Sequelize.DATE
            },
            updatedAt: {
                allowNull: false,
                type: Sequelize.DATE
            },
            roomid: {
                 type: Sequelize.INTEGER,
                 references: { model: 'rooms', key: 'id' }
            }
        });
    });
  },
  //Down defines the actions to rollback an upgrade
  down: function(queryInterface, Sequelize) {
    return queryInterface.dropTable('rooms') && queryInterface.dropTable('entries');
  }
};
