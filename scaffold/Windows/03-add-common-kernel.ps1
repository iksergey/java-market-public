$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'lib/add-lib.ps1') -Name 'common-kernel' -Package 'kernel'
