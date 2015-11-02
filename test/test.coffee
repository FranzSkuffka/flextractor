mocha        =  require      'mocha'
chai         =  require      'chai'
expect       =  chai.expect
Flextractor  =  require      '../'
brain        =  require      'brain'
Entity       =  require '../lib/ner/services/Entity'

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

describe 'API', ->
    before ->
        @extractor = new Flextractor domainTypes
    it 'should return 42', (done) ->
        @extractor.extract('Jan Wirth').then (data) ->
            done()


describe 'NER Module', ->
    before ->
        @ner = require '../lib/ner/index.coffee'
    it 'Should throw if no input is provided', ->
        (=> @ner()).should.throw()
        (=> @ner('Isaac Newton')).should.not.throw()
    it 'Should recognize E-Mail adresses', (done) ->
        @ner('someone@somedomain.com')
            .then (entities) ->
                expect(entities.emailAddressList[0].value).to.equal('someone@somedomain.com') # eeeh plural?
                done()
    it 'Should recognize personal Names', (done) ->
        name = 'Abraham Jacos'
        @ner(name)
            .then (entities) ->
                expect(entities.personNameList[0].value).to.equal(name)
                done()

describe 'Mapper', -> #Map features and vectors from domain structure
    before ->
        Mapper = require('../lib/classifier/mapper.coffee')
        @mapper = new Mapper domainTypes
    it 'Should map classes to features', ->
        expect(@mapper.getClassesFromFeature('personName')[0]).to.equal('Contact')

describe 'Trainer', -> #generate tests iteratively
    before ->
        @train = require('../lib/classifier/trainer.coffee')
    it 'should train the network', ->
        net = new brain.NeuralNetwork()

        @train net, domainTypes # , [zeroRule]

describe 'Classification Module', -> #generate tests iteratively
    before ->
        Classifier = require('../lib/classifier/index.coffee')
        @classifier = new Classifier(domainTypes)

    it 'Should not classify if no required features are recognized', (done) ->
        @classifier.classify(['phoneNumber'])
            .then (classes) =>
                expect(classes.length).to.equal 0
                done()
            .catch(done)
    it 'Should correctly classify an account', (done) ->
        @classifier.classify(['companyName'])
            .then (classes) =>
                expect(classes[0]).to.equal 'Account'
                done()
            .catch(done)
    it 'Should correctly classify a contact', (done) ->
        @classifier.classify(['personName'])
            .then (classes) =>
                expect(classes[0]).to.equal 'Contact'
                done()
            .catch(done)
    it 'Should correctly classify multiple labels', (done) ->
        return @classifier.classify(['companyName', 'personName'])
            .then (classes) =>
                expect(classes.indexOf 'Account' ).to.be.at.least 0
                expect(classes.indexOf 'Contact' ).to.be.at.least 0
                done()
            .catch(done)

describe 'IE Module', -> # disambiguation of affiliation
    before ->
        @informationExtractor = require '../lib/ie/index'
    it 'Should disambiguate Account and Company E-Mail adresses', (done) ->
        entities = {personNameList: [], companyNameList: [], emailAddressList: []}
        entities.companyNameList.push  new Entity 'companyName', 'OpenSauce Inc'
        entities.personNameList.push   new Entity 'contactName', 'Sam Johnson'
        entities.emailAddressList.push new Entity 'emailAddress', 'support@opensauce.com'
        entities.emailAddressList.push new Entity 'emailAddress', 'johnson@opensauce.com'

        return @informationExtractor(domainTypes, ['Account', 'Contact'], entities)
            .then (datasets) =>
                expect(datasets.emails[0].target).to.equal 'Account'
                expect(datasets.emails[1].target).to.equal 'Contact'
                done()
            .catch(done)
    it 'Should assign a single E-Mail Address to a single Account', (done) ->
        entities = {personNameList: [], companyNameList: [], emailAddressList: []}
        entities.emailAddressList.push new Entity 'emailAddress', 'support@opensauce.com'
        return @informationExtractor(domainTypes, ['Account'], entities)
            .then (datasets) =>
                expect(datasets.emails[0].target).to.equal 'Account'
                done()
            .catch(done)
    it 'Should assign a single E-Mail Address to a single Contact', (done) ->
        entities = {personNameList: [], companyNameList: [], emailAddressList: []}
        entities.emailAddressList.push new Entity 'emailAddress', 'support@opensauce.com'
        return @informationExtractor(domainTypes, ['Contact'], entities)
            .then (datasets) =>
                expect(datasets.emails[0].target).to.equal 'Contact'
                done()
            .catch(done)
