function Get-AbrHpeNimbleUser {
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
        $URI = "$BaseUri/users/detail"
    }

    process {
        try {
            $NimbleUsers = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleUsers) {
            Paragraph "The following section provides a summary of the Nimble Storage Users"
            BlankLine
            $UserSummary = foreach ($User in $NimbleUsers.data) {
                [PSCustomObject] @{
                "Name" = $User.name
                "Full Name" = $User.full_name
                "Description" = $User.description
                "Email Address" = $User.email_addr
                "Role" = $User.role
                "ID" = $User.id
                "Disabled" = $User.disabled
                "Inactivity Timeout (seconds)" = $User.inactivity_timeout
                }
            }
            $UserSummary | Sort-Object -Property "Name" | Table -Name "Nimble User Information" -List
        }
    }

}