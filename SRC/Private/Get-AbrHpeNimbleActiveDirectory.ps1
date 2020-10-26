function Get-AbrHpeNimbleActiveDirectory {
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
        $URI = "$BaseUri/active_directory_memberships/detail"
    }

    process {
        try {
            $NimbleAD = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleAD) {
            Paragraph "The following section provides a summary of the Nimble Storage Active Directory Configuration"
            BlankLine
            $NimbleADSummary = [PSCustomObject] @{
                "Computer Name" = $NimbleAD.data.computer_name
                "Description" = $NimbleAD.data.Description
                "Active Directory Name" = $NimbleAD.data.name
                "Netbios Name" = $NimbleAD.data.netbios
                "Organizational Unit" = $NimbleAD.data.organizational_unit
                "Enabled" = $NimbleAD.data.enabled
            }
            $NimbleADSummary | Table -Name "Nimble Active Directory Information" -List
        }
    }

}