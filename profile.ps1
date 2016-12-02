# output colors
Write-Host -nonewline -ForegroundColor Black       "Black       " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor DarkBlue    "DarkBlue    " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor DarkGreen   "DarkGreen   " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor DarkCyan    "DarkCyan    " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor DarkRed     "DarkRed     " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor DarkMagenta "DarkMagenta " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor DarkYellow  "DarkYellow  " -BackgroundColor Black
Write-Host -ForegroundColor Gray                   "Gray        " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor DarkGray    "DarkGray    " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor Blue        "Blue        " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor Green       "Green       " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor Cyan        "Cyan        " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor Red         "Red         " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor Magenta     "Magenta     " -BackgroundColor Black
Write-Host -nonewline -ForegroundColor Yellow      "Yellow      " -BackgroundColor Black
Write-Host -ForegroundColor White                  "White       " -BackgroundColor Black

# environment loading message
Write-Host -ForegroundColor DarkGreen "Setting up PowerShell Environment.."

$user = [Environment]::UserName
$computer = [Environment]::MachineName
$DefaultTitle = $Host.UI.RawUI.WindowTitle

# github for windows
Write-Host -ForegroundColor DarkRed "Loading GitHub.."
$gitHubShellPath = (Resolve-Path "$env:LOCALAPPDATA\GitHub\shell.ps1")
if (Test-Path $gitHubShellPath) {
    . $gitHubShellPath
} else {
    Write-Host "Could not resolve GitHub shell path. Is GitHub installed?"
}

Write-Host -ForegroundColor DarkRed "Adding gulp powershell completion.."
if (Get-Command "gulp") {
    Invoke-Expression ((gulp --completion=powershell) -join [System.Environment]::NewLine)
} else {
    Write-Host "Unable to add gulp powershell completion: Command 'gulp' not found."
}

Write-Host -ForegroundColor DarkRed "Overriding powershell prompt.."
if (Test-Path env:github_posh_git) {
    . $env:github_posh_git\profile.example.ps1

    $GitPromptSettings.BeforeText = "on "
    $GitPromptSettings.BeforeForegroundColor = [ConsoleColor]::White
    $GitPromptSettings.AfterText = ""
    $GitPromptSettings.BranchIdenticalStatusToForegroundColor = [ConsoleColor]::Yellow

    function prompt {
        $location = $executionContext.SessionState.Path.CurrentLocation
        $location = $location -replace "C:\\Users\\$user", "~"

        Write-Host "$user " -ForegroundColor DarkCyan -NoNewline
        Write-Host "at " -NoNewline
        Write-Host "$computer " -ForegroundColor Red -NoNewline
        Write-Host "in " -NoNewline
        Write-Host "$location " -ForegroundColor DarkBlue -NoNewline

        if (-not(Get-GitDirectory)) {
            $Host.UI.RawUI.WindowTitle = $DefaultTitle
        } else {
            Write-VcsStatus
        }

        return "`n$('$' * ($nestedPromptLevel + 1)) "
    }
} else {
    Write-Warning -Message "Unable to load the Posh-Git PowerShell Module."
}

# Finish loading message
Write-Host -ForegroundColor DarkGreen "Done."
