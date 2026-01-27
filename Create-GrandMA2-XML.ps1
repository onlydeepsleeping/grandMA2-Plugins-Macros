# Florian Granzow, 2026
# This script generates matching .xml files for all .lua plugins in a directory (if they don't already exist).
# This script does not check if the .lua files are valid grandMA2 plugins.
# This code is not made or tested for grandMA3 plugin!

# Get the directory where the script is located
$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ("-" * 40)
Write-Host "Creating .xml files for all .lua plugins in this directory without one."
Write-Host "Current Directory: $currentDir"
Write-Host ("-" * 40)
Write-Host ""

# Get current timestamp (2026-01-01T00:00:00 format)
$dateNow = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"

# XML template
$xmlTemplate = @"
<?xml version="1.0" encoding="utf-8"?>
<MA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.malighting.de/grandma2/xml/MA" xsi:schemaLocation="http://schemas.malighting.de/grandma2/xml/MA http://schemas.malighting.de/grandma2/xml/3.9.61/MA.xsd" major_vers="3" minor_vers="9" stream_vers="61">
	<Info datetime="$dateNow" showfile="This .xml file was generated automatically." />
	<Plugin index="100" execute_on_load="0" name="{0}" luafile="{1}" />
</MA>
"@

# Get all .lua files in the directory
Get-ChildItem -Path $currentDir -Filter *.lua | ForEach-Object {

    $baseName = $_.BaseName
    $xmlFileName = "$baseName.xml"
    $xmlPath = Join-Path $currentDir $xmlFileName

    # Skip if XML already exists
    if (Test-Path $xmlPath) {
        Write-Host "Skipped: '$xmlFileName' already exists."
        return
    }

    # Fill the template
    $xmlContent = [string]::Format($xmlTemplate, $baseName, $_.Name)

    # Write file
    try {
        $xmlContent | Out-File -FilePath $xmlPath -Encoding UTF8
        Write-Host "Created: '$xmlFileName'"
    }
    catch {
        Write-Host "ERROR creating '$xmlFileName': $_"
    }
}

# Wait for user input to close
Read-Host "Press Enter to close the window"