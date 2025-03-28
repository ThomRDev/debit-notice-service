const express = require('express');
const compression = require('compression');
const cors = require('cors');

class Server {
  constructor(options) {
    const { port, routes } = options;
    this.app = express();
    this.port = port;
    this.routes = routes;
    this.serverListener = null;
  }

  async start() {
    this.app.use(cors()); // raw
    this.app.use(express.json()); // raw
    this.app.use(express.urlencoded({ extended: true })); // x-www-form-urlencoded
    this.app.use(compression());

    this.app.use(this.routes);

    this.serverListener = this.app.listen(this.port, () => {
      console.log(`Server running on port ${this.port}`);
    });
  }

  close() {
    this.serverListener?.close();
  }
}

module.exports = Server;
