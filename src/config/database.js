const { envs } = require("./envs");
const pg = require("pg");

class Database {
  static #instance = null;
  #pool = null;

  constructor() {
    if (Database.#instance) {
      return Database.#instance;
    }
    this.#pool = new pg.Pool({
      connectionString: envs.POSTGRES_URL,
      max: 20,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 2000,
    });

    this.#pool.on('error', (err) => {
      console.error('Error inesperado en cliente inactivo', err);
    });

    Database.#instance = this;
  }

  getPool() {
    return this.#pool;
  }

  async query(text, params) {
    return this.#pool.query(text, params);
  }

  async connect() {
    return this.#pool.connect();
  }

  async end() {
    await this.#pool.end();
  }
}



module.exports = new Database();
