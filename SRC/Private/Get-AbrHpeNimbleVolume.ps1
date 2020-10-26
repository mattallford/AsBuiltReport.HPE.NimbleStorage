function Get-AbrHpeNimbleVolume {
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
        $URI = "$BaseUri/volumes/detail"
    }

    process {
        try {
            $NimbleVolumes = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleVolumes) {
            Paragraph "The following section provides a summary of the Nimble Storage Volumes"
            BlankLine
            $VolumeSummary = foreach ($Volume in $NimbleVolumes.data) {
                [PSCustomObject] @{
                "Volume Name" = $Volume.name
                "Nimble Pool" = $Volume.pool_name
                "Volume Description" = $Volume.description
                "Serial Number" = $volume.serial_number
                "Size (TB)" = (Convert-Size -From MB -To TB -Value $Volume.size)
                }
            }
            $VolumeSummary | Table -Name "Nimble Volume Information" -List
        }
    }

}