brain = require 'brain'
_     = require 'underscore'
train = require './trainer'
Mapper = require './mapper'
class Classifier
    constructor: (domainTypes) ->
        @mapper = new Mapper domainTypes
        @net = train new brain.NeuralNetwork(), domainTypes
        @features = @mapper.features
        @labels = @mapper.classes
    classify: (recognizedFeatures) ->
        new Promise (resolve) =>
            # map features to vector
            featureVector = Array.apply(null, Array(Object.keys(@features).length)).map(Number.prototype.valueOf,0)
            featureDimension = 0
            for feature of @features
                # any features recognized, map to input vector
                if recognizedFeatures.length > 0
                    for recognizedFeature  in recognizedFeatures
                        if recognizedFeature == feature
                            featureVector[featureDimension] = 1
                        else
                            featureVector[featureDimension] = 0
                featureDimension++
            confidences = @net.run featureVector
            # map output to class labels
            #
            assignedLabels = []
            labelDimension = 0
            for label in @labels
                if confidences[labelDimension] > 0.1
                    assignedLabels.push label.name
                labelDimension++
            # map output to labels
            # insert threshold of 0.1
            resolve assignedLabels

module.exports = Classifier
