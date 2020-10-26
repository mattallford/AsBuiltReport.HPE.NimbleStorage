function Get-AbrHpeNimbleDisk {
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
        $URI = "$BaseUri/disks/detail"
    }

    process {
        try {
            $NimbleDisks = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleDisks) {
            if ($InfoLevel -le 2) {
                Paragraph "The following section provides a summary of the Nimble Storage Disks"
                BlankLine
                $NimbleDiskSummary = foreach ($Disk in $NimbleDisks.data) {
                    [PSCustomObject] @{
                        "Shelf Location" = $Disk.shelf_location
                        "Slot" = $Disk.slot
                        "Array Name" = $Disk.array_name
                        "Capacity (TB)" = (Convert-Size -From B -To TB -Value $Disk.size)
                        "State" = $Disk.state
                        "Type" = $Disk.type
                        "Firmware" = $Disk.firmware_version
                    }
                }
                $NimbleDiskSummary | Table -Name "Nimble Disk Information"
            }

            if ($InfoLevel -ge 3) {
                Paragraph "The following section provides a summary of the Nimble Storage Disks"
                BlankLine
                $NimbleDiskSummary = foreach ($Disk in $NimbleDisks.data) {
                    [PSCustomObject] @{
                        "Disk ID" = $Disk.id
                        "Shelf Location" = $Disk.shelf_location
                        "Slot" = $Disk.slot
                        "Array Name" = $Disk.array_name
                        "Capacity (TB)" = (Convert-Size -From B -To TB -Value $Disk.size)
                        "State" = $Disk.state
                        "Block Type" = $Disk.block_type
                        "Type" = $Disk.type
                        "Firmware" = $Disk.firmware_version
                        "Vendor" = $Disk.vendor
                        "Model" = $Disk.model
                    }
                }
                $NimbleDiskSummary | Table -Name "Nimble Disk Information" -List
            }



        }
    }
}