$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
. (Join-Path $PSScriptRoot 'lib/render.ps1')
. (Join-Path $PSScriptRoot 'lib/config.ps1')

$target = (Get-Location).Path
$contents = @(Get-ChildItem -LiteralPath $target -Force |
    Where-Object { $_.Name -notin @('.git', '.DS_Store') })
if ($contents.Count -gt 0) {
    throw "Папка $target не пуста — скрипт создаёт проект только с нуля"
}

$defaultPackage = Get-BasePackage (Join-Path $PSScriptRoot 'scaffold.conf')
while ($true) {
    $chosenPackage = Read-Host "Базовый Java-пакет [$defaultPackage] (Enter — оставить)"
    if ($null -eq $chosenPackage) {
        throw 'Не удалось прочитать базовый пакет — запустите скрипт в терминале'
    }
    $chosenPackage = $chosenPackage.Trim()
    if ($chosenPackage.Length -eq 0) {
        $chosenPackage = $defaultPackage
    }
    if (Test-BasePackage $chosenPackage) {
        break
    }
    Write-Host 'Некорректное имя пакета. Пример: com.example.foo'
}

$config = Join-Path $target 'scaffold.conf'
Write-Utf8File -Path $config -Text "BASE_PACKAGE=$chosenPackage`n"
Write-Host "Создаю структуру проекта в $target"
Render-Tree -Template (Join-Path $PSScriptRoot 'templates/repo') -Target $target -Variables @{
    project = 'Java Marketplace'
    basepkg = $chosenPackage
}

Write-Host "`nГотово. Базовый пакет $chosenPackage сохранён в $config."
Write-Host 'Добавление сервисов и библиотек из этой же папки:'
Get-ChildItem -LiteralPath $PSScriptRoot -Filter '*.ps1' -File |
    Where-Object { $_.Name -match '^0[2-8]-' } |
    Sort-Object Name |
    ForEach-Object { Write-Host ('  & ''{0}''' -f $_.FullName.Replace("'", "''")) }
