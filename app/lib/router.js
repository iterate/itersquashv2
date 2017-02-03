
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
    Promise
        = require('bluebird'),
    router
        = express.Router();


// Log all requests

router.all('*', (req, res, next) => {
    log.info(`${req.method} ${req.url}`);
    next();
});


//Client app endpoint

router.get('/:title', (req, res, next) => {
    models.room.findOrCreate({
        include: [ models.entry ],
        where: {
            title: req.params.title.toLowerCase()
        },
        defaults: {
            description: `# ${req.params.title.toLowerCase()}`
        }
    })
    .then(() => {
        return res.status(200).render('index.html');
    })
    .catch((err) => {
        next(err);
    });

});


//Create entry endpoint
//This doesn't update existing ones yet

router.put('/api/:title/entry', bodyParser.json(), (req, res, next) => {
    models.room.findOne({
        include: [ models.entry ],
        where: {
            title: req.params.title.toLowerCase()
        }
    })
    .then((roomDAO) => {
        const entries = roomDAO.dataValues.entries;
        if(!req.body.name || entries.some((el) => el.name === req.body.name )) {
            return roomDAO;
        }

        return models.entry.create({
            name: req.body.name,
            roomid: roomDAO.dataValues.id
        })
        .then((entry) => {
            roomDAO.addEntry(entry);
            return roomDAO;
        })
    })
    .then(() => {
        return models.room.findOne({
            include: [ models.entry ],
            where: {
                title: req.params.title.toLowerCase()
            }
        })
    })
    .then((room) => {
        return res.status(200)
            .json(room.get({plain: true}));
    })
    .catch((err) => {
        next(err);
    });
});

//Update room description

router.put('/api/:title/description', bodyParser.json(), (req, res, next) => {
    models.room.findOne({
        where: {
            title: req.params.title.toLowerCase()
        }
    })
    .then((room) => {
        return room.update({ description: req.body.description });
    })
    .then((room) => {
        return res.status(200)
            .json(room.get({plain: true}));
    })
    .catch((err) => {
        next(err);
    });
});

router.get('/api/:title/description', (req, res, next) => {
    models.room.findOne({
        where: {
            title: req.params.title.toLowerCase()
        }
    })
    .then((room) => {
        return room.update({ description: req.query.value });
    })
    .then((room) => {
        return res.status(200)
            .json(room.get({plain: true}));
    })
    .catch((err) => {
        next(err);
    });
});

//Fetch room data endpoint

router.get('/api/:title', (req, res, next) => {
    models.room.findOrCreate({
        include: [ models.entry ],
        where: {
            title: req.params.title.toLowerCase()
        },
        defaults: {
            description: `# ${req.params.title.toLowerCase()}`
        }
    })
    .spread((room) => {
        return res.status(200)
            .json(room.get({plain: true}));
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

router.use('/assets', express.static(config.get('docRoot')));

// Export application

module.exports = router;
