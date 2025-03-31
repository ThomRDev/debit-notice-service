const { Router } = require('express');
const { ClientController } = require('../controllers/client.controller');

class ClienteRoutes {

  static get routes() {
    const router = Router();
    router.get('/', ClientController.getAllOrByParam);
    return router;
  }
}

module.exports = { ClienteRoutes };
