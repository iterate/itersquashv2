'use strict';

import * as mdc from 'material-components-web';
import Elm from './elm/Main.elm';
import moment from 'moment';

const eventName = window.location.pathname.match(/^\/[^/]+\/([a-zA-Z0-9]+)/)[1];
const container = document.getElementById('main');
const language = window.navigator.language;

if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js').then(function() {
      console.log("Service Worker Registered");
    });
}

const callback = function(mutationList) {
    const arr = document.querySelectorAll('.mdc-text-field');
    arr.forEach(mdc.textField.MDCTextField.attachTo);
};

const observer = new MutationObserver(callback);
observer.observe(document.getElementById('main'), { subtree: true, childList: true });


//Init app
fetch(`/api/${eventName}`)
    .then(res => {
        if(res.ok) {
            return res.json();
        }
        throw new Error('Could not fetch event data');
    })
    .then(appData => Elm.Main.embed(container, appData))
    .then(app => {
        //TODO Strip extra languages from moment
        //Parsing time with moment to get time since
        app.ports.parseTime.subscribe(participants => {
            const parsed = participants.map(participant => {
                participant.createdAtTimeSince = moment(participant.createdAt).locale([language, 'en_US']).fromNow();
                
                return participant;
            });
            
            app.ports.parsedTime.send(parsed);
        });

        //Init material style effects
        // console.log(document.querySelector('.mdc-text-field'));
        // mdc.textField.MDCTextField.attachTo(document.querySelector('.mdc-text-field'));

        return app;
    })
    .catch(err => console.error);
