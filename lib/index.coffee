Promise = require 'bluebird'

fillForms = require './ie/index'
Classifier = require('./classifier/index')

class Flextractor
    constructor: (@domainTypes, @opts) ->
        Classifier = new require('./classifier/index')
        @classifier = new Classifier(@domainTypes)
        @ner = require('../../ner-unifier')

    extract: (text) ->
        @ner text, @opts.apiKeys, @opts
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
