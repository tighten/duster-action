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
      - uses: actions/checkout@v3
      - name: "duster"
        uses: tighten/duster-action@v1
        with:
          args: --lint
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
      - uses: actions/checkout@v3
      - name: "duster"
        uses: tighten/duster-action@v1
        with:
          args: --lint --using=tlint,pint
```

If you would like to automatically commit any required fixes you can add the [Git Auto Commit Action](https://github.com/marketplace/actions/git-auto-commit) by [Stefan Zweifel](https://github.com/stefanzweifel).

```yml
# .github/workflows/duster.yml
name: Duster

on: pull_request

jobs:
  duster:
    runs-on: ubuntu-latest

    permissions:
      contents: write

    steps:
      - uses: actions/checkout@v3
        with:
          ref: ${{ github.head_ref }}

      - name: "duster"
        uses: tighten/duster-action@v1
        with:
          args: --fix

      - uses: stefanzweifel/git-auto-commit-action@v4
        with:
          commit_message: Dusting
          commit_user_name: GitHub Action
          commit_user_email: actions@github.com
```

Be sure to check out the [action's documentation](https://github.com/marketplace/actions/git-auto-commit) for limitations and options.
