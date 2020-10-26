function Get-AbrHpeNimbleTime {
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
            $NimbleTime = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleTime) {
            Paragraph "The following section provides a summary of the Nimble Storage Date and Time Configuration"
            BlankLine
            $NimbleTimeSummary = [PSCustomObject] @{
                "NTP Server" = $NimbleTime.data.ntp_server
                "Timezone" = $NimbleTime.data.timezone
            }
            $NimbleTimeSummary | Table -Name "Nimble Time Information" -List
        }
    }
}