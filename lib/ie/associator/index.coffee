ambiguities = require './ambiguities'
disambiguate = require './disambiguator'
_ = require 'underscore'

# this method should assign labels + fields to every single entity
associateEntities = (domainTypes, labels, entities) ->
    # get ambiguities
    entities = ambiguities(domainTypes, labels, entities)
    # determine targets for each entity
    for listName, entityList of entities
        # default case: one target, one entity
        if entityList.targets.length == 1 && entityList.length == 1
            # just assign the single target to the single entity
            entityList[0].target = entityList.targets[0]

        # special case: more than one target or more than one entity
        else
            listType = listName.substring(0, listName.length - 4)
            # check if complex disambiguation procedure is available
            if disambiguate[listType]?
                entityList = disambiguate[listType](entityList, entities)
            else
                throw new Error(listName + ' entity affiliation could not be determined.')
        entities[listName] = entityList
    entities
module.exports = associateEntities
