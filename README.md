
![gkcommander_logo_100px](https://user-images.githubusercontent.com/5913483/29254169-68c9ced8-805d-11e7-8572-76277c27f10a.png)

Goat Komander, GKomander or simply GK is a simple project management tool 
written in bash.

Features:
- Create project following user defined templates
- Switch between managed projects
- Launch project related scripts
- Define alias and functions to manage projects

# Installation
Execute the following command in a bash shell

```bash
$ cd ~ && git clone https://github.com/jwillp/GKomander/ && mv GKomander .gk && echo 'alias gk="source ~/.gk/GKomander.sh" \n' >> ~/.bashrc
```

## Manual Installation
1. Clone this repository in your home directory

```bash
$ cd ~
$ git clone https://github.com/jwillp/GKomander/
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
