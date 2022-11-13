'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
const VERSION = '0.0.1';

// App
const app = express();
app.get('/', (req, res) => {
  res.send(`Hello World, version: ${VERSION}`);
});

app.listen(PORT, () => {
  console.log(`Running on http://${HOST}:${PORT}`);
});