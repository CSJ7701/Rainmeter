param (
    [string]$repoPath
)

# Navigate to the repository directory
Set-Location -Path $repoPath

# Initialize the status variables
$localChanges = $false
$unpushedCommits = $false
$unpulledCommits = $false

# Check for local changes
$gitDiff = git diff --quiet
if ($?) { $localChanges = $false } else { $localChanges = $true }

# Check for unpushed commits
$unpushedCommitsCount = git log origin/master..HEAD --oneline | Measure-Object -Line
if ($unpushedCommitsCount.Count -gt 0) { $unpushedCommits = $true }

# Check for unpulled commits
git fetch
$unpulledCommitsCount = git log HEAD..origin/master --oneline | Measure-Object -Line
if ($unpulledCommitsCount.Count -gt 0) { $unpulledCommits = $true }

# Format the result into a string
$status = "Up to date..."
if ($localChanges) { $status = "Local changes detected" }
if ($unpushedCommits) { $status = "Unpushed commits" }
if ($unpulledCommits) { $status = "Unpulled commits" }

# Output the result
Write-Output $status