# 1 set vim_home environment
# 2 set vim_version   list version supported and choose
# 3 set context menu  list lang supported and choose 
param([switch]$Elevated)
function Set-VIMHome ([string] $PathName) {
    [Environment]::SetEnvironmentVariable('VIM_HOME', $PathName, [EnvironmentVariableTarget]::Machine)
    $VimVer = [Environment]::GetEnvironmentVariable('VIM_VERSION')
    if ($VimVer -eq $null) {
        Set-VIMVersion('74')
    }
    $vimpath=Join-Path -Path "%VIM_HOME%" -ChildPath "vim%VIM_VERSION%"
   
    $path  = reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path
    $path = $path[2].Trim().Substring(24).Trim() #path environment variable
    if (-not $path.Contains($vimpath)) {
        Write-Host $vimpath
        reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "Path" /t REG_EXPAND_SZ /d $vimpath";"$path /f
    }
}

function List-VIMVersion([string] $PathName) {  
    $vers = @()
    Get-ChildItem $PathName -Attributes Directory | Where-Object { $_.BaseName -match 'vim[0-9]+'} | ForEach-Object {
        $vers +=  $_.BaseName.Substring(3)
    }
    return $vers 
}


function List-Language ([string] $PathName) {
    $lang = @()
    Get-ChildItem $PathName -Attributes !Directory  '_vimrc_*' | ForEach-Object {
        $lang +=  $_.BaseName.Substring(7)
    }
    return $lang 
}

function Set-VIMVersion ([String] $VerToken) {
    [Environment]::SetEnvironmentVariable('VIM_VERSION', $VerToken, [EnvironmentVariableTarget]::Machine)
}

function Set-ContextMenu([String] $lang, [String] $PathName) {
    Write-Host $lang
    $newkey = [Microsoft.Win32.Registry]::ClassesRoot.CreateSubKey('*\shell\Gvim('+$lang+')')
    $newsubkey = $newkey.CreateSubKey('command')
    $newsubkey.SetValue('', "wscript "+$PathName+'\gvim.vbs _vimrc_'+$lang +' "%1"')
}


function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($Elevated) 
    {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noexit -file "{0}" -Elevated' -f ($myinvocation.MyCommand.Definition))
}
exit
}

function Write-MenuItem([string] $menu) {
    $mlen = $menu.Length + 20
    $ftext = "{0, $mlen}" -f $menu
    write-host $ftext -ForegroundColor Yellow
}

$workdir = "d:\vim"#[System.Environment]::CurrentDirectory
#$workdir = Get-Location |  ForEach-Object {$_.Path}
function Show-MainMenu{
    Clear-Host
    Write-MenuItem("VIM Main Setup Menu")
    Write-MenuItem("1. Setup VIM Home Path")
    Write-MenuItem("2. List VIM Version")
    Write-MenuItem("3. List Language Supported")
    Write-MenuItem("4. Exit")
    $choice = Read-Host -prompt "Select Choice[1-4]"
    if ($choice -eq 4) {
        exit
    }
    elseif ($choice -eq 2)  {
        Show-VIMVersion
    }
    elseif ($choice -eq 3)  {
        Show-Language
    } else {
        Set-VIMHome($workdir)
    }
    Show-MainMenu
}

function Show-VIMVersion {
    Clear-Host
    Write-MenuItem("VIM Version Menu")
    $vers = List-VIMVersion($workdir)
    $last = $vers.Length
    if ($last -eq 0){
        Show-MainMenu
    }
    foreach($index in 1..$last) {
        Write-MenuItem("$index."+$vers[$index-1])
    }
     
    Write-MenuItem("$($last+1)"+".Back")
    $choice = Read-Host -prompt "Select version to install"
    if ($choice -ne $last+1) {
        Set-VIMVersion($vers[$choice-1])
    }
    Show-MainMenu
}

function Show-Language {
    Clear-Host
    Write-MenuItem("VIM Language Menu")
    $langs = List-Language($workdir)
    $last = $langs.Length
    if ($last -eq 0){
        Show-MainMenu
    }
    foreach($index in 1..$last) {
        Write-MenuItem("$index."+$langs[$index-1])
    }
     
    Write-MenuItem("$($last+1)"+".Back")
    $choice = Read-Host -prompt "Select language to install"
    if ($choice -ne $last+1) {
        Set-ContextMenu $langs[$choice-1] $workdir 
    }
    Show-MainMenu
}

Show-MainMenu

