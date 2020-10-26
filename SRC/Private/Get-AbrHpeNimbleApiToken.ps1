function Get-AbrHpeNimbleApiToken {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        $Username,
        
        [Parameter(
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [SecureString] $password,

        [Parameter(
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String] $BaseUrl
    )

    Begin { 
    # Set Cert Policy
    add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate,WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    
    # Convert the provided password to plain text, as this is needed in the body sent to the token API URI
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    }

    Process {
        Try {
            # Build a variable with the userame and password to be sent to the Nimble API for authentication
            $data = @{
                username = "$username"
                password = "$UnsecurePassword"
            }
            $Body = convertto-json (@{ data = $data })

            # Set the URI and invoke a post with the username and password as the payload
            $TokenUrl = $BaseUrl + "/tokens"
            $token = Invoke-RestMethod -Uri $TokenUrl -Method Post -Body $Body

            # Store the token in a variable and return it to the caller of this function
            # This token is used in subsequent calls to the API
            $token = $token.data.session_token
            return $token
        } Catch {
            Write-Verbose -Message "An error occurred while processing the API request for $($BaseUrl + $Uri)"
            Write-Verbose -Message $_
        }
    }
    End { }
}