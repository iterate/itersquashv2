"use strict";

let mongoose = require('mongoose');

    mongoose.Promise = Promise;

/*
* Model to represent entries/participants to an event
*/
const entry = mongoose.Schema({
    name: String,
    created: { type: Date, default: Date.now() },
    updated: { type: Date, default: Date.now() }
});

/*
* Model to represent a page
*/
const room = mongoose.Schema({
    title: String,
    description: { type: String, default: "Tommelomt" },
    created: { type: Date, default: Date.now() },
    updated: { type: Date, default: Date.now() },
    entries: [ entry ]
});

module.exports.Room = mongoose.model('Room', room);
