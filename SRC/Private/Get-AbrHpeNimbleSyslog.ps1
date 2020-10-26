function Get-AbrHpeNimbleSyslog {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Array information from a Pure Storage FlashArray API
    .DESCRIPTION
    .EXAMPLE
    
    .NOTES
        Version:        0.0.1
        Author:         Matt Allford
        Twitter:        @mattallford
        Github:         mattallford
    .LINK
        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String] $BaseUri,

        [Parameter(Mandatory=$true)]
        $Token
    )

    begin {
        $Header = @{ "X-Auth-Token" = $Token }
        $URI = "$BaseUri/groups/detail"
    }

    process {
        try {
            $NimbleSyslog = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleSyslog) {
            Paragraph "The following section provides a summary of the Nimble Storage Users"
            BlankLine
            $NimbleSyslogSummary = [PSCustomObject] @{
                "Syslog Enabled" = $NimbleSyslog.data.syslogd_enabled
                "Syslog Server" = $NimbleSyslog.data.syslogd_server
                "Syslog Port" = $NimbleSyslog.data.syslogd_port 
            }
            $NimbleSyslogSummary | Table -Name "Nimble Syslog Information" -List
        }
    }

}