targetScope = 'subscription'

// https://learn.microsoft.com/en-us/azure/devops/boards/github/link-to-from-github?view=azure-devops

param randomLongString string = newGuid()
param rgpName string
param rgpLocation string
param dbUserName string
@secure()
param dbUserPw string
param iacResourceGroupName string = 'rgp-iac'
// param iacUmi string = 'umi-001'
param kvtName string = 'kvt-1322'

var randomString = substring(randomLongString,0,8)
var staPrefix = 'sta'
var storageAccountName = '${staPrefix}${randomString}'
var ehnPrefix = 'ehn'
var eventHubNamespaceName = '${ehnPrefix}${randomString}'
var sajPrefix = 'saj'
var streamAnalyticsJobName = '${sajPrefix}${randomString}'
var mlwPrefix = 'mlw'
var machineLearningWorkspaceName = '${mlwPrefix}${randomString}'
var sqsPrefix = 'sqs'
var sqlServerName = '${sqsPrefix}${randomString}'
var sqdPrefix = 'sqd'
var sqlDatabaseName = '${sqdPrefix}${randomString}'
var adfPrefix = 'adf'
var dataFactoryName = '${adfPrefix}${randomString}'



resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgpName
  location: rgpLocation
}

@description('Demand forecasting solution')
module demand 'modules/demand.bicep' = {
  name: 'demand-forecasting'
  scope: resourceGroup
  params: {
    rgpLocation: rgpLocation
    randomString: randomString
    storageAccountName: storageAccountName
    eventHubNamespaceName: eventHubNamespaceName
    streamAnalyticsJobName: streamAnalyticsJobName
    machineLearningWorkspaceName: machineLearningWorkspaceName
    sqlServerName: sqlServerName
    sqlDatabaseName: sqlDatabaseName
    dataFactoryName: dataFactoryName
    dbUserName: dbUserName
    dbUserPw: dbUserPw
    iacResourceGroupName: iacResourceGroupName
    // iacUmi: iacUmi
    kvtName: kvtName
  }
}

output randomLongString string = randomLongString
output randomString string = randomString
output dbUserName string = dbUserName
