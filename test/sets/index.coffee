mocha        =  require      'mocha'
chai         =  require      'chai'
expect       =  chai.expect

fs = require 'fs'

describe 'Basic sets', ->
    before ->
        @extractor = require '../flextractorInstance'

    it 'Should nothing if only noise is given', (done) ->
        fs.readFile './test/sets/zero', (err, data) =>
            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets.length).to.equal 0
                    done()
                .catch(done)

    it 'Should recognize a simple account', (done) ->
        fs.readFile './test/sets/accounts/simple', (err, data) =>
            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets[0].type).to.equal 'Account'
                    expect(datasets.length).to.equal 1
                    expect(datasets[0].data.length).to.equal 3
                    done()
                .catch(done)
    it 'Should recognize a noisy account', (done) ->
        fs.readFile './test/sets/accounts/noisy', (err, data) =>
            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets[0].type).to.equal 'Account'
                    expect(datasets[0].type).to.equal 'Account'
                    expect(datasets.length).to.equal 1
                    expect(datasets[0].data.length).to.equal 2
                    done()
                .catch(done)

    it 'Should recognize a simple chance', (done) ->
        fs.readFile './test/sets/chances/simple', (err, data) =>
            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets[0].type).to.equal 'Chance'
                    expect(datasets.length).to.equal 1
                    expect(datasets[0].data.length).to.equal 2
                    done()
                .catch(done)
    it 'Should recognize a noisy chance', (done) ->
        fs.readFile './test/sets/chances/noisy', (err, data) =>
            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets[0].type).to.equal 'Chance'
                    expect(datasets.length).to.equal 1
                    expect(datasets[0].data.length).to.equal 2
                    done()
                .catch(done)

    it 'Should recognize a simple contact', (done) ->
        fs.readFile './test/sets/contacts/simple', (err, data) =>
            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets[0].type).to.equal 'Contact'
                    expect(datasets.length).to.equal 1
                    expect(datasets[0].data.length).to.equal 3
                    done()
                .catch(done)

    it 'Should recognize a noisy contact', (done) ->
        fs.readFile './test/sets/contacts/noisy', (err, data) =>

            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets[0].type).to.equal 'Contact'
                    expect(datasets.length).to.equal 1
                    expect(datasets[0].data.length).to.equal 3
                    done()
                .catch(done)




    it 'Should recognize a combined Account and Chance with relation', (done) ->
        fs.readFile './test/sets/mixed/accountChance', (err, data) =>

            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets.length).to.equal 2
                    done()
                .catch(done)

    it 'Should recognize a combined Account and Contact with relation', (done) ->
        fs.readFile './test/sets/mixed/accountContact', (err, data) =>

            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets.length).to.equal 2
                    done()
                .catch(done)

    it 'Should recognize a combined Account, Contact and Chance with relation', (done) ->
        fs.readFile './test/sets/mixed/accountContactChance', (err, data) =>

            @extractor.extract(data.toString())
                .then (datasets) ->
                    expect(datasets.length).to.equal 3
                    done()
                .catch(done)

    it.only 'should not choke on complex input', (done) ->
        fs.readFile './test/sets/complex/1', (err, data) =>

            @extractor.extract(data.toString())
                .then (datasets) ->
                    console.log datasets
                    done()
                .catch(done)
    it.only 'should associate emails correctly complex input', (done) ->
        fs.readFile './test/sets/complex/2', (err, data) =>

            @extractor.extract(data.toString())
                .then (datasets) ->
                    console.log datasets
                    done()
                .catch(done)
