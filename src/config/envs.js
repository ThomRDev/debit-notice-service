require("dotenv/config");
const { get } = require("env-var");

const envs = {
  PORT: get("PORT").required().asPortNumber(),
  POSTGRES_URL: get("POSTGRES_URL").default("public").asString(),
};

module.exports = { envs };
