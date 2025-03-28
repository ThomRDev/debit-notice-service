const { envs } = require("./config/envs");
const { AppRoutes } = require("./routes/routes");
const Server = require("./server");

function main() {

  const server = new Server({
    port: envs.PORT,
    routes: AppRoutes.routes,
  });

  server.start();
}

(async () => {
  main();
})();