Knwl    = require 'knwl.js'
knwlSync    = new Knwl 'german'
Entity = require './Entity'
knwlSync.register 'money', require '../../../node_modules/knwl.js/experimental_plugins/money'
knwlSync.register 'ratios', require '../../../node_modules/knwl.js/experimental_plugins/ratios'

knwlEntities = (text) ->
    new Promise (resolve) ->
        # load text into knwl
        knwlSync.init text
        # define results in outer scope
        results = []

        # join and normalize results
        for money in knwlSync.get 'money'
            results.push new Entity 'financialValue', money.value

        for ratio in knwlSync.get 'ratios'
            results.push new Entity 'probability', ratio.percentileValue

        for phone in knwlSync.get 'phones'
            results.push new Entity 'phoneNumber', phone.phone

        for email in knwlSync.get 'emails'
            if email.preview?
                meta =
                    preview:  email.preview
            results.push new Entity 'emailAddress', email.address, meta
        resolve results


module.exports = knwlEntities
