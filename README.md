# misc
This repository contains miscellaneous useful scripts I've picked up or hacked together.

`fresh-start` contains useful scripts and saved information for setting up usual utilities.

Files that may drift due to machine-specific auto-edits. Shouldn't really contain custom logic, and are really only here as examples.

* `unmaintained/.bashrc` - typical Ubuntu bashrc, may drift in minor ways by automatic additions from machine-specific installations. Calls into `.bash_defs`.
* `unmaintained/.bash_profile` - calls into `.bashrc`

## Stuff To Run / Maintain

All in `fresh-start`.

#### Manual steps

Install `Dropbox` manually and put it inside `~/Dropbox` with synchronization. This should pull in a lot of configuration files.

#### `sudo-install-ubuntu.sh`

Does a first cut at removing miscellaneous Canonical crap.

Installs git, chrome, emacs, spotify, tmux, various dev and usability utilities.

Soft-links `~/.emacs.d` to `~/Dropbox/.emacs.d`.

#### `config.sh`

Configure `.bashrc` and `.bash_profile` on the host in-place.

Copy over `.bash_defs`, which is what I use for both login and interactive shell specializations (not really doing anything special in `~/.bashrc`, which gets auto-modified a lot.

Copy over `.tmux.conf` and `~/bin` utilities.

Install `commacd`, which I use for faster navigation.

Set up `git` email and `emerge`.

Generate an ssh key in that machine.

#### Autocomplete

Set up `TabNine` by following the steps [here](https://tabnine.com/subscribe) and [here](https://github.com/TommyX12/company-tabnine).
