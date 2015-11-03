_ = require 'underscore'
findPhoneNumberTargets = (phoneNumberList) ->
    phoneNumbersWithTargets = []
    if phoneNumberList.length == 1
        phoneNumberList[0].target = 'Account'
        phoneNumbersWithTargets.push phoneNumberList[0]
        return phoneNumbersWithTargets
    if phoneNumberList.length == 2
        phoneNumberList

findEmailTargets = (emailAddressList, personNameGrams) ->
    genericLocalParts = ['hello', 'support', 'welcome', 'hello', 'feedback', 'info']
    emailsWithTargets = []
    for emailAddress in emailAddressList
        targetFound = false
        localPart = emailAddress.value.split('@')[0]
        for genericLocalPart in genericLocalParts
            if genericLocalPart == localPart
                emailAddress.target = 'Account'
                emailAddress.targetConfident = true
                emailsWithTargets.push emailAddress
                targetFound = true
        if !targetFound
            for personNameGram in personNameGrams
                if localPart.indexOf(personNameGram) > -1
                    emailAddress.target = 'Contact'
                    emailAddress.targetConfident = true
                    emailsWithTargets.push emailAddress
                    targetFound = true
                    break
        if !targetFound
            emailAddress.target = 'Account'
    emailsWithTargets

# association methods
associate = {}

# get Occurences of each entity
getOccurences = (domainTypes, labels, listName) ->
    # determine outer ambiguity
    entityOccurences = []
    # find occurences of fields that match entity type in all domaintypes
    for label in labels
        for domainType in domainTypes
            if domainType.name == label
                for field in domainType.fields
                    listType = listName.substring(0, listName.length - 4)
                    if field.name == listType
                        occurence =
                            label: label
                            field: field.name
                        entityOccurences.push occurence
    entityOccurences
# this method should assign labels + fields to every single entity
associateEntities = (domainTypes, labels, entities) ->
    return new Promise (resolve) =>
        # intiate res object
        associatedEntities = {}
        # iterate through all entity Lists
        for listName, entityList of entities
            associatedEntityList = []
            # list should not be empty, but just to make sure.
            if entityList.length > 0
                occurences = getOccurences domainTypes, labels, listName
                # call association function for entityList if targets are ambiguous
                if associate[listName]?
                    entities[listName] = associate[listName](entityList)
        # if email adresses exist
        if entities.emailAddressList?
            if entities.emailAddressList.length > 0
                emailsWithTargets = []
                if ((labels.indexOf('Account') > -1) && (labels.indexOf('Contact') > -1))
                    personName = entities.personNameList[0].value.split ' '
                    # grams are the first n letters
                    personNameGrams = []
                    personNameGrams.push part.substring(0,3).toLowerCase() for part in personName
                    emailsWithTargets = findEmailTargets(entities.emailAddressList, personNameGrams)
                else if labels.indexOf('Account') > -1
                    for email in entities.emailAddressList
                        email.target = 'Account'
                        emailsWithTargets.push email
                else if labels.indexOf('Contact') > -1
                    for email in entities.emailAddressList
                        email.target = 'Contact'
                        emailsWithTargets.push email
                else
                    throw new Error('Entities could not be associated to their labels')
                associatedEntities.emails = emailsWithTargets

        if entities.phoneNumberList?
            if entities.phoneNumberList.length > 0
                phoneNumbersWithTargets = findPhoneNumberTargets(entities.phoneNumberList)
                associatedEntities.phones = phoneNumbersWithTargets


        resolve associatedEntities

module.exports = associateEntities
