# IMM installers

This repository builds and publishes installers for
[`susu3304/InsaneMarmotMatrixLanguage`](https://github.com/susu3304/InsaneMarmotMatrixLanguage).

It packages the upstream Rust binary `imm-native` as the user-facing command
`imm`.

## Install

### Windows

Download `imm-windows-x64.msi` from the latest GitHub release and run it.

The MSI installs `imm.exe` under `C:\Program Files\IMM\bin` and adds that
directory to the machine `PATH`. Open a new terminal after installation:

```powershell
imm --version
```

### Ubuntu 22.04+ amd64

After the first successful Pages deployment, install through APT:

```bash
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://susu3304.github.io/imm-installers/apt/imm.asc | sudo tee /etc/apt/keyrings/imm.asc >/dev/null
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/imm.asc] https://susu3304.github.io/imm-installers/apt stable main" | sudo tee /etc/apt/sources.list.d/imm.list
sudo apt update
sudo apt install imm
imm --version
```

The Debian package installs `/usr/bin/imm`, so no extra `PATH` setup is needed
on a normal Ubuntu installation.

### macOS

Install through Homebrew:

```bash
brew tap susu3304/imm
brew install imm
imm --version
```

The formula installs `imm` into Homebrew's `bin` directory, which is already on
`PATH` for a normal Homebrew setup.

### VS Code

Download `imm-vscode-*.vsix` from the latest GitHub release, then install it:

```bash
code --install-extension imm-vscode-0.1.1.vsix
```

The extension provides `.imm` syntax highlighting, snippets, and editor
commands for checking, formatting, running, probe, and law suite workflows.

## Automation

`.github/workflows/build-installers.yml` rebuilds installers from the upstream
IMM repository when any of these events happen:

- `repository_dispatch` with type `imm-updated` or `imm-released`
- manual `workflow_dispatch`
- scheduled polling every 15 minutes as a fallback

The workflow skips publishing if the same upstream commit was already released,
unless `force` is enabled for a manual run.

For immediate rebuilds on every upstream IMM push, copy
`examples/imm-update-installers.yml` into the upstream IMM repository as
`.github/workflows/update-installers.yml`, then add a repository secret named
`INSTALLER_REPO_DISPATCH_TOKEN` there. The token needs write access to this
installer repository so it can create a repository dispatch event.

macOS Homebrew support is published to
[`susu3304/homebrew-imm`](https://github.com/susu3304/homebrew-imm). The
installer workflow updates that tap after each successful release.

## Repository Secrets

Required for signed APT metadata:

- `APT_GPG_PRIVATE_KEY`: ASCII-armored private GPG key used to sign `Release`.
- `APT_GPG_PASSPHRASE`: optional passphrase for that key.

If the signing key is missing, the workflow still creates `.deb` and MSI release
artifacts, but the APT repository is emitted unsigned and should not be used as
the default install path.

Required for automatic Homebrew tap updates:

- `HOMEBREW_TAP_DEPLOY_KEY`: SSH private deploy key with write access to
  `susu3304/homebrew-imm`.
