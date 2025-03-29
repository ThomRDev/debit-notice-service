const db = require("../config/database");

class AdvanceRequestService {
  static async getAdvanceRequest(numero_solicitud = null, page= null, pageSize = null) {
    try{
      if (numero_solicitud == null && page== null && pageSize == null) {
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
      if (numero_solicitud) {
        const numeroStr = String(numero_solicitud).trim();
        const { rows } = await db.getPool().query(
          'SELECT * FROM get_search_solicitudes_anticipo($1::text)',
          [numeroStr]);
          if (!rows[0]) {
            return {
              data: [],
              total_count: 0,
              current_page: 1,
              page_size: 10
            };
          }
    
          return rows[0].get_search_solicitudes_anticipo;
      }
      
      if (page === null || pageSize === null) {
        throw {
          message: "Se requieren ambos parámetros: page y pageSize",
          statusCode: 400
        };
      }
      
      page = parseInt(page);
      pageSize = parseInt(pageSize);

      const { rows } = await db.getPool().query(
        'SELECT * FROM get_search_solicitudes_anticipo(NULL, $1, $2)',
        [page, pageSize]
      );

      return rows[0]?.get_search_solicitudes_anticipo || {
        data: [],
        total_count: 0,
        current_page: page,
        page_size: pageSize
      };

    }catch(error){
        console.error("AdvanceRequestService : ", error)
        throw {
          message: "No se realizo la consulta get_search_solicitudes_anticipo",
          statusCode: error.statusCode
        }
    }
  }

}

module.exports = { AdvanceRequestService };