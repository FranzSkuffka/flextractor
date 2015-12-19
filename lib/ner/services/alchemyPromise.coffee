Entity  = require './Entity'
Alchemy = require './alchemy.js'

alchemyEntities = (text, apiKey) ->
    alchemy = new Alchemy(apiKey)
    entityMap =
        Person: 'personName'
        Company: 'companyName'
    mapEntityName = (name) =>
        if entityMap[name]?
            entityMap[name]
        else
            name.toLowerCase()
    new Promise (resolve) ->
        alchemy.entities "text", text, {'language': 'german'}, (res) ->
            results = []
            for entity in res.entities
                results.push new Entity mapEntityName(entity.type), entity.text
            resolve results

module.exports = alchemyEntities 
