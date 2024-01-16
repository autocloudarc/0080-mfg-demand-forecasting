targetScope = 'resourceGroup'
    
param randomString string
param storageAccountName string
param eventHubNamespaceName string
param streamAnalyticsJobName string
param machineLearningWorkspaceName string
param sqlServerName string
param sqlDatabaseName string
param dataFactoryName string
param rgpLocation string
param dbUserName string
param dbUserPw string
param iacResourceGroupName string
param iacUmi string
param kvtName string
param aiwRetentionInDays int = 7


var staAccessTier = 'Hot'
var staSku = 'Standard_LRS'
var staKind = 'StorageV2'
var staMinTlsVersion = 'TLS1_2'
var staPublicBlobAccess = true
var staHttpsOnly = true
var ehnTier = 'Standard'
var sajSku = 'Standard'
var sajOooPolicy = 'Adjust'
var sajErrPolicy = 'Drop'
var sajOooMaxDelay = 5
var sajLateArrivalMaxDelay = 16
var sqlServerVersion = '12.0'
var sqlDbCollation = 'SQL_Latin1_General_CP1_CI_AS'
var sqlMaxDbSize = 2147483648
var sqlSampleName = 'AdventureWorksLT'
var adfPublicNetworkAccess = 'Enabled'
var aiwPrefix = 'aiw'
var aiwName = '${aiwPrefix}${randomString}'
var aicType = 'web'
var aicFlowType = 'Redfield'
var aicRequestSource = 'IbizaMachineLearningExtension'
var mlwTier = 'Basic'
var mlwDescription = 'Demand Forecasting'
var publicNetworkAccess = 'Enabled'
var aiwSku = 'PerGB2018'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: rgpLocation

  sku: {
    name: staSku
  }
  kind: staKind
  properties: {
    accessTier: staAccessTier
    allowBlobPublicAccess: staPublicBlobAccess
    minimumTlsVersion: staMinTlsVersion
    supportsHttpsTrafficOnly: staHttpsOnly
  }
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' = {
  name: eventHubNamespaceName
  location: rgpLocation
  sku: {
    name: ehnTier
    tier: ehnTier
  }
}

resource streamAnalyticsJob 'Microsoft.StreamAnalytics/streamingjobs@2021-10-01-preview' = {
  name: streamAnalyticsJobName
  location: rgpLocation
  properties: {
    sku: {
      name: sajSku
    }
    eventsOutOfOrderPolicy: sajOooPolicy
    outputErrorPolicy: sajErrPolicy
    eventsOutOfOrderMaxDelayInSeconds: sajOooMaxDelay
    eventsLateArrivalMaxDelayInSeconds: sajLateArrivalMaxDelay
  }
}

resource appInsights 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: aiwName
  location: rgpLocation
  properties: {
      sku: {
        name: aiwSku
    }
  }
}

resource appInsightsComponent 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: aiwName
  location: rgpLocation
  dependsOn: [
    appInsights
  ]
  properties: {
        Application_Type: aicType
        ApplicationId: aiwName
        Flow_Type: aicFlowType
        Request_Source: aicRequestSource
        WorkspaceResourceId: appInsights.id
    }
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' existing = {
  name: 'acr0916'
  scope: resourceGroup(iacResourceGroupName)
}

resource umi 'Microsoft.ManagedIdentity/identities@2023-07-31-preview' existing = {
	name: iacUmi
    scope: resourceGroup(iacResourceGroupName)
}

resource kvt 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
	name: kvtName
    scope: resourceGroup(iacResourceGroupName)
}



resource machineLearningWorkspace 'Microsoft.MachineLearningServices/workspaces@2023-10-01' = {
  name: machineLearningWorkspaceName
  location: rgpLocation
  identity: {
    type: 'userAssigned'
  }
  sku: {
    tier: mlwTier
    name: mlwTier
  }
  properties: {
    friendlyName: machineLearningWorkspaceName
    description: mlwDescription
    storageAccount: storageAccount.id
    keyVault: kvt.id
    applicationInsights: appInsights.id
    containerRegistry: acr.id 
    primaryUserAssignedIdentity: umi.id
    publicNetworkAccess: publicNetworkAccess
  }
}

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: rgpLocation
  properties: {
    administratorLogin: dbUserName
    administratorLoginPassword: dbUserPw
    version: sqlServerVersion
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
    name: sqlDatabaseName
    parent: sqlServer   
    location: rgpLocation
    properties: {
        collation: sqlDbCollation
        maxSizeBytes: sqlMaxDbSize
        sampleName: sqlSampleName
    }
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: rgpLocation
  properties: {
    publicNetworkAccess: adfPublicNetworkAccess
  }
}

output randomString string = randomString
output staId string = storageAccount.id
output ehnId string = eventHubNamespace.id
output sajId string = streamAnalyticsJob.id
output mlwId string = machineLearningWorkspace.id
output sqlId string = sqlServer.id
output sqldbId string = sqlDatabase.id
output adfId string = dataFactory.id
output dbUserName string = dbUserName
output kvtName string = kvtName