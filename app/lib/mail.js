"use strict";

const   config     = require('../config/config'),
        hbs        = require('handlebars'),
        nodemailer = require('nodemailer'),
        Promise    = require('bluebird');

// create reusable transporter object using the default SMTP transport
const transporter = Promise.promisifyAll(nodemailer.createTransport(`smtps://${config.get('mailAccount')}:${config.get('mailPassword')}@smtp.gmail.com`)),
      fs          = Promise.promisifyAll(require('fs'));

// setup e-mail data with unicode symbols
const mailOptions = {
    from: `"Squashbot 👥" <${config.get('mailAccount')}>`, // sender address
    subject: 'Bli med på squash? 🎾', // Subject line
    plaintext: ' ',
    logger: true //logs to stdout
};

function send(recipients, data) {
    return fs.readFileAsync(__dirname+'/mail.hbs', "utf-8")
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

            transporter.sendMailAsync(options);

            return true;

        }).catch((err) => {
            throw Error("Could not send mail. " + err);
        });
}

module.exports.send = send;
