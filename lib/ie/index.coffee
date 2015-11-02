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

fillForms = (domainTypes, labels, entities) ->
    return new Promise (resolve) =>
        # determine if there are multiple emails?
        # disambiguate emails
        # get local part of emails
        # get first three letters of names
        # find if first three letters of either name port is within localpart of email
        # assign accordingly
        #
        # disambiguate phones
        if labels.indexOf 'Account' > -1 && labels.indexOf 'Contact' > -1
            personName = entities.personNameList[0].value.split ' '
            # grams are the first n letters
            personNameGrams = []
            personNameGrams.push part.substring(0,3).toLowerCase() for part in personName
            emailsWithTargets = findEmailTargets(entities.emailAddressList, personNameGrams)
        else
            personName
        resolve emailsWithTargets

module.exports = fillForms
