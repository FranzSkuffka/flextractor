Promise = require 'bluebird'

ner = require './ner/index'

class Flextractor
    construct: (domainTypes) ->
        @classifier = new require('./classifier')(domainTypes)

    extract: (text) ->
        ner(text)

module.exports = Flextractor
