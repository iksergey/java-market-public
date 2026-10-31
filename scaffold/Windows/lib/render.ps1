function Write-Utf8File {
    param([string]$Path, [AllowEmptyString()][string]$Text)

    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Text, $encoding)
}

function Expand-TemplateText {
    param([AllowEmptyString()][string]$Text, [hashtable]$Variables)

    foreach ($key in $Variables.Keys) {
        $Text = $Text.Replace("__${key}__", [string]$Variables[$key])
    }
    return $Text
}

function Render-Tree {
    param([string]$Template, [string]$Target, [hashtable]$Variables)

    $templateRoot = (Get-Item -LiteralPath $Template).FullName
    $files = Get-ChildItem -LiteralPath $templateRoot -Recurse -Force -File |
        Where-Object { $_.Name -notin @('template.conf', '.DS_Store') } |
        Sort-Object FullName

    foreach ($file in $files) {
        $relative = $file.FullName.Substring($templateRoot.Length).TrimStart([char[]]'\/')
        if ($relative.EndsWith('.tpl', [System.StringComparison]::Ordinal)) {
            $relative = $relative.Substring(0, $relative.Length - 4)
        }
        $relative = Expand-TemplateText -Text $relative -Variables $Variables
        $outputPath = Join-Path $Target $relative
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($outputPath)) | Out-Null

        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        if ($bytes -contains [byte]0) {
            [System.IO.File]::WriteAllBytes($outputPath, $bytes)
        } else {
            $text = [System.Text.Encoding]::UTF8.GetString($bytes)
            $text = Expand-TemplateText -Text $text -Variables $Variables
            Write-Utf8File -Path $outputPath -Text $text
        }
        Write-Host ('  + {0}' -f $relative.Replace('\', '/'))
    }
}
