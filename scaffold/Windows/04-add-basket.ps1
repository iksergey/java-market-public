$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'lib/add-service.ps1') -Name 'basket' -Architecture 'slices'
