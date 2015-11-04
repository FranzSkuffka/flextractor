associate = require './associator/index'
Dataset = require './Dataset'
_ = require 'underscore'

fillForms = (domainTypes, labels, entities) ->
    datasets = []
    entities = associate(domainTypes, labels, entities)
    delete entities[undefined]

    flattenedEntities = []
    for listName, entityList of entities
        flattenedEntities = flattenedEntities.concat entityList

    entitiesByLabel = _.groupBy flattenedEntities, (entity) ->
        entity.target.label

    for label, associatedEntities of entitiesByLabel
        datasets.push new Dataset label, associatedEntities
    datasets

module.exports = fillForms
