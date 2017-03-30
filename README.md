# README
Goat Komander, GKomander or simply GK is a simple project management tool 
written in bash.

Features:
    - create project following user defined templates
    - switch between managed project
    - launch project related scripts
    - define alias and functions to manage projects

# Installation
Execute the following command in a shell

```bash
$ cd ~ && git clone https://gitlab.com/GoatGames/GKomander/ && mv GKomander .gk && echo 'alias gk="source ~/.gk/GKomander.sh" \n' >> ~/.bashrc
```

## Manual Installation
1. Clone this repository in your home directory

```bash
$ cd ~
$ git clone https://gitlab.com/GoatGames/GKomander/
```

2. Rename the folder created by the git command to ```.gk```

```bash
$ mv GKomander .gk
```

3. In your bashrc, create an alias like so:

```bash
alias gk="source ~/.gk/GKomander.sh"
```

Note: It is important for the script to be sourced or else many of its feature won't
work properly.


# Usage
For help on how to use:

```bash
gk --help
```

# Update
Execute the following command

```bash
$ gk update
```

or simply ```git pull``` in the ```~/.gk``` directory