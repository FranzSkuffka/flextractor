module.exports =
[
        name: 'Account'
        fields:
            [
                name: 'companyName'
                required: true
            ,
                name: 'phoneNumber'
                variants: ['fax']
            ,
                name: 'emailAddress'
            ,
                name: 'website'
            ,
                name: 'city'
            ]
    ,
        name: 'Contact'
        fields:
            [
                name: 'personName'
                required: true
            ,
                name: 'phoneNumber'
            ,
                name: 'emailAddress'
            ]
        relation: 'Account'
    ,
        name: 'Chance'
        fields:
            [
                name: 'financialValue'
                required: true
            ,
                name: 'probability'
                required: true
            ]
        relation: 'Account'
    ]
