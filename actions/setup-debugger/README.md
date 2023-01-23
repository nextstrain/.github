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

When `debugger` starts, it starts [bpftrace][] in the background to register
[eBPF](https://ebpf.io) probes on the [`execve()`][] and [`execveat()`][]
system calls.  Notably, the [`exec*()` family][] of libc functions are wrappers
for `execve()`, as is [`system()`][], so virtually all new processes will go
thru the two probed functions.  The probes are filtered down to calls made by
the GitHub Actions runner user (`runner`) and the process/thread name used by
the runner agent (`.NET ThreadPool`).

When a process triggers a probe, the probe immediately pauses the process with
`SIGSTOP` and emits an output line containing the process pid, command, and
to-be-`exec()`-ed filename.  This line is read by the debugger and more
information about the process is gathered from the [`/proc` filesystem][].

The debugger uses that information to decide if it looks like the execution of
a GitHub Actions `run:` script.  If it decides yes, then it starts an
interactive debugging session so you can inspect the process state.  If it
decides no, it resumes the process with `SIGCONT` and waits for another
process.

[`execve()`]: https://man7.org/linux/man-pages/man2/execve.2.html
[`execveat()`]: https://man7.org/linux/man-pages/man2/execveat.2.html
[`exec*()` family]: https://man7.org/linux/man-pages/man3/exec.3.html
[`system()`]: https://man7.org/linux/man-pages/man3/system.3.html
[`/proc` filesystem]: https://www.kernel.org/doc/html/latest/filesystems/proc.html

### Alternatives

Other ways to accomplish similar or additional functionality, which might be of
use in the future.

### Wrap the shell executable

Instead of using eBPF to intercept exec calls, we could replace the shell
executable (e.g. `/bin/bash`) with our own wrapper.  The wrapper would decide
whether to intercept the invocation or not, and if so, attach to the debugger
over a socket to send information and receive interactive commands.  When the
debugger detaches (or if it was never attached), the wrapper proceeds with
normal execution by exec-ing into the real shell executable with the same
arguments.

This worked well in my prototypes and has a distinct advantage of being
in-process and more able to make internal changes (e.g. manipulating the
environment more directly or opening/closing fds).  However, it is a little
more complex because of the server/client split and socket handling.  It also
requires more setup, as the shell executables have to be appropriately replaced
on disk.  Still, it may ultimately be a more robust approach.

### Hook into existing shell debuggers

In addition to (or possibly even instead of) intercepting exec calls, we could
arrange for shell-specific debuggers to be invoked upon `run:` script start.
For example, Bash has its `--debugger` mode which can be used
with the very nice [bashdb][] or our own custom debugger, Node has `node
inspect`, etc.  This would complement the existing debugger, in that it
would provide stepping thru the script itself rather than only treating it as a
whole.

We can likely use the `BASH_ENV` variable to auto-load the debugger into a
script.

[bashdb]: https://bashdb.sourceforge.net
