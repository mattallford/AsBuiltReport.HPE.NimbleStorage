function Get-AbrHpeNimbleArray {
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
        $URI = "$BaseUri/arrays/detail"
    }

    process {
        try {
            $NimbleArrays = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleArrays) {
            Paragraph "The following section provides a summary of the Nimble Storage Arrays"
            BlankLine
            $ArraySummary = foreach ($Array in $NimbleArrays.data) {
                [PSCustomObject] @{
                "Array Name" = $Array.full_name
                "Model" = $Array.extended_model
                "Serial Number" = $Array.serial
                "All Flash Array" = $Array.all_flash
                "NimbleOS Version" = $Array.version
                "Raw Capacity (TB)" = (Convert-Size -From B -To TB -Value $Array.raw_capacity_bytes)
                "Usable Capacity (TB)" = (Convert-Size -From B -To TB -Value $Array.usable_capacity_bytes)
                }
            }
            $ArraySummary | Table -Name "Nimble Array Information" -List
        }
    }

}