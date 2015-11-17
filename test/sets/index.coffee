mocha        =  require      'mocha'
chai         =  require      'chai'
expect       =  chai.expect
Flextractor  =  require      '../../'

domainTypes =  require '../domainStructure'

fs = require 'fs'

describe 'Basic sets', ->
    before ->
        @extractor = new Flextractor domainTypes
    it 'Should recognize a simple account', (done) ->
        fs.readFile './test/sets/accounts/simple', (err, data) =>

            @extractor.extract(data.toString()).then (datasets) ->
                expect(datasets[0].type).to.equal 'Account'
                done()
    it 'Should recognize a noisy account', (done) ->
        fs.readFile './test/sets/accounts/noisy', (err, data) =>

            @extractor.extract(data.toString()).then (datasets) ->
                expect(datasets[0].type).to.equal 'Account'
                done()

    it 'Should recognize a simple chance', (done) ->
        fs.readFile './test/sets/chances/simple', (err, data) =>

            @extractor.extract(data.toString()).then (datasets) ->
                expect(datasets[0].type).to.equal 'Chance'
                done()
    it 'Should recognize a noisy chance', (done) ->
        fs.readFile './test/sets/chances/noisy', (err, data) =>

            @extractor.extract(data.toString()).then (datasets) ->
                expect(datasets[0].type).to.equal 'Chance'
                done()

    it 'Should recognize a simple contact', (done) ->
        fs.readFile './test/sets/contacts/simple', (err, data) =>

            @extractor.extract(data.toString()).then (datasets) ->
                expect(datasets[0].type).to.equal 'Contact'
                done()

    it 'Should recognize a noisy contact', (done) ->
        fs.readFile './test/sets/contacts/noisy', (err, data) =>

            @extractor.extract(data.toString()).then (datasets) ->
                expect(datasets[0].type).to.equal 'Contact'
                done()


    it 'Should recognize a combined Account and Chance with relation', (done) ->
        fs.readFile './test/sets/mixed/accountChance', (err, data) =>

            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets[0].type).to.equal 'Chance'
                    done()
                .catch(done)

    it 'Should recognize a combined Account and Chance with relation', (done) ->
        fs.readFile './test/sets/mixed/accountChance', (err, data) =>

            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets[0].type).to.equal 'Chance'
                    done()
                .catch(done)
