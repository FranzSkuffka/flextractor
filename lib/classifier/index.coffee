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
            for label,i in @classes
                if confidences[i] > 0.1
                    assignedLabels.push label.name
            # map output to classes
            # insert threshold of 0.1
            resolve assignedLabels

module.exports = Classifier
