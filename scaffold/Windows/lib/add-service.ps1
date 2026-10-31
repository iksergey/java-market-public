param(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)]
    [ValidateSet('layered', 'slices', 'compact', 'clean')][string]$Architecture
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'render.ps1')
. (Join-Path $PSScriptRoot 'config.ps1')

$repo = (Get-Location).Path
$basePackage = Get-BasePackage (Join-Path $repo 'scaffold.conf')
$template = Join-Path $root "templates/service-$Architecture"
if (-not (Test-Path -LiteralPath $template -PathType Container)) {
    throw "Нет шаблона '$Architecture'"
}
if (-not (Test-Path -LiteralPath (Join-Path $repo 'src/services') -PathType Container)) {
    throw 'В текущей папке нет src/services — сначала 01-init-repo.ps1'
}
$target = Join-Path $repo "src/services/$Name"
if (Test-Path -LiteralPath $target) {
    throw "Сервис уже существует: $target"
}

$defaults = ConvertFrom-StringData ([System.IO.File]::ReadAllText((Join-Path $template 'template.conf')))
$port = $defaults['port']
$package = $defaults['pkg'].Replace('__name__', $Name)
$className = $Name.Substring(0, 1).ToUpperInvariant() + $Name.Substring(1)
$variables = New-Object System.Collections.Hashtable ([System.StringComparer]::Ordinal)
$variables['name'] = $Name
$variables['Name'] = $className
$variables['pkg'] = $package
$variables['port'] = $port
$variables['basepkg'] = $basePackage
$variables['basepkgpath'] = $basePackage.Replace('.', '/')
$variables['bootversion'] = '4.1.1'
$variables['javaversion'] = '25'

Write-Host "Создаю сервис $className ($Architecture, порт $port, пакет $basePackage.$package) в src/services/$Name"
Render-Tree -Template (Join-Path $root 'templates/service-common') -Target $target -Variables $variables
Render-Tree -Template (Join-Path $root 'templates/gradle-wrapper') -Target $target -Variables $variables
Render-Tree -Template $template -Target $target -Variables $variables
$placeholder = Join-Path $repo 'src/services/.gitkeep'
if (Test-Path -LiteralPath $placeholder) {
    Remove-Item -LiteralPath $placeholder -Force
}

if (Test-Path -LiteralPath (Join-Path $target "$Name-api") -PathType Container) {
    $task = ":${Name}-api:bootRun"
} else {
    $task = 'bootRun'
}
$hello = @(Get-ChildItem -LiteralPath $target -Recurse -File -Filter 'HelloController.java')
if ($hello.Count -gt 0) {
    $check = "Invoke-RestMethod http://localhost:$port/hello"
} else {
    $check = "В логе — «Started ${className}Application»"
}
Write-Host "`nГотово. Проверка:"
Write-Host "  Set-Location src/services/$Name"
Write-Host "  .\gradlew.bat $task"
Write-Host "  $check"
