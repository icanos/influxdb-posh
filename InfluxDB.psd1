@{
RootModule = 'InfluxDB.psm1'
ModuleVersion = '0.0.0.1'
GUID = '5bb17f7d-43f4-4467-8584-863c7b2c7375'
Author = 'Marcus Westin'
CompanyName = 'Marcus Westin'
Copyright = '© Marcus Westin. All rights reserved.'
PowerShellVersion = '5.0'
FunctionsToExport = @('New-InfluxDatabase',
                      'Add-InfluxMetric',
                      'Add-InfluxMultiMetric')
VariablesToExport = "*"
FileList = @('InfluxDB.psm1')
}
