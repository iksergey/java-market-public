$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'lib/add-service.ps1') -Name 'promotion' -Architecture 'compact'
