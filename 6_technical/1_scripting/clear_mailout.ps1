function Clear-Mailout {
    param (
        [Parameter(Mandatory=$false)]
        [string]$RootLocation = (Get-Location).Path,
        [Parameter(Mandatory=$false)]
        [switch]$Force
    )
    $projectRoot = Split-Path (Split-Path $RootLocation -Parent) -Parent
    $mailOutMain = "$projectRoot/1_docs/5_mail_out/0000-00-00-00-00-00"
    if (!(Test-Path $mailOutMain)) {
        Write-Error "Mailout folder not found: $mailOutMain"
        return
    }
    
    Write-Output "Cleaning Mailout folder: $mailOutMain"
    Push-Location $mailOutMain
    try {
        Remove-Item * -Recurse -Force -ErrorAction SilentlyContinue
        Write-Output "Mail out folder cleared."
    }
    catch {
        Write-Error "Failed to clear folder: $_"
    }
    finally {
        Pop-Location
    }
}
Clear-Mailout
