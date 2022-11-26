'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
const VERSION = process.env.VERSION;
const APP_VERSION = "1.0.0";
const DEPLOYMENT = process.env.DEPLOYMENT;
const COUNT = process.env.COUNT;

// App
const app = express();
app.get('/', (req, res) => {
  res.send(`Version ${VERSION} - (${DEPLOYMENT}) #${COUNT}!, App Version: ${APP_VERSION}, \n`);
});

app.listen(PORT, () => {
  console.log(`Running on http://${HOST}:${PORT}`);
});
