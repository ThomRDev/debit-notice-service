const handlers = require('./handlers')
const { setupServer } = require('msw/node')

export const server = setupServer(...handleRequest)