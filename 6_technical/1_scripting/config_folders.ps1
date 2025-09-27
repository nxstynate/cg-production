function Organize-StoreFiles {
    param (
        [Parameter(Mandatory=$false)]
        [string]$RootLocation = (Get-Location).Path
    )
    
    # Navigate up two levels from 6_technical/1_scripting to reach the root
    $projectRoot = Split-Path (Split-Path $RootLocation -Parent) -Parent
    $mailOutMain = "$projectRoot/1_docs/5_mail_out/0000-00-00-00-00-00"
    
    if (!(Test-Path $mailOutMain)) {
        Write-Error "Source directory not found: $mailOutMain"
        return
    }
    
    # Rest of your code remains the same...
    Set-Location $mailOutMain
    
    foreach ($folder in @("Beauty", "Mask")) {
        if (!(Test-Path $folder)) {
            mkdir $folder | Out-Null
            Write-Host "Created folder: $folder"
        }
    }
    
    $maskFiles = Get-ChildItem "*Mask*" -File -ErrorAction SilentlyContinue
    if ($maskFiles) {
        Move-Item $maskFiles -Destination "./Mask/" -Force
        Write-Host "Moved $($maskFiles.Count) files to Mask folder"
    }
    
    $beautyFiles = Get-ChildItem "*.jpg" -File -ErrorAction SilentlyContinue
    if ($beautyFiles) {
        Move-Item $beautyFiles -Destination "./Beauty/" -Force
        Write-Host "Moved $($beautyFiles.Count) files to Beauty folder"
    }
    
    Write-Host "File organization complete"
}
Organize-StoreFiles
