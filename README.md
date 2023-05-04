# GitHub organization support files

## Community health

Defaults for all repos.

- [Code of conduct](CODE_OF_CONDUCT.md)
- [Contributing guidelines](CONTRIBUTING.md)
- [How to get support](SUPPORT.md)

See also GitHub's [documentation on community health files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file).


## Issue and PR templates

Defaults for all repos.

- [Bug report template](.github/ISSUE_TEMPLATE/bug_report.md)
- [Documentation issue template](.github/ISSUE_TEMPLATE/documentation-issue.md)
- [Feature request template](.github/ISSUE_TEMPLATE/feature_request.md)
- [New issue config](.github/ISSUE_TEMPLATE/config.yml)

- [Pull request template](.github/pull_request_template.md)

See also GitHub's [documentation on issue and PR templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/about-issue-and-pull-request-templates).


## Actions

Invoked by our GitHub Actions workflows, including the reusable workflows below.

- [Setup Nextstrain CLI](actions/setup-nextstrain-cli/action.yaml)
- [shellcheck](actions/shellcheck/action.yaml)
- [Setup SSH](actions/setup-ssh/action.yaml) access to runner machine
  ([README](actions/setup-ssh/README.md))
- [Setup debugger](actions/setup-debugger/action.yaml) for interactive debugging of workflow jobs
  ([README](actions/setup-debugger/README.md))
- [Run Nextstrain build on AWS Batch](actions/run-nextstrain-build-on-aws-batch/action.yaml)

See also GitHub's [documentation on creating custom actions](https://docs.github.com/en/actions/creating-actions/about-custom-actions).


## Reusable workflows

Invoked by other repos.

- CI for pathogen repos
  ([workflow](.github/workflows/pathogen-repo-ci.yaml))

- CI for docs
  ([workflow](.github/workflows/docs-ci.yaml))

- Sync RTD redirects
  ([workflow](.github/workflows/sync-rtd-redirects.yaml))

See also GitHub's [documentation on reusing workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows).


## Workflow templates

_aka "starter" workflows_

Used to setup other repos.

- CI for pathogen repos
  ([template](workflow-templates/pathogen-repo-ci.yaml),
  [properties](workflow-templates/pathogen-repo-ci.properties.json))

- CI for docs
  ([template](workflow-templates/docs-ci.yaml),
  [properties](workflow-templates/docs-ci.properties.json))

- Sync RTD redirects
  ([template](workflow-templates/sync-rtd-redirects.yaml),
  [properties](workflow-templates/sync-rtd-redirects.properties.json))

- shellcheck
  ([template](workflow-templates/shellcheck.yaml),
  [properties](workflow-templates/shellcheck.properties.json))

- Debugging runner: Launch a runner for ad-hoc interactive debugging over SSH using `setup-ssh` above.
  Only for use in private repositories!
  ([template](workflow-templates/debugging-runner.yaml),
  [properties](workflow-templates/debugging-runner.properties.json))

- Run Nextstrain build on AWS Batch
  ([template](workflow-templates/run-nextstrain-build-on-aws-batch.yaml),
  [properties](workflow-templates/run-nextstrain-build-on-aws-batch.properties.json))

See also GitHub's [documentation on starter workflows](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization).


## Workflows for this repo itself

- CI tests for the actions and reusable workflows above
  ([workflow](.github/workflows/ci.yaml))
