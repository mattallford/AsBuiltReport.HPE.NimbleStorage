function Get-AbrHpeNimbleDns {
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
            $NimbleDns = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleDns) {
            Paragraph "The following section provides a summary of the Nimble Storage Users"
            BlankLine
            $NimbleDnsSummary = [PSCustomObject] @{
                "Domain Name" = $NimbleDns.data.domain_name
                "DNS Servers" = $NimbleDns.data.dns_Servers.ip_addr
            }
            $NimbleDnsSummary | Table -Name "Nimble Syslog Information" -List
        }
    }

}