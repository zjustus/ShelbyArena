/*
     the JWT consists of a headder claim ser and a signiture formatted like so
     {Base64url encoded header}.{Base64url encoded claim set}.{Base64url encoded signature}

     the headder:
          {"alg":"RS256","typ":"JWT"}
*/



'classId' : '3336206256661903001.LuminateChurch',
  'id' : '3336206256661903001.LuminateChurchKids',
  'accountId': '1234567890',
  'accountName': 'Zach Justus',
  'barcode': {
      'alternateText' : '12345',
      'type' : 'qrCode',
      'value' : '28343E3'
  },
  'textModulesData': [{
    'header': 'Jane\'s Baconrista Rewards',
    'body': 'Save more at your local Mountain View store Jane. ' +
            ' You get 1 bacon fat latte for every 5 coffees purchased.  ' +
            'Also just for you, 10% off all pastries in the Mountain View store.'
  }],
  'linksModuleData': {
    'uris': [
      {
        'kind': 'walletobjects#uri',
        'uri': 'http://www.baconrista.com/myaccount?id=1234567890',
        'description': 'My Baconrista Account'
      }]
  },
  'infoModuleData': {
    'labelValueRows': [{
        'columns': [{
          'label': 'Next Reward in',
          'value': '2 coffees'
        }, {
          'label': 'Member Since',
          'value': '01/15/2013'
        }]
      },{
        'columns': [{
          'label': 'Local Store',
          'value': 'Mountain View'
        }]
    }],
    'showLastUpdateTime': 'true'
  },
  'messages': [{
      'header': 'Jane, welcome to Banconrista Rewards',
      'body': 'Thanks for joining our program. Show this message to ' +
              'our barista for your first free coffee on us!',
      'kind': 'walletobjects#walletObjectMessage'
  }],
  'loyaltyPoints': {
      'balance': {
          'string': '500'
      },
      'label': 'Points',
      'pointsType': 'points'
  },
  'state': 'active',
  'version': 1
