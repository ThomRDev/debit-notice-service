const db = require("../config/database");

class DebitNoticeService {
  static async getAll() {
    const result = await db.getPool().query('SELECT * FROM cliente');
    return result.rows;
  }
}

module.exports = { DebitNoticeService };
