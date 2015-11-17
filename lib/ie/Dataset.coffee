class Dataset
    constructor: (@type, entities) ->
        @data = []
        for entity in entities
            dataEntry = {}
            dataEntry.name = entity.target.field # targetfield of entity
            dataEntry.value = entity.value
            @data.push dataEntry


module.exports = Dataset
