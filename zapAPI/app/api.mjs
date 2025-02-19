import express from "express";
import { Client} from "whatsapp-web.js";
import pkg from "qrcode-terminal";
import path from "path";
import { fileURLToPath } from "url";


const __dirname = path.dirname(fileURLToPath(import.meta.url));
const sessionDir = path.join(__dirname, 'session');

const client = new Client({
    puppeteer:{
        userDataDir:sessionDir
    }
});

client.on("qr", (qr) => {
    console.log("tome qr code");
    var generated_qrcode = pkg.generate(qr, {small: true});
    console.log(generated_qrcode)
});

client.on("ready", () => {
    console.log("Client is ready");
});

/* sim, esse é meu debugger */
client.on("message", (message) => {
    if (message.body.startsWith("!teste")) {
        message.reply("testado");
    }
    if (message) {
        console.log(message.from,message.body);
    }

});

client.on('authenticated', (session) => {
    console.log('Autenticado');
});

client.on('auth_failure', (msg) => {
    console.error('Falha:', msg);
});

client.initialize();