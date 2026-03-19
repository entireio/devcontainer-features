# Entire Dev Container Features

Dev container features for the [Entire](https://entire.io) development platform.

## Features

### `entire-cli`

Install the Entire CLI for AI-assisted development workflows.

#### Usage

Add to your `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/entireio/devcontainer-features/entire-cli:1": {}
  }
}
```

#### Options

| Option    | Type   | Default    | Description                          |
|-----------|--------|------------|--------------------------------------|
| `version` | string | `latest`   | Version to install (e.g., `0.5.0`)  |

#### Pin to a specific version

```json
{
  "features": {
    "ghcr.io/entireio/devcontainer-features/entire-cli:1": {
      "version": "0.5.0"
    }
  }
}
```
