#!/usr/bin/env bash

# It is highly recommended to create a "GK" alias. 
# alias gk=". GKomander.sh"

# CONSTANTS
GK_VERSION=0.3.0
GK_COPYRIGHT="(c)2017 Goat Games"
# Set home
GK_HOME="${GK_HOME:-$HOME/.gk}"
GK_PROJ_DIR="$GK_HOME" # dir where the list of projects are stored

# Make sure GK_HOME directory exists
if [[ ! -d $GK_HOME ]]; then
    mkdir $GK_HOME 
fi
if [[ ! -d $GK_PROJ_DIR ]]; then
    mkdir $GK_PROJ_DIR 
fi

function return_error() {
    # Print error message and return error code
    if [ "$2" ]; then
        echo "$2"
    fi
    if [ "$1" ]; then
        return "$1"
    else
        return 1
    fi
}

# Test if gk is sourced. It must not be ran in a subshell 
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    SOURCE="GKomander MUST be sourced - not run in a subshell.\ni.e. '. ./gk'\n"
    return_error 1 "$(printf "$SOURCE")"
    exit
fi


# Displays help for Goat Komander
function gk_help() {
    echo ""
    echo "${LIGHT_GREEN}Goat Komander${WHITE} v"$GK_VERSION
    echo ""
    gk_usage
    echo ""
    echo "Options:"
    echo "  active                                        Display name of the current project"
    echo "  switch_project|switch|load|<project name>     Sets the current project to <project name>"
    echo "  -l,list                                       List projects"
    echo "  new-project|new                               Creates a new game in the current directory"
    echo "  remove|rm                                     Creates a new game in the current directory"
    echo "  quit                                          Quits the current Goat Komander session"
    echo "  -h --help                                     Display this information"
    echo "  -v --version                                  Display version info"
    echo " "
    echo "Please report bugs at https://github.com/GoatGames/GoatKomander"
}

# usage
function gk_usage() {
    echo "usage: GoatKomander <option> [<args>] ..."
}



# Version information
function gk_version() {
    echo "${LIGHT_GREEN}Goat Komander${WHITE}  $GK_VERSION"
    echo "$GK_COPYRIGHT"
}


# Change prompt to display project name
function gk_prompt_start() {
    export OLD_PS1=$PS1
    export PS1="${PS1::-3} [$1]$ "
}

# REset the path to its normal value
function gk_prompt_finish() {
    export PS1=$OLD_PS1 #$OLD_PS1
}


# Returns the path of a project
function gk_get_proj_path() {
    echo "$HOME/"`cat $GK_PROJ_DIR/$1`
}

# Removes a project
function gk_remove() {
    if [[ $GK_ACTIVE_PROJECT ]]; then
        gk_quit
    fi
    echo "Deleting $1"
    rm -rf gk_get_proj_path $1
    rm $GK_HOME/$1
    echo "Project $1 deleted"
}

# Loads a project (should exist)
function gk_load() {
    if [[ $GK_ACTIVE_PROJECT ]]; then
        gk_quit
    fi

    projPath=`gk_get_proj_path $1`
    cd $projPath
    # Name of current project
    export GK_ACTIVE_PROJECT=$1

    # Home directory of current project
    export GK_ACTIVE_HOME=$projPath  
    gk_prompt_start $1
    source $projPath/gk_start.sh

    # Create useful default aliases
    # Get back home alias
    
    alias hcd="cd $projPath"
    alias cddoc="cd $projPath/doc"
    alias cdsr="cd $projPath/src"
    alias getcd="alias | grep -i cd"
}

# Quits gkomander
function gk_quit() {
    echo "Quitting $GK_ACTIVE_PROJECT ... "
    projPath=`gk_get_proj_path $GK_ACTIVE_PROJECT`
    gk_prompt_finish
    source $projPath/gk_stop.sh
    export GK_ACTIVE_PROJECT=""
}

# Active project
function gk_active_project() {
    echo "Active Project: "$GK_ACTIVE_PROJECT
}

# Change the active project for something else
function gk_switch_project() {
    gk_load $1
}

# List available projects
function gk_list() {
    projList=`ls -1p $GK_PROJ_DIR | grep -v /`
    if [[ $projList == "" ]]; then
        echo ""
        echo "There are no projects"
        echo "Create one using: GoatKomander new <project_name>"
    else
        # echo "Game Projects:"
        # echo ""
        ls -1p $GK_PROJ_DIR | grep -v /
    fi
}

function gk_new_project() {
    if [[ "$1" ]]; then
        homeProj="$GK_PROJ_DIR/$1"
        echo "HOME PROJ $homeProj"
        if [[ ! -e  $homeProj ]]; then
            echo "Creating new project : $1 ..."
            
            # Create project in current directory
            projDir=`pwd`"/$1"
            mkdir $projDir
            echo "proj dir fi $projDir"


            # Create begin and quit scripts
            printf "#!/usr/bin/env bash\n\n# This script will run when STARTING the project \"%s\"\n# Here you might want to cd into your project directory, activate virtualenvs, etc.\n\n# The currently active project is available via \$GK_ACTIVE_PROJECT\n\n" > "$projDir/gk_start.sh"
            printf "#!/usr/bin/env bash\n\n# This script will run when STOPPING the project \"%s\"\n# Here you might want to deactivate virtualenvs, clean up temporary files, etc.\n\n# The currently active project is available via \$GK_ACTIVE_PROJECT\n\n" > "$projDir/gk_stop.sh"


            # Add project to local projects
            touch $homeProj

            relPath=`realpath --relative-to=$HOME $projDir`
            echo $relPath > $homeProj


            # Create default directory structure according to template
            # TODO
            
            echo "Project \"$1\" created successfully"
            gk_load "$1"
        else
            echo "Goat Komander: Project already exists, please choose another name"           
        fi
    else
        echo "Goat Komander: You must specify a project name"
        return 1
    fi
    
}




# Main procedure
case "$1" in 

    active)
        gk_active_project
        ;;

    switch_project|switch|load)
        gk_switch_project ${@:2}
        ;;

    list|-l)
        gk_list
        ;;

    new|new-project)
        gk_new_project ${@:2}
        ;;

    rm|remove)
        if [[ -e $GK_PROJ_DIR/$2 ]]; then # dir where the list of projects are storeden
            gk_remove ${@:2}
        else 
            echo "Goat Komander: Deletion of project failed. The project $2 does not exist"
            return 1
        fi
        ;;

    quit)
        gk_quit
        ;;

    -h|--help)
        gk_help
        ;;

    -v|--version)
        gk_version
        ;;

    *)  # Anything else
        if [ -z "$1" ]; then
            gk_help
        else
            # Find project 
            if [[ -e $GK_PROJ_DIR/$1 ]]; then
                gk_load $1
            else
                # If no project found
                echo "Goat Komander: '$1' is not a command. See GoatKomander --help for help"
                return 1
            fi

        fi 
        ;;
esac
