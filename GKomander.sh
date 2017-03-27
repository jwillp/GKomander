#!/usr/bin/env bash

# It is highly recommended to create a "GK" alias. 
# alias gk=". GKomander.sh"

# CONSTANTS
VERSION=0.3.0
COPYRIGHT="(c)2016 Goat Games"
# Set home
GK_HOME="${GK_HOME:-$HOME/.gk}"
GK_PROJ_DIR="$GK_HOME"

# Make sure GK_HOME directory exists
if [[ ! -d $GK_HOME ]]; then 
    mkdir $GK_HOME 
fi
if [[ ! -d $GK_PROJ_DIR ]]; then
    mkdir $GK_PROJ_DIR 
fi


# Displays help for Goat Komander
function gk_help() {
    echo ""
    echo "${LIGHT_GREEN}Goat Komander${WHITE} v"$VERSION
    echo ""
    gk_usage
    echo ""
    echo "Options:"
    echo "  active                                   Display name of the current project"
    echo "  switch_project,switch, <project name>    Sets the current project to <project name>"
    echo "  -l,list                                  List projects"
    echo "  new-game                                 Creates a new game in the current directory"
    echo "  new-screen                               Creates a new game screen and a level in the current directory"
    echo "  new-script                               Creates a new entity script in the current directory"
    echo "  new-level                                Creates a new level new s in the current directory"
    echo "  new-config,new-conf                      Creates a new config file in the current directory"
    echo "  run                                      Runs the current active project"
    echo "  quit                                     Quits the current Goat Komander session"
    echo "  -h --help                                Display this information"
    echo "  -v --version                             Display version info"
    echo " "
    echo "Please report bugs at https://github.com/GoatGames/GoatKomander"
}

# usage
function gk_usage() {
    echo "usage: GoatKomander <option> [<args>] ..."
}



# Version information
function gk_version() {
    echo "${LIGHT_GREEN}Goat Komander${WHITE}  $VERSION"
    echo "$COPYRIGHT"
}


# Change prompt to display project name
function gk_prompt_start() {
    export OLD_PS1=$PS1
    export PS1=${PS1::-2}"\[\e[34m\][$1]\[\e[m\]\\$ "
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
    alias cdda="cd $projPath/data"
    alias cddoc="cd $projPath/doc"
    alias cds="cd $projPath/data/scripts"
    alias cdsc="cd $projPath/data/screens"
    alias cdpref="cd $projPath/data/prefabs"
    alias cdlog="cd $projPath/data/LOG"
    alias cdlev="cd $projPath/data/levels"
    alias cdconf="cd $projPath/data/config"
    alias cdau="cd $projPath/data/audio"
    alias cdsp="cd $projPath/data/sprites"
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
        echo "There are no game projects"
        echo "Create one using: GoatKomander new_game <project_name>"
    else
        # echo "Game Projects:"
        # echo ""
        ls -1p $GK_PROJ_DIR | grep -v /
    fi
}

function gk_new_game() {
    if [[ "$1" ]]; then
        homeProj="$GK_PROJ_DIR\\"$1
        if [[ ! -e  $homeProj ]]; then
            echo "Creating new game : $1 ..."
            
            # Create project in current directory
            projDir=`pwd`"/$1"
            mkdir $projDir


            # Create begin and quit scripts
            printf "#!/usr/bin/env bash\n\n# This script will run when STARTING the project \"%s\"\n# Here you might want to cd into your project directory, activate virtualenvs, etc.\n\n# The currently active project is available via \$GK_ACTIVE_PROJECT\n\n" > "$projDir/gk_start.sh"
            printf "#!/usr/bin/env bash\n\n# This script will run when STOPPING the project \"%s\"\n# Here you might want to deactivate virtualenvs, clean up temporary files, etc.\n\n# The currently active project is available via \$GK_ACTIVE_PROJECT\n\n" > "$projDir/gk_stop.sh"


            # Add project to local projects
            touch $homeProj

            relPath=`realpath --relative-to=$HOME $projDir`
            echo $relPath > $homeProj



            # Create default directory structure
            mkdir $projDir/data
            mkdir $projDir/data/LOG
            mkdir $projDir/data/animations
            mkdir $projDir/data/audio
            mkdir $projDir/data/config
            mkdir $projDir/data/levels
            mkdir $projDir/data/prefabs
            mkdir $projDir/data/screens
            mkdir $projDir/data/scripts
            mkdir $projDir/data/shaders
            mkdir $projDir/data/skins
            mkdir $projDir/data/sprites

            # Copy ge.conf template
            cp $GK_HOME/templates/ge.conf $projDir/ge.conf
            
            echo "Project \"$1\" created successfully"
            gk_load "$1"
        else
            echo "Goat Komander: Project already exist choose another name"           
        fi


    else
        echo "Goat Komander: You must specify a project name"
        return 1
    fi
    
}



# GOAT ENGINE SPECIFIG BEGIN

# Creates a game screen and an associated level in current directory
function gk_new_screen() {
    cp $GK_HOME/templates/screen.ges "$1.ges"
    gk_new_level "$1"
}

function gk_new_script() {
    cp $GK_HOME/templates/entityScript.lua "$1.lua"
}

function gk_new_config() {
    cp $GK_HOME/templates/config.conf "$1.conf"
}

function gk_new_level() {
    cp $GK_HOME/templates/level.gel "$1.gel"
}

# GOAT ENGINE SPECIFIC END



# Main procedure
case "$1" in 

    active)
        gk_active_project
        ;;

    switch_project)
        gk_switch_project
        ;;

    list|-l)
        gk_list
        ;;



    new-game)
        gk_new_game ${@:2}
        ;;

    new-screen)
        gk_new_screen ${@:2}
        ;;

    new-script)
        gk_new_script ${@:2}
        ;;

    new-level)
        gk_new_level ${@:2}
        ;;


    new-config|new-conf)
        gk_new_config ${@:2}
        ;;


    rm|remove)
        if [[ -e "$GK_PROJ_DIR/$2" ]]; then
            gk_remove ${@:2}
        else 
            echo "Goat Komander: Deletion of project failed. The project $2 does not exist"
            return 1
        fi
        ;;

    run)
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
            if [[ -e "$GK_PROJ_DIR/$1" ]]; then
                gk_load $1
            else
                # If no project found
                echo "Goat Komander: '$1' is not a command. See GoatKomander --help for help"
                return 1
            fi

        fi 
        ;;
esac
