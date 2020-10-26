function Get-AbrHpeNimbleSubnets {
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
        $URI = "$BaseUri/subnets/detail"
    }

    process {
        try {
            $NimbleSubnets = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleSubnets) {
            Paragraph "The following section provides a summary of the Nimble Storage Subnets"
            BlankLine
            $NimbleSubnetSummary = foreach ($Subnet in $NimbleSubnets.data) {
                [PSCustomObject] @{
                    "Subnet Name" = $Subnet.name
                    "Type" = $Subnet.type
                    "VLAN ID" = $Subnet.vlan_id
                    "Network Zone Type" = $Subnet.netzone_type
                    "Network" = $Subnet.network
                    "Network Mask" = $Subnet.netmask
                    "Discovery IP" = $Subnet.discovery_ip
                    "Allow group traffic" = $Subnet.allow_group
                    "Allow iSCSI Traffic" = $Subnet.allow_iscsi
                    "MTU" = $Subnet.mtu
                }
            }
            $NimbleSubnetSummary | Table -Name "Nimble Syslog Information" -List
        }
    }

}