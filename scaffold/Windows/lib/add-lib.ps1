param(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)][string]$Package,
    [ValidateSet('lib-common', 'lib-plain')][string]$Template = 'lib-common'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'render.ps1')
. (Join-Path $PSScriptRoot 'config.ps1')

$repo = (Get-Location).Path
$basePackage = Get-BasePackage (Join-Path $repo 'scaffold.conf')
if (-not (Test-Path -LiteralPath (Join-Path $repo 'src/shared') -PathType Container)) {
    throw 'В текущей папке нет src/shared — сначала 01-init-repo.ps1'
}
$target = Join-Path $repo "src/shared/$Name"
if (Test-Path -LiteralPath $target) {
    throw "Библиотека уже существует: $target"
}

$variables = @{
    name = $Name
    pkg = $Package
    basepkg = $basePackage
    basepkgpath = $basePackage.Replace('.', '/')
    bootversion = '4.1.1'
    javaversion = '25'
}

Write-Host "Создаю библиотеку $Name (пакет $basePackage.$Package) в src/shared/$Name"
Render-Tree -Template (Join-Path $root 'templates/service-common') -Target $target -Variables $variables
Remove-Item -LiteralPath (Join-Path $target 'lombok.config')
Render-Tree -Template (Join-Path $root 'templates/gradle-wrapper') -Target $target -Variables $variables
Render-Tree -Template (Join-Path $root "templates/$Template") -Target $target -Variables $variables
[System.IO.Directory]::CreateDirectory((Join-Path $target "src/main/java/$($basePackage.Replace('.', '/'))/$Package")) | Out-Null
$placeholder = Join-Path $repo 'src/shared/.gitkeep'
if (Test-Path -LiteralPath $placeholder) {
    Remove-Item -LiteralPath $placeholder -Force
}

Write-Host "`nГотово. Подключение в сервисе: includeBuild(`"../../shared/$Name`") в settings.gradle.kts"
Write-Host "и implementation(`"${basePackage}:${Name}:0.0.1-SNAPSHOT`") в build.gradle.kts."
