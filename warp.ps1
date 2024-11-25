Param(
    [Parameter(Mandatory = $true, HelpMessage = "Action to take.")]
    [ValidateSet("set", "remove", "to", "list")]
    [string]
    $Action,

    [Parameter(HelpMessage = "Name of the warp to take action on.")]
    [string]
    $Name
)

$dataFilePath = "$PSScriptRoot/warps.csv"

# Ensures that the data file exists
if (-Not (Test-Path $dataFilePath)) {
    Write-Output "Name,Location" > $dataFilePath
}

function WarpSet {
    if ($Name -eq '') {
        throw "Please enter the name of your warp."
    }

    #   Ensures a warp doesn't already exist with the same name
    $data = Import-Csv -Path $dataFilePath
    $matchedWarp = $data | Where-Object { $_.Name -eq $Name }

    if ($matchedWarp) {
        throw "Warp '$($matchedWarp.Name)' already exists."
    }

    $line = @(
        [PSCustomObject]@{Name = $Name; Location = (Get-Location).Path }
    )

    $line | Export-Csv -Path $dataFilePath -NoTypeInformation -Append
    Write-Output "✨ Added warp '$Name' here."
}

function WarpRemove {
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

    Write-Output "✅ Removed warp"
}

function WarpTo {
    if ($Name -eq '') {
        throw "Please enter the name of your warp."
    }

    $data = Import-Csv -Path $dataFilePath

    $matchedWarp = $data | Where-Object { $_.Name -eq $Name }

    if (-Not $matchedWarp) {
        throw "Could not find the warp '$Name'"
    }

    if (-Not(Test-Path $matchedWarp.Location)) {
        throw "The destination associated with this warp is unreachable."
    }

    Set-Location $matchedWarp.Location

    Write-Output "✨ Warped to $Name."
}

function WarpList {
    Write-Output "📖 Registered warps`n"
    $n = 0

    Import-Csv -Path $dataFilePath | ForEach-Object {
        $name = $_.Name
        $location = $_.Location

        Write-Host "'$name' ➡️ $location"
        $n = $n + 1
    }

    Write-Output "`nTotal: $n warps."
}

switch ($Action) {
    "set" {
        WarpSet;
        break
    }
    "remove" {
        WarpRemove;
        break
    }
    "to" {
        WarpTo;
        break
    }
    "list" {
        WarpList;
        break
    }
    default {
        throw "Invalid action '$Action'."
    }
}
