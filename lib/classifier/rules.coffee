zeroRule = (labels, features) ->
    vectors = []
    inputVector = []
    outputVector = []
    for feature of features
        inputVector.push 0
    for label in labels
        outputVector.push 0
    zeroVector =
        input: inputVector
        output: outputVector
    [zeroVector]

maxRule = (labels, features) ->
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

minimumRule = (labels, features) ->
    vectorPairs = []
    # generate required not fullfilled input vector
    for label in labels
        inputVector = []
        outputVector = []
        for feature, classList of features
            # if feauture is required
            if classList.indexOf(label.name)> -1 && label.requires feature
                inputVector.push 1
            else if classList.indexOf(label.name)> -1
                inputVector.push 0
            else
                inputVector.push 0
        # generate output vector
        for targetLabel in labels
            if label.name == targetLabel.name
                outputVector.push 1
            else
                outputVector.push 0
        vector =
            input: inputVector
            output: outputVector
        vectorPairs.push vector
    vectorPairs

incompleteRule = (labels, features) ->
    vectorPairs = []
    # generate required not fullfilled input vector
    for label in labels
        inputVector = []
        outputVector = []
        for feature, classList of features
            # if feauture is required
            if classList.indexOf(label.name)> -1 && label.requires feature
                inputVector.push 0
            else if classList.indexOf(label.name)> -1
                inputVector.push 1
            else
                inputVector.push 0
        # generate output vector
        for targetLabel in labels
            outputVector.push 0
        vector =
            input: inputVector
            output: outputVector
        vectorPairs.push vector
    vectorPairs


module.exports =
    [minimumRule, incompleteRule, zeroRule]
