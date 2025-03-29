const { envs } = require("./config/envs");
const { AppRoutes } = require("./routes/routes");
const Server = require("./server");
const { server: serverSapMock } = require('./config/mock/node')

function main() {

  serverSapMock.listen()
  const server = new Server({
    port: envs.PORT,
    routes: AppRoutes.routes,
  });

  server.start();
}

(async () => {
  main();
})();