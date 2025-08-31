$paneNames = @("Directory", "Notes", "Rendering")

foreach ($paneName in $paneNames) {
    # 1. Spawn new pane
    wezterm cli spawn
    
    # 2. Get the latest pane info
    $json = wezterm cli list --format json | ConvertFrom-Json
    $latestPane = $json | Sort-Object pane_id -Descending | Select-Object -First 1
    $latestPaneId = $latestPane.pane_id
    $tabId = $latestPane.tab_id
    
    # 3. Set the tab title
    wezterm cli set-tab-title --tab-id $tabId $paneName
    
    # 4. Send text to the pane
    # wezterm cli send-text --pane-id $latestPaneId $paneName
}
