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

### Example

```yaml
<...>
  - name: Action-Test
    id: Action-Test
    uses: ./
    with:
      ClientID: ${{ secrets.CLIENT_ID }}
      PrivateKey: ${{ secrets.PRIVATE_KEY }}
```

## Links

- [Generating a JSON Web Token (JWT) for a GitHub App | GitHub Docs](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-a-json-web-token-jwt-for-a-github-app)
