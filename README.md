![Project Banner](https://raw.githubusercontent.com/tighten/duster/main/banner.png)
# GitHub Action for Tighten Duster

> [!WARNING]
> **This action is deprecated and will no longer be maintained.**
> It always installs the newest Duster release in its major version, so CI ignores your `composer.lock` and can report different results than running Duster locally. It also cannot run custom scripts from `duster.json`.
>
> Install your project's dependencies and run Duster from `vendor/bin` instead, so CI uses the version locked in `composer.lock`. Starting with the next Duster release after v3.4.7, `./vendor/bin/duster github-actions` publishes this workflow for you.

```yml
# .github/workflows/duster-lint.yml
name: Duster Lint

on:
    push:
        branches: [ main ]
    pull_request:

jobs:
  duster:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v7
        with:
          ref: ${{ github.event.pull_request.head.ref }}
          repository: ${{ github.event.pull_request.head.repo.full_name }}

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.5'
          tools: composer:v2
          coverage: none

      - name: Install dependencies
        run: composer install --no-interaction --prefer-dist --no-progress

      - name: Duster Lint
        run: ./vendor/bin/duster lint
```

Set `php-version` to the version your project uses, and add any auth steps your private Composer packages need before `composer install`.

The rest of this README documents the deprecated action.

---

GitHub Action for the [Tighten Duster](https://github.com/tighten/duster) package.

If your project requires PHP 8.1 use `tighten/duster-action@v3` which pulls in Duster `2.x`.
If your project requires PHP 8.0 use `tighten/duster-action@v1` which pulls in Duster `1.x`.

This action will not be able to find any additional scripts configured (`duster.json`) to run with Duster. You will have to install your dependencies and run Duster from there instead of using this action.

> [!NOTE]
> This action will **always** use the latest version of Duster.
> If you run into situation where Duster passes locally but the action fails you should first try updating Duster locally.

## Usage

Use with [GitHub Actions](https://github.com/features/actions)

```yml
# .github/workflows/duster.yml
name: Duster

on:
    push:
        branches: main
    pull_request:

jobs:
  duster:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
      - name: "duster"
        uses: tighten/duster-action@v3
        with:
          args: lint
```

---

To use additional Duster options use `args`:

```yml
# .github/workflows/duster.yml
name: Duster

on:
    push:
        branches: main
    pull_request:

jobs:
  duster:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
      - name: "duster"
        uses: tighten/duster-action@v3
        with:
          args: lint --using=tlint,pint
```

---

If you would like to automatically commit any required fixes you can add the [Git Auto Commit Action](https://github.com/marketplace/actions/git-auto-commit) by [Stefan Zweifel](https://github.com/stefanzweifel).

```yml
# .github/workflows/duster.yml
name: Duster Fix

on:
    push:
        branches: main
    pull_request:

jobs:
  duster:
    runs-on: ubuntu-latest

    permissions:
      contents: write

    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.head_ref }}

      - name: "duster"
        uses: tighten/duster-action@v3
        with:
          args: fix

      - uses: stefanzweifel/git-auto-commit-action@v4
        with:
          commit_message: Dusting
          commit_user_name: GitHub Action
          commit_user_email: actions@github.com
```

>**Note** The resulting commit **will not trigger** another GitHub Actions Workflow run.
>This is due to [limitations set by GitHub](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#using-the-github_token-in-a-workflow).

To get around this you can indicate a workflow should run after "Duster Fix" using the `workflow_run` option.

```yml
on:
    workflow_run:
        workflows: ["Duster Fix"]
        types:
          - completed
```

The name "Duster Fix" must match the name defined in your Duster workflow and [must be on the default branch](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_run).

Be sure to check out the [action's documentation](https://github.com/marketplace/actions/git-auto-commit) for limitations and options.

---

To automatically ignore these commits from GitHub's git blame you can add the commit's hash to a `.git-blame-ignore-revs` file.

```yml
# .github/workflows/duster.yml
name: Duster Fix

on:
    push:
        branches: main
    pull_request:

jobs:
  duster:
    runs-on: ubuntu-latest

    permissions:
      contents: write

    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.head_ref }}

      - name: "Duster Fix"
        uses: tighten/duster-action@v3
        with:
          args: fix

      - uses: stefanzweifel/git-auto-commit-action@v4
        id: auto_commit_action
        with:
          commit_message: Dusting
          commit_user_name: GitHub Action
          commit_user_email: actions@github.com

      - name: Ignore Duster commit in git blame
        if: steps.auto_commit_action.outputs.changes_detected == 'true'
        run: echo ${{ steps.auto_commit_action.outputs.commit_hash }} >> .git-blame-ignore-revs

      - uses: stefanzweifel/git-auto-commit-action@v4
        with:
          commit_message: Ignore Dusting commit in git blame
          commit_user_name: GitHub Action
          commit_user_email: actions@github.com
```
