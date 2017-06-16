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

# posh-git
Write-Host -ForegroundColor DarkRed "Loading Posh-Git PowerShell Module.."
$poshGitModule = Get-Module posh-git -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
if ($poshGitModule) {
    $poshGitModule | Import-Module

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

    Write-Host -ForegroundColor DarkGreen "OK"
} else {
    Write-Host "Could not find posh-git module. Is posh-git installed?"
    Write-Host "If you are on PowerShell version 5 or higher, execute the command below to install from the PowerShell Gallery:"
    Write-Host "'PowerShellGet\Install-Module posh-git -Scope CurrentUser'"

    throw
}

# gulp
Write-Host -ForegroundColor DarkRed "Adding gulp powershell completion.."
if (Get-Command "gulp") {
    Invoke-Expression ((gulp --completion=powershell) -join [System.Environment]::NewLine)
    Write-Host -ForegroundColor DarkGreen "OK"
} else {
    Write-Host "Unable to add gulp powershell completion: Command 'gulp' not found."
}
