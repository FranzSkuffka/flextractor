mocha = require 'mocha'
chai = require 'chai'
expect = chai.expect
flextractor = require './main.coffee'
console.log flextractor
describe 'API', ->
    it 'should return 32', ->
        flextractor().then (data) ->
            expect(data).to.equal(32)



