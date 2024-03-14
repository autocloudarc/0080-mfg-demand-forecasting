using './main.bicep'

param rgpName = 'rgp-0800'
param rgpLocation = 'eastus2'
param dbUserName = 'kvtPw'
param dbUserPw = getSecret('e25024e7-c4a5-4883-80af-9e81b2f8f689', 'rgp-iac', 'kvt-1322', 'kvtPw')
