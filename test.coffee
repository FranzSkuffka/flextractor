mocha = require 'mocha'
chai = require 'chai'
expect = chai.expect
Flextractor = require '.'

domainTypes =
    [
        name: 'Account'
        fields: [
            name: 'companyName'
            required: true
        ,
            name: 'phoneNumber'
        ]
    ]

describe 'API', ->
    before ->
        @extractor = new Flextractor domainTypes
    it 'Should return an array', ->
        @extractor.extract('Jan Wirt\n visual4\njanwirth@visual4.de').then (data) ->
            console.log data
            expect(data).to.be.an 'Array'
