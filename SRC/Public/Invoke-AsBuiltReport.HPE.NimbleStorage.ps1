function Invoke-AsBuiltReport.HPE.NimbleStorage {
    <#
    .SYNOPSIS
        PowerShell script which documents the configuration of HPE Nimble Storage Arrays in Word/HTML/XML/Text formats
    .DESCRIPTION
        Documents the configuration of HPE Nimble Storage Arrays in Word/HTML/XML/Text formats using PScribo.
    .NOTES
        Version:        0.1
        Author:         Matt Allford
        Twitter:        @mattallford
        Github:         https://github.com/mattallford
        Credits:        Iain Brighton (@iainbrighton) - PScribo module

    .LINK
        https://github.com/AsBuiltReport/
    #>

    #region Script Parameters
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string[]] $Target,

        [Parameter(Mandatory=$true)]
        [pscredential] $Credential,

        [Parameter(Mandatory=$false)]
        [string] $StylePath
    )

    # If custom style not set, use default style
    if (!$StylePath) {
        & "$PSScriptRoot\..\..\AsBuiltReport.HPE.NimbleStorage.Style.ps1"
    }

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    $Script:Array = $Null
    foreach ($NimbleGroup in $Target) {
        Try {
            # Setup the base URL to access the Nimble Group API
            if ($Options.NimbleGroupPort) {
                $NimbleBaseUrl = "https://" + $NimbleGroup + ":" + ($Options.NimbleGroupPort) + "/v1"
            } else {
                $NimbleBaseUrl = "https://" + $NimbleGroup + ":5392/v1"
            }

            # Use the provided credentials to get a token to be used in subsequent API calls to the Nimble Group
            $HpeNimbleApiToken = Get-AbrHpeNimbleApiToken -BaseUrl $NimbleBaseUrl -username $Credential.Username -password $Credential.Password
            
        } Catch {
            Write-Verbose "Unable to connect to the Nimble Storage Group API at $NimbleGroup"
        }
    
        if ($HpeNimbleApiToken) {
            Write-Verbose "Connected to Nimble Storage Group API at $NimbleGroup"

            if ($NimbleArrays = Get-AbrHpeNimbleArray -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                Section -Style Heading2 'Array Summary' {
                    $NimbleArrays
                }
            }

            if ($NimbleVolumes = Get-AbrHpeNimbleVolume -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                Section -Style Heading2 'Volume Summary' {
                    $NimbleVolumes
                }
            }

            Section -Style Heading2 'Hardware' {
                if ($NimbleDisks = Get-AbrHpeNimbleDisk -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken -InfoLevel $InfoLevel.Disks) {
                    Section -Style Heading3 'Disk Summary' {
                        $NimbleDisks
                    }   
                }

                if ($NimbleNics = Get-AbrHpeNimbleNic -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken -InfoLevel $InfoLevel.Nics) {
                    Section -Style Heading3 'NIC Summary' {
                        $NimbleNics
                    }
                }
            }

            Section -Style Heading2 'Security' {

                if ($NimbleAD = Get-AbrHpeNimbleActiveDirectory -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'Active Directory Summary' {
                        $NimbleAD
                    }
                }

                if ($NimbleUserGroups = Get-AbrHpeNimbleUserGroup -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'User Group Summary' {
                        $NimbleUserGroups
                    }
                }

                if ($NimbleUsers = Get-AbrHpeNimbleUser -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'User Summary' {
                        $NimbleUsers
                    }
                }
            }      

            Section -Style Heading2 'Data Access' {
                if ($NimbleInitiatorGroups = Get-AbrHpeNimbleInitiatorGroup -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'Initiator Group Summary' {
                        $NimbleInitiatorGroups
                    }
                }

                #if ($NimbleChapAccounts = Get-AbrHpeNimbleChapAccount -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                #    Section -Style Heading3 'CHAP Summary' {
                #        $NimbleChapAccounts
                #    }
                #}
            }

            Section -Style Heading2 'Alerts and Monitoring' {
                if ($NimbleEmail = Get-AbrHpeNimbleEmail -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'Email Summary' {
                        $NimbleEmail
                    }
                }

                if ($NimbleSnmp = Get-AbrHpeNimbleSnmp -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'SNMP Summary' {
                        $NimbleSnmp
                    }
                }

                if ($NimbleSyslog = Get-AbrHpeNimbleSyslog -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'Syslog Summary' {
                        $NimbleSyslog
                    }
                }

            }

            Section -Style Heading2 'Network Configuration' {

                if ($NimbleSubnets = Get-AbrHpeNimbleSubnets -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'Subnets' {
                        $NimbleSubnets
                    }
                }

                if ($NimbleInterfaces = Get-AbrHpeNimbleInterfaces -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'Interfaces' {
                        $NimbleInterfaces
                    }
                }

                if ($NimbleDiagnostics = Get-AbrHpeNimbleDiagnostics -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'Diagnostics' {
                        $NimbleDiagnostics
                    }
                }

                if ($NimbleDns = Get-AbrHpeNimbleDns -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'DNS Summary' {
                        $NimbleDns
                    }
                }
            }

            Section -Style Heading2 'Date and Timezone' {
                if ($NimbleTime = Get-AbrHpeNimbleTime -BaseUri $NimbleBaseUrl -Token $HpeNimbleApiToken) {
                    Section -Style Heading3 'Date and Timezone Summary' {
                        $NimbleTime
                    }
                }
            }

        }#End if ($ConnectedNimbleGroup)
    }#End Foreach ($NimbleGroup in $Target)
}#End Function Invoke-AsBuiltReport.HPE.NimbleStorage
