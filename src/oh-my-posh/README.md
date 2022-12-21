
# oh-my-posh (oh-my-posh)

Installs oh-my-posh

## Example Usage

```json
"features": {
    "ghcr.io/rickardgranberg/devcontainer-features/oh-my-posh:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | The oh-my-posh version to use | string | latest |
| themeUrl | URL of theme to use | string | https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json |

## Themes

You can browse all available themes [here](https://ohmyposh.dev/docs/themes)

### How to get the Theme URL

1. Once you've settled on a theme, click it's link to go to github.
1. Click on the **Raw** button and copy the link. 
1. Use the link as the value for `themeUrl` when configuring the feature:

```json
"features": {
    "ghcr.io/rickardgranberg/devcontainer-features/oh-my-posh": {
	    "themeUrl": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_modern.omp.json"
	}
}
```


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/rickardgranberg/devcontainer-features/blob/main/src/oh-my-posh/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
