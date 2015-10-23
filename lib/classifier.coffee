class classifier
    construct: (@domainTypes) ->
    classify:
        new Promise (resolve) ->
            data = 42
            resolve data
module.exports = classifier
