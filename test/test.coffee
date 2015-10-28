mocha        =  require      'mocha'
chai         =  require      'chai'
expect       =  chai.expect
Flextractor  =  require      '../'

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

# describe 'API', ->
    # before ->
        # @extractor = new Flextractor domainTypes
    # it 'should return 42', ->
        # console.log @extractor
        # @extractor.extract().then (data) ->
            # expect(data).to.equal(42)


describe 'NER Module', ->
    before ->
        @ner = require '../lib/ner/index.coffee'
    it 'Should throw if no input is provided', ->
        (=> @ner()).should.throw()
        (=> @ner('Isaac Newton')).should.not.throw()
    it 'Should recognize E-Mail adresses', (done) ->
        @ner('someone@somedomain.com')
            .then (entities) ->
                expect(entities.emails[0].value).to.equal('someone@somedomain.com')
                done()
    it 'Should recognize names', (done) ->
        name = 'Abraham Jacos'
        @ner(name)
            .then (entities) =>
                expect(entities.persons[0].value).to.equal(name)
                done()




