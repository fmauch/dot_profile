# dot_profile
This package holds my personal profile config. Note that I go a little different way than e.g.
Ubuntu goes by default. As I use both bash and zsh on different machines but I like to have almost
the same configuration on both machines I handle most of my settings to the `~/.profile` file which
will then be sourced either by the '~/.zshrc' or the '~/.bashrc' respectively.

This way I have the same configuration no matter whether I work on the machine via ssh or login
locally.

## Installation
### Manual installation
Note: On some systems (such as ubuntu) you'll have to delete (or mv away) the `~/.profile` file as
this will be overwritten by this repository. Having this file present prevents the stow command from
properly installing.

This repository is prepared to be used together with gnu stow. See [Brandon Invergo's
explanation](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
on how to use it. In short

```
mkdir ~/dotfiles
cd ~/dotfiles
git clone https://github.com/fmauch/dot_profile.git
stow dot_profile
```

This will create symlinks for the dotfiles specified in ```dot_profile``` relative to your home
folder.

### Automatic installation
I personally use a shell script to install all my dotfiles at once that clones multiple repositories
and calls stow on them. You find it in my [dotfiles repository](https://github.com/fmauch/dotfiles).
The installation would then be

```
cd
git clone https://github.com/fmauch/dotfiles
cd dotfiles
# You might want to have a look at this to see which modules this will pull.
./install.sh
```
