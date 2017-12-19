# output colors
Write-Host -NoNewLine -ForegroundColor Black       "Black       " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor DarkBlue    "DarkBlue    " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor DarkGreen   "DarkGreen   " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor DarkCyan    "DarkCyan    " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor DarkRed     "DarkRed     " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor DarkMagenta "DarkMagenta " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor DarkYellow  "DarkYellow  " -BackgroundColor Black
Write-Host -ForegroundColor Gray                   "Gray        " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor DarkGray    "DarkGray    " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor Blue        "Blue        " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor Green       "Green       " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor Cyan        "Cyan        " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor Red         "Red         " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor Magenta     "Magenta     " -BackgroundColor Black
Write-Host -NoNewLine -ForegroundColor Yellow      "Yellow      " -BackgroundColor Black
Write-Host -ForegroundColor White                  "White       " -BackgroundColor Black

# environment loading message
Write-Host -ForegroundColor DarkYellow "Setting up PowerShell Environment.."

$user = [Environment]::UserName
$computer = [Environment]::MachineName
$defaultTitle = $Host.UI.RawUI.WindowTitle
$getPoshGitModule = "Get-Module posh-git -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1"

function loadGit {
  Invoke-Expression $getPoshGitModule | Import-Module

  $GitPromptSettings.BeforeText = "on "
  $GitPromptSettings.BeforeForegroundColor = [ConsoleColor]::White
  $GitPromptSettings.AfterText = ""
  $GitPromptSettings.BranchIdenticalStatusToForegroundColor = [ConsoleColor]::Yellow
}

function prompt {
  $location = $executionContext.SessionState.Path.CurrentLocation
  $location = $location -replace "C:\\Users\\$user", "~"

  Write-Host "$user " -ForegroundColor DarkCyan -NoNewline
  Write-Host "at " -NoNewline
  Write-Host "$computer " -ForegroundColor Red -NoNewline
  Write-Host "in " -NoNewline
  Write-Host "$location " -ForegroundColor DarkBlue -NoNewline

  if (-not(Get-GitDirectory)) {
    $Host.UI.RawUI.WindowTitle = $defaultTitle
  } else {
    Write-VcsStatus
  }

  return "`n$('$' * ($nestedPromptLevel + 1)) "
}

# posh-git
Write-Host -ForegroundColor DarkYellow "Loading posh-git powershell module.."
$poshGitModule = Invoke-Expression $getPoshGitModule
if ($poshGitModule) {
  loadGit
  Write-Host -ForegroundColor DarkCyan "OK"
} else {
  Write-Host -ForegroundColor DarkGreen "'posh-git' not found. Installing.."
  Invoke-Expression -Command "PowerShellGet\Install-Module posh-git -Scope CurrentUser" | Out-Null

  loadGit
  Write-Host -ForegroundColor DarkCyan "OK"
}
