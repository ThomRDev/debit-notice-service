const { DebitNoticeService } = require("../services/debitNoticeService.service");

class DebitNoticeController {


  static getDebitNotice(req, res) {
    return DebitNoticeService.getAll()
      .then(result => {
        return res.json(result);
      })
      .catch(error => {
        return res.status(500).json({ error: error.message });
      });
  }
}

module.exports = { DebitNoticeController };
