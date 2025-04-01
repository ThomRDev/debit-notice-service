const { Router } = require('express');
const Database = require('../config/database');
const { DebitNoticeController } = require('../controllers/debitNotice.controller');

class DebitNoticeRoutes {

  static get routes() {
    const router = Router();
    router.get('/', DebitNoticeController.getDebitNotice);
    router.get('/:numberAviso', DebitNoticeController.getDebitNoticeByNumberAviso);
    router.put('/change-state', DebitNoticeController.changeState);
    router.post('/create', DebitNoticeController.createDebitNotice);
    router.get('/create/number', DebitNoticeController.createNumTemp);
    router.put('/update/:id', DebitNoticeController.putDevitNotice);
    return router;
  }
}

module.exports = { DebitNoticeRoutes };
