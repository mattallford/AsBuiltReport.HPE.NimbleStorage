function Get-AbrHpeNimbleNic {
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
        $Token,

        [Parameter(Mandatory=$true)]
        $InfoLevel
    )

    begin {
        $Header = @{ "X-Auth-Token" = $Token }
        $URI = "$BaseUri/network_interfaces/detail"
    }

    process {
        try {
            $NimbleNics = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleNics) {
            if ($InfoLevel -le 2) {
                Paragraph "The following section provides a summary of the Nimble Storage Nics"
                BlankLine
                $NimbleNicSummary = foreach ($Nic in $NimbleNics.data) {
                    [PSCustomObject] @{
                        "Array Name" = $Nic.array_name_or_serial
                        "Array Controller" = $Nic.controller_name
                        "Nic Name" = $Nic.name
                        "Slot / Port" = "$($Nic.slot) / $($Nic.port)"
                        "Link Status" = $Nic.link_status
                    }
                }
                $NimbleNicSummary | sort-object "Array Name" | Table -Name "Nimble Nic Information"
            }

            if ($InfoLevel -ge 3) {
                Paragraph "The following section provides a summary of the Nimble Storage Nics"
                BlankLine
                $NimbleNicSummary = foreach ($Nic in $NimbleNics.data) {
                    [PSCustomObject] @{
                        "Array Name" = $Nic.array_name_or_serial
                        "Array Controller" = $Nic.controller_name
                        "Nic Name" = $Nic.name
                        "Slot / Port" = "$($Nic.slot) / $($Nic.port)"
                        "Link Status" = $Nic.link_status
                        "Link Speed" = $Nic.link_speed
                        "Max Link Speed" = $Nic.max_link_speed
                        "MAC Address" = $Nic.mac
                        "MTU" = $Nic.mtu
                        "NIC Type" = $Nic.nic_type
                    }
                }
                $NimbleNicSummary | sort-object "Array Name","Array Controller","Nic Name" | Table -Name "Nimble Nic Information" -List
            }



        }
    }
}