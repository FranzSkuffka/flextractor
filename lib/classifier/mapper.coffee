# from class
# to features
# to vector
#
# from feature
# to classes
# to vector
#
# from vector
# to classes
# to feature
class Mapper
    constructor: (domainTypes) ->
        @features= {}
        @classes= []
        # push field of domain type into feature list if it does not exist yet
        for domainType in domainTypes
            # push features
            @addClass domainType
            @addFeatures domainType

    addFeatures: (domainType) =>
        for feature in domainType.fields
            if @features[feature.name]? # feature already listed
                @features[feature.name].push domainType.name
            if !@features[feature.name]? # feature not added yet
                @features[feature.name] = [domainType.name]

    addClass: (domainType) =>
        # find out if passed field / feature is required in this class definition
        domainType.requires = (requiredField) ->
            for field in this.fields
                return true if field.name == requiredField && field.required
            return false
        @classes.push domainType
    getClassesFromFeature: (feature) ->
        @features[feature]
module.exports = Mapper
