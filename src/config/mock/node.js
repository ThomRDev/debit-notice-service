const { handlers } = require('./handlers')
const { setupServer } = require('msw/node')

const server = setupServer(...handlers)

module.exports = {
  server
}