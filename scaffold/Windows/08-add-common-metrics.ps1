$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'lib/add-lib.ps1') -Name 'common-metrics' -Package 'metrics' -Template 'lib-plain'
