function Get-AbrHpeNimbleInterfaces {
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

        if ($NimbleNetworkConfigs) {
            # Get the Active Network Configuration
            $ActiveNetworkConfig = $NimbleNetworkConfigs.data | Where-Object {$_.name -eq "active"}

            $Arrays = $ActiveNetworkConfig.array_list

            Paragraph "The following section provides a summary of the Nimble Storage Interfaces"
            BlankLine
            $NimbleSubnetSummary = foreach ($Array in $Arrays) {
                foreach ($Interface in $Array.nic_list) {
                    [PSCustomObject] @{
                        "Array" = $Array.name
                        "Interface Name" = $Interface.name
                        "Subnet" = $Interface.subnet_label
                        "IP Address" = $Interface.data_ip
                        "Tagged" = $Interface.tagged
                    }
                }
            }
            $NimbleSubnetSummary | Sort-Object -Property 'Array','Interface Name' | Table -Name "Nimble Interface Information"
        }
    }

}