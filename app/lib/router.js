
'use strict';

const express       = require('express');
const config        = require('../config/config.js');
const log           = require('./log.js');
const bodyParser    = require('body-parser');
const url           = require('url');
const mail          = require('./mail.js');
const models        = require('../storage/models');
const Promise       = require('bluebird');
const router        = express.Router();
const path          = require('path');


/*
* Log all requests
*/

router.all('*', (req, res, next) => {
    log.info(`${req.method} ${req.url}`);
    next();
});


/*
* Landing page
*/

router.get('/event/:id', (req, res, next) => {
    models.event.findOrCreate({
        include: [ models.participant ],
        where: {
            title: req.params.id.toLowerCase()
        },
        defaults: {
            description: `# ${req.params.id.toLowerCase()}`
        }
    })
    .spread((event) => {
        return res.status(200).sendFile(path.join(process.cwd(), config.get('docRoot'), '/index.html'));
    })
    .catch((err) => {
        next(err);
    });
});


/*
* Event data
*/

router.get('/api/:id', (req, res, next) => {
    models.event.find({
        include: [ models.participant ],
        where: {
            title: req.params.id.toLowerCase()
        },
        defaults: {
            description: `# ${req.params.id.toLowerCase()}`
        }
    })
    .then((event) => {
        if(event) {
            return res.status(200).json({ title: event.dataValues.title, id: event.dataValues.id });
        } else {
            next();
        }
    })
    .catch((err) => {
        next(err);
    });
});


/*
* Create participant
*/

router.put('/api/:id/participants', bodyParser.json(), (req, res, next) => {
    if(!req.body.name) {
        return res.status(400).json({ error : `Expected a name:String in the request body.`, status: 400 });
    }
    
    return models.event.findOne({
        include: [ models.participant ],
        where: {
            id: req.params.id
        }
    })
    .then(event => {
        if(!event){
            return res.status(404).json({ error : `No event with id ${req.params.id} found.`, status: 404 });
        } else {
            return event.createParticipant({
                name: req.body.name,
                eventid: event.dataValues.id
            })
            .then(_ => event.getParticipants({ order: models.sequelize.literal('id ASC') })) //FIXME: {plain: true} returnerer bare 1 objekt
            .then(participants => res.status(200).json(participants.map(p => p.dataValues)))
            .catch(next);
        }
    });
});


/*
* Update participant
*/

router.put('/api/:id/participants/:participantId', bodyParser.json(), (req, res, next) => {
    if (!req.body.name || isNaN(parseInt(req.params.participantId, 10)) || isNaN(parseInt(req.params.id, 10))) {
        return res.status(400).json({ error : `Invalid request`, status: 400 });
    }

    models.participant.update({ name: req.body.name }, { where: { id: req.params.participantId }, returning: true})
    .then((one, two) => {
        return models.participant.findAll({ where: { eventid: req.params.id }, order: models.sequelize.literal('id ASC')})
    }) //FIXME: {plain: true} returnerer bare 1 objekt
    .then(participants => res.status(200).json(participants.map(p => p.dataValues)))
    .catch(next);
});


/*
* Delete participant
*/

router.delete('/api/:id/participants/:participantId', (req, res, next) => {
    if (isNaN(parseInt(req.params.participantId, 10)) || isNaN(parseInt(req.params.id, 10))) {
        return res.status(400).json({ error : `Invalid request`, status: 400 });
    }

    models.participant.destroy({ where: { id: req.params.participantId }})
    .then(_ => {
        return models.participant.findAll({ where: { eventid: req.params.id }, order: models.sequelize.literal('id ASC')})
    }) //FIXME: {plain: true} returnerer bare 1 objekt
    .then(participants => res.status(200).json(participants.map(p => p.dataValues)))
    .catch(next);
});


/*
* Get participant
*/

router.get('/api/:id/participants', (req, res, next) => {
    models.participant.findAll({
        where: {
            eventid: req.params.id
        }
        , order: models.sequelize.literal('id ASC')
    })
    .then((participants) => {
        return res.status(200)
            .json(participants.map(p => p.dataValues));
    })
    .catch((err) => {
        next(err);
    });
});


/*
* Update event description
*/

router.put('/api/:id/description', bodyParser.json(), (req, res, next) => {
    models.event.findOne({
        where: {
            id: req.params.id
        }
    })
    .then((event) => {
        return event.update({ description: req.body.description });
    })
    .then((event) => {
        return res.status(200)
            .json(event.get({plain: true}));
    })
    .catch((err) => {
        next(err);
    });
});


/*
* Get event description
*/

router.get('/api/:id/description', (req, res, next) => {
    models.event.findOne({
        where: {
            id: req.params.id
        }
    })
    .then((event) => {
        return res.status(200)
            .json(event.dataValues.description);
    })
    .catch((err) => {
        next(err);
    });
});


/*
* Health check
*/

router.get('/ping', (req, res) => {
    res.status(200).send('OK ' + config.get('version'));
});


/*
* Static files
*/

router.use('/', express.static(config.get('docRoot')));


module.exports = router;
