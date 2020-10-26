function Get-AbrHpeNimbleDiagnostics {
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
        $URI = "$BaseUri/network_configs/detail"
    }

    process {
        try {
            $NimbleNetworkConfigs = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleSubnets) {
            # Get the Active Network Configuration
            $ActiveNetworkConfig = $NimbleNetworkConfigs.data | Where-Object {$_.name -eq "active"}

            $Arrays = $ActiveNetworkConfig.array_list

            Paragraph "The following section provides a summary of the Nimble Storage diagnostics settings"
            BlankLine
            $NimbleDiagnosticsSummary = foreach ($Array in $Arrays) {
                [PSCustomObject] @{
                    "Array Name" = $Array.name
                    "Controller A Support IP" = $Array.ctrlr_a_support_ip
                    "Controller B Support IP" = $Array.ctrlr_b_support_ip
                }
            }
            $NimbleDiagnosticsSummary | Table -Name "Nimble Diagnostics Information"
        }
    }
}