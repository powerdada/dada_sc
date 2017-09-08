// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // Match any network id
      gas: 4712388
    },
    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      from: "0xcbc9c600209bb3511bc562936770f6b5cbd1267e", // default address to use for any transaction Truffle makes during migrations
      network_id: 4 //,
      //gas: 4612388 // Gas limit used for deploys
    }
  }
}
