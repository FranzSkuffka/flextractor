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
    ,
        name: 'Contact'
        fields:
            [
                name: 'personName'
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
                expect(entities.emailAdressList[0].value).to.equal('someone@somedomain.com') # eeeh plural?
                done()
    it 'Should recognize personal Names', (done) ->
        name = 'Abraham Jacos'
        @ner(name)
            .then (entities) =>
                expect(entities.personNameList[0].value).to.equal(name)
                done()

describe 'Classification Module', -> #generate tests iteratively
    before ->
        Classifier = require('../lib/classifier/index.coffee')
        @classifier = new Classifier(domainTypes)

    it 'Should not classify if no required features are recognized', (done) ->
        @classifier.classify(['phoneNumber'])
            .then (classes) =>
                done()
                expect(classes).to.equal []
    it 'Should correctly classify an account', (done) ->
        @classifier.classify(['companyName'])
            .then (classes) =>
                done()
                expect(classes).to.equal ['Account']
    it 'Should correctly classify a contact', (done) ->
        @classifier.classify(['companyName'])
            .then (classes) =>
                done()
                expect(classes).to.equal ['account']





