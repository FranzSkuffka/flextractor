Promise = require 'bluebird'
knwlEntities = require './services/knwlPromise.coffee'
alchemyEntities = require './services/alchemyPromise.coffee'




ner = (text) =>
    collectEntities = (entityList) ->
        entities = {}
        for entity in entityList
            # assign entity to entity list with pluralized type as name
            pluralTypeName = entity.type + 's'
            if !entities[pluralTypeName]?
                entities[pluralTypeName] = [entity]
            else
                entities[pluralTypeName].push entity
            return entities

    if !text?
        throw new Error('No input provided')
    # join api results
    Promise.join knwlEntities(text), alchemyEntities(text), (knwlRes, alchemyRes) ->
        new Promise (resolve) -> resolve collectEntities(knwlRes.concat alchemyRes)



module.exports = ner