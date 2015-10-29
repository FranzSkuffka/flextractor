module.exports = (net, features, classes) ->
    inputMax= []
    outputMax= []
    # generate max input vector
    for label in classes
        inputVector = []
        for feature, classList of features
            if classList.indexOf(label.name)> -1
                inputVector.push 1
            else
                inputVector.push 0
        inputMax.push inputVector

        # generate output vector
        outputVector = []
        for targetLabel in classes
            if label.name == targetLabel.name
                outputVector.push 1
            else
                outputVector.push 0
        outputMax.push outputVector

    inputIncomplete = []
    outputIncomplete = []

    # generate required not fullfilled input vector
    for label in classes
        inputVector = []
        for feature, classList of features
            # if feauture is required
            if classList.indexOf(label.name)> -1 && label.requires feature
                inputVector.push 0
            else if classList.indexOf(label.name)> -1
                inputVector.push 1
            else
                inputVector.push 0
        inputIncomplete.push inputVector

        # generate output vector
        outputVector = []
        for targetLabel in classes
            outputVector.push 0
        outputIncomplete.push outputVector

    # generate zero rule
    inputZero = []
    for feature of features
        inputZero.push 0
    outputZero = []
    for label of classes
        outputZero.push 0

    # join vectors
    trainingVectors = []
    trainingVectors.push {input: inputZero, output: outputZero}
    for vector, i in inputMax
        trainingVectors.push {input: vector, output: outputMax[i]}
    for vector, i in inputIncomplete
        trainingVectors.push {input: vector, output: outputIncomplete[i]}
    net.train trainingVectors
    net



    # join
