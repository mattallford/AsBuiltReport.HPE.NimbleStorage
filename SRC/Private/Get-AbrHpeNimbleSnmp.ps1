function Get-AbrHpeNimbleSnmp {
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
            $NimbleSnmp = Invoke-RestMethod -Method Get -Uri $URI -Headers $Header
        } catch {

        }

        if ($NimbleSnmp) {
            Paragraph "The following section provides a summary of the Nimble Storage Users"
            BlankLine
            $NimbleSnmpSummary = [PSCustomObject] @{
                "SNMP Get Enabled" = $NimbleSnmp.data.snmp_get_enabled
                "Community String" = $NimbleSnmp.data.snmp_community
                "SNMP Get Port" = $NimbleSnmp.data.snmp_get_port
                "System Contact" = $NimbleSnmp.data.snmp_sys_contact
                "System Location" = $NimbleSnmp.data.snmp_sys_location
                "SNMP Trap Enabled" = $NimbleSnmp.data.snmp_trap_enabled
                "Trap Host" = $NimbleSnmp.data.snmp_trap_host
                "Trap Port" = $NimbleSnmp.data.snmp_trap_port
            }
            $NimbleSnmpSummary | Table -Name "Nimble SNMP Information" -List
        }
    }
}