brain = require 'brain'
_     = require 'underscore'
train = require './trainer'
class Classifier
    features: {}
    classes: []

    constructor: (domainTypes) ->
        # push field of domain type into feature list if it does not exist yet
        for domainType in domainTypes
            # push features
            @addClass domainType
            @addFeatures domainType
        @net = train new brain.NeuralNetwork(), @features, @classes




    addFeatures: (domainType) ->
        for feature in domainType.fields
            if @features[feature.name]? # feature already listed
                @features[feature.name].push domainType.name
            if !@features[feature.name]? # feature not added yet
                @features[feature.name] = [domainType.name]

    addClass: (domainType) ->
        @classes.push domainType
        # train network

    classify: (recognizedFeatures) ->
        console.log 'CLASSIFYING'
        new Promise (resolve) =>
            # map features to vector
            featureVector = []
            for feature of @features
                # any features recognized, map to input vector
                if recognizedFeatures.length > 0
                    for recognizedFeature in recognizedFeatures
                        if recognizedFeature == feature
                            featureVector.push 1
                        else
                            featureVector.push 0
                # no features, fill input with zeros
                else
                    featureVector.push 0
            # map output to class labels
            confidences = @net.run featureVector
            assignedLabels = []
            console.log @classes
            for label,i in @classes
                console.log label
                console.log confidences
                if confidences[i] > 0.1
                    assignedLabels.push label.name
            console.log assignedLabels
            # map output to classes
            # insert threshold of 0.1
            resolve assignedLabels


module.exports = Classifier




# generate a training set example for each model
# trainingSetPerModel = []
# modelIndex = 0

# for model in modelSpace
    # # AND connection for features in feature space
    # input = []
    # # AND connection for models in modelspace
    # output = []

    # for feature in featureSpace
        # if model.relatives.indexOf(feature.entry) > -1
            # input.push 1
        # else
            # input.push 0
    # # determine position of model in model space
    # for modelOfSpace in modelSpace
        # if model.entry == modelOfSpace.entry
            # output.push 1
        # else
            # output.push 0

    # trainingSetPerModel.push
        # input: input
        # output: output



# net = new brain.NeuralNetwork()
# net.train trainingSetPerModel
# netResult = net.run [1,1,0]

# mapNetResultToModelSpace = (netResult) ->
    # modelIndex = 0
    # resultPerModel = []
    # for model in modelSpace
        # resultPerModel.push
            # model: model.entry
            # result: netResult[modelIndex]
        # modelIndex++
    # resultPerModel

# mapFeaturesToFeatureSpace = (features) ->
    # mappedFeatures = []
    # for featureOfSpace in featureSpace
        # # find if current feature of the space is found in given features
        # if features.indexOf(featureOfSpace.entry) > -1
            # mappedFeatures.push 1
        # else
            # mappedFeatures.push 0
    # mappedFeatures


# if results are equal: none are likely
# set feature threshold: 2 through summing up input vector
# todo: capsulate mapping processes
# todo: rename mapping to vector mappin
# todo: rename entry to entryname
# module.exports = (features) =>
    # mappedFeatures = mapFeaturesToFeatureSpace features
    # mappedResults = mapNetResultToModelSpace net.run mappedFeatures
    # mappedResults.sort (a,b) ->
        # b.result - a.result
