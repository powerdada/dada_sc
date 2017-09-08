// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // Match any network id
<<<<<<< HEAD
      gas: 4612388
=======
      gas: 4712388
>>>>>>> d5b78b852593eb2e3405ecf66833ec791f155733
    }
  }
}
