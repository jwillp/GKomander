# README
Goat Komander, GKomander or simply GK is a simple project management tool 
written in bash.

Features:
    - create project following user defined templates
    - switch between managed project
    - launch project related scripts
    - define alias and functions to manage projects

# Installation
1. Put the GKomander.sh in some location.
2. In your bashrc, create an alias like so:

```bash
alias gk="source /path/to/GKomander.sh"
```
Note: It is important for the script to be sourced or else many of its feature won't
work properly.

3. run:
```bash
$ gk install
```

# How to use
For help on how to use:

```bash
source GoatKommnder.sh -h
```