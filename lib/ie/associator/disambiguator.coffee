disambiguate = {}
# findPhoneNumberTargets
disambiguate.phoneNumber = (phoneNumberList) ->
    phoneNumbersWithTargets = []
    if phoneNumberList.length == 1
        target = {}
        target.label = 'Account'
        target.field = 'phoneNumber'
        phoneNumberList[0].target = target
        phoneNumbersWithTargets.push phoneNumberList[0]
        return phoneNumbersWithTargets
    if phoneNumberList.length == 2
        phoneNumberList

disambiguate.emailAddress = (emailAddressList, entities) ->
    emailsWithTargets = []
    personName = entities.personNameList[0].value.split ' '
    # grams are the first n letters
    personNameGrams = []
    personNameGrams.push part.substring(0,3).toLowerCase() for part in personName
    findEmailTargets(emailAddressList, personNameGrams)


findEmailTargets = (emailAddressList, personNameGrams) ->
    genericLocalParts = ['hello', 'support', 'welcome', 'hello', 'feedback', 'info']
    emailsWithTargets = []
    for emailAddress in emailAddressList
        targetFound = false # use this to break the loop
        localPart = emailAddress.value.split('@')[0]
        target = {field: 'emailAddress'}
        for genericLocalPart in genericLocalParts # check if can be associated to Account through generic local parts
            if genericLocalPart == localPart
                target.label = 'Account'
                target.confident = true
                targetFound = true
        if !targetFound # association through personName
            for personNameGram in personNameGrams
                if localPart.indexOf(personNameGram) > -1
                    target.label = 'Contact'
                    target.confident = true
                    targetFound = true
                    break
        if !targetFound # associate default
            target.label = 'Account'
        emailAddress.target = target
        emailsWithTargets.push emailAddress
    emailsWithTargets
module.exports = disambiguate
