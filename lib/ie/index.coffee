associate = require './associator/index'
Dataset = require './Dataset'
_ = require 'underscore'

fillForms = (domainTypes, labels, entities) ->

    # find if this label has a relation
    findRelationType = (domainTypes, label) ->
        for domainType in domainTypes
            if label == domainType.name
                return domainType.relation

    # get name of related dataset
    getRelationId = (datasets, type, domainTypes) ->
        # find dataset with corresponding type
        for dataset in datasets
            if dataset.type == type
                # get matching domaintype
                for domainType in domainTypes
                    if domainType.name == type
                    # get required name id from domaintype
                        for field in domainType.fields
                            idField = null
                            if field.required == true
                                idField = field.name
                            if idField?
                                for field in dataset.data
                                    if field.name == idField
                                        return field.value

    datasets = []
    entities = associate(domainTypes, labels, entities)
    delete entities[undefined]

    # prepare entities for dataset creation
    flattenedEntities = []
    for listName, entityList of entities
        flattenedEntities = flattenedEntities.concat entityList

    entitiesByLabel = _.groupBy flattenedEntities, (entity) ->
        entity.target.label

    #create datasets
    for label, associatedEntities of entitiesByLabel
        dataset = new Dataset label, associatedEntities
        datasets.push dataset

    # mark up relations
    for dataset in datasets
        # find datasets with relation
        relationType = findRelationType domainTypes, dataset.type
        # add relation to dataset
        if relationType?
            relationId = getRelationId datasets, relationType, domainTypes
            dataset.addRelation relationId if relationId?

    datasets

module.exports = fillForms
