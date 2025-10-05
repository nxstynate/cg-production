function Create-Dir {
    # Define source and destination folders
    $templatePath = "./template"

    # List of destination folders to create: add directory names below.
    $destinations = @(
        "Foo",
        "Bar"
    )

    # Loop through each destination and copy the template
    foreach ($dest in $destinations) {
        $targetPath = Join-Path -Path (Get-Location) -ChildPath $dest
        Write-Host "Creating folder: $targetPath"
        Copy-Item -Path $templatePath -Destination $targetPath -Recurse -Force
    }

    Write-Host "`n✅ All folders have been created successfully." -ForegroundColor Green
}

# Execute the function
Create-Dir
