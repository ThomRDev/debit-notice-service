const { DebitNoticeRoutes } = require('./debitNotice.route');
const { AdvanceRequestRoutes } = require('./advanceRequest.route');
const { Router } = require('express');

class AppRoutes {
  static get routes() {
    const router = Router();
    router.use('/api/debit-notice', DebitNoticeRoutes.routes);
    // router.use('/api/advance-request', AdvanceRequestRoutes.routes);
    return router;
  }
}

module.exports = { AppRoutes };
