[CmdletBinding()]
param ()

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
                iss = $env:PSMODULE_GET_APPJWT_INPUT_ClientID
            }
        )
    )
).TrimEnd('=').Replace('+', '-').Replace('/', '_')

$rsa = [System.Security.Cryptography.RSA]::Create()
$rsa.ImportFromPem($env:PSMODULE_GET_APPJWT_INPUT_PrivateKey)

$signature = [Convert]::ToBase64String(
    $rsa.SignData(
        [System.Text.Encoding]::UTF8.GetBytes("$header.$payload"),
        [System.Security.Cryptography.HashAlgorithmName]::SHA256,
        [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
    )
).TrimEnd('=').Replace('+', '-').Replace('/', '_')

$jwt = "$header.$payload.$signature"
Write-Output "::add-mask::$jwt"
"JWT=$jwt" | Out-File -FilePath $env:GITHUB_OUTPUT -Append
