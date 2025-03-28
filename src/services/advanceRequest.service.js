const db = require("../config/database");

class AdvanceRequestService {
  static async getAdvanceRequest(numero_solicitud) {
    try{

      const numeroStr = String(numero_solicitud).trim();

      const { rows } = await db.getPool().query(
        'SELECT * FROM get_search_solicitudes_anticipo($1::text)',
        [numeroStr]
      );

      const tipoDato = typeof numeroStr;
      console.log(`Tipo de dato recibido: ${tipoDato}, Valor: ${numeroStr}`);

      if (!rows[0]) {
        return {
          data: [],
          total_count: 0,
          current_page: 1,
          page_size: 10
        };
      }

      return rows[0].get_search_solicitudes_anticipo;
    }catch(error){
        console.error("AdvanceRequestService : ", error)
        throw {
          message: "No se realizo la consulta get_search_solicitudes_anticipo",
          statusCode: error.statusCode
        }
    }
  }

static async getAll() {
  try{

    const { rows } = await db.getPool().query(
      'SELECT * FROM get_search_solicitudes_anticipo()'
    );
    if (!rows[0]) {
      return {
        data: [],
        total_count: 0
      };
    }
    return rows[0].get_search_solicitudes_anticipo;
  }
  catch(error){
      console.error("Error en getAll : ", error)
      throw {
        message: "No se realizo la consulta getAll",
        statusCode: error.statusCode
      }
  }
}
}

module.exports = { AdvanceRequestService };