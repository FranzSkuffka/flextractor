
Promise = require 'bluebird'
test = -> new Promise (resolve) ->
    value = 32
    resolve value

# test().then (value) ->
    # console.log value

module.exports = test
