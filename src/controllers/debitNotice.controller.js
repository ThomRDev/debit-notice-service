const { DebitNoticeService } = require("../services/debitNoticeService.service");

class DebitNoticeController {

  static getDebitNotice(req, res) {
    return DebitNoticeService.getAllOrParams(req.query)
      .then(result => {
        return res.json(result);
      })
      .catch(error => {
        return res.status(500).json({ error: error.message });
      });
  }

  static changeState(req, res) {
    return DebitNoticeService.changeState(req.body)
      .then(result => {
        return res.json(result);
      })
      .catch(error => {
        return res.status(500).json({ error: error.message });
      });
  }
}

module.exports = { DebitNoticeController };
