<#

.SYNOPSIS
A simple Powershell Script to update your Pi-Hole over SSH.

.DESCRIPTION
The Script looks up on your Web-UI if there is a update available.
If there is a update available, we connect to the device over SSH 
and send the command "pihole -up"

.EXAMPLE
Update-Pihole 10.10.10.1

.NOTES
You need the POSH SSH Module.
#>


function Update-Pihole{
    [CmdletBinding()]
    param (
$target, 
$ports=22    #We only need the IP from the pihole we want to check, SSH is the default Port

)

 Write-Host "Test if Pi is awake " -ForegroundColor Blue #Here we test if the pihole is online
$av=Test-Connection $target -Count 2 -Quiet
if ($av -eq $True) {
    Write-Host "Device is online" -ForegroundColor Green
    $site=$target+"/admin" #Here we build the name for our URI in Invoke Webrequest. Default this is the Start page
    
    try{
    $webcall=Invoke-WebRequest $site -ErrorAction Stop
    $sniff=$aufruf.AllElements | where {$_.tagName -eq "DIV" -and $_.class -eq "pull-right hidden-xs hidden-sm"} | Select innerText
    if($sniff.innerText -contains "*Update*" -or "*available*"){
        Write-Host "Updates available" -ForegroundColor Green
        try {
            $creds= Get-Credential 
            
            
                New-SSHSession -ComputerName $target -Credential $creds -Port $ports -AcceptKey -ErrorAction Stop
                Invoke-SSHCommand -SessionId 0 -Command  "pihole -up" -ErrorAction Stop
                } catch [Renci.SshNet.Common.SshAuthenticationException]{
                Write-Host "Authentication failed!" -ForegroundColor Red
                Write-Host "Exit Script" -NoNewline
                for ($i = 0; $i -lt 3 ; $i++) {
            
                    $ciao="." 
                    Write-Host $ciao -NoNewline
                    Start-Sleep -Seconds 2
                    }
                    break
            }

    }}catch [System.Net.WebException]{
        Write-Host "The Webinterface is unavailble, maybe wrong IP?" -ForegroundColor Red
        Write-Host "Exit Script"  -NoNewline
        for ($i = 0; $i -lt 3 ; $i++) {
            
            $ciao="." 
            Write-Host $ciao -NoNewline
            Start-Sleep -Seconds 2
            }
            
        break
    }



    
}else{
        Write-Host "I don't get a Pong! " -ForegroundColor Red

        Write-Host "Exit Script" -NoNewline
        for ($i = 0; $i -lt 3 ; $i++) {
            
            $ciao="." 
            Write-Host $ciao -NoNewline
            Start-Sleep -Seconds 2
        }
        break
    }
     $sniff.innerText

}



 



