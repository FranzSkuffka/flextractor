# get targets of each entity
getTargets = (domainTypes, labels, listName) ->
    # determine outer ambiguity
    entityTargets = []
    # possible targets: find targets of fields that match entity type in all domaintypes
    for label in labels
        for domainType in domainTypes
            if domainType.name == label
                for field in domainType.fields
                    listType = listName.substring(0, listName.length - 4)
                    if field.name == listType
                        target =
                            label: label
                            field: field.name
                        entityTargets.push target
    entityTargets

# filters any empty lists and lists without targets
determineAmbiguities = (domainTypes, labels, entities) ->
    entityListsWithTargets = {}
    for listName, entityList of entities
        # list should not be empty, but just to make sure.
        if entityList.length > 0
            # find target candidates for each list type
            entityList.targets = getTargets domainTypes, labels, listName
            entityListsWithTargets[listName] = entityList if entityList.targets.length > 0
    entityListsWithTargets

module.exports = determineAmbiguities
