const db = require("../config/database");

class DebitNoticeService {
  static async getAllOrParams(params) {
    const {
      numero_aviso,
      estado,
      numero_sap,
      usuario_creador,
      email_usuario_creador,
      fecha_inicio,
      fecha_fin,
      nombre_cliente,
      ruc_cliente,
      moneda,
      importe_min,
      importe_max,
    } = params;

    const result = await db
      .getPool()
      .query(
        "SELECT * FROM search_aviso_debito($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
        [
          numero_aviso || null,
          estado || null,
          numero_sap || null,
          usuario_creador || null,
          email_usuario_creador || null,
          fecha_inicio || null,
          fecha_fin || null,
          nombre_cliente || null,
          ruc_cliente || null,
          moneda || null,
          importe_min || null,
          importe_max || null,
        ]
      );
    return result.rows[0].search_aviso_debito;
  }

  static async changeState(body) {
    const { avisos, estado_final, usuario_modificador } = body;

    const stateValidation = await db
      .getPool()
      .query("SELECT * FROM validar_cambio_estado_avisos($1, $2, $3)", [
        avisos,
        estado_final,
        usuario_modificador,
      ]);

    const allErrors = stateValidation.rows[0].success.length <= 0;
    if (!allErrors) {
      throw new Error("No se puede cambiar el estado");
    }

    if (estado_final === "MIGRADO") {
      const successIds = stateValidation.rows[0].success.map((item) => item.id);

      // TODO: mock de esto
      const sapResponse = await fetch("http://sap.com/api/migrar", {
        method: "POST",
        body: JSON.stringify({ ids: successIds }),
      });
      const sapResponseData = await sapResponse.json();

      stateValidation.rows[0].success.forEach((item) => {
        item.numero_sap = sapResponseData.find(
          (sap) => sap.id === item.id
        ).numero_sap;
      });
    }
    await db
      .getPool()
      .query("SELECT * FROM actualizar_estado_avisos($1, $2, $3)", [
        stateValidation.rows[0].success,
        estado_final,
        usuario_modificador,
      ]);
    return stateValidation.rows[0];
  }
}

module.exports = { DebitNoticeService };
