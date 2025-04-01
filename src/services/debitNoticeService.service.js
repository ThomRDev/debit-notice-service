const e = require("express");
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
      cliente: nombre_cliente,
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

  static async getDebitNoticeByNumberAviso(numberAviso) {
    const result = await db
      .getPool()
      .query("SELECT * FROM get_detail_aviso_debito($1)", [numberAviso || ""]);
    return result.rows[0].get_detail_aviso_debito;
  }

  static async changeState(body) {
    const { avisos, estado_final, usuario_modificador, motivo } = body;

    const stateValidation = await db
      .getPool()
      .query("SELECT * FROM validar_cambio_estado_avisos($1::varchar[], $2::text)", [
        avisos,
        estado_final
      ]);

    const allErrors = stateValidation.rows[0].validar_cambio_estado_avisos.success.length <= 0;
    if (allErrors) {
      return stateValidation.rows[0].validar_cambio_estado_avisos
    }

    const successIds = stateValidation.rows[0].validar_cambio_estado_avisos.success.map(
      (item) => item.numero_aviso
    );
    console.log("🚀 ~ DebitNoticeService ~ changeState ~ successIds:", successIds)
    if (estado_final === "MIGRADO") {
      const sapResponse = await fetch("https://sap.com/api/migrar", {
        method: "POST",
        body: JSON.stringify(successIds),
      });
      const sapResponseData = await sapResponse.json();

      stateValidation.rows[0].validar_cambio_estado_avisos.success.forEach((item) => {
        item.numero_sap = sapResponseData.data.find(
          (sap) => sap.numero_aviso === item.numero_aviso
        ).numero_sap;
      });
    }

    if (estado_final === "ANULADO") {
      await fetch("https://sap.com/api/anular", {
        method: "POST",
        body: JSON.stringify(successIds),
      });
    }

    console.log('enviando', stateValidation.rows[0].validar_cambio_estado_avisos.success)

    await db
      .getPool()
      .query("SELECT * FROM actualizar_estado_avisos($1::JSONB, $2::text, $3::INTEGER, $4)", [
        JSON.stringify(stateValidation.rows[0].validar_cambio_estado_avisos.success),
        estado_final,
        usuario_modificador,
        motivo || null,
      ]);
    return stateValidation.rows[0].validar_cambio_estado_avisos;
  }

  static async createDebitNotice(bodyDebit, bodyDebitDetail) {

    try {
      bodyDebit['id_cliente'] = bodyDebit['cliente'];
      console.log(bodyDebit, bodyDebitDetail)
      const { rows } = await db.getPool().query(
        `SELECT crear_aviso_completo($1::JSONB, $2::JSONB[])`,
        [
          JSON.stringify(bodyDebit),
          bodyDebitDetail.map(item => JSON.stringify(item))
        ]
      );
      return rows;
    } catch (error) {
      console.error("Create Method fail");
      throw {
        message: "No se realizo la creacion del aviso de debito",
        statusCode: error.statusCode
      }

    }
  }
}

module.exports = { DebitNoticeService };
