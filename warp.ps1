Param(
    [Parameter(Mandatory = $true, HelpMessage = "Action to take. Either 'set' to create a warp here, 'tà' changes the current directory to a given warp, 'list' to list all registered warps.")]
    [ValidateSet("set", "to", "list")]
    [string]
    $Action,

    [Parameter(HelpMessage = "Name of the warp to take action on.")]
    [string]
    $Name
)

$dataFilePath = "$PSScriptRoot/data.csv"

# Ensures that the data file exists
if (-Not (Test-Path $dataFilePath)){
    echo "Name,Location" > $dataFilePath
}

if ($Action -eq "set"){
    if ($Name -eq ''){
        throw "Please enter the name of your warp."
    }

    $line = @(
        [PSCustomObject]@{Name=$Name; Location=(Get-Location).Path}
    )

    $line | Export-Csv -Path $dataFilePath -NoTypeInformation -Append
    echo "✨ Added warp '$Name' here."
} elseif ($Action -eq "to"){
    if ($Name -eq ''){
        throw "Please enter the name of your warp."
    }

    $data = Import-Csv -Path $dataFilePath

    $matchedWarp = $data | Where-Object { $_.Name -eq $Name }

    if (-Not $matchedWarp){
        throw "Could not find the warp '$Name'"
    }

    Set-Location $matchedWarp.Location

    echo "✨ Warped to $Name."
} else {
    echo "📖 Registered warps`n"
    $n = 0

    Import-Csv -Path $dataFilePath | ForEach-Object {
        $name = $_.Name
        $location = $_.Location

        Write-Host "'$name' ➡️ $location"
        $n = $n + 1
    }

    echo "`nTotal: $n warps."
}
