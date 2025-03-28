const { AdvanceRequestService } = require("../services/advanceRequest.service");

class AdvanceRequestController {
    static async getAdvanceRequest(req, res){
        const { numero_solicitud } = req.params;

        console.log(numero_solicitud + 'controller')

        return AdvanceRequestService.getAdvanceRequest(numero_solicitud)
        .then((result) => {
            return res.json(result);
        }).catch((err) => {
            return res.status(500).json({ error: err.message });
        });
    }

    static async getAll(req, res){
        return AdvanceRequestService.getAll()
        .then((result) => {
            return res.json(result);
        }).catch((err) => {
            return res.status(500).json({ error: err.message });
        });
    }
}

module.exports = { AdvanceRequestController };
