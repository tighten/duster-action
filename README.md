![Project Banner](https://raw.githubusercontent.com/tighten/duster/main/banner.png)
# GitHub Action for Tighten Duster

GitHub Action for the [Tighten Duster](https://github.com/tighten/duster) package.

## Usage

Use with [GitHub Actions](https://github.com/features/actions)

```yml
# .github/workflows/duster.yml
name: Duster
on: pull_request
jobs:
  duster:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: "duster"
        uses: tighten/duster-action@v1
```

To use additional Duster options use `args`:

```yml
# .github/workflows/duster.yml
name: Duster
on: pull_request
jobs:
  duster:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: "duster"
        uses: tighten/duster-action@v1
        with:
          args: --using=tlint,pint
```
