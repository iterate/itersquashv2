"use strict";

const   config     = require('../config/config'),
        hbs        = require('handlebars'),
        nodemailer = require('nodemailer');

// create reusable transporter object using the default SMTP transport
const transporter = nodemailer.createTransport(config.get('mailAccount')),
      fs          = require('fs');

// setup e-mail data with unicode symbols
const mailOptions = {
    from: "Squashbot 👥", // sender address
    subject: 'Bli med på squash? 🎾', // Subject line
    plaintext: ' ',
    logger: true //logs to stdout
};

function send(recipients, data) {
    return new Promise((resolve, reject) => {
         fs.readFile(__dirname+'/mail.hbs', "utf-8", (err, template) => {
             if(err) {
                return reject(err);
             }else {
                return resolve(template);
             }
         });
    })
    .catch((err) => {
        throw Error("Could not open mail template. " + err);
    })
    .then((template) => {
        return hbs.compile(template);
    })
    .then((compiledTemplate) => {
        return compiledTemplate(data);
    })
    .then((html) => {
        let options = mailOptions;

        options.to = (recipients instanceof Array) ? recipients.join(', ') : recipients.toString();

        options.html = html;

        transporter.sendMail(options);

        return true;

    }).catch((err) => {
        throw Error("Could not send mail. " + err);
    });
}

module.exports.send = send;
