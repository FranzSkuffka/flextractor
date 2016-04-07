mocha        =  require      'mocha'
chai         =  require      'chai'
expect       =  chai.expect
Flextractor  =  require      '../'
brain        =  require      'brain'
Entity       =  require('../../ner-unifier').Entity

domainTypes =  require './domainStructure'


describe 'API', ->
    before ->
        keys = require '../../ner-unifier/test/API_keys_module'
        @extractor = new Flextractor domainTypes, {apiKeys: keys}
    it 'Extract a simple contact', (done) ->
        @extractor.extract('Steve Jobs \n email: steve@jobs.com').then (datasets) ->
            expect(datasets[0].type).to.equal('Contact')
            expect(datasets[0].data[0].value).to.equal('Steve Jobs')
            expect(datasets[0].data[1].value).to.equal('steve@jobs.com')
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
    it 'Should correctly classify a chance', (done) ->
        @classifier.classify(['probability', 'financialValue'])
            .then (classes) =>
                expect(classes[0]).to.equal 'Chance'
                done()
            .catch(done)
    it 'Should correctly classify multiple labels', (done) ->
        return @classifier.classify(['companyName', 'personName'])
            .then (classes) =>
                expect(classes.indexOf 'Account' ).to.be.at.least 0
                expect(classes.indexOf 'Contact' ).to.be.at.least 0
                done()
            .catch(done)

describe 'Association Module', -> # disambiguation of affiliation
    before ->
        @associate= require '../lib/ie/associator/index'
    it 'Should disambiguate Account and Company E-Mail adresses', (done) ->
        entities = {personNameList: [], companyNameList: [], emailAddressList: []}
        entities.companyNameList.push  new Entity 'companyName', 'OpenSauce Inc'
        entities.personNameList.push   new Entity 'personName', 'Sam Johnson'
        entities.emailAddressList.push new Entity 'emailAddress', 'support@opensauce.com'
        entities.emailAddressList.push new Entity 'emailAddress', 'johnson@opensauce.com'

        entitiesWithTargets = @associate(domainTypes, ['Account', 'Contact'], entities)
        expect(entitiesWithTargets.emailAddressList[0].target.label).to.equal 'Account'
        expect(entitiesWithTargets.emailAddressList[1].target.label).to.equal 'Contact'
        done()

    it 'Should assign a single E-Mail Address to a single Account', (done) ->
        entities = {personNameList: [], companyNameList: [], emailAddressList: []}
        entities.emailAddressList.push new Entity 'emailAddress', 'support@opensauce.com'
        entitiesWithTargets =  @associate(domainTypes, ['Account'], entities)
        expect(entitiesWithTargets.emailAddressList[0].target.label).to.equal 'Account'
        done()

    it 'Should assign a single E-Mail Address to a single Contact', (done) ->
        entities = {personNameList: [], companyNameList: [], emailAddressList: []}
        entities.emailAddressList.push new Entity 'emailAddress', 'support@opensauce.com'
        entitiesWithTargets =  @associate(domainTypes, ['Contact'], entities)
        expect(entitiesWithTargets.emailAddressList[0].target.label).to.equal 'Contact'
        done()

    it 'Should assign a single phone Number to an Account', (done) ->
        entities = {personNameList: [], companyNameList: [], phoneNumberList: []}
        entities.phoneNumberList.push new Entity 'phoneNumber', '+49 251 91741 - 0'
        entitiesWithTargets =  @associate(domainTypes, ['Account'], entities)
        expect(entitiesWithTargets.phoneNumberList[0].target.label).to.equal 'Account'
        done()

describe 'Extraction Module', -> # disambiguation of affiliation
    before ->
        @extractor= require '../lib/ie/index'
    it 'Should create a Contact from Entities', (done) ->
        entities = {personNameList: [], companyNameList: [], emailAddressList: []}
        entities.personNameList.push   new Entity 'personName', 'Sam Johnson'
        entities.emailAddressList.push new Entity 'emailAddress', 'johnson@opensauce.com'
        datasets = @extractor(domainTypes, ['Contact'], entities)
        expect(datasets[0].type).to.equal 'Contact'
        expect(datasets[0].data[0].value).to.equal 'Sam Johnson'
        expect(datasets[0].data[1].value).to.equal 'johnson@opensauce.com'
        done()
