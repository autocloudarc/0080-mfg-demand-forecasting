using './main.bicep'

param randomLongString = newGuid()
param randomString = randomLongString.substring(0, 8)
param rgpName = 'rgp-0800'
param rgpLocation = 'eastus2'
@minLength(3)
@maxLength(24)
@pattern('^[a-z0-9]+(-[a-z0-9]+)*$')
param storageAccountName = '1sta${randomString}'
param eventHubNamespaceName = 'ehn-${randomString}'
param streamAnalyticsJobName = 'saj-${randomString}'
param machineLearningWorkspaceName = 'mlw-${randomString}'
param sqlServerName = 'sqs-${randomString}'
param sqlDatabaseName = 'sqd-${randomString}'
param dataFactoryName = 'adf-${randomString}'
param dbUserName string = ''
param dbUserPw string = ''
