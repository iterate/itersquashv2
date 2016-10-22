/* jshint node: true, strict: true */

"use strict";

const   path    = require('path'),
        fs      = require('fs'),
        convict = require('convict'),
        pckage  = require('../../package.json');

// Configuration schema

let conf = convict({
    env: {
        doc     : "Applicaton environments",
        format  : ["development", "production"],
        default : "development",
        env     : "NODE_ENV",
        arg     : "env"
    },

    version: {
        doc     : "Version of the application",
        format  : String,
        default : pckage.version
    },

    name: {
        doc     : "Name of the application",
        format  : String,
        default : "itersquash"
    },

    serverType: {
        doc     : "Which type of server this is - might be overrided by API environment",
        format  : String,
        default : 'dev',
        env     : 'API_SERVER_TYPE'
    },

    serverName: {
        doc     : "The name of the server - might be overrided by API environment",
        format  : String,
        default : 'dev',
        env     : 'API_SERVER_NAME'
    },

    serverRole: {
        doc     : "The role of this server - might be overrided by API environment",
        format  : String,
        default : 'dev',
        env     : 'API_SERVER_ROLE'
    },

    backendType: {
        doc     : "Which type of backend this is - might be overrided by API environment",
        format  : String,
        default : 'dev',
        env     : 'API_BACKEND_TYPE'
    },

    contextPath: {
        doc     : "Context path for the application. Serves as a prefix for the paths in all URLs",
        format  : String,
        default : ""
    },

    apiPath: {
        doc     : "The prefix for all API routes intended to be accessed by the browser",
        format  : String,
        default : "/"
    },

    httpServerPort: {
        doc     : "The port the server should bind to",
        format  : "port",
        default : 9797,
        env     : "PORT",
        arg     : "port"
    },

    docRoot: {
        doc     : "Document root for static files to be served by the http server",
        format  : String,
        default : "./client/public"
    },

    consoleLogLevel: {
        doc     : "Which level the console transport log should log at",
        format  : String,
        default : "debug",
        env     : "LOG_LEVEL",
    },

    db: {
        doc     : "Database connection string",
        format  : String,
        default : "mongodb://localhost:27017/default",
        env     : "DB_STRING",
    },

    mailAccount: {
        doc     : "Mail account for sending mail",
        format  : String,
        default : "smtps://itersquash%40gmail.com:squashisawesome@smtp.gmail.com",
        env     : "MAIL_URL",
    }
});



// Load config files

if (fs.existsSync(path.resolve(__dirname, '../config/local.json'))) {
    conf.loadFile([path.resolve(__dirname, '../config/', conf.get('env') + '.json'), path.resolve(__dirname, '../config/local.json')]);
} else {
    conf.loadFile([path.resolve(__dirname, '../config/', conf.get('env') + '.json')]);
}

// Validate all properties and export it

conf.validate();

module.exports = conf;
