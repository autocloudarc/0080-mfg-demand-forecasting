using './main.bicep'

param randomString string = uniqueString(resourceGroup().id).substring(0, 8)
param rgpName string = 'rgp-0800'
param rgpLocation string = 'eastus2'
@minLength(3)
@maxLength(24)
@pattern('^[a-z0-9]+(-[a-z0-9]+)*$')
param storageAccountName string = '1sta${randomString}'
param eventHubNamespaceName string = 'ehn-${randomString}'
param streamAnalyticsJobName string = 'saj-${randomString}'
param machineLearningWorkspaceName string = 'mlw-${randomString}'
param sqlServerName string = 'sqs-${randomString}'
param sqlDatabaseName string = 'sqd-${randomString}'
param dataFactoryName string = 'adf-${randomString}'
param dbUserName string = 'demandDbUserName'
param dbUserPw string = 'dbUserPw'
