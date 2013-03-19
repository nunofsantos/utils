#!/bin/bash

if [ $# -eq 1 ] && [ $1 == "-h" ]; then
    echo "Usage: githubmirror.sh [-refresh] [-h]"
    echo "  no options : mirror repos in repolist"
    echo "  -refresh   : force refresh of repo list from github"
    echo "  -h         : display usage"
    exit
fi

basedir="redhat-openstack"

if [ ! -d "$basedir" ]; then
    mkdir $basedir
fi

function mirror {
    if [ $# -ne 2 ]; then
	echo "Usage: mirror <remote.git> <local.git>"
    fi

    remote=$1
    local=$2

    echo "Mirroring from $remote to $local..."

    if [ -d "$local" ]; then
	git --git-dir=$local remote update
    else
	git clone --mirror $remote $local
    fi
}

function getrepolist {
    wget -O - https://github.com/$basedir | \
    grep "<a href=\"/redhat-openstack/" | \
    grep -v "Stargazers" | \
    grep -v "Forks" | \
    grep -v "/repositories" | \
    sed 's:<a href="/redhat-openstack/\(.*\)">.*</a>:\1:' > $basedir/repolist
}

if [ $# -eq 1 ] && [ $1 == "-refresh" ] || [ ! -f "$basedir/repolist" ] ; then
    echo "Refreshing redhat-openstack repo list from GitHub..."
    getrepolist
fi

for r in `cat $basedir/repolist`; do
  mirror git://github.com/$basedir/$r.git $basedir/$r
done
