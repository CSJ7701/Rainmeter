# Define Paths
$ConfigFile = ".\repos.ini" # Path to the repo config file
$OutputFile = ".\GitStatus.txt" # Path to the Rainmeter-readable output file

# Parse the INI file
function Parse-IniFile {
    param ([string]$FilePath)
    $Ini = @{}
    $CurrentSection = $null

    foreach ($Line in Get-Content $FilePath) {
	if ($Line -match '^\[(.+)\]$') {
	    $CurrentSection = $matches[1]
	    $Ini[$CurrentSection] = @{}
	} elseif ($Line -match '^(.+?)=(.+)$' -and $CurrentSection) {
	    $Ini[$CurrentSection][$matches[1].Trim()] = $matches[2].Trim()
	}
    }
    return $Ini
}

# Execute Git Commands
function Run-GitCommand {
    param (
	[string]$Path,
	[bool]$IsWSL,
	[string]$Command
    )
    if ($IsWSL) {
	return & wsl.exe git -C "$Path" $Command 2>$null
    } else {
	return & git -C "$Path" $Command 2>$null
    }
}	    

# Get the repo info
$Repos = Parse-IniFile -FilePath $ConfigFile

# Initialize Output
Set-Content -Path $OutputFile -Value "Git Repository Status:`n"

# Process each repo
foreach ($Repo in $Repos.keys) {
    $Path = $Repos[$Repo]["Path"]
    $Remote = $Repos[$Repo]["Remote"]
    $IsWSL = $Repos[$Repo]["WSL"] -eq "true"

    if ($IsWSL -or (Test-Path $Path)) {
	$LocalChanges = Run-GitCommand -Path $Path -IsWSL $IsWSL -Command "status --porcelain"
        $UnpushedCommits = Run-GitCommand -Path $Path -IsWSL $IsWSL -Command "log @{u}.."
        $UnpulledCommits = Run-GitCommand -Path $Path -IsWSL $IsWSL -Command "log ..@{u}"

        # Format the output
        Add-Content -Path $OutputFile -Value "$Repo:`n"
        Add-Content -Path $OutputFile -Value "  Local Changes: $($LocalChanges.Count)`n"
        Add-Content -Path $OutputFile -Value "  Unpushed Commits: $($UnpushedCommits.Count)`n"
        Add-Content -Path $OutputFile -Value "  Unpulled Commits: $($UnpulledCommits.Count)`n`n"
    } else {
        Add-Content -Path $OutputFile -Value "$Repo: Invalid Path`n`n"
    }
}
