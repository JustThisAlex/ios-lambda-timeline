# Cocopods Homebrew and Ruby Install Guide

You'll use Hombrew (`brew`) to install Cocoapods in order to build the Firebase project.

Homebrew is built on Ruby, and you'll want to configure Ruby (programming language) so that it's update to date.

With the system installed version in macOS, you don't have the ability to update the libraries that come with Ruby (`gem update`). 

Gem is the tool to update Ruby packages, which is a prerequisite for Homebrew (`brew`).

## Enter `rbenv`

To help with managing different versions of Ruby, there is a tool called `rbenv`.

You can use it to install a different version of Ruby, which you can then update, and then install hombrew, and then install Cocoapods.

# When Ruby gem update fails (and how to install Cocoapods)
​
You can't update the system version of Ruby, and you shouldn't do that anyway, since Apple manages it. Forcing it to change can cause issues with other tools that Apple ships with each verison of macOS.

Running the command in Terminal may fail.

`gem update`

If you see this error, then you'll want to setup `rbenv` to manage your versions of Ruby (programming langauge).

`Updating installed gems
Updating CFPropertyList
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /Library/Ruby/Gems/2.6.0 directory.`


## Install `rbenv`

Follow the [rbenv install instructors](https://github.com/rbenv/rbenv) to setup your `.zshrc` file for `rbenv`

### Terminal setup (zsh/bash for rbenv)

To follow the instructions you'll either need to edit your zsh setup file, or bash. In Catalina (10.15) Apple made `zsh` the new default shell in Terminal (instead of `bash`).

`open ~/.zshrc` 

Will allow you to open and edit your .zshrc file (in your home directory) that is used by the shell `zsh` in Catalina (If you're still using bash, edit the `~/.bashrc` file)

## Use `rbenv` to see what versions are installed

Run the command: 

`rbenv versions`

```
* system (set by /Users/paulsolt/.rbenv/version)
  2.6.2
  2.6.3
```

And you can see the current "global" version of Ruby is the "system"" default (what Apple provides, and it's read-only)

## Install a new Ruby version that will read-write

Run the command:

`rbenv install 2.6.3`

## Switch Ruby Versions

After you install a new version of Ruby, you can switch to it as the default.

`rbenv global 2.6.3` 

Will change Ruby across the system, unless you've specified a local version (inside a directory).

NOTE: Sometimes you need to switch back to system with `rbenv global system` if Apple related commands are failing, but generally you'll want to stay on your version)

## Update Ruby Gems (Package Manager for Ruby)

Gems are either applications or libraries that you can use within Ruby projects or apps.

Run the command to keep your gems for the current version of Ruby up to date.

`gem update`

## Install Homebrew

To install [Homebrew](https://brew.sh) Run

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## Install Cocoapods (if you don't have it installed)

```brew install cocoapods```

## (Optional) Update Cocoapods

Update your current cocoapods version to keep it up to date after it's installed:

```
brew upgrade cocoapods
```

## Test pod

Type the command test pod is installed, you should see normal output.

```
Usage:

    $ pod COMMAND

      CocoaPods, the Cocoa library package manager.
		...
```


## (Extra) Occasionally you get errors running pod / gem / etc.

Errors are one of the challenges you'll need to overcome as a developer. Maintaining your Mac is part of the job.

I Google these errors or I follow the instructions provided in the error (read the message). Usually they have a hint.

On my system I had overwritten an install of Ruby 2.6.3 that I believe is causing this issue. It's warning me every time I try to use the command `pod` (not good)

```
pod

Ignoring json-2.3.0 because its extensions are not built. Try: gem pristine json --version 2.3.0
Ignoring json-2.3.0 because its extensions are not built. Try: gem pristine json --version 2.3.0
...

```

Run a command to install gems with the current version you installed (2.6.3 in this case). 

Keep in mind that ruby gems are install per install of Ruby, so you might need to do this again if there's a new version of Ruby to install.

```
rbenv global 2.6.3 
gem pristine --all
```

After running `gem pristine` (and waiting 5-10 minutes) the errors went away. 
