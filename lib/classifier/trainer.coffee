# extract rules 5 min
# import ruls 5 min
# push rules to vectors 5 min
# refactor rules 10 min
rules = require './rules'
Mapper = require './mapper'
module.exports = (net, domainTypes) ->
    mapper = new Mapper domainTypes
    features = mapper.features
    labels = mapper.classes
    # join vectors
    trainingVectors = []
    for rule in rules
        trainingVectors = trainingVectors.concat rule(labels, features)
    trainingOptions =
        errorThresh: 0.00001
        iterations: 200000
        learingRate: 0.5
    console.log net.train trainingVectors, trainingOptions
    net



    # join
