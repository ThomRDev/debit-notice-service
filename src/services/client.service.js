const db = require("../config/database");

class ClientService {
  static async getAllOrParams(req) {
    const { filter } = req.query;

    const result = await db
      .getPool()
      .query("SELECT * FROM buscar_clientes($1)", [filter || null]);
    return result.rows;
  }

}

module.exports = { ClientService };
