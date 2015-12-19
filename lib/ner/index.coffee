Promise = require 'bluebird'
knwlEntities = require './services/knwlPromise.coffee'
alchemyEntities = require './services/alchemyPromise.coffee'




ner = (text, apiKeys) =>
    collectEntities = (entityList) ->
        entities = {}
        for entity in entityList
            # assign entity to entity list with pluralized type as name
            pluralTypeName = entity.type + 'List'
            if !entities[pluralTypeName]?
                entities[pluralTypeName] = [entity]
            else
                entities[pluralTypeName].push entity
        return entities

    if !text?
        throw new Error("input is #{ text }")

    # join api results
    Promise.join knwlEntities(text), alchemyEntities(text, apiKeys.alchemy), (knwlRes, alchemyRes) ->
        new Promise (resolve) ->
            entities = collectEntities(knwlRes.concat alchemyRes)
            resolve entities



module.exports = ner
