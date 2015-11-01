Promise = require 'bluebird'


class Flextractor
    constructor: (domainTypes) ->
        Classifier = new require('./classifier/index')
        @classifier = new Classifier(domainTypes)
        @ner= require('./ner/index')

    extract: (text) ->
        @ner text
            .then (entities) =>
                recognizedEntities = []
                for listName of entities
                    entityName = listName.substring(0, listName.length - 4)
                    recognizedEntities.push entityName

                return @classifier.classify recognizedEntities
                    .then (classes) =>
                        return


module.exports = Flextractor
