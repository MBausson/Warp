Param(
    [Parameter(HelpMessage = "Action to take. (list|to|set|remove)")]
    [string]
    $Action,

    [Parameter(HelpMessage = "Name of the warp to take action on.")]
    [string]
    $Name
)

if (-not $Action -and $Name) {
    $Action = "to"
}
elseif (-not $Action) {
    $Action = "list"
}

$dataFilePath = "$PSScriptRoot/warps.csv"

# Ensures that the data file exists
if (-Not (Test-Path $dataFilePath)) {
    Write-Output "Name,Location" > $dataFilePath
}

function WarpSet {
    if ($Name -eq '') {
        throw "Please enter the name of your warp"
    }

    #   Ensures a warp doesn't already exist with the same name
    $data = Import-Csv -Path $dataFilePath
    $matchedWarp = $data | Where-Object { $_.Name -eq $Name }

    if ($matchedWarp) {
        throw "Warp '$($matchedWarp.Name)' already exists"
    }

    $line = @(
        [PSCustomObject]@{Name = $Name; Location = (Get-Location).Path }
    )

    $line | Export-Csv -Path $dataFilePath -NoTypeInformation -Append
    Write-Output "Warp '$Name' added"
}

function WarpRemove($Name) {
    $data = Import-Csv -Path $dataFilePath

    $newData = foreach ($line in $data) {
        #   If no name is provided, remove the local warp.
        if ($Name -eq '') {
            if (-not ($line.Location -eq (Get-Location).Path)) {
                $line
            }
        }

        #   Otherwise, remove the warp by its name
        if (-not ($line.Name -eq $Name)) {
            $line
        }
    }

    $newData | Export-Csv -Path $dataFilePath -NoTypeInformation

    Write-Output "Warp '$Name' removed"
}

function WarpTo($Name) {
    if ($Name -eq '') {
        throw "Please enter the name of your warp"
    }

    $data = Import-Csv -Path $dataFilePath
    $matchedWarp = $data | Where-Object { $_.Name -eq $Name }

    if (-Not $matchedWarp) {
        throw "Warp '$Name' not found"
    }

    #   Checks that the warp is reachable. If not asks, to remove it.
    if (-Not(Test-Path $matchedWarp.Location)) {
        Write-Host "The destination associated with this warp is unreachable."

        $shouldRemoveWarp = (Read-Host -Prompt "Would you like to remove this warp (yes/no) ?") -match '^(y|yes|1)$'

        if ($shouldRemoveWarp) {
            WarpRemove($matchedWarp.Name)
        }

        return
    }

    Set-Location $matchedWarp.Location

    Write-Output "Warped to $Name"
}

function WarpList {
    $lineCount = Get-Content $dataFilePath | Measure-Object | Select-Object -expand Count
    Write-Output "Registered warps ($($lineCount - 1))"

    Import-Csv -Path $dataFilePath | ForEach-Object {
        $name = $_.Name
        $location = $_.Location

        Write-Host "'$name' -> $location"
        $n = $n + 1
    }
}

function WarpAbout {
    Write-Output "Installation path: $PSCommandPath"
    Write-Output "OS: $($PSVersionTable.OS)"
    Write-Output "Shell: Powershell ($($PSVersionTable.PSVersion.ToString()))"
}

switch ($Action) {
    "set" {
        WarpSet;
        break
    }
    "remove" {
        WarpRemove($Name);
        break
    }
    "to" {
        WarpTo($Name);
        break
    }
    "list" {
        WarpList;
        break
    }
    "--about" {
        WarpAbout;
        break
    }
    default {
        WarpTo($Action)
    }
}
