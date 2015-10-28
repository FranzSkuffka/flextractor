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
    it 'Should recognize E-Mail Adresses', (done) ->
        @ner('someone@somedomain.com')
            .then (entities) ->
                emails = entities.get().emails
                address = emails[0].value
                expect(address).to.equal('someone@somedomain.com')
                done()
    it 'Should recognize names', (done) ->
        @ner('Witney Houston')
            .then (entities) =>
                persons = entities.get().persons
                name = persons[0].value
                expect(name).to.equal('Witney Houston')
                done()




