function Get-AbrHpeNimbleInitiatorGroup {
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
        $URI = "$BaseUri/initiator_groups/detail"
    }

    process {
        try {
            $NimbleInitiatorGroups = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleInitiatorGroups) {
            Paragraph "The following section provides a summary of the Nimble Storage Date and Time Configuration"
            BlankLine
            $NimbleInitiatorGroupSummary = foreach ($InitiatorGroup in $NimbleInitiatorGroups.data) {
                [PSCustomObject] @{
                    "Name" = $InitiatorGroup.name
                    "Access Protocol" = $InitiatorGroup.access_protocol
                    "ID" = $InitiatorGroup.id
                    "# of Connections" = $InitiatorGroup.num_connections
                    "Volume Count" = $InitiatorGroup.volume_count
                    "Volume List" = $InitiatorGroup.volume_list.Name
                    "IQNs" = $InitiatorGroup.iscsi_initiators.iqn
                }
            }
            $NimbleInitiatorGroupSummary | Table -Name "Nimble Initiator Group Information" -List
        }
    }
}