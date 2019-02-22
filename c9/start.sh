#!/bin/bash
if [ -z $C9_WORKSPACE ]
then
    export C9_WORKSPACE=$WORKSPACE
fi
if [ -z $C9_PASSWORD ]
then
    export C9_PASSWORD=$C9_PASS
fi

sudo a2enmod rewrite
sudo service apache2 start
sudo mkdir $C9_WORKSPACE
sudo chown -R student $C9_WORKSPACE

if [ -n $C9_USER ] && [ -z $C9_PASS ]
then
    echo 'Authorization mode cannot be started without specifying a password ($C9_PASS).'
fi
if [ -z $C9_USER ] && [ -n $C9_PASS ]
then
    echo 'Authorization mode cannot be started without specifying a username ($C9_USER).'
fi

if [ ! -f $C9_WORKSPACE/.c9/project.settings ]
then 
mkdir $C9_WORKSPACE/.c9
cp /cloud9/project.settings $C9_WORKSPACE/.c9/project.settings
echo 'Loaded default "project.settings" file.'
else
echo '"project.settings" file detected. Using existing file.'
fi

node /cloud9/server.js --listen 0.0.0.0 --port 8080 -w $C9_WORKSPACE --auth $C9_USER:$C9_PASS $C9_EXTRA