const { AdvanceRequestService } = require("../services/advanceRequest.service");

class AdvanceRequestController {
    static async getAdvanceRequest(req, res){
        const { numero_solicitud , page, pageSize} = req.params;

        console.log(numero_solicitud + page + pageSize + 'controller')

        return AdvanceRequestService.getAdvanceRequest(
            numero_solicitud !== 'null' ? numero_solicitud : null,
            page !== 'null' ? page : null,
            pageSize !== 'null' ? pageSize : null
        )
        .then((result) => {
            return res.json(result);
        }).catch((err) => {
            return res.status(500).json({ error: err.message });
        });
    }
}

module.exports = { AdvanceRequestController };
