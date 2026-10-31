$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'lib/add-lib.ps1') -Name 'common-messaging' -Package 'messaging' -Template 'lib-plain'
