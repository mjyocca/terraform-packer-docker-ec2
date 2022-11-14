'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
const VERSION = process.env.VERSION;
const DEPLOYMENT = process.env.DEPLOYMENT;
const COUNT = process.env.COUNT;

// App
const app = express();
app.get('/', (req, res) => {
  res.send(`Version ${VERSION} - (${DEPLOYMENT}) #${COUNT}!, \n`);
});

app.listen(PORT, () => {
  console.log(`Running on http://${HOST}:${PORT}`);
});