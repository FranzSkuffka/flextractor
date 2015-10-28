Knwl    = require 'knwl.js'
knwlSync    = new Knwl 'german'
Entity = require './Entity'

knwlEntities = (text) ->
    new Promise (resolve) ->
        # load text into knwl
        knwlSync.init text
        # define results in outer scope
        results = []
        # join and normalize results
        for email in knwlSync.get 'emails'
            if email.preview?
                meta =
                    preview:  email.preview
            results.push new Entity 'email', email.address, meta
        resolve results


module.exports = knwlEntities
