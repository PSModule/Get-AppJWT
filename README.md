# Get-AppJWT

This action gets a JWT token for a GitHub Application.

## Usage

### Inputs

| Input | Required | Description |
| ----- | -------- | ----------- |
| `ClientID` | Yes | The Client ID of the GitHub App |
| `PrivateKey` | Yes | The Private Key of the GitHub App |

### Outputs

| Output | Description |
| ------ | ----------- |
| `JWT` | The JWT for the GitHub App |

### Example: Using the JWT to access the GitHub API

```yaml
<...>
  - name: Get-AppJWT
    id: Get-AppJWT
    uses: PSModule/Get-AppJWT@v1
    with:
      ClientID: ${{ secrets.CLIENT_ID }}
      PrivateKey: ${{ secrets.PRIVATE_KEY }}

  - name: Get app info
    shell: pwsh
    env:
      JWT: ${{ steps.Get-AppJWT.outputs.JWT }}
    run: |
      # Access the GitHub /app endpoint using the JWT as bearer token
      Invoke-RestMethod -Uri "$env:GITHUB_API_URL/app" -Method Get -Headers @{
          Authorization = "Bearer $env:JWT"
      }
```

## Links

- [Generating a JSON Web Token (JWT) for a GitHub App | GitHub Docs](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-a-json-web-token-jwt-for-a-github-app)
