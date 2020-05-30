function Compare-Processes($direction) {
    $initial_processes = (nvidia-smi -q -d 'PIDS' | Select-String 'name') -replace '^\s*Name\s*:\s*'
    return Compare-Object (Get-Content $env:USERPROFILE+'\.saved-processes') $initial_processes -IncludeEqual | Where-Object { $_.SideIndicator -eq $direction } | Select-Object -ExpandProperty inputobject
}

if (-not (Test-Path $env:USERPROFILE+'\.saved-processes')) {
    New-Item $env:USERPROFILE+'\.saved-processes' -value '`r`n'
}

$new_processes = Compare-Processes('=>')
foreach ($process in $new_processes) {
    $question = 'Do you want to add ' + $process + ' to the list of saved processes?' 
    $choices = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice($process, $question, $choices, 0)
    if ($decision -eq 0) {
        Add-Content -Value $process -Path '.saved-processes'
    }
}

Write-Host "Pausing wallpaper rotation"
$old_interval = (Get-ItemProperty 'HKCU:\Control Panel\Personalization\Desktop Slideshow' Interval).interval
Set-ItemProperty 'HKCU:\Control Panel\Personalization\Desktop Slideshow' Interval 86400000 #8640000 is equivalent to a day, which is more than enough for our purpouses
RUNDLL32.EXE USER32.DLL, UpdatePerUserSystemParameters 1, True #Refreshes user profile

try {
    #Surrounding in try as finally catches some unintentional exit coniditons where we still want to reset the registry back to its original state
    $processes = Compare-Processes('==')
    while ($processes) {
        Write-Progress -id 1 -Activity "Waiting on processes to reset wallpaper timeout:" -PercentComplete -1 -Status ($processes -join [Environment]::NewLine)
        Start-Sleep 5
        $processes = Compare-Processes('==')
    }
    exit
}
finally {
    Write-Host "Resetting desktop wallpaper timeout"
    Set-ItemProperty 'HKCU:\Control Panel\Personalization\Desktop Slideshow' Interval $old_interval
    RUNDLL32.EXE USER32.DLL, UpdatePerUserSystemParameters 1, True
}
