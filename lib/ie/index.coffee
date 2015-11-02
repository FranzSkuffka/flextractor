_ = require 'underscore'
# findPhoneNumberTargets = (phoneNumberList) ->
#         phoneNumbersWithTargets = []
#     if phoneNumberList.length == 1
#         phoneNumberList[0].target = 'Account'
#         phoneNumbersWithTargets.push phoneNumberList[0]
#         return phoneNumbersWithTargets
#     if phoneNumberList.length == 2
#         phoneNumberList

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
        results = {}
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
                console.log 'E-Mail adress targets not found'
            results.emails = emailsWithTargets
        resolve results

module.exports = fillForms
