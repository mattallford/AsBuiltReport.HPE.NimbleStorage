function Get-AbrHpeNimbleEmail {
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
        $URI = "$BaseUri/groups/detail"
    }

    process {
        try {
            $NimbleEmail = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleEmail) {
            Paragraph "The following section provides a summary of the Nimble Storage Users"
            BlankLine
            $NimbleEmailSummary = [PSCustomObject] @{
                "SMTP Sender Address" = $NimbleEmail.data.alert_from_email_addr
                "SMTP Receipient Address(es)" = $NimbleEmail.data.alert_to_email_addrs
                "SMTP Server" = $NimbleEmail.data.smtp_server
                "SMTP Port" = $NimbleEmail.data.smtp_port
                "SMTP Encryption" = $NimbleEmail.data.smtp_encrypt_type
                "SMTP Auth Enabled" = $NimbleEmail.data.smtp_auth_enabled
                "SMTP Auth Username" = $NimbleEmail.data.smtp_auth_username
                "Send Data to Nimble Support" = $NimbleEmail.data.send_alert_to_support
            }
            $NimbleEmailSummary | Table -Name "Nimble Email Information" -List
        }
    }

}