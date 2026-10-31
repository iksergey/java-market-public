function Test-BasePackage {
    param([string]$Value)

    return $Value -cmatch '^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)*$'
}

function Get-BasePackage {
    param([string]$Config)

    if (-not [System.IO.File]::Exists($Config)) {
        throw "Не найден файл настроек: $Config"
    }

    $lines = @([System.IO.File]::ReadAllLines($Config, [System.Text.Encoding]::UTF8) |
        Where-Object { $_ -cmatch '^\s*BASE_PACKAGE\s*=' })
    if ($lines.Count -ne 1) {
        throw "В $Config задайте одну строку BASE_PACKAGE=com.example.foo"
    }

    $package = ($lines[0] -creplace '^\s*BASE_PACKAGE\s*=\s*', '').Trim()
    if (-not (Test-BasePackage $package)) {
        throw "В $Config задайте корректный пакет, например BASE_PACKAGE=com.example.foo"
    }

    return $package
}
