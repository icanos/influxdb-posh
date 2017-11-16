# influxdb-posh
Powershell module for InfluxDB to insert metrics into one or more series in a database.

Easily insert new metrics into a database:
```powershell
Import-Module InfluxDB
Add-InfluxMetric -ComputerName grafana01 -Database metricsdb -SeriesName series1 -Value 0.4 -Tags @{ "tag1" = "value1"; }
```

Create a new database:
```powershell
Import-Module InfluxDB
New-InfluxDatabase -ComputerName grafana01 -Database mynewdatabase
```

If you've set up the database on a different port than 8086, you just specify the -ComputerName parameter to include the port, eg:
```powershell
... -ComputerName "grafana01:8888" -Database ...
```
