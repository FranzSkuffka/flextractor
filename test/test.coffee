mocha = require 'mocha'
chai = require 'chai'
expect = chai.expect
Flextractor = require './main.coffee'

domainTypes =
    [
        name: 'Account'
        fields:
            [
                name: 'companyName'
                required: true
            ,
                name: 'phoneNumber'
            ]
    ]

describe 'API', ->
    before ->
        @extractor = new Flextractor domainTypes
    it 'should return 42', ->
        console.log @extractor
        @extractor.extract().then (data) ->
            expect(data).to.equal(42)



