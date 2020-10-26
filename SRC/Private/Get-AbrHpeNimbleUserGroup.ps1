function Get-AbrHpeNimbleUserGroup {
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
        $URI = "$BaseUri/user_groups/detail"
    }

    process {
        try {
            $NimbleUserGroups = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleUserGroups) {
            Paragraph "The following section provides a summary of the Nimble Storage User Groups"
            BlankLine
            $UserGroupSummary = foreach ($UserGroup in $NimbleUserGroups.data) {
                [PSCustomObject] @{
                "Group Name" = $UserGroup.name
                "Description" = $UserGroup.description
                "Domain Name" = $UserGroup.domain_name
                "Role" = $UserGroup.role
                "ID" = $UserGroup.id
                "Disabled" = $UserGroup.disabled
                "Inactivity Timeout (seconds)" = $UserGroup.inactivity_timeout
                }
            }
            $UserGroupSummary | Sort-Object -Property "Group Name" | Table -Name "Nimble User Group Information" -List
        }
    }

}