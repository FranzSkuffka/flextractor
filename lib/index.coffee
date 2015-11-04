Promise = require 'bluebird'

fillForms = require './ie/index'

class Flextractor
    constructor: (@domainTypes) ->
        Classifier = new require('./classifier/index')
        @classifier = new Classifier(@domainTypes)
        @ner= require('./ner/index')

    extract: (text) ->
        @ner text
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
