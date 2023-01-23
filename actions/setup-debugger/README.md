# setup-debugger

Interactive debugger for GitHub Actions workflow jobs.  Intercepts job steps to
let you inspect and manipulate them interactively before they run.

Available commands inside the debugger:

    pid                  show process id
    exe                  show process exe
    args                 show process args
    argv                 show process argv
    argv0                show process argv[0]
    env[iron]            show process environment
    env[iron] <str>      show process environment containing <str>
    env[iron] <k>=<v>    set process environment var <k> to <v> in script

    script               show script to be executed
    edit                 edit script to be executed in $EDITOR

    w[rite] <fd> <data>  write <data> to process file descriptor <fd>

    c[ontinue]           resume process execution and wait for next exec
    q[uit]               resume process execution and exit debugger

    help                 show this help

Currently only supports interception of `bash` script steps, i.e. steps with a
[`run:` key][] using the `bash` shell via the [step's `shell:` key][] or the
[job's `shell:` key][].  When `shell:` is left unspecified, it also defaults to
`bash` (on Linux).

Support for other shells and step types could be added.

[`run:` key]: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsrun
[step's `shell:` key]: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsshell
[job's `shell:` key]: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_iddefaultsrun

## Inputs

### `tailscale-auth-key`

**Required.**  String.  Tailscale auth key (i.e. from the admin panel); **highly
recommended to be ephemeral!**  Otherwise, a runner will stick around as a
registered machine and your Tailscale account's limit will be quickly reached.
Used in an automated context, it should also be **reusable**, else you'll only
get one use out of it before needing to update the secret.

Passed to our [setup-ssh action](../setup-ssh/).

## Examples

You might use this action as the first step of a job, running only if the job
is being manually [re-run][] under [debug mode][]:

```yaml
- if: github.run_attempt > 1 && runner.debug == 1
  uses: nextstrain/.github/actions/setup-debugger@master
  with:
    tailscale-auth-key: ${{ secrets.TAILSCALE_AUTH_KEY }}
```

This would let you manually re-run a job that failed and have job execution
pause at the setup-debugger step.  Then, you'd login via SSH:

    ssh runner@100.x.y.z

and start the debugger:

    ./debugger

The debugger will resume execution of the job but intercept subsequent job
steps before they run, letting you inspect and manipulate them interactively in
the debugger.

If you need to drop out of the debugger to run some other commands, you can
suspend it with Ctrl-Z, do what you need to do in the shell, and then re-enter
with `fg`.

[re-run]: https://docs.github.com/en/actions/managing-workflow-runs/re-running-workflows-and-jobs
[debug mode]: https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging

## How it works

TKTK
