Promise = require 'bluebird'

Alchemy = require './alchemy.js'
alchemyCallback = new Alchemy

alchemyEntities = (callback) ->
    new Promise
    alchemy.entities "text", text, {'language': 'german'}, callback


Knwl    = require 'knwl.js'
knwlSync    = new Knwl 'german'

knwlEntities = (text) ->
    new Promise (resolve) ->
        knwlSync.init text
        results = []
        results.push knwlSync.get 'emails'
        resolve results


ner = (text) ->
    # alchemy text
    knwlEntities text


module.exports = ner
