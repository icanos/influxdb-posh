<#
.SYNOPSIS
Creates a new database in InfluxDB

.DESCRIPTION
Creates a new database with the specified name in the instance of InfluxDB running on the computer provided.

.PARAMETER ComputerName
Name of the server that runs InfluxDB

.PARAMETER Database
Name of the database to create

.EXAMPLE
New-InfluxDatabase -ComputerName grafana01 -Database my-test-database
#>
Function New-InfluxDatabase {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,
        [Parameter(Mandatory = $true)]
        [string]$Database
    )

    if (!$ComputerName.Contains(":")) {
        # Add default port if none specified
        $ComputerName = "$($ComputerName):8086"
    }

    $BinaryData = "q=CREATE DATABASE $Database"
    Invoke-WebRequest -Method Post -Uri "http://$ComputerName/query" -Body $BinaryData | Out-Null
    
    Write-Output "'$BinaryData' has been inserted."
}

<#
.SYNOPSIS
Add a new metric to a series in InfluxDB

.DESCRIPTION
Add a new metric to a series in InfluxDB

.PARAMETER ComputerName
Name of the server running InfluxDB

.PARAMETER Database
Name of the database that the metric should be inserted into

.PARAMETER SeriesName
Name of the series to insert the metric into

.PARAMETER FieldName
(optional) Name of the field to insert the value into

.PARAMETER Metric
Value to insert

.PARAMETER Tags
(optional) Tags to add to the metric

.EXAMPLE
Add-Metric -ComputerName grafana01 -Database my-database -SeriesName test-series -Metric 0.4
#>
Function Add-InfluxMetric {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,
        [Parameter(Mandatory = $true)]
        [string]$Database,
        [Parameter(Mandatory = $true)]
        [string]$SeriesName,
        [Parameter(Mandatory = $false)]
        [string]$FieldName,
        [Parameter(Mandatory = $true)]
        [System.Object]$Metric,
        [Hashtable]$Tags
    )

    if (!$ComputerName.Contains(":")) {
        # Add default port if none specified
        $ComputerName = "$($ComputerName):8086"
    }

    if (!$Database) {
        Write-Error "Missing or invalid database name."
        return
    }

    if (!$SeriesName) {
        Write-Error "Missing or invalid series name"
        return
    }

    $TagsList = @()

    foreach ($Key in $Tags.Keys) {
        $TagsList += "$Key=$($Tags[$Key])"
    }

    $TagsCombined = [string]::Join(",", $TagsList)

    if ($FieldName) {
        if ($TagsList.Count -gt 0) {
            $BinaryData = "$SeriesName,$TagsCombined $FieldName=$Metric"
        }
        else {
            $BinaryData = "$SeriesName $FieldName=$Metric"
        }
    }
    else {
        if ($TagsList.Count -gt 0) {
            $BinaryData = "$SeriesName,$TagsCombined value=$Metric"
        }
        else {
            $BinaryData = "$SeriesName value=$Metric"
        }
    }

    Invoke-WebRequest -Method Post -Uri "http://$ComputerName/write?db=$Database" -Body $BinaryData | Out-Null

    Write-Output "'$BinaryData' has been inserted."
}

<#
.SYNOPSIS
Add a new metric to a series in InfluxDB

.DESCRIPTION
Add a new metric to a series in InfluxDB

.PARAMETER ComputerName
Name of the server running InfluxDB

.PARAMETER Database
Name of the database that the metric should be inserted into

.PARAMETER SeriesName
Name of the series to insert the metric into

.PARAMETER Metrics
Values to insert

.PARAMETER Tags
(optional) Tags to add to the metric

.EXAMPLE
Add-Metric -ComputerName grafana01 -Database my-database -SeriesName test-series -Metrics @{ "field1" = 0.2; "field2" = 1.3; }
#>
Function Add-InfluxMultiMetric {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,
        [Parameter(Mandatory = $true)]
        [string]$Database,
        [Parameter(Mandatory = $true)]
        [string]$SeriesName,
        [Parameter(Mandatory = $true)]
        [Hashtable]$Metrics,
        [Hashtable]$Tags
    )

    if (!$ComputerName.Contains(":")) {
        # Add default port if none specified
        $ComputerName = "$($ComputerName):8086"
    }

    if (!$Database) {
        Write-Error "Missing or invalid database name."
        return
    }

    if (!$SeriesName) {
        Write-Error "Missing or invalid series name"
        return
    }

    # Tags
    $TagsList = @()

    foreach ($Key in $Tags.Keys) {
        $TagsList += "$Key=$($Tags[$Key])"
    }

    $TagsCombined = [string]::Join(",", $TagsList)

    # Metrics
    $MetricsList = @()

    foreach ($Key in $Metrics.Keys) {
        $MetricsList += "$Key=$($Metrics[$Key])"
    }

    $MetricsCombined = [string]::Join(",", $MetricsList)

    if ($TagsList.Count -gt 0) {
        $BinaryData = "$SeriesName,$TagsCombined $MetricsCombined"
    }
    else {
        $BinaryData = "$SeriesName $MetricsCombined"
    }
    
    Invoke-WebRequest -Method Post -Uri "http://$ComputerName/write?db=$Database" -Body $BinaryData | Out-Null

    Write-Output "'$BinaryData' has been inserted."
}
