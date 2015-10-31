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
            # initialize feature vector with length of all features
            featureVector = Array.apply(null, Array(Object.keys(@features).length)).map(Number.prototype.valueOf,0)
            # current Position in feature vector
            featureDimension = 0
            # if features recognized
            if recognizedFeatures.length > 0
                # go through all features and put 1 into inputvector if it is the current feature
                for feature of @features
                    for recognizedFeature  in recognizedFeatures
                        if recognizedFeature == feature
                            featureVector[featureDimension] = 1
                    featureDimension++
            # get confidences
            confidences = @net.run featureVector
            # map output to class labels
            assignedLabels = []
            labelDimension = 0
            for label in @labels
                # insert threshold of 0.1
                if confidences[labelDimension] > 0.1
                    assignedLabels.push label.name
                labelDimension++
            resolve assignedLabels

module.exports = Classifier
