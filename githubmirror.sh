#!/bin/bash

function mirror {
    if [ $# -ne 2 ]; then
	echo "Usage: mirror <remote.git> <local.git>"
    fi

    remote=$1
    local=$2

    echo "Mirroring from $remote to $local"

    if [ -d "$local" ]; then
	git --git-dir=$local remote update
    else
	git clone --mirror $remote $local
    fi
}

function getrepolist {
    repolist=`wget -O - https://github.com/redhat-openstack | \
    grep "<a href=\"/redhat-openstack/" | \
    grep -v "Stargazers" | \
    grep -v "Forks" | \
    grep -v "/repositories" | \
    sed 's:<a href="/redhat-openstack/\(.*\)">.*</a>:\1:'`
}

if [ ! -d "redhat-openstack" ]; then
    mkdir redhat-openstack
fi

getrepolist

for r in $repolist; do
  mirror git://github.com/redhat-openstack/$r.git redhat-openstack/$r
done
