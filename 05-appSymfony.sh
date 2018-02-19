#!/bin/sh

version=
composer=
node=
quiet=
maj_version=

#cd to cemm root directory
cd "${BASH_SOURCE%/*}" 

function update_composer {
    if [ "$composer" == 1 ]; then
        echo " " 
        echo "  UPDATE VENDORS W/ COMPOSER" 
        if [ "$quiet" == 1 ]; then
                sudo composer update -q
            else
                sudo composer update 
            fi
        echo " " 
    fi
}

function update_nodejs {
    if [ "$node" == 1 ]; then
        echo " " 
        echo "  UPDATE NODE_MODULE W/ YARN" 
        if [ "$quiet" == 1 ]; then
                yarn install -q
            else
                yarn install
            fi
        echo " " 
    fi
}

function update_git {
    echo " " 
    echo "  Mise a jour depuis git" 

    sudo git fetch --all
    sudo git reset --hard ${version}

    echo " " 
}

function install_assets {
    echo " " 
    echo "  Installation des assets" 
    if [ "$quiet" == 1 ]; then
        php app/console assets:install --env=prod -q && php app/console assetic:dump --env=prod -q
        php app/console assets:install -q && php app/console assetic:dump -q
        yarn run encore dev -q
    else
        php app/console assets:install --env=prod && php app/console assetic:dump --env=prod
        php app/console assets:install && php app/console assetic:dump
        yarn run encore dev
    fi
    echo " " 
}

function cache_clear {
    echo " " 
    echo "  Effacement du cache de prod" 
    if [ "$quiet" == 1 ]; then
        php app/console cache:clear --env=prod -q
        php app/console cache:clear --env=dev -q
    else
        php app/console cache:clear --env=prod
        php app/console cache:clear --env=dev
    fi
    echo " " 
}

while getopts "iqcv:tb:" OPTION
do
    case $OPTION in
        q)
            quiet=1
            ;;
        c)
            composer=1
            ;;
        n)
            node=1
            ;;
        v)
            version="$OPTARG" 
            ;;
        \?)
            echo "Deployement de l'application" 
            echo " " 
            echo "options:" 
            echo "-q                mode silencieux" 
            echo "-c                mettre à jours les vendors" 
            echo "-n                mettre à jours les modules node" 
            echo "-v=VERSION        indique quel tag doit être déployé" 
            echo " " 
            echo "exemple : ./deploy.sh -v=2.1.2 -c -n" 
            exit 0
            ;;
    esac
done

rm -rf app/cache/*
#update_git
update_composer
cache_clear
install_assets
cache_clear

echo " " 
echo "  Changement des permissions" 
chown -R apache:apache . && chmod -R 755 . && chmod -R 777 app/cache app/logs
echo " " 

echo "  Déploiement terminé" 

echo " " 