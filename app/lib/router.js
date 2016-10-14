
'use strict';

const express
        = require('express'),
    config
        = require('../config/config.js'),
    log
        = require('./log.js'),
    bodyParser
        = require('body-parser'),
    url
        = require('url'),
    mail
        = require('./mail.js'),
    models
        = require('../storage/models'),
    router
        = express.Router();


// Log all requests

router.all('*', (req, res, next) => {
    log.info(`${req.method} ${req.url}`);
    next();
});


//Client app endpoint

router.get('/r/:title', (req, res, next) => {
    models.Room.findOne({ 'title': req.params.title })
        .exec()
        .then((room) => {
            //If a room with the given title doesnt exist, we create it
            if(!room){
                let newRoom = new models.Room({ title: req.params.title, description: "Tommelomt", entries: []});
                //Save persists the new room to the database
                newRoom.save();
            }

            res.status(200).render('index.html');
        })
        .catch((err) => {
            next(err);
        });
});


//Create entry endpoint
//This doesn't update existing ones yet

router.put('/api/:title/entry', bodyParser.json(), (req, res, next) => {
    let content = req.body || {};

    //Todo, should probably have some better input validation on this
    if (content.name) {
        models.Room.findOne({ 'title': req.params.title })
            .exec()
            .then((room) => {
                if(!room){
                    res.status(403).json({ error: "You cannot sign up to an event that does not exist!" });
                }else {
                    room.entries.push({ name: content.name });
                    room.save();

                    res.status(200).json(room);
                }
            })
            .catch((err) => {
                next(err);
            });
    }else {
        res.status(400).json({ error: "Invalid JSON in request body!"});
    }
});


//Fetch room data endpoint

router.get('/api/:title', (req, res, next) => {

    models.Room.findOne({ 'title': req.params.title })
        .exec()
        .then((room) => {
            //If a room with the given title doesnt exist, we create it
            if(!room){
                res.status(404).json({error: "Room not found"});
            }else {
                res.status(200).json(room);
            }
        })
        .catch((err) => {
            next(err);
        });

});


//Mail endpoint

router.get('/invite', (req, res, next) => {
    const urlObj = url.parse(req.url, true);
    const recipients = urlObj.query.recipients;

    if(!recipients) {
        throw Error("No recipients found. Example: /invite?recipients=foo@baz.com,bar@bizz.com");
    }

    mail.send(recipients)
        .then(() => {
            res.status(200).send("Mail sent successfully!");
            return;
        }).catch((err) => {
            return next(err);
       });
});


// Health check

router.get('/ping', (req, res) => {
    res.status(200).send('OK ' + config.get('version'));
});


// Static files

router.use(express.static(config.get('docRoot')));

// Export application

module.exports = router;
