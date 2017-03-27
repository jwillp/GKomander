# Template representing a default project
# $1 nameof the project
# $2 directory containing the project
# Start and stop scripts already exist. Therefore it is quite easy to
# append custon commands to the scripts 

cd $2

# Project Structure
mkdir doc
mkdir src

# Project Info
touch README.md
touch LICENSE.md

# Git
git init
git add -A
git commit -m "Initial commit"