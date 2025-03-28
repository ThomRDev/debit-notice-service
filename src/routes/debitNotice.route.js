const { Router } = require('express');
const Database = require('../config/database');
const { DebitNoticeController } = require('../controllers/debitNotice.controller');

class DebitNoticeRoutes {

  static get routes() {
    const router = Router();
    router.get('/', DebitNoticeController.getDebitNotice);
    router.put('/change-state', DebitNoticeController.changeState);
    return router;
  }
}

module.exports = { DebitNoticeRoutes };
