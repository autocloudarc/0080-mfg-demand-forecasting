using './main.bicep'

param randomLongString = newGuid()
param rgpName = 'rgp-0800'
param rgpLocation = 'eastus2'
param dbUserName string = ''
param dbUserPw string = ''
