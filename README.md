# influxdb-posh
Community made Powershell module for InfluxDB to work with data in one or more databases directly from the PS console.

Querying data from a database:
```powershell
Import-Module InfluxDB
Select-Data -ComputerName grafana01 -Database metricsdb -Query "SELECT value FROM cpu_load WHERE dc='hq'"
Select-Data -ComputerName grafana01 -Database metricsdb -Query "SELECT value FROM cpu_load WHERE dc='hq'" -Epoch s
Select-Data -ComputerName grafana01 -Database metricsdb -Query "SELECT value FROM cpu_load WHERE dc='hq'" -Epoch m -ChunkSize 100
```

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

This repository is in no way affiliated with InfluxData. All use of this module is at your own risk.
