#!/bin/bash

###Updates pivpn scripts (Not PiVPN)
###Main Vars
pivpnrepo="https://github.com/pivpn/pivpn.git"
pivpnlocalpath="/etc/.pivpn"
pivpnscripts="/opt/pivpn/"
bashcompletiondir="/etc/bash_completion.d/"


###Functions
##Updates scripts
updatepivpnscripts(){
    ##We don't know what sort of changes users have made.
    ##Lets remove first /etc/.pivpn dir then clone it back again
    echo "going do update PiVPN Scripts"
    if [[ -d "$pivpnlocalpath" ]]; then
      if [[ -n "$pivpnlocalpath" ]]; then
        sudo rm -rf "${pivpnlocalpath}/../.pivpn"
        cloneandupdate
      fi
    else
        cloneandupdate
    fi
    echo "PiVPN Scripts have been updated"
}

##Updates scripts using test branch
updatefromtest(){
    ##We don't know what sort of changes users have made.
    ##Lets remove first /etc/.pivpn dir then clone it back again
    echo "PiVPN Scripts updating from test branch"
    if [[ -d "$pivpnlocalpath" ]]; then
      if [[ -n "$pivpnlocalpath" ]]; then
        rm -rf "{$pivpnlocalpath}/../.pivpn"
        cloneupdttest
      fi
    else

        cloneupdttest

    fi
    echo "PiVPN Scripts updated have been updated from test branch"
  }

##Clone and copy pivpn scripts to /op/
cloneandupdate(){

        sudo git clone "$pivpnrepo" "$pivpnlocalpath"
        sudo cp "${pivpnlocalpath}"/scripts/*.sh "$pivpnscripts"
        sudo cp "${pivpnlocalpath}"/scripts/bash-completion "$bashcompletiondir"

}

##same as cloneandupdate() but from test branch
##and falls back to master branch again after updating
cloneupdttest(){

        sudo git clone "$pivpnrepo" "$pivpnlocalpath"
        sudo git -C "$pivpnlocalpath" checkout test
        sudo git -C "$pivpnlocalpath" pull origin test
        sudo cp "${pivpnlocalpath}"/scripts/*.sh "$pivpnscripts"
        sudo cp "${pivpnlocalpath}"/scripts/bash-completion "$bashcompletiondir"
        sudo git -C "$pivpnlocalpath" checkout master

}

scriptusage(){
    echo -e "Updates pivpn scripts,

              Usage:
              pivpn update              | updates from master branch
              pivpn update -t or --test | updates from test branch"

}

## SCRIPT

if [[ $# -eq 0 ]]; then
    updatepivpnscripts

else
  while true; do
    case "$1" in
      -t|--test|test)
          updatefromtest
          exit 0
          ;;
      -h|--help|help)
          scriptusage
          exit 0
          ;;
      * )
        updatepivpnscripts
        exit 0
        ;;
    esac
  done
fi

