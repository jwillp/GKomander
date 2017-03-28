# Template representing a default project
# $1 name of the project
# $2 directory containing the project
# Start and stop scripts already exist. Therefore it is quite easy to
# append custon commands to the scripts 
projectName=$1
projectPath=$2

cd $projectPath

# Project Structure
mkdir doc

# Download grav admin and unzip it
wget  -O grav.zip https://getgrav.org/download/core/grav-admin/1.1.17
unzip grav.zip
rm -rf grav.zip

# The archive will create a grav-admin folder, take content and bring it one level up
mv grav-admin/* .

# Update grav
bin/gpm selfupgrade
bin/gpm update

# Useful commands
echo  xamp_start \n >> gk_start.sh
echo  xamp_stop \n >> gk_stop.sh 

echo 'alias hcd="cd $projectPath"' >> gk_start.sh
echo 'alias cddoc="cd $projPath/doc"' >> gk_start.sh
echo 'alias cdu="cd $projPath/user"' >> gk_start.sh

# Git
touch .gitignore
echo  "cache/" >> .gitignore
echo  "logs/" >> .gitignore

git init
git add -A
git commit -m "Initial commit"
