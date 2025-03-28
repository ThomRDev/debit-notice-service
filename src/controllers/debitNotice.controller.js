const db = require("../config/database");

class DebitNoticeController {
  static getDebitNotice(req, res) {
    return db.getPool().query('SELECT * FROM cliente').then(result => res.json(result.rows));
  }
}

module.exports = { DebitNoticeController };
