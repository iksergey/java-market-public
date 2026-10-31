$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'lib/add-service.ps1') -Name 'catalog' -Architecture 'layered'
