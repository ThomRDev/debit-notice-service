const { ClientService } = require("../services/client.service");

class ClientController {
  static async getAllOrByParam(req, res) {
    return ClientService.getAllOrParams(req)
      .then((result) => {
        return res.json(result);
      })
      .catch((err) => {
        return res.status(500).json({ error: err.message });
      });
  }
}

module.exports = { ClientController };
