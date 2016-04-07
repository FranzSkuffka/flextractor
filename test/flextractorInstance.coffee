Flextractor = require '..'
keys = require '../../ner-unifier/test/API_keys_module'
domainTypes =  require './domainStructure'
module.exports = new Flextractor domainTypes, {apiKeys: keys}
