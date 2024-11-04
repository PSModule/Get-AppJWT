[CmdletBinding()]
param (
    [Parameter()]
    [string] $ClientID = $env:GITHUB_ACTION_INPUT_ClientID,

    [Parameter()]
    [string] $PrivateKey = $env:GITHUB_ACTION_INPUT_PrivateKey
)

$header = [Convert]::ToBase64String(
    [System.Text.Encoding]::UTF8.GetBytes(
        (
            ConvertTo-Json -InputObject @{
                alg = 'RS256'
                typ = 'JWT'
            }
        )
    )
).TrimEnd('=').Replace('+', '-').Replace('/', '_')

$payload = [Convert]::ToBase64String(
    [System.Text.Encoding]::UTF8.GetBytes(
        (
            ConvertTo-Json -InputObject @{
                iat = [System.DateTimeOffset]::UtcNow.AddSeconds(-10).ToUnixTimeSeconds()
                exp = [System.DateTimeOffset]::UtcNow.AddMinutes(10).ToUnixTimeSeconds()
                iss = $ClientID
            }
        )
    )
).TrimEnd('=').Replace('+', '-').Replace('/', '_')

$rsa = [System.Security.Cryptography.RSA]::Create()
$rsa.ImportFromPem($PrivateKey)

$signature = [Convert]::ToBase64String(
    $rsa.SignData(
        [System.Text.Encoding]::UTF8.GetBytes("$header.$payload"),
        [System.Security.Cryptography.HashAlgorithmName]::SHA256,
        [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
    )
).TrimEnd('=').Replace('+', '-').Replace('/', '_')

$jwt = "$header.$payload.$signature"
# Write-Host "::add-mask::$jwt"
"JWT=$jwt" | Out-File -FilePath $env:GITHUB_OUTPUT -Append
