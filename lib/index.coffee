Promise = require 'bluebird'

fillForms = require './ie/index'
Classifier = require('./classifier/index')
ner= require('./ner/index')

class Flextractor
    constructor: (@domainTypes, opts) ->
        @classifier = new Classifier(@domainTypes)
        @ner = ner
        @apiKeys = opts.apiKeys

    extract: (text) ->
        @ner text, @apiKeys
            .then (entities) =>
                recognizedFeatures = []
                for listName of entities
                    entityName = listName.substring(0, listName.length - 4)
                    recognizedFeatures.push entityName

                @classifier.classify recognizedFeatures
                    .then (labels) =>
                        datasets = fillForms @domainTypes, labels, entities
                        return datasets



module.exports = Flextractor
