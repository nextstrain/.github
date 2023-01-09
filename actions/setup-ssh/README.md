# setup-ssh

Sets up SSH access to the current runner machine over a Tailscale network.

The public SSH keys associated with GitHub users are used for authentication
and authorization.  By default, the users who triggered the initial and current
workflow runs (which may be different in a re-run) are allowed access.

Tailscale is used to provide direct network access to the runner machine since
it is behind a NAT and otherwise unreachable.

Note that this does _not_ use [Tailscale
SSH](https://tailscale.com/kb/1193/tailscale-ssh/), a feature specific to
Tailscale, but the standard SSH server (e.g. OpenSSH) that already exists on
the runner machine.  If Tailscale SSH is enabled for your tailnet, then you'll
need to use [Tailscale ACLs](https://tailscale.com/kb/1018/acls/#tailscale-ssh)
to manage authentication and authorization instead of SSH keys.

## Inputs

### `tailscale-auth-key`

**Required.**  String.  Tailscale auth key (i.e. from the admin panel); **highly
recommended to be ephemeral!**  Otherwise, a runner will stick around as a
registered machine and your Tailscale account's limit will be quickly reached.
Used in an automated context, it should also be **reusable**, else you'll only
get one use out of it before needing to update the secret.

### `allowed-users`

Optional.  String.  Comma-separated list of GitHub usernames who are allowed
access via their public SSH keys.  By default, the users who triggered the
initial and current workflow runs are allowed.

### `wait-for-continue`

Optional.  Boolean.  Wait for a _~/continue_ file to appear before returning to
the calling workflow.

## Examples

You might use this action as the last step of a job, running only if the job
has failed:

```yaml
- if: failure()
  uses: nextstrain/.github/actions/setup-ssh@master
  with:
    tailscale-auth-key: ${{ secrets.TAILSCALE_AUTH_KEY }}
    wait-for-continue: true
```

This would cause a failing job to setup SSH access and then pause, giving you a
chance to log in and debug the failure.  To resume the job's execution, you'd
run `touch ~/continue` as the `runner` user (the default user).

## Prior art

Similar actions by other authors also exist:

  - [lhotari/action-upterm](https://github.com/lhotari/action-upterm) uses
    [upterm](https://upterm.dev/) to cross the NAT.

  - [mxschmitt/action-tmate](https://github.com/mxschmitt/action-tmate) uses
    [tmate](https://tmate.io) to cross the NAT.

Both cross the NAT using third-party proxy/relay servers, e.g.
`uptermd.upterm.dev` and `nyc1.tmate.io`.  Third-party proxies can be
unpalatable for security and privacy reasons, and while both support running
your own proxy instance, Tailscale allows us not to bother and provides more
robust security at the same time.
