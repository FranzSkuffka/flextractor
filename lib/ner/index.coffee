Promise = require 'bluebird'
knwlEntities = require './services/knwlPromise.coffee'
alchemyEntities = require './services/alchemyPromise.coffee'


class EntityCollection
    entities: {}
    add: (entity) ->
        if !@entities[entity.type]?
            @entities[entity.type] = [entity]
        else
            @entities[entity.type].push entity
    get: -> @entities


ner = (text) ->
    if !text?
        throw new Error('No input provided')
    # join api results
    Promise.all [knwlEntities(text), alchemyEntities(text)]
        .then (data ) ->
            new Promise (resolve) ->
                # add to entity collection
                entities = new EntityCollection()
                for entityList in data
                    for entity in entityList
                        entities.add entity
                resolve entities


module.exports = ner
