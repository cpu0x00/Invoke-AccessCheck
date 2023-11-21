function CheckSMB
{ # thanks to Rapheal for this trick (linkedin.com/in/rafa-pimentel)

    Write-Host ""
    $comps = Get-ADComputer -Filter *
    $comps.dnshostname | ForEach-Object {
        if (ls "\\$_\C$" -ErrorAction SilentlyContinue){
            Write-Host "[*] Found Access to: $_\C$"
        }
    }  
}

function CheckPSRemoting
{

    [Console]::WriteLine("[+] Checking Access using PSRemoting")
    Write-Host ""
    $comps = Get-ADComputer -Filter *   
    $comps.dnshostname | ForEach-Object {
        if(Invoke-Command -ComputerName "$_"  -ScriptBlock {hostname} -ErrorAction SilentlyContinue){
            Write-Host "[*] Found Access to: $_"
        }
    }       
}


function Invoke-AccessCheck
{
    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory = $false)]
        [switch]
        $SMB,
        
        [Parameter(Position = 1, Mandatory = $false)]
        [switch]
        $PSRemoting
    )

<#
.DESCRIPTION
    uses either SMB or PSRemoting to check access to all machines around the network   

.PARAMETER PSRemoting
    use PSRemoting to check access runs the command "hostname" on machines with Invoke-Command, if a hostname returned means we got access 

.PARAMETER SMB
    use SMB/CIFS to check access, attempts listing the C$ on every machine if an output returns means we got a hit 

.EXAMPLE
    Invoke-AccessCheck -PSRemoting/-SMB     
#>

    
    if (-not ($PSRemoting -or $SMB)) {
        [Console]::WriteLine("[-] use one of [-SMB | -PSRemoting], Example:  Invoke-AccessCheck -PSRemoting")
        return
    }

    [Console]::WriteLine("[+] Checking for Access Around The Network")
    
    if (Get-Module -Name ActiveDirectory -ListAvailable) {
    Write-Host "[+] Active Directory module is already Imported."
    } else {
    [Console]::WriteLine("[+] Didn't Find ActiveDirectory Module,  Pulling and Importing it, this will take a minute...")
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/ADModule/master/Import-ActiveDirectory.ps1');Import-ActiveDirectory
    }



    if ($SMB){
        [Console]::WriteLine("[+] Checking Access using SMB/CIFS")
        CheckSMB
    }

    if ($PSRemoting){
        CheckPSRemoting
    }


}