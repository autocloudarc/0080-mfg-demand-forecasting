targetScope = 'subscription'

param rgpName string
param rgpLocation string
param storageAccountName string
param eventHubNamespaceName string
param streamAnalyticsJobName string
param machineLearningWorkspaceName string
param sqlServerName string
param sqlDatabaseName string
param dataFactoryName string
param dbUserName string 
param dbUserPw string 

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgpName
  location: rgpLocation
}

@description('Demand forecasting solution')
module demand './modules/demand.bicep' = {
  name: 'demand-forecasting'
  scope: resourceGroup
  params: {
    rgpLocation: rgpLocation
    storageAccountName: storageAccountName
    eventHubNamespaceName: eventHubNamespaceName
    streamAnalyticsJobName: streamAnalyticsJobName
    machineLearningWorkspaceName: machineLearningWorkspaceName
    sqlServerName: sqlServerName
    sqlDatabaseName: sqlDatabaseName
    dataFactoryName: dataFactoryName
    dbUserName: dbUserName
    dbUserPw: dbUserPw
  }
}

output randomString string = randomString
output dbUserName string = dbUserName
output dbUserPw string = dbUserPw