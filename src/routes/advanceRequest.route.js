const { Router } = require('express');
const { AdvanceRequestController } = require('../controllers/advanceRequest.controller');

class AdvanceRequestRoutes {
  static get routes() {
    const router = Router();
    router.get('/:numero_solicitud?/:page?/:pageSize?', AdvanceRequestController.getAdvanceRequest)
    return router;
  }
}

module.exports = { AdvanceRequestRoutes };
